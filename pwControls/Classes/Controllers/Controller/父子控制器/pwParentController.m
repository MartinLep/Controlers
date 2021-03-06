//
//  pwParentController.m
//  pwControls
//
//  Created by MartinLee on 17/5/5.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwParentController.h"

@interface pwParentController ()
@property (weak, nonatomic) IBOutlet UIView *titleButtonView;
@property (weak, nonatomic) IBOutlet UIView *containView;

@end

@implementation pwParentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpUI{
    [self.tableView removeFromSuperview];
    
    //添加所有的子控制器
    [self setUpAllViewControllers];
    //设置按钮的内容
    [self setUptitleButtn];
}

- (void)setUptitleButtn{
    NSInteger count = self.titleButtonView.subviews.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.titleButtonView.subviews[i];
        UIViewController *vc = self.childViewControllers[i];
        [btn setTitle:vc.title forState:UIControlStateNormal];
    }
}

- (void)setUpAllViewControllers{
    UIViewController *view1 = [[UIViewController alloc] init];
    view1.title = @"第1个";
    [self addChildViewController:view1];
    
    UIViewController *view2 = [[UIViewController alloc] init];
    view2.title = @"第2个";
    [self addChildViewController:view2];
    
    UIViewController *view3 = [[UIViewController alloc] init];
    view3.title = @"第3个";
    [self addChildViewController:view3];
}

- (IBAction)showViewControllerView:(UIButton *)sender {
    
    [self.containView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIViewController *vc = self.childViewControllers[sender.tag];
    vc.view.backgroundColor = sender.backgroundColor;
    vc.view.frame = self.containView.bounds;
    [self.containView addSubview:vc.view];
}

@end
