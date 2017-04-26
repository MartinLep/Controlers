//
//  pwRadarIndicator.m
//  pwControls
//
//  Created by MartinLee on 17/3/27.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwRadarIndicator.h"

@implementation pwRadarIndicator

- (instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawWithContext:context];
}

- (void)drawWithContext:(CGContextRef)context{
    
    //起始点移到视图中间
    CGContextTranslateCTM(context, CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    
    //设置扫描扇形半径
    
    CGFloat radius = CGRectGetWidth(self.frame)/2.0;
    CGContextSetLineWidth(context, 0.1);
    CGFloat single = M_PI/180/2.0; //尾巴阴影的大小
    CGFloat colorAlpha = M_PI_2/90/2;
    CGFloat x = 0.0;
    
    for (int i = 0; i < 90 * 2; i ++) {
        
        //画小扇形
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddArc(context, 0, 0, radius, 0, -single, 1);
        
        //设置填充颜色以及透明度
        x = x + colorAlpha;
        CGFloat alpha = sin(1-x);
        UIColor * color = [UIColor colorWithRed:41/255.0 green:253/255.0 blue:47/255.0 alpha:alpha];
        [color setFill];
        
        CGContextFillPath(context);
        [color setStroke];
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
        
        //逆时针旋转坐标轴
        CGContextRotateCTM(context, -single);
        
    }
    
}

- (void) start
{
    [self setNeedsDisplay];
    CABasicAnimation * rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(2* M_PI);
    rotationAnimation.duration = 360/60;
    rotationAnimation.repeatCount = NSIntegerMax;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void) stop
{
    [self.layer removeAnimationForKey:@"rotationAnimation"];
}
- (void) rectangularCoordinates
{
    
    //画X轴
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 150, 0);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 150, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddLineToPoint(context, 140, 5);
    CGContextMoveToPoint(context, 150, 0);
    CGContextAddLineToPoint(context, 140, -5);
    CGContextStrokePath(context);
    
    //画Y轴
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, 150);
    CGContextAddLineToPoint(context, 5, 140);
    CGContextMoveToPoint(context, 0, 150);
    CGContextAddLineToPoint(context, -5, 140);
    CGContextStrokePath(context);
}


@end
