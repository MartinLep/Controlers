//
//  NSObject+Property.h
//  pwControls
//
//  Created by MartinLee on 17/5/2.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)

//@property分类只会生成get和set方法的声明，不会生成实现，也不会生成下划线属性成员
@property NSString *name;
@end
