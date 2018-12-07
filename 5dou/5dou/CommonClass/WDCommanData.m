



//
//  WDCommanData.m
//  5dou
//
//  Created by rdyx on 16/9/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDCommanData.h"

@implementation WDCommanData

+(instancetype)shareInstance{
    
    static WDCommanData *_commanData = nil;
    static dispatch_once_t t;
    dispatch_once(&t,^{
        _commanData = [[WDCommanData alloc]init];
    });
    return _commanData;
}


@end
