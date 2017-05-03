   //
//  pwChainCaculatorBlock.m
//  pwControls
//
//  Created by MartinLee on 17/4/28.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwChainCaculatorBlock.h"

@implementation pwChainCaculatorBlock

- (pwChainCaculatorBlock *(^)(int))add{
    return ^(int value){
        _result += value;
        return self;
    };
}

@end
