//
//  pwStatusModel.h
//  pwControls
//
//  Created by MartinLee on 17/5/2.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <Foundation/Foundation.h>

//设计模型有哪些属性由字典决定
//KVC：模型中属性必须与字典中key一一对应

@class User;
@interface pwStatusModel : NSObject
//自动生成属性=>根据字典的key

@property (nonatomic,strong) NSString *source;

@property (nonatomic,assign) NSInteger reposts_count;

@property (nonatomic,strong) NSArray *pic_urls;

@property (nonatomic,strong) NSString *created_at;

@property (nonatomic,assign) NSInteger attitudes_count;

@property (nonatomic,strong) NSString *idstr;

@property (nonatomic,strong) NSString *text;

@property (nonatomic,assign) NSInteger comments_count;

@property (nonatomic,strong) User *user;

+ (instancetype)itemWithDictionary:(NSDictionary *)dictionary;

@end
