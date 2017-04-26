//
//  UIBarButtonItem+pwExtension.h
//  pwControls
//
//  Created by MartinLee on 17/1/3.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (pwExtension)
+ (instancetype)initWithTitle:(NSString *)title fontSize:(CGFloat)size target:(id)target action:(SEL)action isBack:(BOOL)back;
@end
