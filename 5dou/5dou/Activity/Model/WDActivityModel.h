//
//  WDActivityModel.h
//  5dou
//
//  Created by ChunXin Zhou on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDActivityModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *activityUrl;
@property (nonatomic,copy) NSString *activityStatus;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *thumbUrl;
@property (nonatomic,copy) NSString *pageView;
@property (nonatomic,copy) NSString *nowDate;
@property (nonatomic,copy) NSString *startDate;
@property (nonatomic,copy) NSString *endDate;
@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,copy) NSString *activityID;
@property (nonatomic,copy) NSString *activityTag;

@property(nonatomic,copy)NSString *isHot;
@property(nonatomic,copy)NSString *isTop;
@property(nonatomic,assign)NSInteger withHead;//进去的页面是web页面，是否带导航1 有  0 没

@end
