//
//  JZViewController.m
//  JieZi
//
//  Created by 崔峥 on 14-8-5.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import "JZViewController.h"
#import "iOSBlocks/iOSBlocks.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "JZOcrResultViewController.h"
#import "RWBlurPopover/RWBlurPopover.h"
#import "btSimplePopUp/btSimplePopUP.h"
#import "JZDictController.h"

@interface JZViewController ()

@end

@implementation JZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.ocrFrameImageView.backgroundColor = [UIColor clearColor];
    self.ocrFrameImageView.opaque = NO;
    self.ocrFrameImageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.ocrFrameImageView.layer.borderWidth = 1.0f;
    
    if (!self.ocr) {
        self.ocr = [[JZOcr alloc] initWithView:self.ocrImageView];
    }
    self.ocr.delegate = self;
    self.ocr.borderView = self.ocrFrameImageView;
    [self.ocr startRunning];
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self.ocr.tesseract respondsToSelector:@selector(clear)]) {
        [self.ocr.tesseract clear];
        self.ocr.tesseract = nil;
    }else {
        self.ocr.tesseract = nil;
    }
}

#pragma mark -
#pragma mark OcrAction

- (IBAction)gotIt:(id)sender
{
    [SVProgressHUD showWithStatus:@"翻词典去啦！" maskType:SVProgressHUDMaskTypeGradient];
    [self.ocr captureimage];
}

#pragma mark -
#pragma mark OcrDelegation

- (void)OcrDidGetReconizedContextWithString:(NSString *)value
{
    [SVProgressHUD dismiss];
    NSLog(@"Recognized %@", value);
    
    JZOcrResultViewController *resultController = [[JZOcrResultViewController alloc] initWithNibName:@"JZOcrResultViewController" bundle:nil];
    resultController.value = value;
    RWBlurPopover *popover = [[RWBlurPopover alloc] initWithContentViewController:resultController];
    [self presentViewController:popover animated:YES completion:^(){
        
    }];
}

//- (void)OcrProgressImageRecognitionForTesseract:(Tesseract *)tesseract
//{
//    if (tesseract.progress < 100) {
//        [SVProgressHUD showProgress:tesseract.progress status:@"满头大汗的查找中" maskType:SVProgressHUDMaskTypeGradient];
//    }
//}

#pragma mark -
#pragma mark TesseractDelegate

- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract
{
//    NSLog(@"progress: %d", tesseract.progress);
    return NO;  // return YES, if you need to interrupt tesseract before it finishes
}

#pragma mark -
#pragma mark CardButton

- (IBAction)tapAtCardButton:(id)sender
{
    NSLog(@"Tap");
    //得到收藏列表前27个
    //pop上共3页
    self.favorites = [[[[JZFavorite lazyFetcher] limit:27] orderBy:@"id" ascending:NO] fetchRecords];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:[self.favorites count]];
    NSMutableArray *actions = [[NSMutableArray alloc] initWithCapacity:[self.favorites count]];
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:[self.favorites count]];
    btSimplePopUP *popUp;
    for (JZFavorite *f in self.favorites) {
        [titles addObject:f.character];
        completion a = ^(BOOL success, NSInteger idx){
            //选中了某个收藏
            JZFavorite *f = [self.favorites objectAtIndex:idx];
            [popUp dismiss];
            [JZDictController showCharacterView:f.character withController:self];
        };
        [actions addObject:a];
    }
    popUp = [[btSimplePopUP alloc] initWithItemImage:images
                                                        andTitles:titles
                                                   andActionArray:actions
                                              addToViewController:self];
    [self.view addSubview:popUp];
    popUp.delegate = self;
    [popUp show];
}

#pragma mark -
#pragma mark btSimplePopUPDelegate

- (void)btSimplePopUPDelegateRemoveFromSpringboard:(NSString *)string
{
    //根据string找到相同的收藏
    //删除之
    JZFavorite *favorite = [[[[JZFavorite lazyFetcher] whereField:@"character" equalToValue:string] fetchRecords] lastObject];
    if (favorite) {
        [favorite dropRecord];
    }
}

@end
