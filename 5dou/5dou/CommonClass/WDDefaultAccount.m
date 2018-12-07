//
//  WDDefaultAccount.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/6.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDDefaultAccount.h"

#define CITYLIST  @"cityList"
#define CITYNAME  @"cityName"
#define CITYID    @"cityId"
#define PROVINCEID @"provinceId"

#define USERINFO  @"userInfo"

@implementation WDDefaultAccount

+ (NSMutableArray *)cityList{
    return [[NSUserDefaults standardUserDefaults] objectForKey:CITYLIST];
}

+ (void)setCityList:(NSMutableArray *)cityList {
    [[NSUserDefaults standardUserDefaults] setValue:cityList forKey:CITYLIST];
    //确保线程安全
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)cityId{
    return [[NSUserDefaults standardUserDefaults] objectForKey:CITYID];
}

+ (void)setCityId:(NSString *)cityId{
    [[NSUserDefaults standardUserDefaults] setValue:cityId forKey:CITYID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)cityName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:CITYNAME];
}

+ (void)setCityName:(NSString *)cityName{
    [[NSUserDefaults standardUserDefaults] setValue:cityName forKey:CITYNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)provinceId{
    return [[NSUserDefaults standardUserDefaults] objectForKey:PROVINCEID];
}
+ (void)setProvinceId:(NSString *)provinceId{
    [[NSUserDefaults standardUserDefaults] setValue:provinceId forKey:PROVINCEID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)setUserInfoWithDic:(NSDictionary *)infoDic{
    [[NSUserDefaults standardUserDefaults] setValue:infoDic forKey:USERINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getUserInfo{
    return [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO];
}

+ (void)cleanAccountCache{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CITYLIST];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CITYNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CITYID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PROVINCEID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERINFO];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
