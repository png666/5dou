//
//  WDTaskModel.m
//  5dou
//
//  Created by ChunXin Zhou on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskModel.h"

@implementation WDTaskModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.taskId = value;
    }
}
@end
