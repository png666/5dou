//
//  DDClearCache.m
//  sinaSport
//
//  Created by mac on 14/11/13.
//  Copyright (c) 2014年 student. All rights reserved.
//

#import "DDClearCache.h"

#define DDCachePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]


@implementation DDClearCache

+ (NSString *)allCacheSize{
    double cacheSize = [self fileSizeWithPath:DDCachePath];
    if(cacheSize < 1.0){
        return [NSString stringWithFormat:@"%ldK", (long)(cacheSize * 1000)];
    }
    return [NSString stringWithFormat:@"%0.2fM", cacheSize];
}

+ (void)clearAllCache{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:DDCachePath]){
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:DDCachePath error:nil];
        // 目录
        if([fileAttributes[NSFileType] isEqualToString:NSFileTypeDirectory]){
            for(NSString *fileName in [fileManager subpathsAtPath:DDCachePath]){
                NSString *fileAbsolutePath = [DDCachePath stringByAppendingPathComponent:fileName];
                // 只删除txt的文件
                if([fileAbsolutePath hasSuffix:@".txt"]){
                    [fileManager removeItemAtPath:fileAbsolutePath error:nil];
                }
            }
        }
    }
}
+ (double)fileSizeWithPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    double cacheSize = 0.0f;
    if ([fileManager fileExistsAtPath:path]){
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
        // 目录
        if([fileAttributes[NSFileType] isEqualToString:NSFileTypeDirectory]){
            NSArray *subPaths = [fileManager subpathsAtPath:path];
            long long fileSize = 0;
            for(NSString *fileName in subPaths){
                NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
                if([fileAbsolutePath hasSuffix:@".txt"]){
                    fileSize += [[fileManager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
                }
            }
            cacheSize = (double)fileSize;
        }else{
            cacheSize = (double)[fileAttributes fileSize];
        }
    }
    return cacheSize / (1000.0 * 1000.0);
}


@end
