//
//  MessageTypeCell.h
//  5dou
//
//  Created by 黄新 on 16/9/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDUnReadMessageModel.h"

@interface WDMessageTypeCell : UITableViewCell

@property (nonatomic, strong) UIImageView *messageImg;///<消息图标
@property (nonatomic, strong) UILabel *titleLabe;///< 标题
@property (nonatomic, strong) UILabel *contentLabel;///< 内容
@property (nonatomic, strong) UILabel *timeLabel;///< 时间
@property (nonatomic, strong) UILabel *lineLabel;///< 分割线
@property (nonatomic, strong) UILabel *unReadLabel;///< 红点标记未读消息


- (void)remakeConstraint;
- (void)configWithMemberModel:(WDUnReadMessageModel *)model;

@end
