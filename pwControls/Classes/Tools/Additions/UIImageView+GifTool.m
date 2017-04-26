//
//  UIImageView+GifTool.m
//  
//
//  Created by MartinLee on 17/4/19.
//
//

#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>
#import "UIImageView+GifTool.h"


@implementation UIImageView (GifTool)

- (instancetype)initWithFrame:(CGRect)frame gifPathString:(NSString *)path repeatCount:(CGFloat)repeatCout{
    self = [super initWithFrame:frame];
    if(self){
        NSURL *url = [self urlFromString:path];
        NSMutableArray *delayTimerArray = [NSMutableArray array];
        CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
        size_t count = CGImageSourceGetCount(imageSource);
        for (size_t i = 0; i < count; i ++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
            [self.gifArray addObject:CFBridgingRelease(image)];
            NSDictionary *dic = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(imageSource, i, NULL));
            [delayTimerArray addObject:[[dic valueForKey:(NSString *)kCGImagePropertyGIFDictionary] valueForKey:@"DelayTime"]];
        }
        CGFloat totalTime = [self getTotalTimeFromDelayTimeArray:delayTimerArray];
        self.gifDuration = totalTime;
        NSMutableArray *keyTimes = [self getKeyTimesFromDelayTimeArray:delayTimerArray totalTime:totalTime];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        animation.duration = totalTime;
        animation.values = self.gifArray;
        animation.keyTimes = keyTimes;
        animation.repeatCount = repeatCout;
        animation.fillMode =kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.delegate = self;
        self.clipsToBounds = true;
        [self.layer addAnimation:animation forKey:@"gifAnimation"];
    }
    return self;
}

- (instancetype)initWithGifPathString:(NSString *)path repeatCount:(CGFloat)repeatCount{
    NSURL *url = [self urlFromString:path];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    NSDictionary *dic = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL));
    CGFloat height = [dic[@"PixelHeight"] floatValue];
    CGFloat width = [dic[@"PixelWidth"] floatValue];
    CGRect frame = CGRectMake(0, 0, width, height);
    return [self initWithFrame:frame gifPathString:path repeatCount:repeatCount];
}

- (instancetype)initWithGifPathString:(NSString *)path repeat:(BOOL)repeat{
    return [self initWithGifPathString:path repeatCount:repeat?MAXFLOAT:1];
}

- (NSURL *)urlFromString:(NSString *)path{
    if([path hasPrefix:@"http"]){
        return [NSURL URLWithString:path];
    }
    return [NSURL fileURLWithPath:path];
}

- (CGFloat)getTotalTimeFromDelayTimeArray:(NSMutableArray *)mArray{
    CGFloat total = 0;
    for (NSNumber *delay in mArray) {
        total += delay.floatValue;
    }
    return total;
}

- (NSMutableArray *)getKeyTimesFromDelayTimeArray:(NSMutableArray *)delayTimeArray totalTime:(CGFloat)totalTime{
    NSMutableArray *mArray = [NSMutableArray array];
    [mArray addObject:@0];
    CGFloat currnt = 0;
    for (NSNumber *num in delayTimeArray) {
        currnt += num.floatValue;
        [mArray addObject:@(currnt/totalTime)];
    }
    return mArray;
}


/**
 类别中增加属性，getter 和 setter 方法只能用运行时去设置
 */
- (NSMutableArray *)gifArray{
    NSMutableArray *mArray = objc_getAssociatedObject(self, _cmd);
    if(!mArray){
        mArray = [NSMutableArray array];
        objc_setAssociatedObject(self, _cmd, mArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return mArray;
}

- (void)setGifArray:(NSMutableArray *)gifArray{
    objc_setAssociatedObject(self, @selector(gifArray), gifArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)gifDuration{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setGifDuration:(CGFloat)gifDuration{
    objc_setAssociatedObject(self, @selector(gifDuration), @(gifDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)animationDidStart:(CAAnimation *)anim{
    [[NSNotificationCenter defaultCenter] postNotificationName:kImageViewGifStart object:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(flag){
        [[NSNotificationCenter defaultCenter] postNotificationName:kImageViewGifFinish object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kImageViewGifCancel object:nil];
    }
}

- (void)suspendGif{
    CFTimeInterval pauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    [self.layer setTimeOffset:pauseTime];
    [self.layer setSpeed:0.0];
}

- (void)resumeGif{
    CFTimeInterval pauseTime = self.layer.timeOffset;
    CFTimeInterval startTime = CACurrentMediaTime() - pauseTime;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = startTime;
    self.layer.speed = 1.0f;
}

- (void)invalidGif{
    [self.layer removeAnimationForKey:@"gifAnimation"];
    self.layer.contents = self.gifArray.firstObject;
}

@end
