//
//  UIBarButtonItem+pwExtension.m
//  pwControls
//
//  Created by MartinLee on 17/1/3.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "UIBarButtonItem+pwExtension.h"

@implementation UIBarButtonItem (pwExtension)

+ (instancetype)initWithTitle:(NSString *)title fontSize:(CGFloat)size target:(id)target action:(SEL)action isBack:(BOOL)back{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:size];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    if(back){
        NSString *imageName = @"navigationbar_back_withtext";
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",imageName]] forState:UIControlStateHighlighted];
    }
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
