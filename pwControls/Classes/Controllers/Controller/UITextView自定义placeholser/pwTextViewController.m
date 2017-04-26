//
//  pwTextViewController.m
//  pwControls
//
//  Created by MartinLee on 17/4/11.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwTextViewController.h"
#import "pwTextViewPlaceholder.h"

@interface pwTextViewController ()

@end

@implementation pwTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)setUpUI{
    [super setUpUI];
    [self.tableView removeFromSuperview];
    pwTextViewPlaceholder *textView = [[pwTextViewPlaceholder alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    textView.myPlaceholder = @"测试程序";
    [self.view addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
}

@end
