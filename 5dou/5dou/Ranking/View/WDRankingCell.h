//
//  WDRankingCell.h
//  5dou
//
//  Created by 黄新 on 16/11/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RankingListModel;

@interface WDRankingCell : UITableViewCell

@property (nonatomic, assign) BOOL isShowInviteImg;

- (void)configValue:(RankingListModel *)model IndexPath:(NSIndexPath *)indexPath;

@end
