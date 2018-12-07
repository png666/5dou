//
//  UITableViewCell+Ext.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/5.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "UITableViewCell+Ext.h"

@implementation UITableViewCell (Ext)
+(id)cellWithTableView:(UITableView *)tableView{
    NSString * Identifier = NSStringFromClass([self class]);
    //注册
    UINib *nib = [UINib nibWithNibName:Identifier bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:Identifier];
    //如果有则返回，如果没有就创建
    return  [tableView dequeueReusableCellWithIdentifier:Identifier];
}
@end
