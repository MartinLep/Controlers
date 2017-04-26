//
//  pwSettingItemModel.h
//  pwControls
//
//  Created by MartinLee on 17/2/8.
//  Copyright © 2017年 MartinLee. All rights reserved.
//
//  cell模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PWSettingAccessoryType) {
    PWSettingAccessoryTypeNone,
    PWSettingAccessoryTypeDisclosureIndicator, //右边箭头
    PWSettingAccessoryTypeSwitch,
    PWSettingAccessoryTypeButton,
    pwSettingItemModelMiddle,
};
@interface pwSettingItemModel : NSObject

@property (nonatomic,copy)NSString *cellName;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,copy)NSString *detailText;
@property (nonatomic,strong)UIImage *detailImage; //更多信息提示图片
@property (nonatomic,copy)NSString *btnImage; //一下是按钮属性
@property (nonatomic,copy)NSString *btnName;
@property (nonatomic,strong)UIColor *normalColor;
@property (nonatomic,strong)UIColor *highLightColor;
@property (nonatomic,copy)NSString *middleName;
@property (nonatomic,assign)BOOL switchState;

@property (nonatomic,assign) PWSettingAccessoryType accessoryType;
@property (nonatomic,copy) void (^executeCode)(); //点击cell要执行的代码
@property (nonatomic,copy) void (^buttonClickedCode)();//点击button要执行的代码
@property (nonatomic,copy) void(^switchValueChanged)(BOOL isOn);//Switch 开关变化

- (void)setModelWithName:(NSString *)cellName image:(UIImage *)image detailText:(UIImage *)detailImage accessoryType:(PWSettingAccessoryType)accessoryType executeCode:(void(^)())completeBlock;
@end
