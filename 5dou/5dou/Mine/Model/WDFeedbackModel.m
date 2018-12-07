//
//  WDFeedbackModel.m
//  5dou
//
//  Created by rdyx on 16/11/24.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDFeedbackModel.h"

@implementation WDFeedbackModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        _message = value;
    }
    if ([key isEqualToString:@"id"]) {
        _uid = value;
    }
}

@end
