//
//  WDWithDrawViewController.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/26.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseWebViewController.h"
typedef void (^WithDrawSuccessBlock)();
@interface WDWithDrawViewController : WDBaseWebViewController
@property (nonatomic,copy) WithDrawSuccessBlock successBlock;
@end
