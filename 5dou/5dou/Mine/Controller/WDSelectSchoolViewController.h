//
//  WDSelectSchoolViewController.h
//  5dou
//
//  Created by rdyx on 16/9/4.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
typedef void (^SchoolChangeBlock) (NSString *schoolName);
@interface WDSelectSchoolViewController : WDBaseViewController
@property (nonatomic,copy) SchoolChangeBlock schoolChangeBlock;
@end
