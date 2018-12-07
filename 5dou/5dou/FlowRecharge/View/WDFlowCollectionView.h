//
//  WDFlowCollectionView.h
//  5dou
//
//  Created by 黄新 on 16/12/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDFlowPackageDataModel,WDFlowListModel;

typedef void(^SetBuyViewBlock)(WDFlowListModel *flowListModel);



@interface WDFlowCollectionView : UICollectionView


@property (nonatomic, copy) SetBuyViewBlock setBuyViewBlock;

- (void)configValue:(WDFlowPackageDataModel *)model;
@end
