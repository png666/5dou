//
//  WDTaskCardCell.h
//  5dou
//
//  Created by ChunXin Zhou on 16/10/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDTaskCardCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *taskBgView;///< 任务卡底部
@property (nonatomic, strong) UILabel *cardTitleLabel;///< 任务卡标题
@property (nonatomic, strong) UILabel *cardCountLabel;///< 任务卡数量
@property (nonatomic, strong) UILabel *cardBriefLabel;///< 任务卡简介
@property (nonatomic, strong) UILabel *cardContentLabel;///< 任务卡简介内容

@end
