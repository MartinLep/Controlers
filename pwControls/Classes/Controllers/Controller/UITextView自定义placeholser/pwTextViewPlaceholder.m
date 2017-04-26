//
//  pwTextViewPlaceholder.m
//  pwControls
//
//  Created by MartinLee on 17/4/11.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwTextViewPlaceholder.h"

@interface pwTextViewPlaceholder ()

@property (nonatomic,strong)UILabel *placeHolderLabel;

@end

@implementation pwTextViewPlaceholder

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, self.frame.size.width, 0)];
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.numberOfLines = 0;
        [self addSubview:_placeHolderLabel];
        
        self.myPlaceholderColor = [UIColor lightGrayColor];
        self.font = [UIFont systemFontOfSize:15];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChanged) name:UITextViewTextDidChangeNotification object:nil]; //通知:监听文字的改变
    }
    return self;
}

- (void)textViewDidChanged{
    //hasText是系统的BOOL属性如果UITextView输入了文字hasText就是YES反之就为NO
    _placeHolderLabel.hidden = self.hasText;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize maxSize = CGSizeMake(_placeHolderLabel.width, MAXFLOAT);
    _placeHolderLabel.height = [_myPlaceholder boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _placeHolderLabel.font} context:nil].size.height;
}

- (void)setMyPlaceholder:(NSString *)myPlaceholder{
    _myPlaceholder = [myPlaceholder copy];
    _placeHolderLabel.text = myPlaceholder;
    [self setNeedsLayout];
}

- (void)setMyPlaceholderColor:(UIColor *)myPlaceholderColor{
    _myPlaceholderColor = myPlaceholderColor;
    _placeHolderLabel.textColor = myPlaceholderColor;
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    _placeHolderLabel.font = font;
    [self setNeedsLayout];
}

//- (void)setText:(NSString *)text{
//    [super setText:text];
//    [self textDidChanged];
//}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self textViewDidChanged];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:UITextViewTextDidChangeNotification];
}
@end
