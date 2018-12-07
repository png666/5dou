//
//  WDNormalQuestionViewController.h
//  5dou
//
//  Created by rdyx on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//zeng

#import "WDBaseViewController.h"
#import "ZJScrollPageViewDelegate.h"
@interface WDNormalQuestionViewController : UIViewController<ZJScrollPageViewChildVcDelegate>
@property (nonatomic,assign) NSInteger questionType;
@end
