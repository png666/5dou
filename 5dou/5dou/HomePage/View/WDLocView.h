//
//  WDLocView.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/6.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDLocView : UIView
@property (weak, nonatomic) IBOutlet UIButton *nowLocationBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherLocatonBtn;
@property (weak, nonatomic) IBOutlet UIView *hotCityView;

+ (WDLocView *)view;
@end
