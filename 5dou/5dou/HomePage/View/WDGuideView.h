//
//  WDStepView.h
//  5dou
//
//  Created by 黄新 on 17/1/3.
//  Copyright © 2017年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DismissGuideView)();

@interface WDGuideView : UIView

@property (nonatomic, strong) DismissGuideView dismissGuideView;///< 隐藏功能指示图

@end
