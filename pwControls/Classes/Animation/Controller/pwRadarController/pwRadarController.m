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

- (void)setUpUI{
    [super setUpUI];
    [self.tableView removeFromSuperview];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"1_0.jpg"];
    //image = [image circleImage:image withParam:180];
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    NSLog(@"imageSize = %@",NSStringFromCGSize(image.size));
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [path addClip];
    
    [image drawAtPoint:CGPointZero];
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndPDFContext();
    
    [self.view addSubview:imageView];
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
}
@end
