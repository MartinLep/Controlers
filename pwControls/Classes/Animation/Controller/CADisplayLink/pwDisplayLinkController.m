//
//  pwDisplayLinkController.m
//  pwControls
//
//  Created by MartinLee on 17/4/18.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwDisplayLinkController.h"

@interface pwDisplayLinkController ()
@property (nonatomic,strong) CADisplayLink * timerInC;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) int curentIndex;
@end

@implementation pwDisplayLinkController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUpUI{
    [super setUpUI];
    [self.tableView removeFromSuperview];
    self.view.backgroundColor = [UIColor grayColor];
    self.timerInC = [CADisplayLink displayLinkWithTarget:self selector:@selector(imageGif)];
    
    //暂停
    self.timerInC.paused = YES;
    
    //触发间隔
    self.timerInC.frameInterval = 2;
    
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    //加入一个runloop
    [self.timerInC addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    //[button setTitle:@"play" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"account_spinner"] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(gifAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
}

- (void)imageGif{
    _curentIndex++;
    if(_curentIndex > 75){
        _curentIndex = 1;
    }
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",_curentIndex]];
}

- (void)gifAction{
    self.timerInC.paused = !self.timerInC.paused;
}
@end
