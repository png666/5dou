//
//  WDInterestViewController.h
//  5dou
//
//  Created by rdyx on 16/9/5.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
typedef void (^InterestChangeBlock) (NSString *interestStr);
@interface WDInterestViewController : WDBaseViewController
@property (nonatomic,strong) NSMutableArray *selectButtonList;
@property (nonatomic,copy) NSString *selectedStr;
@property (nonatomic,copy) InterestChangeBlock interestBlock;
@end
