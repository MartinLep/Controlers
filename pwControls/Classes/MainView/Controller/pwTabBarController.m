//
//  pwTabBarController.m
//  pwControls
//
//  Created by MartinLee on 17/1/3.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwTabBarController.h"
#import "pwBaseViewController.h"
#import "pwNavigationController.h"
#import "pwHomeViewController.h"
#import "pwViewController.h"

@interface pwTabBarController ()

@end

@implementation pwTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpChildControllers];
    [self setUpAddButton];
}

- (void)setUpAddButton{
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    NSString *imageNameHL = @"tabbar_compose_icon_add_highlighted";
    [addBtn setImage:[UIImage imageNamed:imageNameHL] forState:UIControlStateHighlighted];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    NSString *backgroundImageNameHL = @"tabbar_compose_button_highlighted";
    [addBtn setBackgroundImage:[UIImage imageNamed:backgroundImageNameHL] forState:UIControlStateHighlighted];
    [addBtn sizeToFit];
    [self.tabBar addSubview:addBtn];
    [addBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat count = (CGFloat)self.childViewControllers.count;
    CGFloat w = self.tabBar.bounds.size.width/count -1;
    addBtn.frame = CGRectInset(self.tabBar.bounds, 2*w, 0);
}

- (void)clickBtn{
    NSLog(@"点击了添加按钮");
}

- (void)setUpChildControllers{
    NSDictionary *homeDic = [NSDictionary dictionaryWithObjectsAndKeys:@"pwHomeViewController",@"clsName",@"控件",@"title",@"home",@"imageName", nil];
    NSDictionary *ablumDic = [NSDictionary dictionaryWithObjectsAndKeys:@"pwMessageViewController",@"clsName",@"网络",@"title",@"message_center",@"imageName", nil];
    NSDictionary *addDic = [NSDictionary dictionaryWithObjectsAndKeys:@"UIViewController",@"clsName", nil];
    NSDictionary *alertDic = [NSDictionary dictionaryWithObjectsAndKeys:@"pwDiscoverViewController",@"clsName",@"动画",@"title",@"discover",@"imageName", nil];
    NSDictionary *profileDic = [NSDictionary dictionaryWithObjectsAndKeys:@"pwProfileViewController",@"clsName",@"架构",@"title",@"profile",@"imageName", nil];
    NSArray *viewArr = [NSArray arrayWithObjects:homeDic,ablumDic,addDic,alertDic,profileDic,nil];

    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    for(int i = 0 ; i< viewArr.count ; i++){
        [arrayM addObject:[self controller:viewArr[i]]];
    }
    self.viewControllers = arrayM;
}

- (UIViewController *)controller:(NSDictionary *)dict{
    NSString *clsName = [dict objectForKey:@"clsName"];
    NSString *title = dict[@"title"];
    NSString *imageName = dict[@"imageName"];
    if(clsName&&title&&imageName){
        if([NSClassFromString(clsName) isSubclassOfClass:[pwBaseViewController class]]){
            pwBaseViewController *vc = [[NSClassFromString(clsName) alloc] init];
            vc.titleName = title;
            vc.tabBarItem.title = title;
            vc.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@",imageName]];
            vc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_selected",imageName]];
            [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
            [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName] forState:UIControlStateNormal];
            pwNavigationController *nav = [[pwNavigationController alloc] initWithRootViewController:vc];
            return nav;
        }
    }
    return [UIViewController new];
}
@end
