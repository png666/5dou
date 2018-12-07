//
//  DEFINE.h
//  5dou
//
//  Created by rdyx on 16/8/28.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#ifndef DEFINE_h
#define DEFINE_h

//所有的宏定义写在此类中

#ifdef DEBUG
# define YYLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define YYLog(...)
#endif

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width

#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define iOS8OrLater ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9OrLater ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS10OrLater ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)



//应用的名称
#define app_Name [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

/// IOS_YANG渠道下的apple id
#define Apple_ID @"1185458201"

//获取rgb颜色
#define WDColorRGB(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]
//获取16进制颜色
#define WDColorFrom16RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//直接根据图片名称获取图片
#define WDImgName(name) [UIImage imageNamed:name]

#define WDURL(urlString)  [NSURL URLWithString:urlString]

//2.0版本的导航栏颜色
#define kNavigationBarGrayColor WDColorFrom16RGB(0xF9F8F8)

//之前的黄色导航栏背景
#define kNavigationBarColor [UIColor colorWithRed:250.f/255.f green:190.f/255.f blue:64.f/255.f alpha:1]

#define kBackgroundColor [UIColor colorWithRed:242.f/255.f green:242.f/255.f blue:242.f/255.f alpha:1]
#define kNavigationTitleColor kBlackColor

//工程所用黄色调
#define kMainColor WDColorRGB(251.f, 191.f, 45.f)
#define KCoffeeColor WDColorRGB(138, 87, 47)

#define device_is_iphone_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640,960),[[UIScreen mainScreen] currentMode].size):NO)
#define device_is_iphone_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640,1136),[[UIScreen mainScreen] currentMode].size):NO)
#define device_is_iphone_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(750,1334),[[UIScreen mainScreen] currentMode].size):NO)
#define device_is_iphone_6p ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(1242,2208),[[UIScreen mainScreen] currentMode].size):NO)

#define kBlackColor      ([UIColor blackColor])
#define kLightGrayColor  [UIColor lightGrayColor]
#define kGrayColor  [UIColor grayColor]

#define kWhiteColor  [UIColor whiteColor]
#define kClearColor  [UIColor clearColor]
#define kCyanColor  [UIColor cyanColor]
#define kFont8 [UIFont systemFontOfSize:8]
#define kFont9 [UIFont systemFontOfSize:9]
#define kFont10 [UIFont systemFontOfSize:10]
#define kFont12 [UIFont systemFontOfSize:12]
#define kFont13 [UIFont systemFontOfSize:13]
#define kFont14 [UIFont systemFontOfSize:14]
#define kFont15 [UIFont systemFontOfSize:15]
#define kFont16 [UIFont systemFontOfSize:16]
#define kFont18 [UIFont systemFontOfSize:18]

//block 循环引用避免
#define WeakStament(wself) __weak typeof(self) wself=self


//项目中常用的黑色
#define kFirstLevelBlack WDColorFrom16RGB(0x333333)
#define kSecondLevelBlack WDColorFrom16RGB(0x666666)
#define kThirdLevelBlack WDColorFrom16RGB(0x999999)
#define kLineBlack WDColorFrom16RGB(0xdddddd)

//去除"-(id)performSelector:(SEL)aSelector withObject:(id)object;"的警告
#define SuppressPerformSelectorLeakWarning(Stuff) /do { /_Pragma("clang diagnostic push") /_Pragma("clang diagnostic ignored /"-Warc-performSelector-leaks/"") /Stuff; /_Pragma("clang diagnostic pop") /} while (0)


#define  KEY_USERNAME_PASSWORD @"com.5dou.app.usernamepassword"
#define  KEY_USERNAME @"com.5dou.app.username"
#define  KEY_PASSWORD @"com.5dou.app.password"

#define BUGLY_APP_ID @"b144222f02"
//友盟
#define UmengAPPKey @"57d4d3c767e58ebaec0032d2"

//////********5dou*******////
////qq
//#define QQ_APPID @"1105513489"
//#define QQ_APPKEY @"2bOhRM8Sb2uMYD9b"
////微信
//#define WX_APPID  @"wx2952cceae5dd010f"
//#define WX_APPSECRET @"a10d94c5103a90b720e745e06f4b3ffb"
//#define WX_BASE_URL @"https://api.weixin.qq.com/sns"

////********5逗*******////
//qq
#define QQ_APPID @"1105684529"
#define QQ_APPKEY @"47miQLbzifSUInWA"
//微信
#define WX_APPID  @"wx8f6f260e4b23a092"
#define WX_APPSECRET @"7517662fe0bfab64e302d8e057b052f9"
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"



//分享重定向地址
#define UMeng_RedirectURL @"http://www.5dou.cn"

//线上H5 代码移动到 WDHTTPServer统一控制
//#define H5Url @"ios.5dou.cn"
//测试H5 代码移动到 WDHTTPServer统一控制
//#define H5Url @"iostest.5dou.cn"


//判断是否显示首页的用户指导图
#define GuideKey @"guideshow"

//通知

#define  DISMISS_MESSAGE_BADGE @"dismissUnreadMessageBadge"
#define  DISMISS_VIEWCONTROLLER @"dismissViewController"

#define  WD_JUMP_TO_VIEWCONTROLLER @"jumpToViewcontroller"


#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif


#define kButtonHeight 32

//微信认证后存储用户信息
#define kSaveWechatUserInfo  @"saveInfo"
//支付宝支付成功发通知
#define kAlipaySucceedInfo @"alipaySucceed"
//支付宝支付成功发通知
#define kAlipayFailedInfo @"alipayFailed"
//支付宝支付成功发通知
#define kAlipayCancelInfo @"alipayCanceld"







#endif /* DEFINE_h */
