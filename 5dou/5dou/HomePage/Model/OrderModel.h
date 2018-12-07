//
//  OrderModel.h
//  5dou
//
//  Created by ChunXin Zhou on 2016/12/1.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject


@property(nonatomic,copy)NSString *order_id;//订单id
@property(nonatomic,copy)NSString *order_no;//订单号
@property(nonatomic,copy)NSString *order_payment_total;//总价
@property(nonatomic,copy)NSString *order_status;//订单状态

@property(nonatomic,strong)NSDictionary *dictionary;
@end
