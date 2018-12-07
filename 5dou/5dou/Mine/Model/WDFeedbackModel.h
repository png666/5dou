//
//  WDFeedbackModel.h
//  5dou
//
//  Created by rdyx on 16/11/24.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDFeedbackModel : NSObject

@property(nonatomic,copy)NSString *uid;

@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *headImg;
@property(nonatomic,copy)NSString *createDateStr;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *sysReply;//客服回复

@property (nonatomic, assign) BOOL isExpand;



@end
