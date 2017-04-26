//
//  pwSettingSectionModel.h
//  pwControls
//
//  Created by MartinLee on 17/2/8.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface pwSettingSectionModel : NSObject

@property (nonatomic,copy) NSString *sectionHeaderName;
@property (nonatomic,assign) CGFloat sectionHeaderHeight;
@property (nonatomic,strong) NSArray *itemArray; // item 的模型数组
@property (nonatomic,strong) UIColor *sectionHeaderBGColor;

@end
