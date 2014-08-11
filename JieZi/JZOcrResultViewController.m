//
//  JZOcrResultViewController.m
//  JieZi
//
//  Created by 崔峥 on 14-8-6.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import "JZOcrResultViewController.h"
#import "UIImage+Filters.h"
#import "JZDictController.h"

@interface JZOcrResultViewController ()

@end

@implementation JZOcrResultViewController

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
//    self.view.backgroundColor = UIColorFromRGB(0xFFFF99);
    
    //设置边缘为圆角
    self.view.layer.cornerRadius = 6;
    self.view.layer.masksToBounds = YES;
    //设置识别结果的显示效果
    self.characterLabel.backgroundColor = UIColorFromRGB(0x99CC99);
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 0;
    //添加搜索手势
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearchButton:)];
    [self.characterLabel addGestureRecognizer:gesture];
    
    //设置识别结果显示文案
    if ([self.value length] > 0) {
        self.characterLabel.text = [self.value substringWithRange:NSMakeRange(0, 1)];
        self.contentLabel.text = [NSString stringWithFormat:@"完整的结果应该是这样的：%@", self.value];
        self.favorite = [[[[JZFavorite lazyFetcher] whereField:@"character" equalToValue:self.characterLabel.text] fetchRecords] lastObject];
    }else{
        self.favorite = nil;
        self.characterLabel.text = @"";
        self.contentLabel.text = @"很遗憾没有识别出来";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.value || [self.value length] == 0) {
        UIImage *image = [UIImage imageNamed:@"star_empty"];
        [self.favButton setImage:image forState:UIControlStateDisabled];
        favButtonStats = NO;
        self.favButton.enabled = NO;
    }else{
        if (self.favorite) {
            UIImage *image = [UIImage imageNamed:@"star_solid"];
            [self.favButton setImage:image forState:UIControlStateNormal];
            favButtonStats = YES;
        }else{
            UIImage *image = [UIImage imageNamed:@"star_empty"];
            [self.favButton setImage:image forState:UIControlStateNormal];
            favButtonStats = NO;
        }
        self.favButton.enabled = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(300, 116);
}

- (IBAction)switchTouchFav:(id)sender
{
    if (self.favorite) {
        UIImage *image = [UIImage imageNamed:@"star_empty"];
        [self.favButton setImage:image forState:UIControlStateNormal];
        if (self.favorite) {
            [self.favorite dropRecord];
            self.favorite = nil;
        }
    }else {
        UIImage *image = [UIImage imageNamed:@"star_solid"];
        [self.favButton setImage:image forState:UIControlStateNormal];
        if ([self.characterLabel.text length] > 0 && !self.favorite) {
            //保存到CoreData
            self.favorite = [JZFavorite newRecord];
            self.favorite.character = self.characterLabel.text;
            self.favorite.content = self.value;
            [self.favorite save];
        }
    }
}

- (void)tapSearchButton:(UITapGestureRecognizer *)gesture
{
    [self clickSearchButton:nil];
}

- (IBAction)clickSearchButton:(id)sender
{
    [JZDictController showCharacterView: self.characterLabel.text withController:self];
}

@end
