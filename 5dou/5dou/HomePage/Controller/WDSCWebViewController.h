//
//  WDSCWebViewController.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseWebViewController.h"
typedef void (^SurveySuccessBlock)();
//这个VC是最初是给双创写的，但是后来有些页面也和这个共用了，比如调查问卷，所以有了一个bool值，标记进行判断需要加载的页面是不是双创，双创这是要die的节奏
@interface WDSCWebViewController : WDBaseWebViewController
@property (nonatomic,copy) SurveySuccessBlock successblock;
@property(nonatomic,assign)BOOL isShowNav;
@property(nonatomic,assign)BOOL isNotSC;//标记是否要加载的是双创界面
@end
