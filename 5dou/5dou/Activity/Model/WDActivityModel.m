//
//  WDActivityModel.m
//  5dou
//
//  Created by ChunXin Zhou on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDActivityModel.h"

@implementation WDActivityModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.activityID = value;
    }
}
@end
