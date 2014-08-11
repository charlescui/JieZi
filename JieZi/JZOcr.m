//
//  JZOcr.m
//  JieZi
//
//  Created by 崔峥 on 14-8-5.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import "JZOcr.h"
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import "UIImage+Filters.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "GPUImage.h"
#import "btSimplePopUp/btSimplePopUP.h"

@implementation JZOcr

- (id)initWithView:(UIImageView *)view
{
    self = [super init];
    if (self) {
        self.view = view;
//        [self initCoreVideo];
        [self initGPUImage];
        
        dispatch_async(dispatch_queue_create("ocr", NULL), ^(){
            [self initTesseract];
        });
        // 增加手势
        [self addGestureForScale];
        
        NSLog(@"Tesseract version %@", Tesseract.version);
    }
    return self;
}

- (void)initGPUImage
{
    //初始化GPUImageVIew
    self.gpuImageView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.gpuImageView];
}

- (void)initCoreVideo
{
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureStillImageOutput alloc]init];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
}

- (void)initTesseract
{
    // Init ocr
    //        self.tesseract = [[Tesseract alloc] initWithLanguage:@"chi_sim+eng"];
    //        self.tesseract.delegate = self;
    //        self.tesseract  = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    self.tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata"
                                                language:@"chi_sim"
                                           ocrEngineMode:OcrEngineModeTesseractOnly
                                         configFilenames:nil
                                               variables:nil
                                   setOnlyNonDebugParams:NO];
    //        [self.tesseract setVariableValue:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" forKey:@"tessedit_char_whitelist"]; //limit search
}

- (void)startGPUImageRunning
{
    //GPUImage
    //调用GPUImageStillCamera 作为相机，并将相机添加到一个GPUImageView中
    self.stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    //设置输出视频的方向
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    //切记使用小一些的尺寸initWithSessionPreset:AVCaptureSessionPreset640x480。否则会出现memory warning
    //如果需要添加fiilter。就通过其中添加
    self.filter = [[GPUImageTiltShiftFilter alloc] init];
    ((GPUImageTiltShiftFilter *)self.filter).blurRadiusInPixels = 10.0;

    [self.stillCamera addTarget: self.filter];
    [self.filter addTarget:self.gpuImageView];
    //启动
    [self.stillCamera startCameraCapture];
}

- (void)startCoreVideo
{
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [self.view.layer addSublayer:self.preview];
    //触碰屏幕后对焦
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFocus:)];
    [self.view addGestureRecognizer:tap];
    // Start
    [self.session startRunning];
}

- (void)startRunning
{
    [self startGPUImageRunning];
}

-(void)handleFocus:(UITouch*)touch
{
    if( [self.device lockForConfiguration:nil] )
    {
        CGPoint location = [touch locationInView:self.view];
        
        if( [self.device isFocusPointOfInterestSupported] )
            self.device.focusPointOfInterest = location;
        
        if( [self.device isExposurePointOfInterestSupported] )
            self.device.exposurePointOfInterest = location;
        
        
        [self.device unlockForConfiguration];
    }
}

- (void)processCapturedImage:(UIImage *)image
{
    self.currentImage = image;
    //        self.currentImage = [self.view screenshot];
    self.currentRawImage = self.currentImage;
    UIImageWriteToSavedPhotosAlbum(self.currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    GPUImageFilter *filter;
    
    //修复旋转错误
    self.currentImage = [self.currentImage fixOrientation];
    
    //裁剪图片
    filter = [[GPUImageCropFilter alloc] initWithCropRegion:[self toGPUImageRect:self.currentImage]];
    self.currentImage = [filter imageByFilteringImage:self.currentImage];
    UIImageWriteToSavedPhotosAlbum(self.currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    //灰度
    filter = [[GPUImageGrayscaleFilter alloc] init];
    self.currentImage = [filter imageByFilteringImage:self.currentImage];
    UIImageWriteToSavedPhotosAlbum(self.currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    //求反
    filter = [[GPUImageColorInvertFilter alloc] init];
    self.currentImage = [filter imageByFilteringImage:self.currentImage];
    UIImageWriteToSavedPhotosAlbum(self.currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    //边缘检测
    //        filter = [[GPUImageThresholdEdgeDetectionFilter alloc] init];
    //        t_image = [filter imageByFilteringImage:t_image];
    //        UIImageWriteToSavedPhotosAlbum(t_image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    //亮度阈
    //        filter = [[GPUImageLuminanceThresholdFilter alloc] init];
    //        [(GPUImageLuminanceThresholdFilter *)filter setThreshold:0.3f];
    //        self.currentImage = [filter imageByFilteringImage:self.currentImage];
    //        UIImageWriteToSavedPhotosAlbum(self.currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    //锐化
    filter = [[GPUImageSharpenFilter alloc] init];
    self.currentImage = [filter imageByFilteringImage:self.currentImage];
    UIImageWriteToSavedPhotosAlbum(self.currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [self recognize:self.currentImage];
}

/*
 捕获图片
 **/
- (void)captureimage
{
    //拍照后想生成图片
    [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.filter
                                       withCompletionHandler:^(UIImage *processed, NSError *error){
                                           [self processCapturedImage:processed];
                                       }];
}

- (CGRect)toGPUImageRect:(UIImage *)image
{
    //转换borderView的坐标和image的坐标
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat toHeight = (self.borderView.frame.size.height/screenHeight);
    CGFloat toWidth = (self.borderView.frame.size.width/screenWidth);
    CGFloat toX = (self.borderView.frame.origin.x/screenWidth);
    CGFloat toY = (self.borderView.frame.origin.y/screenHeight);
    CGRect inImageRect = CGRectMake(toX, toY, toWidth, toHeight);
    
    NSLog(@"screenRect %@", NSStringFromCGRect(screenRect));
    NSLog(@"rawImageRect %@", NSStringFromCGSize(image.size));
    NSLog(@"rawBorderViewRect %@", NSStringFromCGRect(self.borderView.frame));
    NSLog(@"inImageRect %@", NSStringFromCGRect(inImageRect));
    
    return inImageRect;
}

// 识别文字
- (NSString *)recognize:(UIImage *)image
{
    NSString *result = @"";
    
    if (!self.tesseract) {
        [self initTesseract];
    }
    self.tesseract.image = image;
//    self.tesseract.rect = self.borderView.frame;//optional: set the rectangle to recognize text in the image
    [self.tesseract recognize];
    
    result = [self.tesseract recognizedText];

    if ([self.delegate respondsToSelector:@selector(OcrDidGetReconizedContextWithString:)]) {
        [self.delegate OcrDidGetReconizedContextWithString:result];
    }
    
    NSLog(@"%@", result);
    return result;
}

//如果Tesseract支持读取识别进度
//则启动定时器，当识别完成时回掉delegate
//而不需要获取识别结果时候阻塞
- (void)checkTesseractRecognizeProcess
{
    dispatch_async(dispatch_queue_create("ocr", NULL), ^(){

    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        NSLog(@"%@", error);
    }
    else  // No errors
    {
        // Show message image successfully saved
    }
}

- (void)progressImageRecognitionForTesseract:(Tesseract *)tesseract
{
    if ([self.delegate respondsToSelector:@selector(OcrProgressImageRecognitionForTesseract:)]) {
        [self.delegate OcrProgressImageRecognitionForTesseract:self.tesseract];
    }
//    if (tesseract.progress == 100) {
//        NSString *result = [self.tesseract recognizedText];
//        if ([self.delegate respondsToSelector:@selector(OcrDidGetReconizedContextWithString:)]) {
//            [self.delegate OcrDidGetReconizedContextWithString:result];
//        }
//        
//        NSLog(@"%@", result);
//    }
}

//放大缩小
- (void)zoomPreviewSwipe:(UISwipeGestureRecognizer *)recognizer
{
    CGFloat scale = 0.0;
    // 计算互动距离
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.startLocation = [recognizer locationInView:self.view];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint stopLocation = [recognizer locationInView:self.view];
        CGFloat dx = stopLocation.x - self.startLocation.x;
        CGFloat dy = stopLocation.y - self.startLocation.y;
        CGFloat distance = sqrt(dx*dx + dy*dy );
        NSLog(@"Distance: %f", distance);
        scale = (distance / 960.0 * 5);
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        self.currentScale += scale - self.lastScale;
        self.lastScale = scale;
    }
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionDown)
    {
        self.currentScale -= scale - self.lastScale;
        self.lastScale = scale;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        self.lastScale = 1.0;
    }
    
    if (self.currentScale < 1.0)
    {
        self.currentScale = 1.0;
    }
    
    if (self.currentScale > 5.0)
    {
        self.currentScale = 5.0;
    }
    
    if (self.currentScale >= 1.0 && self.currentScale <= 5.0)
    {
        [[self.output.connections objectAtIndex:0] setVideoScaleAndCropFactor:self.currentScale];
        
        self.view.transform = CGAffineTransformMakeScale(self.currentScale, self.currentScale);
    }
}

- (void)zoomPreviewPin:(UIPinchGestureRecognizer *)recognizer
{
    self.currentScale += recognizer.scale - self.lastScale;
    self.lastScale = recognizer.scale;
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        self.lastScale = 1.0;
    }
    
    if (self.currentScale < 1.0)
    {
        self.currentScale = 1.0;
    }
    
    if (self.currentScale > 5.0)
    {
        self.currentScale = 5.0;
    }
    
    if (self.currentScale >= 1.0 && self.currentScale <= 5.0)
    {
        [[self.output.connections objectAtIndex:0]setVideoScaleAndCropFactor:self.currentScale];
        
        self.view.transform = CGAffineTransformMakeScale(self.currentScale, self.currentScale);
    }
}

- (void)addGestureForScale
{
    self.view.userInteractionEnabled = YES;
    self.view.multipleTouchEnabled = YES;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(zoomPreviewSwipe:)];
    [self.view addGestureRecognizer:swipe];
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomPreviewPin:)];
    [self.view addGestureRecognizer:pin];
}

- (void)showCurrentRawImageInViewBackground
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.currentRawImage];
    imageView.frame = self.view.frame;
    imageView.tag = 777;
    [self.view addSubview:imageView];
}

- (void)removeCurrentRawImageInViewBackground
{
    [[self.view viewWithTag:777] removeFromSuperview];
}

@end
