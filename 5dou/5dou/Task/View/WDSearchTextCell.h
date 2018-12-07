//
//  WDSearchTextCell.h
//  5dou
//
//  Created by ChunXin Zhou on 16/10/8.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDSearchTextCell;
@protocol WDSearchTextCellDelegate <NSObject>

-(void)didClickedCopyOnSerachTextCell:(WDSearchTextCell *)cell;

@end

@interface WDSearchTextCell : UITableViewCell

@property (nonatomic,copy) NSString *searchTextStr;
@property(nonatomic,weak)id<WDSearchTextCellDelegate>delegate;

@end
