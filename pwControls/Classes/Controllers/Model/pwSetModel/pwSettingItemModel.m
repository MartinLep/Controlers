//
//  pwSettingItemModel.m
//  pwControls
//
//  Created by MartinLee on 17/2/8.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwSettingItemModel.h"

@implementation pwSettingItemModel


- (void)setModelWithName:(NSString *)cellName image:(UIImage *)image detailText:(UIImage *)detailImage accessoryType:(PWSettingAccessoryType)accessoryType executeCode:(void(^)())completeBlock{
    _cellName = cellName;
    _image = image;
    _detailImage = detailImage;
    _accessoryType = accessoryType;
    _executeCode = completeBlock;
}

- (UIColor *)normalColor{
    if(!_normalColor){
        _normalColor = [UIColor blueColor];
    }
    return _normalColor;
}

- (UIColor *)highLightColor{
    if(!_highLightColor){
        _highLightColor = [UIColor grayColor];
    }
    return _highLightColor;
}
@end
