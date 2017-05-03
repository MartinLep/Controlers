//
//  pwStatusModel.m
//  pwControls
//
//  Created by MartinLee on 17/5/2.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwStatusModel.h"

@implementation pwStatusModel


+ (instancetype)itemWithDictionary:(NSDictionary *)dictionary{
    pwStatusModel *item = [[pwStatusModel alloc] init];
    
    [item setValuesForKeysWithDictionary:dictionary];
    
//    //遍历字典中所有的key，去模型中查找有没有对应的属性
//    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
////        去模型中查找有没有对应的属性
//        [item setValue:obj forKey:key];
//    }];
    
    return item;
}
@end
