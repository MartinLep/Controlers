//
//  pwAlertView.h
//  pwControls
//
//  Created by MartinLee on 17/4/13.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AlertType) {
    AlertNormal,
    AlertTitle,
};

@interface pwAlertView : UIAlertController

+ (instancetype)pwShowAlertWithType:(AlertType)type title:(NSString *)title message:(NSString *)message placeHolder:(NSString *)placeHolder okButton:(NSString *)okMessage cancleButton:(NSString *)cancelMessage okActionHandler:(void(^)(NSString *title))okCompelete cancelActionHandler:(void(^)())cancelCompelete;


@end
