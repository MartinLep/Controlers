//
//  pwJsonMessageModel.m
//  pwControls
//
//  Created by MartinLee on 17/2/7.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwJsonMessageModel.h"

@implementation pwJsonMessageModel

+ (instancetype)messageWithDic:(NSDictionary *)dic{
    pwJsonMessageModel *msg = [self new];
    [msg setValuesForKeysWithDictionary:dic];
    return msg;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ {message:%@,messageId:%d}",[super description],self.message,[self.messageId intValue]];
}

@end
