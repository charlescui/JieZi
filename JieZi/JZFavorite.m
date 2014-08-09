//
//  JZFavorite.m
//  JieZi
//
//  Created by 崔峥 on 14-8-8.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import "JZFavorite.h"
#import "ARDatabaseManager.h"

@implementation JZFavorite

+ (void)createIndexOnDB
{
    ARDatabaseManager *manager = (ARDatabaseManager *)[ARDatabaseManager sharedInstance];
    if ([[manager tables] containsObject:@"JZFavorite"]) {
        [manager executeSqlQuery:[@"create index idx_on_jzfavorite_character on JZFavorite(character)" UTF8String]];
    }
}

@end
