//
//  WDCommentCell.h
//  5dou
//
//  Created by ChunXin Zhou on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDCommentModel.h"
@interface WDCommentCell : UITableViewCell
@property (nonatomic,strong) WDCommentModel *commentModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@end
