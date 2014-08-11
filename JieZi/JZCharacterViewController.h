//
//  JZCharacterViewController.h
//  JieZi
//
//  Created by 崔峥 on 14-8-11.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCollapseTableView.h"

@class JZDict;

@interface JZCharacterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSArray *jieshixiangs;
    NSString *xiangguanci;
}

@property (nonatomic, strong) IBOutlet UILabel *characterLabel;
@property (nonatomic, strong) IBOutlet UILabel *pinyinlabel;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) JZDict *dict;

- (CGSize)preferredContentSize;

@end
