//
//  WDMessageCell.h
//  5dou
//
//  Created by 黄新 on 16/9/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDMemberMessageModel.h"

@interface WDMessageCell : UITableViewCell


- (void)configWithMemberModel:(MemberDataModel *)memberDataModel;

@end
