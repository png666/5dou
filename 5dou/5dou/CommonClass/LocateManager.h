//
//  LocateManager.h
//  oc
//
//  Created by macfai on 16/4/8.
//  Copyright © 2016年 macfaith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LocateSuccessBlock)(NSString *cityName);
typedef void (^LocateFailBlock)(NSError *error);

@interface LocateManager : NSObject

@property(nonatomic,copy)LocateSuccessBlock successblock;
@property(nonatomic,copy)LocateFailBlock failBlock;


+(instancetype)shareInstance;

-(void)locateWithSuccessBlock:(LocateSuccessBlock)successBlock failBlock:(LocateFailBlock)failBlock;

@end
