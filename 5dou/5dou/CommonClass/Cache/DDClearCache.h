//
//  DDClearCache.h
//  sinaSport
//
//  Created by mac on 14/11/13.
//  Copyright (c) 2014年 student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDClearCache : NSObject

+ (NSString *)allCacheSize; // 直接转换为字符串输出，不足1M时，单位为K，超过1M时，单位为M，保留两位小数

+ (void)clearAllCache; // 清除缓存



@end
