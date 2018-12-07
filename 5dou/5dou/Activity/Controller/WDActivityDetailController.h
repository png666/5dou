//
//  WDActivityDetailController.h
//  5dou
//
//  Created by ChunXin Zhou on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
#import "ENUM.h"
@interface WDActivityDetailController : WDBaseViewController
@property (nonatomic,copy) NSString * activityID;
@property (nonatomic,assign) RequestType requestType;
@end
