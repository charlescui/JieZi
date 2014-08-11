//
//  JZDictController.h
//  JieZi
//
//  Created by 崔峥 on 14-8-10.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABSQLiteDB.h"

@interface JZDictController : NSObject{
    ABSQLiteDB *db;
}

@property (nonatomic, strong) NSMutableDictionary *dict;

+ (JZDictController *)default;
- (id)initDict;
- (void)showWordInDict:(NSString *)w;
- (NSArray *)queryDictWithCharacter:(NSString *)w;

@end
