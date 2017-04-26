//
//  pwAlertView.m
//  pwControls
//
//  Created by MartinLee on 17/4/13.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwAlertView.h"

@interface pwAlertView ()

@end

@implementation pwAlertView

+ (instancetype)pwShowAlertWithType:(AlertType)type title:(NSString *)title message:(NSString *)message placeHolder:(NSString *)placeHolder okButton:(NSString *)okMessage cancleButton:(NSString *)cancelMessage okActionHandler:(void(^)(NSString *title))okCompelete cancelActionHandler:(void(^)())cancelCompelete{
    pwAlertView *alert = [pwAlertView alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (type == AlertTitle){
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeHolder;
        }];
    }
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okMessage style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(type == AlertTitle){
            UITextField *textField = alert.textFields.firstObject;
            okCompelete(textField.text);
        }else{
            okCompelete(nil);
        }
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelMessage style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        cancelCompelete();
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    return alert;
}

@end
