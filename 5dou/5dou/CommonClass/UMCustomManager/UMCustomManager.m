////
////  UMCustomManager.m
////  UMengDemo
////
////  Created by 黄新 on 16/11/30.
////  Copyright © 2016年 wudou. All rights reserved.
////
//
#import "UMCustomManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <WXApi.h>
#import "JWShareView.h"
#import "ToolClass.h"
#import "WDUserInfoModel.h"

@implementation UMCustomManager

+(instancetype)shareInstance{
    
    static UMCustomManager *_customManager = nil;
    static dispatch_once_t t;
    dispatch_once(&t,^{
        
        _customManager = [[UMCustomManager alloc]init];
    });
    return _customManager;
}

#pragma mark ==== 分享基础方法
/**
 分享纯文本
 
 @param text         分享的内容信息
 @param platformType 分享的平台
 @param vc           当前的控制器
 */
+ (void)shareText:(NSString *)text WithPlatform:(UMSocialPlatformType)platformType WithController:(UIViewController *)vc {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = text;
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:vc completion:^(id result, NSError *error) {
        if (!error) {
            [ToolClass showAlertWithMessage:@"分享成功"];
        }else{
            [ToolClass showAlertWithMessage:@"分享失败"];
            YYLog(@"分享失败的原因-------%@",error);
        }
        //移除分享的View
        [[JWShareView shareInstance] cancleButtonAction];
    }];
}



/**
 分享网络图片
 
 @param image        图片
 @param title        标题
 @param descr        描述
 @param thumImg      缩略图
 @param platformType 平台
 @param vc           控制器
 */
+ (void)shareImage:(id)image Title:(NSString *)title descr:(NSString *)descr ThumImg:(id)thumImg WithPlatform:(UMSocialPlatformType)platformType WithController:(UIViewController *)vc{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:title descr:descr thumImage:thumImg];
    shareObject.shareImage = image;
    messageObject.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:vc completion:^(id result, NSError *error) {
        if (error) {
            [ToolClass showAlertWithMessage:@"分享失败"];
            YYLog(@"分享失败---------%@",error);
        }else{
            [ToolClass showAlertWithMessage:@"分享成功"];
        }
        //移除分享的View
        [[JWShareView shareInstance] cancleButtonAction];
    }];
}



/**
 网页分享
 
 @param url          网页的URL
 @param title        标题
 @param descr        描述
 @param thumImg      缩略图
 @param platformType 分享的平台
 @param vc           当前所在的控制器
 */
+ (void)shareWebPage:(NSString *)url Title:(NSString *)title descr:(NSString *)descr ThumImg:(id)thumImg WithPlatform:(UMSocialPlatformType)platformType WithController:(UIViewController *)vc{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumImg];
    //设置网页地址
    shareObject.webpageUrl = url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
//    WeakStament(ws);
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:vc completion:^(id result, NSError *error) {
        UMSocialShareResponse *res = (UMSocialShareResponse *)result;
        YYLog(@"%@",res.message);
        if (error) {
            YYLog(@"分享失败---------%@",error);
            [ToolClass showAlertWithMessage:@"分享失败"];
        }else{
            if ([WDUserInfoModel shareInstance].isLotShare) {
                //目的是通知h5刷新抽奖页面
                [[NSNotificationCenter defaultCenter]postNotificationName:@"shareLottery" object:nil];
                 [[JWShareView shareInstance] cancleButtonAction];
                return ;
                //这个由js来弹框
            }
            [ToolClass showAlertWithMessage:@"分享成功"];
            //为了鼓励用户分享，在用户分享成功后，和后台交互进行记录，为其增加一次抽奖机会
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if ([WDUserInfoModel shareInstance].isLotShare) {
//                    NSDictionary *paras = @{@"lotteryCode":[WDUserInfoModel shareInstance].lotteryCode,@"memberId":[WDUserInfoModel shareInstance].memberId};
//                    [WDNetworkClient postRequestWithBaseUrl:kLottoryShareTimeUrl setParameters:paras success:^(id responseObject) {
//                        YYLog(@"%@",responseObject);
//                        NSDictionary *dic = (NSDictionary *)responseObject;
//                        if ([dic[@"result"][@"code"] isEqualToString:@"1000"]) {
//                            //完成循环
//                            [WDUserInfoModel shareInstance].isLotShare = false;
//                        }else{
//                            [ToolClass showAlertWithMessage:dic[@"result"][@"msg"]];
//                        }
//                    } fail:^(NSError *error) {
//                    } delegater:nil];
//                }
//            });

        }
        //移除分享的View
        [[JWShareView shareInstance] cancleButtonAction];
    }];
}

#pragma mark ===== VC中调用的分享方法    即弹出分享视图
/**
 分享URL
 
 @param vc         控制器
 @param shareTitle 标题
 @param content    描述
 @param thumbImage 缩略图
 @param url        URL地址
 */
+ (void)shareWebWithViewController:(UIViewController *)vc ShareTitle:(NSString *)shareTitle Content:(NSString *)content ThumbImage:(id)thumbImage Url:(NSString *)url{
    
    JWShareView *shareView = [JWShareView shareInstance];
    [shareView addShareItems:[UIApplication sharedApplication].keyWindow shareItems:[self getUserAPPInstalled] selectShareItem:^(NSInteger tag, NSString *title) {
        if ([title isEqualToString:@"QQ"]) {
            [UMCustomManager shareWebPage:url Title:shareTitle descr:content ThumImg:thumbImage WithPlatform:UMSocialPlatformType_QQ WithController:vc];
        }else if ([title isEqualToString:@"QQ空间"]){
            [UMCustomManager shareWebPage:url Title:shareTitle descr:content ThumImg:thumbImage WithPlatform:UMSocialPlatformType_Qzone WithController:vc];
        }else if ([title isEqualToString:@"微信"]){
            [UMCustomManager shareWebPage:url Title:shareTitle descr:content ThumImg:thumbImage WithPlatform:UMSocialPlatformType_WechatSession WithController:vc];
        }else if ([title isEqualToString:@"朋友圈"]){
            
            if ([WDUserInfoModel shareInstance].isRebateShareToTimeLine) {
                NSString *timeLineContent = [WDUserInfoModel shareInstance].timeLineContent;
                 [UMCustomManager shareWebPage:url Title:timeLineContent descr:timeLineContent ThumImg:thumbImage WithPlatform:UMSocialPlatformType_WechatTimeLine WithController:vc];
            }else{
                
                  [UMCustomManager shareWebPage:url Title:shareTitle descr:content ThumImg:thumbImage WithPlatform:UMSocialPlatformType_WechatTimeLine WithController:vc];
            }
            [WDUserInfoModel shareInstance].isRebateShareToTimeLine = false;
        }else{
            return ;
        }
    }];
}
/**
 分享图片
 
 @param vc         控制器
 @param shareTitle 标题
 @param content    描述
 @param thumbImage 缩略图
 @param image      分享的图片
 */
+ (void)shareImageWithViewController:(UIViewController *)vc ShareTitle:(NSString *)shareTitle Content:(NSString *)content ThumbImage:(id)thumbImage Image:(id)image{
    JWShareView *shareView = [JWShareView shareInstance];
    [shareView addShareItems:[UIApplication sharedApplication].keyWindow shareItems:[self getUserAPPInstalled] selectShareItem:^(NSInteger tag, NSString *title) {
        if ([title isEqualToString:@"QQ"]) {
            [UMCustomManager shareImage:image Title:shareTitle descr:content ThumImg:thumbImage WithPlatform:UMSocialPlatformType_QQ WithController:vc];
        }else if ([title isEqualToString:@"QQ空间"]){
            [UMCustomManager shareImage:image Title:shareTitle descr:content ThumImg:thumbImage WithPlatform:UMSocialPlatformType_Qzone WithController:vc];
        }else if ([title isEqualToString:@"微信"]){
            [UMCustomManager shareImage:image Title:shareTitle descr:content ThumImg:thumbImage WithPlatform:UMSocialPlatformType_WechatSession WithController:vc];
        }else if ([title isEqualToString:@"朋友圈"]){
            [UMCustomManager shareImage:image Title:shareTitle descr:content ThumImg:thumbImage WithPlatform:UMSocialPlatformType_WechatTimeLine WithController:vc];
        }else{
            return ;
        }
    }];
}

/**
 分享纯文本
 
 @param vc      控制器
 @param content 分享的内容
 */
+ (void)shareTextWithViewController:(UIViewController *)vc Content:(NSString *)content{
    JWShareView *shareView = [JWShareView shareInstance];
    [shareView addShareItems:[UIApplication sharedApplication].keyWindow shareItems:[self getUserAPPInstalled] selectShareItem:^(NSInteger tag, NSString *title) {
        if ([title isEqualToString:@"QQ"]) {
            [UMCustomManager shareText:content WithPlatform:UMSocialPlatformType_QQ WithController:vc];
        }else if ([title isEqualToString:@"QQ空间"]){
            [UMCustomManager shareText:content WithPlatform:UMSocialPlatformType_Qzone WithController:vc];
        }else if ([title isEqualToString:@"微信"]){
            [UMCustomManager shareText:content WithPlatform:UMSocialPlatformType_WechatSession WithController:vc];
        }else if ([title isEqualToString:@"朋友圈"]){
            [UMCustomManager shareText:content WithPlatform:UMSocialPlatformType_WechatTimeLine WithController:vc];
        }else{
            return ;
        }
    }];
}

#pragma mark ===== 检测用户安装的分享客户端

+ (NSArray *)getUserAPPInstalled{
    
    NSMutableArray *shareArray = [NSMutableArray array];
    
    if ([QQApiInterface isQQInstalled]) {
        if ([WXApi isWXAppInstalled]) {
            //微信QQ都有安装
            [shareArray addObject:@{@"name":@"QQ",@"icon":@"qq"}];
            [shareArray addObject:@{@"name":@"QQ空间",@"icon":@"qqzone"}];
            [shareArray addObject:@{@"name":@"微信",@"icon":@"wechat"}];
            [shareArray addObject:@{@"name":@"朋友圈",@"icon":@"friend"}];
        }else{
            //只安装了QQ
            [shareArray addObject:@{@"name":@"QQ",@"icon":@"qq"}];
            [shareArray addObject:@{@"name":@"QQ空间",@"icon":@"qqzone"}];
        }
    }else{
        if ([WXApi isWXAppInstalled]) {
            //只安装了微信
            [shareArray addObject:@{@"name":@"微信",@"icon":@"wechat"}];
            [shareArray addObject:@{@"name":@"朋友圈",@"icon":@"friend"}];
        }else{
            //都没有安装
            [ToolClass showAlertWithMessage:@"请安装QQ或微信客户端"];
        }
    }
    return shareArray;
}

#pragma mark ================= 授权登录
/**
 QQ授权登录
 
 @param vc      当前控制器
 @param success 授权成功回调
 @param failure 授权失败回调
 */
+ (void)loginWithQQWithController:(UIViewController *)vc Success:(GetUserInfoSuccessBlock)success Failure:(GetUserInfoFailBlock)failure{
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_QQ completion:^(id result, NSError *error) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:vc completion:^(id result, NSError *error) {
            if (error) {
                failure(error);
            }else{
                success(result);
            }
        }];
    }];
    
}

/**
 微信授权登录
 
 @param vc      当前控制器
 @param success 授权成功回调
 @param failure 授权失败回调
 */
+ (void)loginWithWXWithController:(UIViewController *)vc Success:(GetUserInfoSuccessBlock)success Failure:(GetUserInfoFailBlock)failure{
    
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_WechatSession completion:^(id result, NSError *error) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:vc completion:^(id result, NSError *error) {
            if (error) {
                failure(error);
            }else{
                success(result);
            }
        }];
    }];
}



@end

