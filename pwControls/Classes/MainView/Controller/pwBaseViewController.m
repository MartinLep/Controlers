//
//  pwBaseViewController.m
//  pwControls
//
//  Created by MartinLee on 17/1/3.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwBaseViewController.h"
#import "pwMethodSwizzling.h"
#import "UIColor+pwAddition.h"

@interface pwBaseViewController ()

@end

@implementation pwBaseViewController

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MT_ExchangeInstanceMethod(@selector(viewWillAppear:), @selector(mt_viewWillAppear:), self);
    });
}

-(void)mt_viewWillAppear:(BOOL)animated{
    [self mt_viewWillAppear:YES];
    NSString * className = NSStringFromClass([self class]);
    if (![className hasPrefix:@"UI"] && ![className hasPrefix:@"_"]) {
        //NSLog(@"即将显示:%@   备注:%@",self.class,self.view.accessibilityIdentifier);
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,64)];
        self.navItem = [[UINavigationItem alloc] init];
    }
    return self;
}


- (UINavigationItem *)navItem{
    if(_navItem == nil){
        UINavigationItem *item = [[UINavigationItem alloc] init];
        _navItem = item;
    }
    return _navItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPullUp = false;
    [self setUpUI];
}

- (void)setUpUI{
    //取消自动缩进，如果隐藏了导航栏，会缩进20个点
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self setUpNavigationBar];
    [self setUpTableView];
}

- (void)setTitleName:(NSString *)titleName{
    self.navItem.title = titleName;
}


- (void)setUpNavigationBar{
    [self.view addSubview:self.navigationBar];
    self.navigationBar.items = [NSArray arrayWithObject:self.navItem];
    self.navigationBar.barTintColor = [UIColor pwColorWithHex:0xF6F6F6];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor darkGrayColor] forKey:NSForegroundColorAttributeName];
}

#pragma mark 下拉刷新

- (void)setUpTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view insertSubview:tableView belowSubview:self.navigationBar];
    tableView.contentInset = UIEdgeInsetsMake(self.navigationBar.bounds.size.height, 0, self.tabBarController.tabBar.bounds.size.height, 0);
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    
    self.tableView = tableView;
    self.refreshControl = refreshControl;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  [UITableViewCell new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (void)loadData{
    [self.refreshControl endRefreshing];
}


#pragma 上拉刷新
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = (int)indexPath.row;
    int section = (int)tableView.numberOfSections - 1;
    if(row<0 || section<0) return;
    
    int count = (int)[tableView numberOfRowsInSection:section];
    if(row == (count - 1) && !self.isPullUp){
        self.isPullUp = TRUE;
        [self loadData];
    }
}

@end
