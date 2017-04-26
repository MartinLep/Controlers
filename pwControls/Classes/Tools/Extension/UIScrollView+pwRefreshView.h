//
//  UIScrollView+pwRefreshView.h
//  pwControls
//
//  Created by MartinLee on 17/1/5.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pwPullUpToRefreshView.h"
#import "pwPullDownToRefreshView.h"
@interface UIScrollView (pwRefreshView)

@property(nonatomic,strong)pwPullUpToRefreshView *upRefreshView;
@property(nonatomic,strong)pwPullDownToRefreshView *downRefrehView;

@end
