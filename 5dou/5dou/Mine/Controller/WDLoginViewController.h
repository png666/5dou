//
//  WDLoginViewController.h
//  5dou
//
//  Created by rdyx on 16/9/2.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
typedef void (^SuccessLoginBlock) ();
typedef void (^ThirdLoginBlock) ();

@interface WDLoginViewController : WDBaseViewController
@property (nonatomic,copy) SuccessLoginBlock successLoginBlock;
@property (nonatomic,copy) SuccessLoginBlock thirdLoginBlock;

@end
