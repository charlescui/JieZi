//
//  JZDictController.h
//  JieZi
//
//  Created by 崔峥 on 14-8-10.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZDictController : NSObject

@property (nonatomic, strong) NSMutableDictionary *dict;

+ (JZDictController *)default;
- (void)initDict;
- (void)showWordInDict:(NSString *)w;

@end
