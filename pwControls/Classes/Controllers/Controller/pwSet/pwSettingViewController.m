//
//  pwSettingViewController.m
//  pwControls
//
//  Created by MartinLee on 17/2/8.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwSettingViewController.h"
#import "pwSettingItemModel.h"
#import "pwSettingSectionModel.h"
#import "pwSettingCell.h"

@interface pwSettingViewController ()

@property (nonatomic,strong) NSArray  *sectionArray; /**< section模型数组*/

@end

@implementation pwSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSections];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupSections{
//*************************************
    __weak typeof(self) weakSelf = self;
    
    pwSettingItemModel *reNameItem = [[pwSettingItemModel alloc] init];
    reNameItem.image = [UIImage imageNamed:@"rename"];
    reNameItem.cellName = @"重命名";
    reNameItem.executeCode = ^{
        NSLog(@"重命名");
    };
    reNameItem.detailText = @"My Camera";
    reNameItem.accessoryType = PWSettingAccessoryTypeDisclosureIndicator;
    
    pwSettingItemModel *shareItem = [[pwSettingItemModel alloc] init];
    shareItem.image = [UIImage imageNamed:@"shared"];
    shareItem.cellName = @"分享摄像机";
    shareItem.executeCode = ^{
        NSLog(@"分享摄像机");
    };
    shareItem.accessoryType = PWSettingAccessoryTypeDisclosureIndicator;
    
    pwSettingSectionModel *section1 = [[pwSettingSectionModel alloc] init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[reNameItem,shareItem];
    
//*************************************
    pwSettingItemModel *installItem = [[pwSettingItemModel alloc] init];
    installItem.cellName = @"视角";
    installItem.image = [UIImage imageNamed:@"shijiao"];
    installItem.detailText = @"俯视";
    installItem.executeCode = ^{
        NSLog(@"视角");
    };
    installItem.accessoryType = PWSettingAccessoryTypeDisclosureIndicator;
    
    pwSettingItemModel *breathLightItem = [[pwSettingItemModel alloc] init];
    breathLightItem.cellName = @"呼吸灯";
    breathLightItem.image = [UIImage imageNamed:@"breathLight"];
    breathLightItem.switchValueChanged = ^(BOOL isOn){
        NSLog(@"呼吸灯 = %d",isOn);
    };
    breathLightItem.accessoryType = PWSettingAccessoryTypeSwitch;
    
    pwSettingItemModel *firmwareItem = [[pwSettingItemModel alloc] init];
    firmwareItem.image = [UIImage imageNamed:@"gujian"];
    firmwareItem.cellName = @"固件";
    firmwareItem.accessoryType = PWSettingAccessoryTypeNone;
    firmwareItem.detailText = @"已是最新版本";
    __weak pwSettingItemModel *weakItem = firmwareItem;
    firmwareItem.executeCode = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if([weakItem.detailText isEqualToString:@"已是最新版本"]){
                weakItem.detailText = @"有新的固件";
                NSLog(@"已是最新版本");
            }else{
                weakItem.detailText = @"已是最新版本";
                NSLog(@"有新的固件");
            }
            [weakSelf.tableView reloadData];
        });
    };
    pwSettingSectionModel *section2 = [[pwSettingSectionModel alloc] init];
    section2.sectionHeaderHeight = 18;
    section2.itemArray = @[installItem,breathLightItem,firmwareItem];
    
//*************************************
    pwSettingItemModel *rootItem = [[pwSettingItemModel alloc] init];
    rootItem.middleName = @"重启该摄像机";
    rootItem.accessoryType = pwSettingItemModelMiddle;
    rootItem.executeCode = ^{
        NSLog(@"重启该摄像机");
    };
    
    pwSettingItemModel *deleteItem = [[pwSettingItemModel alloc] init];
    deleteItem.middleName = @"删除此摄像机";
    deleteItem.accessoryType = pwSettingItemModelMiddle;
    deleteItem.executeCode = ^{
        NSLog(@"删除此摄像机");
    };
    
    pwSettingSectionModel *section3 = [[pwSettingSectionModel alloc] init];
    section3.sectionHeaderHeight = 18;
    section3.itemArray = @[rootItem,deleteItem];
    
    self.sectionArray = @[section1,section2,section3];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    pwSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"CellID";
    pwSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    pwSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    pwSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[pwSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.item = itemModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    pwSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    pwSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    pwSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if(itemModel.executeCode){
        itemModel.executeCode();
    }
}

@end
