//
//  pwPhotoLayout.m
//  pwControls
//
//  Created by MartinLee on 17/5/6.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "pwPhotoLayout.h"

/*
 自定义布局，只要了解5个方法
 */

@implementation pwPhotoLayout

//重写方法，扩展一些功能

//作用：计算cell的布局，条件：cell的位置是固定不变的
//什么时候调用：collectionView第一次布局，刷新的时候也会调用
//- (void)prepareLayout{
//    //必须调用
//    [super prepareLayout];
//}


//计算collectionView滚动范围
//- (CGSize)collectionViewContentSize{
//    return [super collectionViewContentSize];
//}



/*
 UICollectionViewLayoutAttributes 确定cell的尺寸
 一个UICollectionViewLayoutAttributes的对象，对应一个cell，拿到UICollectionViewLayoutAttributes相当于拿到cell
 
 作用：指定一段区域，返回这段区域内cell的尺寸
 可以一次性但会所有cell的尺寸，也可以每隔一个距离返回cell
 定位：距离中心点越近，这个cell最重展示到中心点
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
//    1 获取当前显示区域
//    2 获取当前显示cell的布局
    NSArray *array = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    for (UICollectionViewLayoutAttributes *attr in array) {
//        越靠近中心点，图片越大
//        求cell与中心点的距离
        CGFloat delta= fabs(attr.center.x - self.collectionView.contentOffset.x - self.collectionView.bounds.size.width/2);
        CGFloat scale = 1 - delta / (self.collectionView.bounds.size.width/2)*0.25;
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}

/*
  在滚动的时候是否允许刷新布局
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
    //return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

/*
 确定最终的偏移量
 用户手指一松开就回调用
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
//  拖动比较快的时候  最终的偏移量，不等于手指移开时的偏移量
    CGFloat collectionW = self.collectionView.bounds.size.width;
    CGPoint target = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    //获取最终显示的区域
    CGRect targetRect = CGRectMake(target.x, 0, collectionW, MAXFLOAT);
    
//    获取最终显示的cell
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in array) {
        //获取距离中心点的距离
        CGFloat delta= fabs(attr.center.x - self.collectionView.contentOffset.x - self.collectionView.bounds.size.width/2);
        if(fabs(delta) < fabs(minDelta)){
            minDelta = delta;
        }
    }
    target.x += minDelta;
    if (target.x < 0) {
        target.x = 0;
    }
    return target;
}
@end
