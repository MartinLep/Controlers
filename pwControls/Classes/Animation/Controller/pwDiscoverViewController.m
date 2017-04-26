//
//  pwDiscoverViewController.m
//  pwControls
//
//  Created by MartinLee on 17/1/3.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwCoreAnimationController.h"
#import "pwDiscoverViewController.h"
#import "pwTransitionController.h"
#import "pwAlertController.h"
#import "pwRadarController.h"
#import "LayerViewController.h"
#import "pwDisplayLinkController.h"
#import "pwAlertView.h"


@interface pwDiscoverViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *mClassArray;
@end

static NSString *cellID = @"cellID";

@implementation pwDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

- (NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [[NSMutableArray alloc] initWithObjects:@"自定义提示框",@"雷达动画",@"RACSignal",@"Animation", @"CALayer",@"转场动画",@"CADisplayLnik",@"GifAnimation",nil];
    }
    return _dataArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSMutableArray *)mClassArray{
    if(_mClassArray == nil){
        _mClassArray = [NSMutableArray arrayWithObjects:@"",@"pwRadarController",@"",@"pwCoreAnimationController",@"LayerViewController",@"pwTransitionController",@"pwDisplayLinkController",@"pwGifAnimationViewController",@"",@"",@"",@"", nil];
    }
    return _mClassArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if(indexPath.row == 0){
        [self getAlertIndex];
    }else if (indexPath.row == 2){
        [self racsignalTest];
    }else{
        [self.navigationController pushViewController:[NSClassFromString(self.mClassArray[indexPath.row]) new] animated:true];
    }
}

- (void)getAlertIndex{
//    pwAlertController *alert = [[pwAlertController alloc] initWithtitles:nil detailArray:nil imageArray:nil selectedBlock:^(int itemIndex) {
//        NSLog(@"itemIndex = %d",itemIndex);
//    }];
//    alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:alert animated:YES completion:^(void){
//        alert.view.superview.backgroundColor = [UIColor clearColor];
//    }];
    
    pwAlertView *alert = [pwAlertView pwShowAlertWithType:AlertTitle title:@"title" message:@"message" placeHolder:@"text" okButton:@"ok" cancleButton:@"cancel" okActionHandler:^(NSString *title) {
        NSLog(@"title = %@",title);
    } cancelActionHandler:^{
        NSLog(@"点击了取消按钮");
    }];
    [self presentViewController:alert animated:true completion:nil];
    
}

#pragma mark RACSignal的简单使用

- (void)racsignalTest{
    // RACSignal使用步骤：
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 - (void)sendNext:(id)value
    
    
    // RACSignal底层实现：
    // 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
    // 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
    // 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
    // 2.1 subscribeNext内部会调用siganl的didSubscribe
    // 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
    // 3.1 sendNext底层其实就是执行subscriber的nextBlock
    
    // 1.创建信号
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        // block调用时刻：每当有订阅者订阅信号，就会调用block。

        // 2.发送信号
        [subscriber sendNext:@1];

        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];

        return [RACDisposable disposableWithBlock:^{

            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。

            // 执行完Block后，当前信号就不在被订阅了。

            NSLog(@"信号被销毁");

        }];
    }];

    // 3.订阅信号,才会激活信号.
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];

}

#pragma mark RACSubject和RACReplaySubject简单使用

- (void)racSubjectTest{
    // RACSubject使用步骤
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    
    //创建信号
    RACSubject *subject = [RACSubject subject];
    //订阅信号
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第一个订阅者:%@",x);
    }];
    
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第二个订阅者:%@",x);
    }];
    
    [subject sendNext:@"subject 信号"];
    
    // RACReplaySubject使用步骤:
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    // 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 2.2 发送信号 sendNext:(id)value
    
    // RACReplaySubject:底层实现和RACSubject不一样。
    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    //创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    //发送信号
    [replaySubject sendNext:@"信号 1"];
    [replaySubject sendNext:@"信号 2"];
    
    //订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"订阅着收到 %@",x);
    }];
    
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"订阅着收到了 ＝ %@",x);
    }];
}
@end
