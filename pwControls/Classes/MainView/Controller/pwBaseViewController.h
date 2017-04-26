//
//  pwBaseViewController.h
//  pwControls
//
//  Created by MartinLee on 17/1/3.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pwBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)BOOL isPullUp;//是否是上拉刷新
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIRefreshControl *refreshControl;
@property(nonatomic,strong) UINavigationBar *navigationBar;
@property(nonatomic,strong) UINavigationItem *navItem;
@property(nonatomic,copy) NSString *titleName;

- (void)setUpUI;
@end
