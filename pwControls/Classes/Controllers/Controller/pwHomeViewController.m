//
//  pwHomeViewController.m
//  pwControls
//
//  Created by MartinLee on 17/1/3.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwHomeViewController.h"
#import "UIBarButtonItem+pwExtension.h"
#import "pwHUDViewController.h"
#import "pwPullDownToRefreshViewController.h"
#import "pwPullUpToRefreshViewController.h"
#import "pwShowPictureViewController.h"
#import "pwMethodSwizzling.h"
#import "pwAlertViewController.h"
#import "pwSettingViewController.h"
#import "pwTextViewController.h"
#import "pwParentController.h"
#import "pwLayoutViewController.h"

@interface pwHomeViewController ()

@property(nonatomic,strong)NSArray *dataArray;

@end

static NSString *cellID = @"cellID";

@implementation pwHomeViewController

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MT_ExchangeInstanceMethod(@selector(viewWillAppear:), @selector(self_viewWillAppear:), self);
    });
}

- (void)self_viewWillAppear:(BOOL)animated{
    [self self_viewWillAppear:YES];
    NSString * className = NSStringFromClass([self class]);
    if (![className hasPrefix:@"UI"] && ![className hasPrefix:@"_"]) {
        //NSLog(@"self_viewWillAppear_即将显示:%@   备注:%@",self.class,self.view.accessibilityIdentifier);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"下拉刷新+RACSubject替换代理",
                       @"上拉刷新",
                       @"显示大图",
                       @"AlertView",
                       @"pwSet",
                       @"UITextView自定义placeholder属性",
                       @"父子控制器",
                       @"图片浏览器"];
}

#pragma mark UITableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            pwPullDownToRefreshViewController *view = [pwPullDownToRefreshViewController new];
            view.delegateSignal = [RACSubject subject];
            [view.delegateSignal subscribeNext:^(id x) {
                NSLog(@"点击了按钮 = %@",x);
            }];
            [self.navigationController pushViewController:view animated:true];
        }
            break;
        case 1:{
            pwPullUpToRefreshViewController *view = [pwPullUpToRefreshViewController new];
            [self.navigationController pushViewController:view animated:true];
        }
            break;
        case 2:{
            pwShowPictureViewController * view = [[pwShowPictureViewController alloc] init];
            [self.navigationController pushViewController:view animated:true];
        }
            break;
        case 3:{
            pwAlertViewController *view = [[pwAlertViewController alloc] init];
            [self.navigationController pushViewController:view animated:true];
        }
            break;
        case 4:{
            pwSettingViewController *view = [[pwSettingViewController alloc] init];
            [self.navigationController pushViewController:view animated:true];
        }
            break;
        case 5:{
            pwTextViewController *view = [[pwTextViewController alloc] init];
            [self.navigationController pushViewController:view animated:true];
        }
            break;
        case 6:{
            pwParentController *view = [[pwParentController alloc] init];
            [self.navigationController pushViewController:view animated:true];
        }
            break;
        case 7:{
            pwLayoutViewController *view = [[pwLayoutViewController alloc] init];
            [self.navigationController pushViewController:view animated:true];
        }
            break;
        default:
            break;
    }
}

#pragma mark 子类重写父类的方法
- (void)setUpUI{
    [super setUpUI];
    //注册复用UITableViewCell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"HUD" style:UIBarButtonItemStyleDone target:self action:@selector(pushToNextPage)];
}

- (void)pushToNextPage{
    pwHUDViewController *view = [pwHUDViewController new];
    view.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)loadData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        if(self.isPullUp){
            NSLog(@"上拉刷新");
        }else{
            NSLog(@"下拉刷新");
        }
        self.isPullUp = false;
    });
}



@end
