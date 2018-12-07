//
//  PayModel.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/12/1.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "PayModel.h"
#import <AlipaySDK/AlipaySDK.h>
@implementation PayModel


///**
// *  支付宝支付，需要对支付结果进行处理
// *
// *  @param model       orderModel，包含了 订单ID order_id，总价钱 order_payment_total
// *  @param finishBlock 支付结束后的回调，回传参数 resultDic 中包含状态代码 resultStatus，本次操作返回的结果数据 result，提示信息 memo 保留参数,一般无内容。 可空
// 状态码：
// 9000 订单支付成功
// 8000 正在处理中
// 4000 订单支付失败
// 6001 用户中途取消
// 6002 网络连接出错
// */
+(void)aliPay:(NSString *)orderString finishBlock:(void(^)(NSDictionary *resultDic))finishBlock{
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"5dou" callback:^(NSDictionary *resultDic) {
        YYLog(@"resultDic = %@",resultDic);
    }];
}

@end
