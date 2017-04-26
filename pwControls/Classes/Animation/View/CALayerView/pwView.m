//
//  pwView.m
//  pwControls
//
//  Created by MartinLee on 17/4/14.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwView.h"
#import "pwLayer.h"

@implementation pwView

-(instancetype)initWithFrame:(CGRect)frame{
    NSLog(@"initWithFrame:");
    if (self=[super initWithFrame:frame]) {
        pwLayer *layer=[[pwLayer alloc]init];
        layer.bounds=CGRectMake(0, 0, 185, 185);
        layer.position=CGPointMake(160,284);
        layer.backgroundColor=[UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
        
        //显示图层
        [layer setNeedsDisplay];
        
        [self.layer addSublayer:layer];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    NSLog(@"2-drawRect:");
    NSLog(@"CGContext:%@",UIGraphicsGetCurrentContext());//得到的当前图形上下文正是drawLayer中传递的
    [super drawRect:rect];
    
}
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    NSLog(@"1-drawLayer:inContext:");
    NSLog(@"CGContext:%@",ctx);
    [super drawLayer:layer inContext:ctx];
    
}


@end
