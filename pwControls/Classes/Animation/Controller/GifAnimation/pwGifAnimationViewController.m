//
//  pwGifAnimationViewController.m
//  pwControls
//
//  Created by MartinLee on 17/4/19.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "UIImageView+GifTool.h"
#import "pwGifAnimationViewController.h"

@interface pwGifAnimationViewController ()

@property (nonatomic,strong) UIImageView *gifImage;
@end

@implementation pwGifAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setUpUI{
    [super setUpUI];
    [self.tableView removeFromSuperview];
    
    _gifImage = [[UIImageView alloc] initWithGifPathString:[[NSBundle mainBundle] pathForResource:@"vvv" ofType:@"gif"] repeatCount:MAXFLOAT];
    [self.view addSubview:_gifImage];
    _gifImage.contentMode = UIViewContentModeScaleAspectFit;

    
    UIButton *gifBtn = [[UIButton alloc] init];
    [gifBtn setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:gifBtn];
    [gifBtn addTarget:self action:@selector(gifAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [gifBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.bottom.mas_equalTo(self.view).offset(-60);
    }];
}

- (void)gifAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        [_gifImage suspendGif];
    }else{
        [_gifImage resumeGif];
    }
}

@end
