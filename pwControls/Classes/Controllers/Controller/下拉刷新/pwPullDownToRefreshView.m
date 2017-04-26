//
//  pwPullDownToRefreshView.m
//  pwControls
//
//  Created by MartinLee on 17/1/5.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwPullDownToRefreshView.h"

typedef enum {
    pwPullDownToRefreshViewNormal,
    pwPullDownToRefreshViewPulling,
    pwPullDownToRefreshViewRefreshing
}pwPullDownToRefreshViewStatus;

@interface pwPullDownToRefreshView ()

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIScrollView *superScrollView;
@property(nonatomic,strong)NSArray *refreshArray;
@property(nonatomic,assign)pwPullDownToRefreshViewStatus currentStatus;

@end
@implementation pwPullDownToRefreshView

- (instancetype)initWithFrame:(CGRect)frame{
    CGRect newFrame = CGRectMake(0, -60, [UIScreen mainScreen].bounds.size.width, 60);
    if(self = [super initWithFrame:newFrame]){
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        self.backgroundColor = [UIColor grayColor];
        self.imageView.frame = CGRectMake(130, 5, 50, 50);
        self.label.frame = CGRectMake(190, 20, 200, 20);
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if([newSuperview isKindOfClass:[UIScrollView class]]){
        self.superScrollView = (UIScrollView *)newSuperview;
        [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if(self.superScrollView.isDragging){
        //正在拖动
        CGFloat normalPullingOffset = -124;
        if(self.superScrollView.contentOffset.y > normalPullingOffset
           && self.currentStatus == pwPullDownToRefreshViewPulling){
            self.currentStatus = pwPullDownToRefreshViewNormal;
        }else if (self.superScrollView.contentOffset.y <= normalPullingOffset
                  && self.currentStatus == pwPullDownToRefreshViewNormal){
            self.currentStatus = pwPullDownToRefreshViewPulling;
        }
    }else{
        //手指放开
        if(self.currentStatus == pwPullDownToRefreshViewPulling){
            self.currentStatus = pwPullDownToRefreshViewRefreshing;
        }
    }
}

- (void)dealloc{
    [self.superScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)setCurrentStatus:(pwPullDownToRefreshViewStatus)currentStatus{
    _currentStatus = currentStatus;
    switch (_currentStatus) {
        case pwPullDownToRefreshViewNormal:
            self.label.text = @"下拉刷新";
            [self.imageView stopAnimating];
            self.imageView.image = [UIImage imageNamed:@"refreshing_04"];
            break;
        case pwPullDownToRefreshViewPulling:
            self.label.text = @"释放刷新";
            self.imageView.image = [UIImage imageNamed:@"refreshing_05"];
            break;
        case pwPullDownToRefreshViewRefreshing:
            self.label.text = @"正在刷新...";
            self.imageView.animationImages = self.refreshArray;
            self.imageView.animationDuration = 0.1*self.refreshArray.count;
            [self.imageView startAnimating];
            
            //tableView往下挪，保证动画不被遮挡
            [UIView animateWithDuration:0.25f animations:^{
                self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top + 60, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.left, self.superScrollView.contentInset.right);
            }];
            if(self.refreshBlock){
                self.refreshBlock();
            }
            break;
    }
}

- (void)endRefresh{
    if(self.currentStatus == pwPullDownToRefreshViewRefreshing){
        self.currentStatus = pwPullDownToRefreshViewNormal;
        [UIView animateWithDuration:0.25f animations:^{
            self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top - 60, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.left, self.superScrollView.contentInset.right);
        }];
    }
}

#pragma mark 懒加载

- (UIImageView *)imageView{
    if(_imageView == nil){
        UIImage *image = [UIImage imageNamed:@"refreshing_04"];
        _imageView = [[UIImageView alloc] initWithImage:image];
    }
    return _imageView;
}

- (UILabel *)label{
    if(_label == nil){
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor darkGrayColor];
        _label.font = [UIFont systemFontOfSize:16];
        _label.text = @"下拉刷新";
    }
    return _label;
}

- (NSArray *)refreshArray{
    if(_refreshArray == nil){
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 1; i < 4; i++) {
            NSString *imageName = [NSString stringWithFormat:@"refreshing_0%d",i];
            [array addObject:[UIImage imageNamed:imageName]];
        }
        _refreshArray = array;
    }
    return _refreshArray;
}

@end
