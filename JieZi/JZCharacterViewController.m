//
//  JZCharacterViewController.m
//  JieZi
//
//  Created by 崔峥 on 14-8-11.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import "JZCharacterViewController.h"
#import "JZDict.h"

@interface JZCharacterViewController ()

@end

@implementation JZCharacterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置UI头
    self.characterLabel.text = self.dict.character;
    
    //准备datasource
    NSDictionary *dancixiang = [[self.dict.data objectForKey:@"基本词义"] objectForKey:@"单词项"];
    self.pinyinlabel.text = [[dancixiang objectForKey:@"单词音标"] objectForKey:@"汉语拼音"];
    jieshixiangs = [dancixiang objectForKey:@"解释项"];
    NSDictionary *cankaocihui = [[self.dict.data objectForKey:@"基本词义"] objectForKey:@"参考词汇"];
    xiangguanci = [[cankaocihui objectForKey:@"单词项"] objectForKey:@"相关词"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    //设置边缘为圆角
    self.view.layer.cornerRadius = 18;
    self.view.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellIdentifier = @"JZCharacterViewControllerCell";
	
    //由于每个cell的高度都可能不同
    //并且每个卡片
	UITableViewCell* cell = nil;//[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	
    if (indexPath.section == 0) {
        cell.textLabel.text = [jieshixiangs objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = xiangguanci;
    }
    
    //支持文案多行
    [cell.textLabel sizeToFit];
    cell.textLabel.numberOfLines = 0;
    //让列表有UL的感觉
    cell.imageView.image = [UIImage imageNamed:@"character_point.png"];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!xiangguanci) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
        return [jieshixiangs count];
    }else{
        return 1;
    }
}

//cell自适应label文案长短变化
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label = [[UILabel alloc] init];
    CGRect labelFrame = label.frame;
    labelFrame.size.width = 220;
    label.frame = labelFrame;
    label.numberOfLines = 0;
    
    if (indexPath.section == 0) {
        label.text = [jieshixiangs objectAtIndex:indexPath.row];
    }else {
        label.text = xiangguanci;
    }
    
    [label sizeToFit];
    CGSize labelSize;
    labelSize = label.frame.size;
    
    return labelSize.height + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 320, 40)];
    switch (section) {
        case 0:
            label.text = @"解释项";
            return label;
            break;
        case 1:
            label.text = @"相关词";
            return label;
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark -
#pragma mark BtnAction

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(300, 420);
}

@end
