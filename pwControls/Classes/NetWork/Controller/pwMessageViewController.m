//
//  pwMessageViewController.m
//  pwControls
//
//  Created by MartinLee on 17/1/3.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwMessageViewController.h"
#import "pwJsonViewController.h"
#import "pwPlistViewController.h"
#import "pwXMLViewController.h"

@interface pwMessageViewController ()

@property(nonatomic,strong)NSArray *dataArray;

@end

static NSString *cellID = @"cellID";

@implementation pwMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"JSON",@"PLIST",@"XML"];
}

- (void)setUpUI{
    [super setUpUI];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            pwJsonViewController *viewController = [[pwJsonViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 1:
        {
            pwPlistViewController *viewController = [[pwPlistViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 2:
        {
            pwXMLViewController *viewController = [[pwXMLViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        default:
            break;
    }
}

@end
