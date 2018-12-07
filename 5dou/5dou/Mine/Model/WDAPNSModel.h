//
//  WDAPNSModel.h
//  5dou
//
//  Created by 黄新 on 16/9/22.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  推送的model
//

#import "JSONModel.h"

@class WDAps;

@protocol WDAPNSModel <NSObject>

@end

@interface WDAPNSModel : JSONModel
@property (nonatomic, strong) WDAps *aps;
@property (nonatomic, copy) NSString <Optional>*openTo;///< 要跳转的页面

@end

@protocol WDAps <NSObject>
@end

@interface WDAps : JSONModel

@property (nonatomic, copy) NSString *alert;

@end


