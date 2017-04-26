//
//  pwShowPictureViewController.m
//  pwControls
//
//  Created by MartinLee on 17/1/5.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwShowPictureViewController.h"
#import "pwUIImageView.h"

@interface pwShowPictureViewController ()
@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,weak)UIImageView *imageView;
@end

@implementation pwShowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUpUI{
    [super setUpUI];
    [self.tableView removeFromSuperview];
    
    pwUIImageView *imageView = [[pwUIImageView alloc] initWithFrame:self.view.bounds andImage:[UIImage imageNamed:@"car.jpg"]];
    imageView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"compose_slogan"].CGImage);
    [self.view insertSubview:imageView belowSubview:self.navigationBar];
//    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64);
//
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car.jpg"]];
//    [scrollView addSubview:imageView];
//    self.imageView = imageView;
//    scrollView.contentSize = imageView.image.size;
//    
//    //内容的内边距
//    scrollView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
//    
//    //设置scrollView的背景图片
//    scrollView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"compose_slogan"].CGImage);
//    
//    scrollView.delegate = self;
//    
//    scrollView.maximumZoomScale = 3.0;
//    scrollView.minimumZoomScale = 0.5;
//    
//    self.scrollView = scrollView;
//    [self.view addSubview:scrollView];
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
//    tapGesture.numberOfTapsRequired = 2;
//    [self.scrollView addGestureRecognizer:tapGesture];
//}
//
//- (void)doubleClick:(UITapGestureRecognizer *)tapGesture{
//    [self.imageView sizeToFit];
//    self.scrollView.contentSize = self.imageView.image.size;
//}
//
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return self.imageView;
}

@end
