//
//  pwPullDownToRefreshViewController.m
//  pwControls
//
//  Created by MartinLee on 17/1/5.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwPullDownToRefreshViewController.h"
#import "pwPullDownToRefreshView.h"
#import "UIScrollView+pwRefreshView.h"

@interface pwPullDownToRefreshViewController ()
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

static NSString *cellID = @"cellID";
@implementation pwPullDownToRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loaddata];
}

- (void)loaddata{
    if(_dataSource == nil){
        NSMutableArray *array = [[NSMutableArray alloc] init];
        _dataSource = array;
    }
    for (int i = 0; i < 5; i++) {
        [_dataSource addObject:[NSString stringWithFormat:@"下拉数据_%lu",(unsigned long)_dataSource.count]];
    }
    
    [_dataSource addObject:@"RACSequence和RACTuple简单使用"];
}

- (void)setUpUI{
    [super setUpUI];
    [self.refreshControl removeFromSuperview];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    UIView *footView = [UIView new];
    self.tableView.tableFooterView = footView;
    
    __weak typeof(self) weakSelf = self;
    [weakSelf.tableView.downRefrehView setRefreshBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf loaddata];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.downRefrehView endRefresh];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if(self.delegateSignal){
        [self.delegateSignal sendNext:[NSNumber numberWithInteger:indexPath.row]];
    }
}

- (void)dictionaryToModel{
    //遍历数组
    NSArray *numbers = @[@1,@2,@3,@4];
    
    //把数组转换成集合RACSequence numbers.rac_sequence
    //把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    //订阅号，激活信号，会自动把集合中的所有值遍历出来
    
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"numbers = %@",x);
    }];
    
    //遍历字典，遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"MartinLee",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        //解包元组，会把元组的值，按顺序给参数里面的变量复制
        RACTupleUnpack(NSString *key,NSString *value) = x;
        //相当于以下写法
        //NSString *key = x[0];
        //NSString *value = x[1];
        NSLog(@"key = %@,value = %@",key,value);
    }];
    
    //字典转模型
    //RAC高级写法:
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
        
        return nil;//[FlagItem flagWithDict:value];
        
    }] array];
}
@end
