//
//  pwAlertViewController.m
//  pwControls
//
//  Created by MartinLee on 17/1/11.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwAlertViewController.h"
#import "JXTAlertManagerHeader.h"

@interface pwAlertViewController ()

@property (nonatomic, strong) NSArray * dataArray;

@end

static NSString *cellID = @"cellID";

@implementation pwAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@"常规两个按钮alert",
                       @"简易调试使用alert，单按钮，标题默认为'确定'",
                       @"不定数量按钮alert",
                       @"无按钮toast样式",
                       @"单文字HUD",
                       @"带indicatorView的HUD",
                       @"带进度条的HUD，成功！",
                       @"带进度条的HUD，失败！",
                       @"常规alertController-Alert",
                       @"常规alertController-ActionSheet",
                       @"无按钮alert-toast",
                       @"无按钮actionSheet-toast",
                       @"带输入框的alertController-Alert"];
}

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
        case 0:
            jxt_showAlertTwoButton(@"常规两个按钮alert", @"支持按钮点击回调，支持C函数快速调用", @"cancel", ^(NSInteger buttonIndex) {
                NSLog(@"cancel");
            }, @"other", ^(NSInteger buttonIndex) {
                NSLog(@"other");
            });
            break;
        case 1:
            jxt_showAlertTitle(@"简易调试使用alert，单按钮，标题默认为“确定”");
            break;
        case 2:
            [JXTAlertView showAlertViewWithTitle:@"不定数量按钮alert" message:@"支持按钮点击回调，根据按钮index区分响应，有cancel按钮时，cancel的index默认0，无cancel时，按钮index根据添加顺序计算" cancelButtonTitle:@"cancel" buttonIndexBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    NSLog(@"cancel");
                }
                else if (buttonIndex == 1) {
                    NSLog(@"按钮1");
                }
                else if (buttonIndex == 2) {
                    NSLog(@"按钮2");
                }
                else if (buttonIndex == 3) {
                    NSLog(@"按钮3");
                }
                else if (buttonIndex == 4) {
                    NSLog(@"按钮4");
                }
                else if (buttonIndex == 5) {
                    NSLog(@"按钮5");
                }
            } otherButtonTitles:@"按钮1", @"按钮2", @"按钮3", @"按钮4", @"按钮5", nil];
            break;
        case 3:
            [JXTAlertView showToastViewWithTitle:@"无按钮toast样式" message:@"可自定义展示延时时间，支持关闭回调" duration:2 dismissCompletion:^(NSInteger buttonIndex) {
                NSLog(@"关闭");
            }];
            break;
        case 4:
            jxt_showTextHUDTitleMessage(@"单文字HUD", @"支持子标题，手动执行关闭，可改变显示状态");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                jxt_dismissHUD();
            });
            break;
        case 5:
            jxt_showLoadingHUDTitleMessage(@"带indicatorView的HUD", @"支持子标题，手动执行关闭，可改变显示状态");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                jxt_dismissHUD();
            });
            break;
        case 6:{
            jxt_showProgressHUDTitleMessage(@"带进度条的HUD", @"支持子标题，手动执行关闭，可改变显示状态");
            __block float count = 0;
//#warning timer block ios10 only
            [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                count += 0.05;
                jxt_setHUDProgress(count);
                if (count > 1) {
                    [timer invalidate];
                    jxt_setHUDSuccessTitle(@"加载成功！");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        jxt_dismissHUD();
                    });
                }
            }];
        }
            break;
        case 7:{
            jxt_showProgressHUDTitleMessage(@"带进度条的HUD", @"支持子标题，手动执行关闭，可改变显示状态");
            __block float count = 0;
//#warning timer block ios10 only
            [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                count += 0.05;
                jxt_setHUDProgress(count);
                if (count > 1) {
                    [timer invalidate];
                    jxt_setHUDFailMessage(@"加载失败！");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        jxt_dismissHUD();
                    });
                }
            }];
        }
            break;
        case 8:{
            [self jxt_showAlertWithTitle:@"常规alertController-Alert" message:@"基于系统UIAlertController封装，按钮以链式语法模式快捷添加，可根据按钮index区分响应，可根据action区分响应，支持配置弹出、关闭回调，可关闭弹出动画" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.
                addActionCancelTitle(@"cancel").
                addActionDestructiveTitle(@"按钮1");
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                if (buttonIndex == 0) {
                    NSLog(@"cancel");
                }
                else if (buttonIndex == 1) {
                    NSLog(@"按钮1");
                }
                NSLog(@"%@--%@", action.title, action);
            }];
        }
            break;
        case 9:{
            [self jxt_showActionSheetWithTitle:@"常规alertController-ActionSheet" message:@"基于系统UIAlertController封装，按钮以链式语法模式快捷添加，可根据按钮index区分响应，可根据action区分响应，支持配置弹出、关闭回调，可关闭弹出动画" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.
                addActionCancelTitle(@"cancel").
                addActionDestructiveTitle(@"按钮1").
                addActionDefaultTitle(@"按钮2").
                addActionDefaultTitle(@"按钮3").
                addActionDestructiveTitle(@"按钮4");
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                
                if ([action.title isEqualToString:@"cancel"]) {
                    NSLog(@"cancel");
                }
                else if ([action.title isEqualToString:@"按钮1"]) {
                    NSLog(@"按钮1");
                }
                else if ([action.title isEqualToString:@"按钮2"]) {
                    NSLog(@"按钮2");
                }
                else if ([action.title isEqualToString:@"按钮3"]) {
                    NSLog(@"按钮3");
                }
                else if ([action.title isEqualToString:@"按钮4"]) {
                    NSLog(@"按钮4");
                }
            }];
        }
            break;
        case 10:{
            [self jxt_showAlertWithTitle:@"无按钮alert-toast" message:@"toast样式，可自定义展示延时时间，支持配置弹出、关闭回调，可关闭弹出动画" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.toastStyleDuration = 2;
                [alertMaker setAlertDidShown:^{
                    [self logMsg:@"alertDidShown"];//不用担心循环引用
                }];
                alertMaker.alertDidDismiss = ^{
                    [self logMsg:@"alertDidDismiss"];
                };
            } actionsBlock:NULL];
        }
            break;
        case 11:{
            [self jxt_showActionSheetWithTitle:@"无按钮actionSheet-toast" message:@"toast样式，可自定义展示延时时间，支持配置弹出、关闭回调，可关闭弹出动画" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.toastStyleDuration = 3;
                //关闭动画效果
                [alertMaker alertAnimateDisabled];
                
                [alertMaker setAlertDidShown:^{
                    NSLog(@"alertDidShown");
                }];
                alertMaker.alertDidDismiss = ^{
                    NSLog(@"alertDidDismiss");
                };
            } actionsBlock:NULL];
        }
            break;
        case 12:{
            [self jxt_showAlertWithTitle:@"带输入框的alertController-Alert" message:@"点击按钮，控制台打印对应输入框的内容" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.
                addActionDestructiveTitle(@"获取输入框1").
                addActionDestructiveTitle(@"获取输入框2");
                
                [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"输入框1-请输入";
                }];
                [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"输入框2-请输入";
                }];
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                if (buttonIndex == 0) {
                    UITextField *textField = alertSelf.textFields.firstObject;
                    [self logMsg:textField.text];//不用担心循环引用
                }
                else if (buttonIndex == 1) {
                    UITextField *textField = alertSelf.textFields.lastObject;
                    [self logMsg:textField.text];
                }
            }];
        }
            break;
        default:
            break;
    }
}

-(void)setUpUI{
    [super setUpUI];
    [self.refreshControl removeFromSuperview];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

#pragma mark - Methods
- (void)logMsg:(NSString *)msg
{
    NSLog(@"%@", msg);
}
- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(255);
    CGFloat g = arc4random_uniform(255);
    CGFloat b = arc4random_uniform(255);
    
    return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:0.3f];
}


@end
