//
//  Animal.m
//  pwControls
//
//  Created by MartinLee on 17/5/2.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "Animal.h"
#import <objc/runtime.h>

@implementation Animal

void animal(id self ,SEL _cmd ,NSNumber *meter){
    NSLog(@"animal = %@",meter);
}

//只要一个对象调用了一个未实现的方法就回调用这个方法
+ (BOOL)resolveInstanceMethod:(SEL)sel{ //实例方法
    if(sel == NSSelectorFromString(@"animal:")){
        
        //class:给哪个类添加方法
        //SEL:添加哪个方法
        //IMP:方法实现－>函数-> 函数入口-> 函数名
        //type:方法类型
        class_addMethod(self, sel, (IMP)animal, "v@:@");
        return true;
    }
    return [super resolveInstanceMethod:sel];
}


@end
