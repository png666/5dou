//
//  DDSaveDataToCache.m
//  sinaSport
//
//  Created by mac on 14/11/13.
//  Copyright (c) 2014年 student. All rights reserved.
//

#import "DDSaveDataToCache.h"
#import "FCFileManager.h"
#import "NSString+MD5.h"
@implementation DDSaveDataToCache

+(BOOL)writeDateForPath:(NSDictionary *)dicJson forPathName:(NSString *) namePath{
    NSString *path = [FCFileManager pathForDocumentsDirectoryWithPath:[NSString stringWithFormat:@"%@.txt",[namePath MD5Digest]]];
    if ([FCFileManager isFileItemAtPath:path]) {
        [FCFileManager removeItemAtPath:path];
    }
    [FCFileManager writeFileAtPath:path content:[NSString stringWithFormat:@"%@",dicJson]];
    
    return YES;
}

+(NSDictionary *)readFilePath:(NSString *)namePath{
    
    NSString *path = [FCFileManager pathForDocumentsDirectoryWithPath:[NSString stringWithFormat:@"%@.txt",[namePath MD5Digest]]];
    if ([FCFileManager isFileItemAtPath:path]) {
        return [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    return nil;
    
}


@end
