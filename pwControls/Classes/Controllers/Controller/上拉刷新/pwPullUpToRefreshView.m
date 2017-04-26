//
//  pwPullUpToRefreshView.m
//  pwControls
//
//  Created by MartinLee on 17/1/5.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwPullUpToRefreshView.h"

#define pwPullUpToRefreshViewHeigh 64

typedef enum {
    pwPullUpToRefreshViewNormal,
    pwPullUpToRefreshViewPulling,
    pwPullUpToRefreshViewRefreshing
}pwPullUpToRefreshViewStatus;

@interface pwPullUpToRefreshView ()

@property (nonatomic,strong)UIScrollView *superScrollView;
@property (nonatomic,strong)UIImageView *animView;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)NSArray *refreshArray;
@property (nonatomic,assign)pwPullUpToRefreshViewStatus currentStatue;

@end

@implementation pwPullUpToRefreshView

- (instancetype)initWithFrame:(CGRect)frame{
    CGRect newFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, pwPullUpToRefreshViewHeigh);
    if(self = [super initWithFrame:newFrame]){
        self.currentStatue = pwPullUpToRefreshViewNormal;
        self.backgroundColor = [UIColor brownColor];
        [self addSubview:self.animView];
        [self addSubview:self.label];
        self.animView.translatesAutoresizingMaskIntoConstraints = false;
        self.label.translatesAutoresizingMaskIntoConstraints = false;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.animView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-5]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.animView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:5]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if([newSuperview isKindOfClass:[UIScrollView class]]){
        self.superScrollView = (UIScrollView *)newSuperview;
        [self.superScrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
        [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if(self.superScrollView.contentSize.height < [UIScreen mainScreen].bounds.size.height-64){
        self.hidden = YES;
        return;
    }else{
        self.hidden = NO;
    }
    if([keyPath isEqualToString:@"contentSize"]){
        CGRect frame = self.frame;
        frame.origin.y = self.superScrollView.contentSize.height;
        self.frame = frame;
    }else if ([keyPath isEqualToString:@"contentOffset"]){
        if(self.superScrollView.dragging){
            if(self.superScrollView.contentOffset.y + self.superScrollView.frame.size.height < self.superScrollView.contentSize.height + pwPullUpToRefreshViewHeigh && self.currentStatue == pwPullUpToRefreshViewPulling){
                self.currentStatue = pwPullUpToRefreshViewNormal;
            }else if (self.superScrollView.contentOffset.y + self.superScrollView.frame.size.height >= self.superScrollView.contentSize.height + pwPullUpToRefreshViewHeigh && self.currentStatue == pwPullUpToRefreshViewNormal){
                self.currentStatue = pwPullUpToRefreshViewPulling;
            }
        }else{
            if(self.currentStatue == pwPullUpToRefreshViewPulling){
                self.currentStatue = pwPullUpToRefreshViewRefreshing;
            }
        }
    }
}

- (void)setCurrentStatue:(pwPullUpToRefreshViewStatus)currentStatue{
    _currentStatue = currentStatue;
    switch (_currentStatue) {
        case pwPullUpToRefreshViewNormal:
            [self.animView stopAnimating];
            self.label.text = @"上拉加载数据";
            self.animView.image = [UIImage imageNamed:@"refreshing_01"];
            break;
        case pwPullUpToRefreshViewPulling:
            self.label.text = @"释放刷新数据";
            self.animView.image = [UIImage imageNamed:@"refreshing_02"];
            break;
        case pwPullUpToRefreshViewRefreshing:
            self.label.text = @"正在刷新数据...";
            self.animView.animationImages = self.refreshArray;
            self.animView.animationDuration = 0.1*self.refreshArray.count;
            [self.animView startAnimating];
            
            [UIView animateWithDuration:0.25 animations:^{
                UIEdgeInsets contentInset = self.superScrollView.contentInset;
                contentInset.bottom = contentInset.bottom + pwPullUpToRefreshViewHeigh;
                self.superScrollView.contentInset = contentInset;
            } completion:^(BOOL finished) {
                if(self.pwPullUpToRefreshViewBlock){
                    self.pwPullUpToRefreshViewBlock();
                }
            }];
            break;
    }
}

- (void)dealloc{
    [self.superScrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.superScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)endreFresh{
    if(self.currentStatue == pwPullUpToRefreshViewRefreshing){
        self.currentStatue = pwPullUpToRefreshViewNormal;
        UIEdgeInsets contentInset = self.superScrollView.contentInset;
        contentInset.bottom = contentInset.bottom - pwPullUpToRefreshViewHeigh;
        self.superScrollView.contentInset = contentInset;
    }
}

- (UIImageView *)animView{
    if(_animView == nil){
        _animView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refreshing_04"]];
    }
    return _animView;
}

- (UILabel *)label{
    if(_label == nil){
        _label = [[UILabel alloc] init];
        _label.text = @"上拉刷新";
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont systemFontOfSize:16];
        [_label sizeToFit];
    }
    return _label;
}

- (NSArray *)refreshArray{
    if(_refreshArray == nil){
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int i = 4 ; i < 7 ; i++){
            NSString *imageName = [NSString stringWithFormat:@"refreshing_0%d",i];
            [array addObject:[UIImage imageNamed:imageName]];
        }
        _refreshArray = array;
    }
    return _refreshArray;
}
@end
