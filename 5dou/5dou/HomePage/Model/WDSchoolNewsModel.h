//
//  WDSchoolNewsModel.h
//  5dou
//
//  Created by rdyx on 16/9/1.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDSchoolNewsModel : NSObject
@property(nonatomic,strong)NSNumber *newsId;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *thumb_url;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSNumber *pageView;
@property(nonatomic,strong)NSNumber *commentCount;
@property(nonatomic,strong)NSString *thumbUrl;
@end
