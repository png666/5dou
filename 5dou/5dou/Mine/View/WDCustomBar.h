//
//  WDCustomBar.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/5.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDCustomBar : UIControl
//@property(nonatomic,strong)UIView *barView;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong) UIView *lineView;
/**
 *  创建问答详情页导航条
 *
 *  @param count 数量
 *  @param name  标题
 *
 */
- (instancetype) initWithCount:(NSString *)count andName :(NSString *)name size:(CGSize)size;

@end
