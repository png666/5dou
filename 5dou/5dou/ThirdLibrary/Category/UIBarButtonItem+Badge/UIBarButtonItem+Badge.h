//
//  UIBarButtonItem+Badge.h
//  therichest
//
//  Created by Mike on 2014-05-05.
//  Copyright (c) 2014 Valnet Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Badge)

@property (strong, atomic) UILabel *badge;

// Badge value to be display
@property (nonatomic) NSString *badgeValue;
// Badge background color
@property (nonatomic) UIColor *badgeBGColor;///< 背景颜色
// Badge text color
@property (nonatomic) UIColor *badgeTextColor;///< 文本颜色
// Badge font
@property (nonatomic) UIFont *badgeFont;///< 字体大小
// Padding value for the badge
@property (nonatomic) CGFloat verticalBadgePadding;///< 垂直间距
@property (nonatomic) CGFloat horizontalBadgePadding;///< 水平间距
// Minimum size badge to small
@property (nonatomic) CGFloat badgeMinSize;
// Values for offseting the badge over the BarButtonItem you picked
@property (nonatomic) CGFloat badgeOriginX;
@property (nonatomic) CGFloat badgeOriginY;
// In case of numbers, remove the badge when reaching zero
@property BOOL shouldHideBadgeAtZero;
// Badge has a bounce animation when value changes
@property BOOL shouldAnimateBadge;

@end
