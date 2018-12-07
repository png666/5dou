//
//  WDAboutPlatformViewController.h
//  5dou
//
//  Created by rdyx on 16/12/16.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDH5BaseController.h"

//此类可以发展成一个公共类

@interface WDAboutPlatformViewController : WDH5BaseController
@property(nonatomic,copy)NSString *productUrl;
@property(nonatomic,assign)BOOL withHead;
@property(nonatomic,assign)BOOL isAbout5dou;
@end
