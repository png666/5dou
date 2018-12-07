//
//  DDSaveDataToCache.h
//  sinaSport
//
//  Created by mac on 14/11/13.
//  Copyright (c) 2014年 student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDSaveDataToCache : NSObject

+(BOOL)writeDateForPath:(NSDictionary *)dicJson forPathName:(NSString *) namePath;

+(NSDictionary *)readFilePath:(NSString *)namePath;

@end
