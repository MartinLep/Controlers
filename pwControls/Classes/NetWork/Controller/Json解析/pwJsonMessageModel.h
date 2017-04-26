//
//  pwJsonMessageModel.h
//  pwControls
//
//  Created by MartinLee on 17/2/7.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pwJsonMessageModel : NSObject

@property(nonatomic,copy) NSString *message;
@property(nonatomic,strong) NSNumber *messageId;

+ (instancetype)messageWithDic:(NSDictionary *)dic;
@end
