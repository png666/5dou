//
//  WDDouActivityCell.h
//  5dou
//
//  Created by rdyx on 16/11/23.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
//逗活动cell
#import "WDSchoolNewsModel.h"
#import "WDActivityModel.h"
@interface WDDouActivityCell : UITableViewCell

-(void)configData:(WDActivityModel *)model;

@end
