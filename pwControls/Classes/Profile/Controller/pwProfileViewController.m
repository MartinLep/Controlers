//
//  pwProfileViewController.m
//  pwControls
//
//  Created by MartinLee on 17/1/3.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwProfileViewController.h"
#import "pwChainCaculatorBlock.h"
#import "NSObject+Property.h"
#import "NSDictionary+Property.h"
#import "NSObject+Model.h"
#import "pwStatusModel.h"
#import "Animal.h"
#import "pwControls-swift.h"
@interface pwProfileViewController ()

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation pwProfileViewController


- (NSArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSArray arrayWithObjects:@"链式编程",@"消息机制",@"RunTime实现字典转模型",@"地图",@"指南针",@"地域监听",@"地理编码&反地理编码",@"显示地图",nil];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    switch (indexPath.row) {
        case 0:{
            pwChainCaculatorBlock *block = [[pwChainCaculatorBlock alloc] init];
            block.add(5).add(3);
            NSLog(@"result = %d",block.result);
        }
            break;
        case 1:{
            Animal *animal = [[Animal alloc] init];
            [animal performSelector:@selector(animal:) withObject:@6];
            
            NSObject *obj = [[NSObject alloc] init];
            obj.name = @"abc";
        }
            break;
        case 2:{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"status.plist" ofType:nil];
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
            pwStatusModel *model = [pwStatusModel modelWithDictionary:dict];
            NSLog(@"model = %@",model);
        }
            break;
        case 3:{
            pwLocationViewController *view = [[pwLocationViewController alloc] init];
            [self.navigationController pushViewController:view animated:true];
        }
            break;
        case 4:{
            pwCompassViewController *view = [[pwCompassViewController alloc] init];
            [self.navigationController pushViewController:view animated:true];
        }
            break;
        case 5:{
            pwLocationMonitor *view = [[pwLocationMonitor alloc] init];
            [self.navigationController pushViewController:view animated:true];
        }
            break;
        case 6:{
            pwLocationDecode *view = [[pwLocationDecode alloc] init];
            [self.navigationController pushViewController:view animated:true];
        }
            break;
        case 7:{
            pwMapViewController *view = [[pwMapViewController alloc] init];
            [self.navigationController pushViewController:view animated:true];
        }
            break;
        default:
            break;
    }
}

@end
