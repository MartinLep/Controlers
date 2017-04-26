//
//  pwXMLModel.m
//  pwControls
//
//  Created by MartinLee on 17/2/7.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwXMLModel.h"

@implementation pwXMLModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)videoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (NSString *)time {
    int len = self.length.intValue;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", len / 3600, (len % 3600) / 60, (len % 60)];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %p> { videoId : %@, name : %@, length : %@, videoURL : %@, imageURL : %@, desc : %@, teacher : %@}", [self class], self, self.videoId, self.name, self.length, self.videoURL, self.imageURL, self.desc, self.teacher];
}

@end
