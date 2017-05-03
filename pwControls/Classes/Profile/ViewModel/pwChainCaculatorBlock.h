//
//  pwChainCaculatorBlock.h
//  pwControls
//
//  Created by MartinLee on 17/4/28.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pwChainCaculatorBlock : NSObject

@property (nonatomic,assign) int result;

- (pwChainCaculatorBlock *(^)(int))add;

@end
