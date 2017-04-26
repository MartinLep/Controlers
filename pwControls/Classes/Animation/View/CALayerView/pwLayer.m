//
//  pwLayer.m
//  pwControls
//
//  Created by MartinLee on 17/4/14.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwLayer.h"

@implementation pwLayer

- (void)drawInContext:(CGContextRef)ctx{
    NSLog(@"3-drawInContext = %@",ctx);
    
    CGContextSetRGBFillColor(ctx, 135/255.0, 232/255.0, 84/255.0, 1);
    CGContextSetRGBStrokeColor(ctx, 135/255.0, 232/255.0, 84/255.0, 1);
    
    CGContextMoveToPoint(ctx, 94.5, 33.5);
    
    //// Star Drawing
    CGContextAddLineToPoint(ctx,104.02, 47.39);
    CGContextAddLineToPoint(ctx,120.18, 52.16);
    CGContextAddLineToPoint(ctx,109.91, 65.51);
    CGContextAddLineToPoint(ctx,110.37, 82.34);
    CGContextAddLineToPoint(ctx,94.5, 76.7);
    CGContextAddLineToPoint(ctx,78.63, 82.34);
    CGContextAddLineToPoint(ctx,79.09, 65.51);
    CGContextAddLineToPoint(ctx,68.82, 52.16);
    CGContextAddLineToPoint(ctx,84.98, 47.39);
    CGContextClosePath(ctx);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end
