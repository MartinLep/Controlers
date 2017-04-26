//
//  pwPullUpToRefreshView.h
//  pwControls
//
//  Created by MartinLee on 17/1/5.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pwPullUpToRefreshView : UIView

@property(nonatomic,strong)void(^pwPullUpToRefreshViewBlock)();

- (void)endreFresh;
@end
