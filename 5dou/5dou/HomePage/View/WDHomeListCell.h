//
//  WDHomeListCell.h
//  5dou
//
//  Created by rdyx on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDHomeListModel.h"
#import "WDTaskModel.h"
@interface WDHomeListCell : UICollectionViewCell


@property (nonatomic,strong) WDTaskModel *taskModel;

//-(void)configData:(WDHomeListModel *)model;

@end
