//
//  pwRadarView.h
//  pwControls
//
//  Created by MartinLee on 17/3/27.
//  Copyright © 2017年 MartinLee. All rights reserved.
//  雷达扇形区域动画

#import <UIKit/UIKit.h>
#import "pwRadarIndicator.h"

@interface pwRadarView : UIView

@property (nonatomic, strong) pwRadarIndicator * radarIndicatorView;
- (void) radarScan;
- (void) radarStop;

@end
