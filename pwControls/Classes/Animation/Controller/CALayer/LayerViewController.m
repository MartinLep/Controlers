//
//  LayerViewController.m
//  pwControls
//
//  Created by MartinLee on 17/4/14.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "LayerViewController.h"
#import "pwView.h"

@interface LayerViewController ()<CALayerDelegate>

@end

@implementation LayerViewController{
    CGFloat width;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    width = 50;
}

- (void)setUpUI{
    [super setUpUI];
    [self.tableView removeFromSuperview];
    
    pwView *view=[[pwView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor=[UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1];
    [self.view addSubview:view];
    
    CALayer *layer = [[CALayer alloc] init];
    layer.backgroundColor = [UIColor colorWithRed:0 green:146/255.0 blue:1.0 alpha:1.0].CGColor;
    layer.position = self.view.center;
    layer.bounds = CGRectMake(0, 0, 50, 50);
    layer.cornerRadius = 25;//设置圆角，当圆角半径等于聚星的一半时看就来就是一个圆形
    layer.masksToBounds = true;//设置true后 阴影部分将被剪切
    
    //直接设置图片 不需要考虑图片倒立的问题
    UIImage *image = [UIImage imageNamed:@"img_loading_2"];
    [layer setContents:(id)image.CGImage];
  
//    //利用图形层形变解决图想倒立问题
//    layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
//    [layer setValue:@M_PI forKey:@"transform.rotation.x"];
    //layer.delegate = self;
    [self.view.layer addSublayer:layer];
    //[layer setNeedsDisplay];
    

    
    //设置图片阴影效果 再定义一个大小一样的图层
    CALayer *layerShadow=[[CALayer alloc]init];
    layerShadow.bounds=CGRectMake(0, 0, 50, 50);;
    layerShadow.position=self.view.center;
    layerShadow.cornerRadius=25;
    layerShadow.shadowColor=[UIColor grayColor].CGColor;
    layerShadow.shadowOffset=CGSizeMake(2, 1);
    layerShadow.shadowOpacity=1;
    layerShadow.borderColor=[UIColor whiteColor].CGColor;
    layerShadow.borderWidth=2;
    [self.view.layer addSublayer:layerShadow];
    [layerShadow setNeedsDisplay];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    
    
    CGContextSaveGState(ctx);
//    //解决图形上下文形变，解决图片倒立的问题
//    CGContextScaleCTM(ctx, 1, -1);
//    CGContextTranslateCTM(ctx, 0, -width);
    
    //图形层已处理图片倒立问题
    
    UIImage *image = [UIImage imageNamed:@"img_loading_2"];
    CGContextDrawImage(ctx, CGRectMake(0, 0, width, width), image.CGImage);
    CGContextRestoreGState(ctx);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    for (CALayer *layer in self.view.layer.sublayers) {
        if([self.view.layer.sublayers lastObject] == layer || self.view.layer.sublayers[self.view.layer.sublayers.count - 2] == layer){
            width = layer.bounds.size.width;
            if(width == 50){
                width = 50*2;
            }else{
                width = 50;
            }
            layer.bounds = CGRectMake(0, 0, width, width);
            layer.position = [touch locationInView:self.view];
            layer.cornerRadius = width/2;
            [layer setNeedsDisplay];
            
        }
    }
    //CALayer *layer = [self.view.layer.sublayers lastObject];
}

@end
