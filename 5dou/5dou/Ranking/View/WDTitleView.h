//
//  WDTitleView.h
//  5dou
//
//  Created by 黄新 on 16/11/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger,TitleType) {
    WealthTitleType = 1001,
    HotTitleType
};


@interface WDTitleView : UIButton

@property (nonatomic, strong) UIButton *imgView;
@property (nonatomic, strong) UILabel *title;//标题


@end
