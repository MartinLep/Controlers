//
//  UIScrollView+pwRefreshView.m
//  pwControls
//
//  Created by MartinLee on 17/1/5.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "UIScrollView+pwRefreshView.h"
#import <objc/runtime.h>

@interface UIScrollView ()
@end

static const char *upKey = "upKey";
static const char *downKey = "downKey";
@implementation UIScrollView (pwRefreshView)

-(pwPullUpToRefreshView *)upRefreshView{
    pwPullUpToRefreshView *refrshView = objc_getAssociatedObject(self, upKey);
    if(refrshView == nil){
        refrshView = [[pwPullUpToRefreshView alloc] init];
        [self addSubview:refrshView];
        self.upRefreshView = refrshView;
    }
    return refrshView;
}

-(void)setUpRefreshView:(pwPullUpToRefreshView *)upRefreshView{
    objc_setAssociatedObject(self, upKey, upRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(pwPullDownToRefreshView *)downRefrehView{
    pwPullDownToRefreshView *refreshView = objc_getAssociatedObject(self, downKey);
    if(refreshView == nil){
        refreshView = [[pwPullDownToRefreshView alloc] init];
        [self addSubview:refreshView];
        self.downRefrehView = refreshView;
    }
    return  refreshView;
}

- (void)setDownRefrehView:(pwPullDownToRefreshView *)downRefrehView{
    objc_setAssociatedObject(self, downKey, downRefrehView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
