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
- (void)initDict
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"powerword2007_pwdcccjk" ofType:@"xml"];
    NSDictionary *rawDict = [NSDictionary dictionaryWithXMLFile:filePath];
    NSArray *words = [rawDict objectForKey:@"单词解释块"];
    //建立以查询词为key的hash
    //避免按照xml做搜索，hash更快
    self.dict = [NSMutableDictionary dictionaryWithCapacity:[words count]];
    for (NSDictionary *d in words) {
        NSDictionary *e = [d objectForKey:@"基本词义"];
        if (e) {
            NSDictionary *f = [e objectForKey:@"单词项"];
            if (f) {
                NSString *w = [f objectForKey:@"单词原型"];
                if (w && w.length > 0) {
                    [self.dict setObject:d forKey:w];
                }
            }
        }
    }
    NSLog(@"dict load complete.");
}

//展示某个单词
- (void)showWordInDict:(NSString *)w
{
    NSDictionary *wDict = [self.dict objectForKey:w];
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

@end
