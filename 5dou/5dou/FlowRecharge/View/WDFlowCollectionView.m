//
//  WDFlowCollectionView.m
//  5dou
//
//  Created by 黄新 on 16/12/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  流量充值页面 显示流量包的CollectionView
//
//
//

#import "WDFlowCollectionView.h"
#import "WDFlowPackageCell.h"
#import "WDFlowPackageModel.h"
#import "UICollectionViewLeftAlignedLayout.h"

#define WD_FLOWPAGECOLLECTIONVIEW_CELL_ID @"flowPageCollectionViewCell"

@interface WDFlowCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *operatorLabel; ///< 运营商
//@property (nonatomic, strong) UICollectionView *flowPageCollectionView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSMutableArray *flowListArray;///< 存储流量是本地的还是全国的



@end

@implementation WDFlowCollectionView

#pragma mark - /*** 重写初始化方法 ***/
- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:[self getFlowLayout]]) {
        self.dataSource = self;
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[WDFlowPackageCell class] forCellWithReuseIdentifier:WD_FLOWPAGECOLLECTIONVIEW_CELL_ID];
        self.flowListArray = [NSMutableArray array];
    }
    return self;
}

/**
 绑定数据源

 @param model 数据源
 */
- (void)configValue:(WDFlowPackageDataModel *)model{
    self.dataArray = model.flowList;
    [self reloadData];
}


#pragma mark ======= CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    [collectionView.collectionViewLayout invalidateLayout];
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WDFlowPackageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WD_FLOWPAGECOLLECTIONVIEW_CELL_ID forIndexPath:indexPath];
    if (self.dataArray.count) {
        WDFlowListModel *model = self.dataArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.selected = YES;
            if (self.setBuyViewBlock) {
                self.setBuyViewBlock(model);
            }
        }else{
            cell.selected = NO;
        }
//        cell.selected = NO;
        [cell configValueWith:model];
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self.flowListArray removeAllObjects];
    WDFlowListModel *flowListModel = nil;
    if (self.dataArray.count) {
        flowListModel = self.dataArray[indexPath.item];
    }
    if (self.setBuyViewBlock) {
        self.setBuyViewBlock(flowListModel);
    }
}
#pragma mark - /*** 获取水布局 ***/
- (UICollectionViewFlowLayout *)getFlowLayout {
    UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.estimatedItemSize = CGSizeMake((ScreenWidth-60)/3.0, (ScreenWidth-60)/6.0);
    return flowLayout;
}

@end
