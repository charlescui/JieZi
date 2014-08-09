//
//  JZFavorite.h
//  JieZi
//
//  Created by 崔峥 on 14-8-8.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveRecord.h"

@interface JZFavorite : ActiveRecord

@property (nonatomic, retain) NSString * character;//被识别的首字母
@property (nonatomic, retain) NSString * content;//被识别出来的原文

+ (void)createIndexOnDB;

@end
