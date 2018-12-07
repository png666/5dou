//
//  WDTopView.h
//  5dou
//
//  Created by rdyx on 16/8/29.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDBannerModel.h"
#import "WDFourIconModel.h"
@class WDTopView;

typedef void (^ indexBlock)(NSInteger indexNum,WDFourIconModel *model);
typedef void (^ bannerBlock)(NSInteger bannerIndex);
@interface WDTopView : UIView
@property(nonatomic,strong)NSArray *bannerArray;
@property(nonatomic,strong)UIImageView *schoolImage;
@property(nonatomic,copy)indexBlock topViewBlock;
@property(nonatomic,copy)bannerBlock bannerBlock;
@end
