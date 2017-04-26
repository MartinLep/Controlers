//
//  pwRadarController.m
//  pwControls
//
//  Created by MartinLee on 17/4/13.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwRadarController.h"
#import "pwRadarView.h"

@interface pwRadarController ()
@property (nonatomic,strong) pwRadarView * radarView;
@end

@implementation pwRadarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.radarView = [[pwRadarView alloc] initWithFrame:CGRectMake(0, 0, 121, 121)];
    self.view.backgroundColor = [UIColor whiteColor];
    _radarView.layer.cornerRadius = 10;
    _radarView.layer.masksToBounds = YES;
    self.radarView.center = self.view.center;
    [self.view addSubview:self.radarView];
    [self.radarView radarScan];
}

@end
