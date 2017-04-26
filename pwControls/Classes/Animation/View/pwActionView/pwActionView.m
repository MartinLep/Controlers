//
//  pwActionView.m
//  Alert
//
//  Created by MartinLee on 17/3/27.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwActionView.h"
#import "Masonry.h"

@interface pwActionView ()

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *detailLabel;

@property (nonatomic,strong)UIImageView *rightImage;

@end

@implementation pwActionView

- (instancetype) initWithFrame:(CGRect)frame titleLabel:(NSString *)title detailLabel:(NSString *)detail rightImage:(NSString *)image{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.text = title;
        self.detailLabel.text = detail;
        self.rightImage.image = [UIImage imageNamed:image];
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailLabel];
        [self addSubview:self.rightImage];
        [self setUpUIFrame];
        
    }
    return self;
}

- (void)setUpUIFrame{
    UIView *superView = self;
    CGSize size = CGSizeMake(superView.bounds.size.width*0.8, superView.bounds.size.height/2-3);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
        make.leftMargin.mas_equalTo(@3);
        make.topMargin.mas_equalTo(@3);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
        make.leftMargin.mas_equalTo(@3);
        make.bottomMargin.mas_equalTo(@-3);
    }];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(superView);
        make.rightMargin.equalTo(@-3);
    }];
}

- (UILabel *)titleLabel{
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel{
    if(_detailLabel == nil){
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.numberOfLines = 0;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _detailLabel;
}

- (UIImageView *)rightImage{
    if(_rightImage == nil){
        _rightImage = [[UIImageView alloc] init];
    }
    return _rightImage;
}

@end
