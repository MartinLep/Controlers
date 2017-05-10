//
//  pwPhotoCollectionViewCell.m
//  pwControls
//
//  Created by MartinLee on 17/5/6.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwPhotoCollectionViewCell.h"

@interface pwPhotoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@end

@implementation pwPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setImage:(UIImage *)image{
    _image = image;
    _photoView.image = image;
}

@end
