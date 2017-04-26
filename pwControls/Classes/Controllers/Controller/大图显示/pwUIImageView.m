//
//  pwUIImageView.m
//  pwControls
//
//  Created by MartinLee on 17/1/7.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwUIImageView.h"

@interface UIImage (Util)
- (CGSize)sizeToFits:(CGSize)size;
@end

@implementation UIImage (Util)

-(CGSize)sizeToFits:(CGSize)size{
    CGSize imageSize = CGSizeMake(self.size.width/self.scale, self.size.height/self.scale);
    CGFloat widthRatio = imageSize.width/size.width;
    CGFloat heightRatio = imageSize.height/size.height;
    
    //按照比例显示图片
    if(widthRatio > heightRatio){
        imageSize = CGSizeMake(imageSize.width/widthRatio, imageSize.height/widthRatio);
    }else{
        imageSize = CGSizeMake(imageSize.width/heightRatio, imageSize.height/heightRatio);
    }
    return imageSize;
}
@end

@interface UIImageView (Util)
- (CGSize)contentSize;
@end

@implementation UIImageView (Util)

-(CGSize)contentSize{
    return [self.image sizeToFits:self.bounds.size];
}

@end
@interface pwUIImageView () <UIScrollViewDelegate>

@property(nonatomic,weak) UIView *containerView;
@property(nonatomic,weak) UIImageView *imageView;
@property(nonatomic,assign) BOOL rotating;
@property(nonatomic,assign) CGSize minSize;

@end

@implementation pwUIImageView

-(instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image{
    self = [super initWithFrame:frame];
    if(self){
        self.delegate = self;
        
        UIView *containView = [[UIView alloc] initWithFrame:self.bounds];
        containView.backgroundColor = [UIColor clearColor];
        [self addSubview:containView];
        _containerView = containView;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.bounds;
        imageView.contentMode = UIViewContentModeScaleToFill;
        [containView addSubview:imageView];
        _imageView = imageView;
        
        CGSize imageSize = imageView.contentSize;
        self.containerView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
        imageView.center = CGPointMake(imageSize.width/2, imageSize.height/2);
        
        self.contentSize = imageSize;
        self.minSize = imageSize;
        [self setMaximumZoomScale];
        [self centerContent];
        
        [self setupGestureRecognizer];
        [self setupRotationNotification];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.rotating) {
        self.rotating = NO;
        
        // update container view frame
        CGSize containerSize = self.containerView.frame.size;
        BOOL containerSmallerThanSelf = (containerSize.width < CGRectGetWidth(self.bounds)) && (containerSize.height < CGRectGetHeight(self.bounds));
        
        CGSize imageSize = [self.imageView.image sizeToFits:self.bounds.size];
        CGFloat minZoomScale = imageSize.width / self.minSize.width;
        self.minimumZoomScale = minZoomScale;
        if (containerSmallerThanSelf || self.zoomScale == self.minimumZoomScale) { // 宽度或高度 都小于 self 的宽度和高度
            self.zoomScale = minZoomScale;
        }
        
        // Center container view
        [self centerContent];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setMaximumZoomScale{
    CGSize imageSize = self.imageView.image.size;
    CGSize imagePresentationSize = self.imageView.contentSize;
    CGFloat maxScale = MAX(imageSize.height/imagePresentationSize.height, imageSize.width/imagePresentationSize.width);
    self.maximumZoomScale = MAX(1, maxScale);
    self.minimumZoomScale = 1.0;
}

- (void)centerContent
{
    CGRect frame = self.containerView.frame;
    
    CGFloat top = 0, left = 0;
    if (self.contentSize.width < self.bounds.size.width) {
        left = (self.bounds.size.width - self.contentSize.width) * 0.5f;
    }
    if (self.contentSize.height < self.bounds.size.height) {
        top = (self.bounds.size.height - self.contentSize.height) * 0.5f;
    }
    
    top -= frame.origin.y;
    left -= frame.origin.x;
    
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

- (void)setupGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [_containerView addGestureRecognizer:tapGestureRecognizer];
}

- (void)tapHandler:(UITapGestureRecognizer *)recognizer
{
    if (self.zoomScale > self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else if (self.zoomScale < self.maximumZoomScale) {
        CGPoint location = [recognizer locationInView:recognizer.view];
        CGRect zoomToRect = CGRectMake(0, 0, 50, 50);
        zoomToRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomToRect)/2, location.y - CGRectGetHeight(zoomToRect)/2);
        [self zoomToRect:zoomToRect animated:YES];
    }
}

- (void)setupRotationNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
    self.rotating = YES;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerContent];
}

@end
