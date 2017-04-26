//
//  pwAlertController.h
//  Alert
//
//  Created by MartinLee on 17/3/27.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^itemClickBlock)(int itemIndex);

@interface pwAlertController : UIViewController

@property (nonatomic,copy) itemClickBlock indexBlock;

- (instancetype)initWithtitles:(NSArray *)titles detailArray:(NSArray *)details imageArray:(NSArray *)images selectedBlock:(itemClickBlock) block;

@end
