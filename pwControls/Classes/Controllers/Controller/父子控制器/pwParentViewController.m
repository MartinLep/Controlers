//
//  pwParentViewController.h
//  pwControls
//
//  Created by MartinLee on 17/5/4.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwParentViewController.h"

@interface pwParentViewController ()
@property (weak, nonatomic) IBOutlet UIView *titleViews;
@property (weak, nonatomic) IBOutlet UIView *containtView;

@end

@implementation pwParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllViewControllers];
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
}

@end
