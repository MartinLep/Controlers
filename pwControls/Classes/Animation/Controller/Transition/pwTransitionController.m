//
//  pwTransitionController.m
//  pwControls
//
//  Created by MartinLee on 17/4/14.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwTransitionController.h"

#define IMAGE_COUNT 5

@interface pwTransitionController (){
    UIImageView *_imageView;
    int _currentIndex;
}

@end

@implementation pwTransitionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUpUI{
    [super setUpUI];
    [self.tableView removeFromSuperview];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(0, 100, [UIScreen pwScreenWidth], [UIScreen pwScreenHeight]-100);
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = [UIImage imageNamed:@"0_0.jpg"];
    [self.view addSubview:_imageView];
    
    //添加手势
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];
}

- (void)leftSwipe:(UISwipeGestureRecognizer *)gesture{
    [self transitionAnimation:true];
}

- (void)rightSwipe:(UISwipeGestureRecognizer *)gesture{
    [self transitionAnimation:false];
}


/**
 转场动画
 */
- (void)transitionAnimation:(BOOL)isNext{
    //创建专场动画
    CATransition *transition = [[CATransition alloc] init];
//    设置动画类型
    transition.type = @"cube";
//    设置子类
    if(isNext){
        transition.subtype = kCATransitionFromRight;
    }else{
        transition.subtype = kCATransitionFromLeft;
    }
//    设置动画常量
    transition.duration = 1.0f;
//    设置转场后的新视图添加转场动画
    _imageView.image = [self getImage:isNext];
    [_imageView.layer addAnimation:transition forKey:@"KCTransitionAnimation"];
}

- (UIImage *)getImage:(BOOL)isNext{
    if(isNext){
        _currentIndex = (_currentIndex + 1)%IMAGE_COUNT;
    }else{
        _currentIndex = (_currentIndex-1+IMAGE_COUNT)%IMAGE_COUNT;
    }
    NSString *imageName = [NSString stringWithFormat:@"%d_0.jpg",_currentIndex];
    return [UIImage imageNamed:imageName];
}


@end
