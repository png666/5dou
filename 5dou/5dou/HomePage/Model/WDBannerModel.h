//
//  WDBannerModel.h
//  5dou
//
//  Created by rdyx on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDBannerModel : NSObject

@property(nonatomic,copy)NSString *clickTo;//这个是判断是跳转的内部页面还是外部链接

//0:任务，1：干货 2：活动
@property(nonatomic,copy)NSString *bannerType;

@property(nonatomic,copy)NSString *productCode;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *productUrl;//外部链接跳转url

@end
