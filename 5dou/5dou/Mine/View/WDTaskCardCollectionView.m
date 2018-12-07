//
//  WDTaskCardCollectionView.m
//  5dou
//
//  Created by 黄新 on 16/11/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskCardCollectionView.h"
#import "WDTaskCardCell.h"
#import "WDTaskCardHeader.h"

#define WD_TASKCARDCOLLECTION_CELL_ID (@"WDTaskCardCollectionViewID")


@interface WDTaskCardCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) UILabel *contentLabel;///< 任务卡说明
@property (nonatomic, strong) NSArray *imageArray;///< 任务卡背景
@property (nonatomic, strong) NSArray *titleArray;///< 任务卡标题



@end

@implementation WDTaskCardCollectionView

#pragma mark - /*** 重写初始化方法 ***/
- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:[self getFlowLayout]]) {
        self.dataSource = self;
        self.delegate = self;
        self.imageArray = @[@"novice_taskcard_img",@"common_taskcard_img",@"exclusive_taskcard_img",@"weal_taskcard_img"];
        self.titleArray = @[@"新手任务卡",@"普通任务卡",@"专属任务卡",@"福利卡"];
        self.showsVerticalScrollIndicator = YES;
        [self registerClass:[WDTaskCardCell class] forCellWithReuseIdentifier:WD_TASKCARDCOLLECTION_CELL_ID];
//        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID"];
    }
    return self;
}
#pragma mark - /*** 获取水布局 ***/
- (UICollectionViewFlowLayout *)getFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.estimatedItemSize = CGSizeMake(145, 170);
    
    if (device_is_iphone_5 || device_is_iphone_4) {
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
    }else if (device_is_iphone_6){
        flowLayout.minimumInteritemSpacing = 20;
        flowLayout.minimumLineSpacing = 20;
    }else if (device_is_iphone_6p){
        //左右两个item的最小间距
        flowLayout.minimumInteritemSpacing = 20;
        //上下两个item的最小间距
        flowLayout.minimumLineSpacing = 40;
    }
    return flowLayout;
}


#pragma mark - /*** 数据源方法 ***/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WDTaskCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WD_TASKCARDCOLLECTION_CELL_ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[WDTaskCardCell alloc] init];
    }
    cell.taskBgView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.cardTitleLabel.text = self.titleArray[indexPath.row];
    return cell;
}


@end
