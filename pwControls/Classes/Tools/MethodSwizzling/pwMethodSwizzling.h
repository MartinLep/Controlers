//
//  pwMethodSwizzling.h
//  pwControls
//
//  Created by MartinLee on 17/1/11.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pwMethodSwizzling : NSObject

void MT_ExchangeInstanceMethod(SEL originalSEL,SEL objectSEL,Class objectClass);

void MT_ExchangeClassMethod(SEL originalSEL,SEL objectSEL,Class objectClass);
@end


@interface UIControl (Swizzling)
@property (nonatomic,assign) NSTimeInterval mt_acceptEventInterval;
@property (nonatomic,assign) BOOL mt_ignoreEvent;
@end
