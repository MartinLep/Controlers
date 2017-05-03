//
//  NSObject+Property.m
//  pwControls
//
//  Created by MartinLee on 17/5/2.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

@implementation NSObject (Property)

-(void)setName:(NSString *)name{
    
    //object：给哪个对象添加属性
    //key：属性名称
    //value:属性值
    //policy:保存策略
    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)name{
    return objc_getAssociatedObject(self, @"name");
}

@end
