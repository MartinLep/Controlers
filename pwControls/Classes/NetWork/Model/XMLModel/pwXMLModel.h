//
//  pwXMLModel.h
//  pwControls
//
//  Created by MartinLee on 17/2/7.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pwXMLModel : NSObject

@property (nonatomic,copy) NSNumber *videoId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSNumber *length;
@property (nonatomic,copy) NSString *videoURL;
@property (nonatomic,copy) NSString *imageURL;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *teacher;
@property (nonatomic,readonly) NSString *time;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)videoWithDict:(NSDictionary *)dict;

@end
