//
//  pwProfileViewController.m
//  pwControls
//
//  Created by MartinLee on 17/1/3.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwProfileViewController.h"


//链式编程特点：方法的返回值是block,block必须有返回值（本身对象），block参数（需要操作的值）
//代表：masonry框架。
@interface CaculatorMaker : NSObject

@property (nonatomic,assign) NSInteger result;

+ (NSInteger)makeCaculate:(void(^)(CaculatorMaker *))block;

- (CaculatorMaker *(^)(NSInteger))add;
- (CaculatorMaker *(^)(NSInteger))sub;

@end

@implementation CaculatorMaker

- (CaculatorMaker *(^)(NSInteger))add{
    return ^CaculatorMaker *(NSInteger num){
        _result += num;
        return self;
    };
}

- (CaculatorMaker *(^)(NSInteger))sub{
    return ^CaculatorMaker*(NSInteger num){
        _result -= num;
        return self;
    };
}

+ (NSInteger)makeCaculate:(void (^)(CaculatorMaker *))block{
    if(block){
        CaculatorMaker *maker = [[CaculatorMaker alloc] init];
        block(maker);
        return maker.result;
    }
    return 0;
}
@end


//函数式编程思想：是把操作尽量写成一系列嵌套的函数或者方法调用。

//函数式编程特点：每个方法必须有返回值（本身对象）,把函数或者Block当做参数,block参数（需要操作的值）block返回值（操作结果）

//代表：ReactiveCocoa

@interface Calulator : NSObject

@property (nonatomic,assign) BOOL isEqual;
@property (nonatomic,assign) int result;

- (Calulator *)caculator:(int(^)(int result))caculator;
- (Calulator *)equle:(BOOL(^)(int result))operation;

@end


@interface pwProfileViewController ()

@end

@implementation pwProfileViewController

- (void)viewWillAppear:(BOOL)animated{
    NSInteger result = [CaculatorMaker makeCaculate:^(CaculatorMaker *maker) {
        maker.add(10).add(10);
    }];
    NSLog(@"result = %zd",result);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
