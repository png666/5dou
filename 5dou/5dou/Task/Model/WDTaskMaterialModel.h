//
//  WDTaskMaterialModel.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/2.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "JSONModel.h"
/**
 *  任务素材模型
 */
@interface WDTaskMaterialModel : JSONModel
/**
 *  素材文字
 */
@property (nonatomic,copy) NSString <Optional> *materialInfo;
/**
 *  素材链接地址
 */
@property (nonatomic,copy) NSString <Optional>*materialUrl;
/**
 *  素材链接标题
 */
@property (nonatomic,copy) NSString <Optional>*materialTitle;
/**
 *  素材分享对应的小图片
 */
@property (nonatomic,copy) NSString <Optional>*materialPic;
/**
 *  素材图片
 */
@property (nonatomic,strong) NSArray <Optional>*materialPics;
@end
