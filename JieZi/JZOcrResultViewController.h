//
//  JZOcrResultViewController.h
//  JieZi
//
//  Created by 崔峥 on 14-8-6.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZFavorite.h"

@class JZOcr;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface JZOcrResultViewController : UIViewController {
    BOOL favButtonStats;
}

@property (nonatomic, strong) IBOutlet UILabel *characterLabel;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UIButton *favButton;
@property (nonatomic, strong) JZFavorite *favorite;
@property (nonatomic, strong) NSString *value;//识别结果

- (CGSize)preferredContentSize;
+ (void)searchCharacter:(NSString *)character;
@end
