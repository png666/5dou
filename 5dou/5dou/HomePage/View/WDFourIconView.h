//
//  WDFourIconView.h
//  5dou
//
//  Created by rdyx on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDFourIconModel.h"
@class WDFourIconModel;
typedef void (^indexBlock)(NSInteger indexNum,WDFourIconModel *model);

@interface WDFourIconView : UIView

@property(nonatomic,strong)NSArray *iconArray;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,copy)indexBlock indexBlock;

@end
