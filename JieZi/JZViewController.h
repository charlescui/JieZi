//
//  JZViewController.h
//  JieZi
//
//  Created by 崔峥 on 14-8-5.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZOcr.h"

@interface JZViewController : UIViewController<JZOcrDelegate>

@property (nonatomic, strong) JZOcr *ocr;

@property (nonatomic, strong) IBOutlet UIImageView *ocrFrameImageView;
@property (nonatomic, strong) IBOutlet UIImageView *ocrImageView;
@property (nonatomic, strong) IBOutlet UIButton *ocrButton;
@property (nonatomic, strong) IBOutlet UIButton *cardButton;

@end
