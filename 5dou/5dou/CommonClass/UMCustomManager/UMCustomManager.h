////
////  UMCustomManager.h
////  UMengDemo
////
////  Created by 黄新 on 16/11/30.
////  Copyright © 2016年 wudou. All rights reserved.
////
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

typedef void(^GetUserInfoSuccessBlock)(id response);
typedef void(^GetUserInfoFailBlock)(id error);

@interface UMCustomManager : NSObject

//初始化
+(instancetype)shareInstance;

+ (void)shareWebWithViewController:(UIViewController *)vc
                        ShareTitle:(NSString *)shareTitle
                           Content:(NSString *)content
                        ThumbImage:(id)thumbImage
                               Url:(NSString *)url;

+ (void)shareImageWithViewController:(UIViewController *)vc
                          ShareTitle:(NSString *)shareTitle
                             Content:(NSString *)content
                          ThumbImage:(id)thumbImage
                               Image:(id)image;
+ (void)shareTextWithViewController:(UIViewController *)vc
                            Content:(NSString *)content;


+ (void)loginWithQQWithController:(UIViewController *)vc
                          Success:(GetUserInfoSuccessBlock)success
                          Failure:(GetUserInfoFailBlock)failure;

+ (void)loginWithWXWithController:(UIViewController *)vc
                          Success:(GetUserInfoSuccessBlock)success
                          Failure:(GetUserInfoFailBlock)failure;
@end

