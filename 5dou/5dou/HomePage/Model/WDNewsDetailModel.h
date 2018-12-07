//
//  WDNewsDetailModel.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDNewsDetailModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *newsUrl;
@property (nonatomic,copy) NSString *createBy;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *images;
@property (nonatomic,copy) NSString *shareUrl;
@end
