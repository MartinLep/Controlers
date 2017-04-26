//
//  pwCoreAnimationController.m
//  pwControls
//
//  Created by MartinLee on 17/4/13.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwCoreAnimationController.h"

@interface pwCoreAnimationController ()

@end

@implementation pwCoreAnimationController{
    UIView *view;
    UIImageView *imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView removeFromSuperview];
}

- (void)setUpUI{
    [super setUpUI];
    for (int i = 0 ; i < 5 ; i++ ) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*[UIScreen pwScreenWidth]/5, [UIScreen pwScreenHeight]-30, [UIScreen pwScreenWidth]/5, 30)];
        [button setTitle:[NSString stringWithFormat:@"动画 %d",i+1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.tag = i;
        [self.view addSubview:button];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.center.equalTo(self.view);
    }];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_loading_1"]];
    imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 120));
        make.centerX.equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-120);
    }];
}

- (void)buttonClicked:(UIButton *)btn{
    [view.layer removeAllAnimations];
    switch (btn.tag) {
        case 0:
        {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];//bounds，position，frame
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.duration = 2;
            animation.timeOffset = 1.0;
            animation.repeatCount = MAXFLOAT;
            animation.beginTime = CACurrentMediaTime() + 2;
            animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 10, 10)];
            [view.layer addAnimation:animation forKey:nil];
        }
            break;
        case 1:{
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation.values = @[[NSValue valueWithCGPoint:CGPointMake(0, 0)],[NSValue valueWithCGPoint:CGPointMake(200, 200)],[NSValue valueWithCGPoint:CGPointMake(0, 200)]];
            animation.removedOnCompletion = NO;
            animation.duration = 2;
            animation.fillMode = kCAFillModeForwards;
            [view.layer addAnimation:animation forKey:@"keyframe"];
        }
            break;
        case 2:{
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 200, 300, 100)].CGPath; //指定path属性 values属性将被忽略
            //animation.values = @[[NSValue valueWithCGPoint:CGPointMake(0, 0)],[NSValue valueWithCGPoint:CGPointMake(200, 200)],[NSValue valueWithCGPoint:CGPointMake(0, 200)]];
            animation.removedOnCompletion = NO;
            animation.duration = 2;
            animation.fillMode = kCAFillModeBackwards;
            //animation.calculationMode = kCAAnimationPaced;
            animation.rotationMode = kCAAnimationRotateAuto;
            animation.keyTimes = @[@0,@0.2,@0.6,@0.8,@1];//path属性将动画分成四部分，所以keyTimes要设置五个值
            [view.layer addAnimation:animation forKey:@"keyframe"];
        }
            break;
        case 3:{
            CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            keyAnimation.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 100, 100)].CGPath;
            //keyAnimation.values = @[[NSValue valueWithCGPoint:CGPointMake(0, 0)],[NSValue valueWithCGPoint:CGPointMake(200, 200)],[NSValue valueWithCGPoint:CGPointMake(0, 200)]];
            keyAnimation.duration = 2;
            keyAnimation.removedOnCompletion = NO;
            keyAnimation.fillMode = kCAFillModeForwards;
            keyAnimation.keyTimes = @[@0,@0.25,@0.5,@0.75,@1];
            
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            basicAnimation.toValue = @50;
            basicAnimation.duration = 2;
            basicAnimation.fillMode = kCAFillModeForwards;
            basicAnimation.removedOnCompletion = NO;
            
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.duration = 2;
            group.fillMode = kCAFillModeForwards;
            group.removedOnCompletion = NO;
            group.animations = @[keyAnimation,basicAnimation];
            [view.layer addAnimation:group forKey:@"group"];
        }
            break;
        case 4:{
            CATransition *animation = [CATransition animation];
            animation.duration = 0.5;
            animation.fillMode = kCAFillModeForwards;
            animation.type = @"rippleEffect";
            animation.subtype = kCATransitionFromTop;
            [imageView.layer addAnimation:animation forKey:@"ripple"];
            imageView.image = [UIImage imageNamed:@"img_loading_2"];
        }
            break;
        default:
            break;
    }
}

@end
