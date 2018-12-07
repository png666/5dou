//
//  ENUM.h
//  5dou
//
//  Created by ChunXin Zhou on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//  定义所有的枚举类型

#ifndef ENUM_h
#define ENUM_h

typedef NS_ENUM (NSInteger,TaskFilterType) {
    TaskFilterTypeSort = 1,
    TaskFilterKind = 2,
    TaskFilterRemove = 3
};


typedef NS_ENUM(NSInteger,RequestType) {
    RequestTypeNews = 1,
    RequestTypeTask = 2,
    ReuqestTypeActivity = 3
};


typedef NS_ENUM(NSInteger,TaskType) {
    TaskTypeNone = 0,
    TaskTypeDoing = 1,
    TaskTypeFinish = 2,
    TaskTypeGiveUp = 3,
    TaskTypeChecking = 4,
    TaskTypeNotPass = 5,
    TaskTypeExpiryDate = 6,
    TaskTypeCollection = 7
};

#endif /* ENUM_h */
