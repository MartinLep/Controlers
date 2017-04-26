//
//  pwPullUpToRefreshViewController.m
//  pwControls
//
//  Created by MartinLee on 17/1/5.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwPullUpToRefreshViewController.h"
#import "UIScrollView+pwRefreshView.h"

@interface pwPullUpToRefreshViewController ()

@property (nonatomic,strong) NSMutableArray *dataSource;
@end

static NSString *cellID = @"cellID";

@implementation pwPullUpToRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loaddata];
}

- (void)loaddata{
    if(_dataSource == nil){
        NSMutableArray *array = [[NSMutableArray alloc] init];
        _dataSource = array;
    }
    for (int i = 0; i < 14; i++) {
        [_dataSource addObject:[NSString stringWithFormat:@"上拉数据_%lu",(unsigned long)_dataSource.count]];
    }
}

- (void)setUpUI{
    [super setUpUI];
    [self.refreshControl removeFromSuperview];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    UIView *footView = [UIView new];
    self.tableView.tableFooterView = footView;
    
    __weak typeof(self) weakSelf = self;
    [weakSelf.tableView.upRefreshView setPwPullUpToRefreshViewBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf loaddata];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.upRefreshView endreFresh];
            //结束刷新
        });
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

@end
