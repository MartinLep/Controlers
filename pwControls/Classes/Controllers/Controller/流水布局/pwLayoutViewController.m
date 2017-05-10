//
//  pwLayoutViewController.m
//  pwControls
//
//  Created by MartinLee on 17/5/6.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

/*
 UIcollectionView使用的注意点
 1 创建UIcollectionView必须要有布局参数
 2 cell必须通过注册
 3 cell必须自定义 系统cell没有任何子控件
 */

#import "pwPhotoLayout.h"
#import "pwLayoutViewController.h"
#import "pwPhotoCollectionViewCell.h"

static NSString * const ID = @"cell";
@interface pwLayoutViewController ()<UICollectionViewDataSource>

@end

@implementation pwLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
//利用布局做出效果，让cell的尺寸不一样，自定义流水布局
//    流水布局，调整cell的尺寸
    
    
//流水布局
    pwPhotoLayout *layout = ({
        pwPhotoLayout *layout = [[pwPhotoLayout alloc] init];
        layout.itemSize = CGSizeMake(160, 160);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat margin = ([UIScreen pwScreenWidth]-106)/2;
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
        //    最小行间距
        layout.minimumLineSpacing = 50;
        ////    设置最小的item距离
        //    layout.minimumInteritemSpacing = 0;
        layout;
    });
    
    //    创建UICollectionView
    UICollectionView *collectionView = ({
        //    创建UICollectionView
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.center = self.view.center;
        collectionView.bounds = CGRectMake(0, 0, [UIScreen pwScreenWidth], 200);
        collectionView.showsHorizontalScrollIndicator = false;
        [self.view addSubview:collectionView];
        collectionView;
    });
    
    
//     设置数据源方法
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([pwPhotoCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    pwPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    NSString *imageName = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (void)setUpUI{
    [super setUpUI];
    [self.tableView removeFromSuperview];
}


@end
