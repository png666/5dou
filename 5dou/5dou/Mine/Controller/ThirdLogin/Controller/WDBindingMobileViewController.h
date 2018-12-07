//
//  WDBindingMobileViewController.h
//  5dou
//
//  Created by 黄新 on 16/9/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
typedef void (^ThirdLoginSuccessBlock) ();
typedef void (^ThirdLoginFailBlock) ();

@interface WDBindingMobileViewController : WDBaseViewController

@property (nonatomic, copy) NSString *loginAuthType;
@property (nonatomic, copy) NSString *loginAuthId;
@property (nonatomic, copy) NSString *authHeadImg;

@property (nonatomic, copy) ThirdLoginSuccessBlock thirdLoginSuccessBlock;

@property (nonatomic, copy) ThirdLoginFailBlock thirdLoginFailBlock;

@end
