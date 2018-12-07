//
//  WDTaskStepModel.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/2.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "JSONModel.h"
/**
 *  任务步骤的数据模型
 */
@interface WDTaskStepModel : JSONModel
/**
 *  步骤名称
 */
@property (nonatomic,copy) NSString *stepName;
/**
 *  步骤详情
 */
@property (nonatomic,copy) NSString *stepInfo;
/**
 *   是否有图片 0 否 1 是
 */
@property (nonatomic,copy) NSString *isImg;
/**
 *   图片链接地址
 */
@property (nonatomic,strong) NSArray *images;
/**
 *  图片大小
 */
@property (nonatomic,copy) NSString *imagesPx;
/**
 *  是否是激活状态
 */
@property (nonatomic,copy) NSString *isActive;
@property (nonatomic,copy) NSString *doubi;
@property (nonatomic,copy) NSString *taskStatusStr;
@end
