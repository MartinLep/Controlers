//
//  pwAlertController.m
//  Alert
//
//  Created by MartinLee on 17/3/27.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwAlertController.h"
#import "pwActionView.h"
#import "Masonry.h"

@interface pwAlertController ()

@property (nonatomic,strong) UIView *customView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *wifiButton;

@property (nonatomic,strong) UIButton *lineButton;

@property (nonatomic,strong) UIButton *APButton;

@property (nonatomic,assign) int actionNumbers;

@end

@implementation pwAlertController

- (instancetype)initWithtitles:(NSArray *)titles detailArray:(NSArray *)details imageArray:(NSArray *)images selectedBlock:(itemClickBlock)block{
    if(self = [super init]){
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        self.view.backgroundColor = [UIColor clearColor];
        self.indexBlock = block;
        self.view.superview.backgroundColor = [UIColor clearColor];
        UIView *backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self.view addSubview:backGroundView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
        [backGroundView addGestureRecognizer:tap];
        [self commonInit];
    }
    return self;
}

- (void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)commonInit{
    
    UIView *superView = self.view;
    self.view.clipsToBounds = FALSE;
    
    //用于覆盖原有的样式
    self.customView = [[UIView alloc] init];
    self.customView.backgroundColor = [UIColor lightGrayColor];
    self.customView.layer.masksToBounds = TRUE;
    self.customView.layer.cornerRadius = 5;
    self.customView.center = self.view.center;
    [self.view addSubview:self.customView];
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 300));
        make.center.equalTo(superView);
    }];
    
    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.layer.cornerRadius = 5;
    self.titleLabel.layer.masksToBounds = TRUE;
    self.titleLabel.text = @"添加摄像机";
    self.titleLabel.backgroundColor = [UIColor orangeColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.customView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(300, 40));
        make.topMargin.mas_equalTo(@0);
    }];
    
    for (int i = 0; i < 4; i++) {
        CGRect rect = CGRectMake(8, 45+65*i, 284, 60);
        pwActionView *actionView = [[pwActionView alloc] initWithFrame:rect titleLabel:@"WIFI添加" detailLabel:@"通过WIFI和声波传输配置摄像机" rightImage:@"refreshing_04"];
        actionView.tag = i;
        actionView.layer.cornerRadius = 3;
        [self.customView addSubview:actionView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
        [actionView addGestureRecognizer:tap];
        
    }
}

- (void)action:(UITapGestureRecognizer*)recognizer{
    
    if(self.indexBlock){
        _indexBlock((int)recognizer.view.tag);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

