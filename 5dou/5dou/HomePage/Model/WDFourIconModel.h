//
//  WDFourIconModel.h
//  5dou
//
//  Created by rdyx on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDFourIconModel : NSObject

@property(nonatomic,copy)NSString *iconName;
@property(nonatomic,copy)NSString *iconUrl;
@property(nonatomic,copy)NSString *productUrl;
@property(nonatomic,copy)NSString *iconType;
@property(nonatomic,copy)NSString *productCode;//区分产品 例如是观影体验，问卷调查

@end
