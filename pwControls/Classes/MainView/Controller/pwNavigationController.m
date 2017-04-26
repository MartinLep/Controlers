//
//  pwNavigationController.m
//  pwControls
//
//  Created by MartinLee on 17/1/3.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwNavigationController.h"
#import "pwBaseViewController.h"
#import "UIBarButtonItem+pwExtension.h"

@interface pwNavigationController ()

@end

@implementation pwNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.viewControllers.count > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        if([viewController isKindOfClass:[pwBaseViewController class]]){
            pwBaseViewController *vc = (pwBaseViewController *)viewController;
            NSString *title = @"<";
            if (self.viewControllers.count == 1) {
                title = [self.viewControllers firstObject].title == nil?@"<":[self.viewControllers firstObject].title;
            }
            
            //UIBarButtonItem *item = [UIBarButtonItem initWithTitle:title fontSize:16 target:self action:@selector(popToParent) isBack:true];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(popToParent)];
            vc.navItem.leftBarButtonItem = item;
        }
    }
    [super pushViewController:viewController animated:TRUE];
}

- (void)popToParent{
    [self popViewControllerAnimated:TRUE];
}

@end
