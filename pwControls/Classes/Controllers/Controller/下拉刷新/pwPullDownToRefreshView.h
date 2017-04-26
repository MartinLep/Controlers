//
//  pwPullDownToRefreshView.h
//  pwControls
//
//  Created by MartinLee on 17/1/5.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pwPullDownToRefreshView : UIView
@property(nonatomic,copy)void(^refreshBlock)();

- (void)endRefresh;
@end
