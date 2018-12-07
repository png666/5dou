//
//  UITableViewCell+Ext.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/5.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Ext)
/**
 *  快速进行注册复用的方法
 *
 *  @param tableView 复用的tableView,适用于用xib搭建的cell
 *
 *  @return 复用后的Cell
 */
+(id)cellWithTableView:(UITableView *)tableView;
@end
