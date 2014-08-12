//
//  JZDictController.m
//  JieZi
//
//  Created by 崔峥 on 14-8-10.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import "JZDictController.h"
#import "XMLDictionary/XMLDictionary.h"
#import "iOSBlocks/iOSBlocks.h"
#import "JZDict.h"
#import "JZCharacterViewController.h"
#import "RWBlurPopover/RWBlurPopover.h"

@implementation JZDictController

+ (JZDictController *)default
{
    static JZDictController *__controller;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        __controller = [[JZDictController alloc] init];
    });
    return __controller;
}

// 初始化词库
- (id)initDict
{
    if (!(self = [super init])) return nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dict" ofType:@"sqlite"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    NSLog(@"dict base file - %@ and file exists - %d", filePath, fileExists);
    db = [[ABSQLiteDB alloc] init];
	
	if(![db connect:filePath]) {
		return nil;
	}
    
    return self;
}

- (NSArray *)queryDictWithCharacter:(NSString *)w
{
    NSString* sql = [NSString stringWithFormat:@"select * from dicts where character = '%@'", w];
	id<ABRecordset> results = [db sqlSelect:sql];
    NSMutableArray *records = [NSMutableArray arrayWithCapacity:[results recordCount]];
	while (![results eof]) {
		JZDict* dict = [[JZDict alloc] init];
		NSString *data = [[results fieldWithName:@"data"] stringValue];
		dict.character = w;
        dict.data = [NSDictionary dictionaryWithXMLString:data];
        [records addObject:dict];
		[results moveNext];
	}
    return records;
}

//展示某个单词
- (void)showWordInDict:(NSString *)w
{
    NSArray *records = [self queryDictWithCharacter:w];
    NSLog(@"fetch data %@", records);
    JZDict *dict = [records lastObject];
    NSDictionary *wDict = dict.data;
    if (wDict) {
        NSString *title = [NSString stringWithFormat:@"\"%@\"的查询结果", w];
        
        NSDictionary *dancixiang = [[wDict objectForKey:@"基本词义"] objectForKey:@"单词项"];
        NSString *yinbiao = [[dancixiang objectForKey:@"单词音标"] objectForKey:@"汉语拼音"];
        NSArray *jieshixiangs = [dancixiang objectForKey:@"解释项"];
        NSString *jieshixiang = [jieshixiangs componentsJoinedByString:@"\n"];
        NSString *message = [NSString stringWithFormat:@"%@ - 音标:%@\n解释项:%@\n", w, yinbiao, jieshixiang];

        [UIAlertView alertViewWithTitle:title
                                message:message
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil
                              onDismiss:^(NSInteger idx, NSString *title){}
                               onCancel:^(){}];
    }else{
        [UIAlertView alertViewWithTitle:@""
                                message:@"抱歉，没找到结果"
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil
                              onDismiss:nil
                               onCancel:nil];
    }
}

+ (void)showCharacterView:(NSString *)character withController:(UIViewController *)parent
{
    NSArray *records = [[JZDictController default] queryDictWithCharacter:character];
    JZDict *dict = records.lastObject;
    JZCharacterViewController *controller = [[JZCharacterViewController alloc] initWithNibName:nil bundle:nil];
    controller.dict = dict;
    RWBlurPopover *popover = [[RWBlurPopover alloc] initWithContentViewController:controller];
    [parent presentViewController:popover animated:YES completion:^(){
        
    }];
}

@end
