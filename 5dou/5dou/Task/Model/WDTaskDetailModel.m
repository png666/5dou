//
//  WDTaskDetailModel.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/2.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskDetailModel.h"

@implementation WDTaskDetailModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"taskId",
                                                       @"copyText": @"textSearch"}];
}

@end
