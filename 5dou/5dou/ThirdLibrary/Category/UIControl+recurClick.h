//
//  UIControl+recurClick.h
//  
//
//  Created by King on 16/9/2.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (recurClick)
@property (nonatomic, assign) NSTimeInterval uxy_acceptEventInterval;
@property (nonatomic, assign)BOOL uxy_ignoreEvent;
@end
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const void *BandNameKey = &BandNameKey;
