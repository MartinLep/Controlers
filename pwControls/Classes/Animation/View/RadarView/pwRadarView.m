//
//  pwRadarView.m
//  pwControls
//
//  Created by MartinLee on 17/3/27.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwRadarView.h"

@implementation pwRadarView

- (instancetype) initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.radarIndicatorView];
        
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCircle:context];
    
    
}
- (pwRadarIndicator *) radarIndicatorView
{
    if (!_radarIndicatorView) {
        
        _radarIndicatorView = [[pwRadarIndicator alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _radarIndicatorView.center = self.center;
        
    }
    return _radarIndicatorView;
    
}
- (void) drawCircle:(CGContextRef ) context
{
    
    //将坐标轴移动到视图中心
    CGContextTranslateCTM(context, CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    
    
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(context, 2);
    
    
    //画圆弧
    for (int i = 0; i < 3; i ++) {
        
        CGContextMoveToPoint(context, 20 + i* 20, 0);
        CGContextAddArc(context, 0, 0, 20 + i* 20, 0, M_PI * 2, 0);
        
    }
    CGContextStrokePath(context);
    
    //画十字坐标
    CGContextMoveToPoint(context, -CGRectGetWidth(self.frame)/2.0, 0);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame)/2.0, 0);
    
    CGContextMoveToPoint(context, 0, -CGRectGetWidth(self.frame)/2.0);
    CGContextAddLineToPoint(context, 0, CGRectGetWidth(self.frame)/2.0);
    
    CGContextStrokePath(context);
    
}
//开始扫描
- (void) radarScan
{
    
    [self.radarIndicatorView start];
}

- (void) radarStop{
    [self.radarIndicatorView stop];
}

-  (void)dealloc{
    [self.radarIndicatorView stop];
}


@end
