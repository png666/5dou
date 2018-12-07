//
//  OrderModel.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/12/1.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setDictionary:(NSDictionary *)dictionary{
    
    _dictionary = dictionary;
    self.order_id = dictionary[@"order_id"];
    self.order_no = dictionary[@"order_no"];
    self.order_payment_total = dictionary[@"total"];
    self.order_status = dictionary[@"order_status"];
    
}


@end
