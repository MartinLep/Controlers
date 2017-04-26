//
//  main.m
//  pwControls
//
//  Created by MartinLee on 17/1/3.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//1.创建UIApplicationMain对象
//2.创建AppDelegate对象，并且成为UIApplication对象代理属性
//3.开启主允许循环:目的让程序一直跑起来
//4.加载info.plist文件，判断info.plist文件里面有没有指定main.storyboard，如果指定就会加载main.storyboard
        //main.storyboard
        //1.初始化窗口
        //2.加载storyboard文件，并且创建箭头指向的控制器
        //3.把新创建的控制器作为窗口的根控制器，让窗口显示
int main(int argc, char * argv[]) {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    [storyboard instantiateInitialViewController];//默认加载箭头指向的控制器
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
