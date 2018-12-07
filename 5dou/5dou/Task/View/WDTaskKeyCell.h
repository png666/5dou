//
//  WDTaskKeyCell.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/5.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TaskKeyCellClick) (NSString *key);
@interface WDTaskKeyCell : UICollectionViewCell
@property (nonatomic,copy) TaskKeyCellClick taskKeyCellClick;
- (void)setKeyTitle:(NSString *)title;
/**
 *  选择
 */
- (void)select;
/**
 *  反选
 */
- (void)inverse;
@end
