//
//  pwSettingCell.m
//  pwControls
//
//  Created by MartinLee on 17/2/8.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwSettingCell.h"
#import "pwSettingItemModel.h"
#import "UIView+pwAddition.h"
#import "UIColor+pwAddition.h"
#import "UIScreen+pwAddition.h"
#import "UIButton+pwAddition.h"
#import "pwConst.h"
@interface pwSettingCell ()

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *indicator;
@property (nonatomic,strong) UISwitch *aSwitch;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIImageView *detailImageView;
@property (nonatomic,strong) UILabel *middleLabel;

@end

@implementation pwSettingCell

- (void)setItem:(pwSettingItemModel *)item{
    _item = item;
    [self updateUI];
}

- (void)updateUI{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(self.item.image){
        [self setupImageView];
    }
    
    if(self.item.cellName){
        [self setupNameLabel];
    }
    
    if(self.item.accessoryType){
        [self setupAccessoryType];
    }
    
    if(self.item.detailText){
        [self setupDetailText];
    }
    
    if(self.item.detailImage){
        [self setupDetailImage];
    }
    
}

- (void)setupImageView{
    self.imgView = [[UIImageView alloc] initWithImage:self.item.image];
    [self.contentView addSubview:self.imgView];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(PWFuncViewToLeftGap);
        make.centerY.equalTo(self.contentView);
    }];
    
}

- (void)setupNameLabel{
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = self.item.cellName;
    self.nameLabel.textColor = [UIColor pwColorWithRed:51 green:51 blue:51];
    self.nameLabel.font = [UIFont systemFontOfSize:PWCellLabelFont];
    self.nameLabel.size = [self sizeForTitle:self.item.cellName withFont:[UIFont systemFontOfSize:PWCellLabelFont]];
    [self.contentView addSubview:self.nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.right).offset(PWCellLabelToFuncViewGap);
        make.centerY.equalTo(self.contentView);
    }];
}

- (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font{
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return CGSizeMake(titleRect.size.width, titleRect.size.height);
}

- (void)setupIndicator{
    [self.contentView addSubview:self.indicator];
    [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-PWIndicatorToRightGap);
        make.centerY.equalTo(self.contentView);
    }];
}

- (UIImageView *)indicator{
    if(!_indicator){
        _indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-arrow1"]];
    }
    return _indicator;
}

- (void)setupSwitch{
    [self.contentView addSubview:self.aSwitch];
    [_aSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-PWIndicatorToRightGap);
        make.centerY.equalTo(self.contentView);
    }];
}

- (UISwitch *)aSwitch{
    if(!_aSwitch){
        _aSwitch = [[UISwitch alloc] init];
        _aSwitch.on = self.item.switchState;
        [_aSwitch addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
    }
    return _aSwitch;
}

- (void)switchTouched:(UISwitch *)sw{
    __weak typeof(self) weakSelf = self;
    if(self.item.switchValueChanged){
        self.item.switchValueChanged(weakSelf.aSwitch.isOn);
    }
}

- (void)setupButton{
    [self.contentView addSubview:self.rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-PWIndicatorToRightGap);
        make.centerY.equalTo(self.contentView);
    }];
}

- (UIButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn = [UIButton pwButonText:self.item.btnName fontSize:PWCellLabelFont normalColor:self.item.normalColor highlightedColor:self.item.highLightColor backgroundImageName:self.item.btnImage];
        [_rightBtn addTarget:self action:@selector(clickFunction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (void)clickFunction{
    if(self.item.buttonClickedCode){
        self.item.buttonClickedCode();
    }
}

- (void)setupAccessoryType{
    switch (self.item.accessoryType) {
        case PWSettingAccessoryTypeNone:
            break;
        case PWSettingAccessoryTypeDisclosureIndicator:
            [self setupIndicator];
            break;
        case PWSettingAccessoryTypeSwitch:
            [self setupSwitch];
            break;
        case PWSettingAccessoryTypeButton:
            [self setupButton];
            break;
        case pwSettingItemModelMiddle:
            [self setMiddleCell];
            break;
        default:
            break;
    }
}


- (void)setupDetailText{
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.text = self.item.detailText;
    self.detailLabel.textColor = [UIColor pwColorWithRed:142 green:142 blue:142];
    self.detailLabel.font = [UIFont systemFontOfSize:PWDetailLabelFont];
    self.detailLabel.size = [self sizeForTitle:self.item.detailText withFont:[UIFont systemFontOfSize:PWDetailLabelFont]];
    [self.contentView addSubview:self.detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        switch (_item.accessoryType) {
            case PWSettingAccessoryTypeNone:
                make.right.equalTo(self.contentView).offset(- PWDetailViewToIndicatorGap - 2);
                break;
            case PWSettingAccessoryTypeDisclosureIndicator:
                make.right.mas_equalTo(_indicator.left).offset(-PWDetailViewToIndicatorGap);
                break;
            case PWSettingAccessoryTypeSwitch:
                make.right.mas_equalTo(_aSwitch.left).offset(-PWDetailViewToIndicatorGap);
                break;
            case PWSettingAccessoryTypeButton:
                make.right.mas_equalTo(_rightBtn.left).offset(-PWDetailViewToIndicatorGap);
                break;
            default:
                break;
        }
    }];
}

- (void)setupDetailImage{
    self.detailImageView = [[UIImageView alloc] initWithImage:self.item.detailImage];
    [self.contentView addSubview:self.detailImageView];
    [_detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        switch (_item.accessoryType) {
            case PWSettingAccessoryTypeNone:
                make.right.equalTo(self.contentView).offset(- PWDetailViewToIndicatorGap - 2);
                break;
            case PWSettingAccessoryTypeDisclosureIndicator:
                make.right.mas_equalTo(_indicator.left).offset(- PWDetailViewToIndicatorGap);
                break;
            case PWSettingAccessoryTypeSwitch:
                make.right.mas_equalTo(_aSwitch.left).offset(- PWDetailViewToIndicatorGap);
                break;
            case PWSettingAccessoryTypeButton:
                make.right.mas_equalTo(_rightBtn.left).offset(- PWDetailViewToIndicatorGap);
                break;
            default:
                break;
        }
    }];

    
}

- (void)setMiddleCell{
    self.middleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.middleLabel];
    self.middleLabel.frame = self.contentView.frame;
    self.middleLabel.text = self.item.middleName;
    self.middleLabel.font = [UIFont systemFontOfSize:16];
    self.middleLabel.textColor = [UIColor redColor];
    self.middleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
