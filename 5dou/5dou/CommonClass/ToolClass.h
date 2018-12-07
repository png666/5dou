//
//  ToolClass.h
//  5dou
//
//  Created by rdyx on 16/8/29.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFToast.h"
#import "WDCustomSearchBar.h"
#import <WebKit/WebKit.h>
@interface ToolClass : NSObject
//判断网路连接状态
@property(nonatomic,assign)BOOL isConnected;



+(instancetype)shareInstance;

+ (void)showAlertWithMessage:(NSString *)message;

///设置view边框

+ (void)setView:(UIView *)theView withRadius:(float )radius andBorderWidth:(float )borderWidth andBorderColor:(UIColor *)borderColor;


///基础控件快捷创建
+ (UIButton *)buttonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor;

+ (UIButton *)buttonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andNorImage:(NSString *)norImage andHiImage:(NSString *)hiImage;

+ (UIButton *)buttonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andBgImage:(NSString *)bgImage;

+ (UILabel *)labelWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor;

+ (UILabel *)labelWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTextAlignment:(NSTextAlignment)alignment andFont:(UIFont *)font;

#pragma mark- 字符串校验
+ (BOOL)judgeChineseWord:(NSString *)text;//纯汉字
+ (BOOL)judgePassWord:(NSString *)psd;//验证密码只支持数字、字母
//字符串长度和特殊字符检测
+ (BOOL)checkStringLength:(NSString *)str andMin:(int) min andMax:(int)max andAlertStr:(NSString *)alertStr;
+ (BOOL)checkStringSpecial:(NSString *)str andAlertStr:(NSString *)alertStr andNeedShow:(BOOL)show;

//只能输入整数和小数
+ (BOOL)validateNumberAndDot:(NSString *)text;
+ (BOOL)validateTwoDots:(NSString *)text;
+ (NSString *)mobileOperator:(NSString *)mobileNum;//获取手机的运营商
+ (BOOL)validateMobile:(NSString *)mobileNum;//验证手机号
+ (BOOL)validateMail:(NSString *)mail;
+ (BOOL)validatePassWord:(NSString *)psd;//验证密码（只支持数字、字母、下划线，字母区分大小写，不支持特殊字符）^[0-9a-zA-Z_]{1,}$
+ (BOOL)validateIdCard:(NSString *)idCard;//判断身份证格式
+ (BOOL)stringContainsEmoji:(NSString *)string;//判断是否是emoji文字
/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum;
//获取广告标志符
+(NSString *)getIDFA;

///获取UUID
//+(NSString *)getUUID;
//动态计算高度
+ (CGFloat)getCellHeight:(NSString *)str
                withFont:(CGFloat)fontSize
               withWidth:(CGFloat)width;
//获取缓存
+ (NSString *)getAllCacheSize; // 直接转换为字符串输出，不足1M时，单位为K，超过1M时，单位为M，保留两位小数

// 清除缓存
+ (void)clearAllCache;

//将SDWeb的图片进行k转换

+(NSString *)getImageCache;

/**
清除图片缓存
 */
+(void)clearImageCache;

+(UITextField *)showSearchBarWithPlaceHolder:(NSString *)placeHolder;

+(UIView *)getSearchBarWithPlaceholder:(NSString *)placeholder hasLeftButton:(BOOL)haveButton;

//快速设置图片
+(UIImage *)setImage:(UIImage *)image WithTintColor:(UIColor *)color;
+(NSInteger)getStrHeightWithStr:(NSString *)str andWidth:(NSInteger)width andWithFont:(UIFont *)font;

//获取当前显示控制器
+ (UIViewController *)getCurrentVC;

//截屏
+ (UIImage *)captureView:(UIView *)view;

+ (void) startAnimationWithView:(UIView *)view;

//获取APP版本号
+(NSString *)getAPPVersion;

//网络监测
//+(void)NetWorkMonitoring;

///系统版本
+(CGFloat )currentSystemVersion;
//这个方法只能获取到iPhone、iPad这种信息，无法获取到是iPhone 4、iPhpone5这种具体的型号。
+(NSString *)currentDeviceModel;
//获取设备具体型号 eg: 5s, 6,6p

//+(NSString *)currentDetailDeviceModel;


+(void)animateWithCell:(UITableViewCell *)cell;

+ (NSString *)getTimestamp;

/**
 float截取到最后一位不是0
 如0.060000->0.06
 @param stringFloat 原§始字符串
 @return 处理之后的字符串
 */
+(NSString *)changeFloat:(NSString *)stringFloat;
/**创建BezierPath 并设置角 和 半径*/
+ (void)setLayerAndBezierPathCutCircularWithView:(UIView *) view;

/**设置行间距*/
+ (void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font;
/**返回高度*/
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;
/**设置文件的富文本属性*/
+ (NSDictionary *)textDict : (UIFont *)font;
/**设置textview*/
+ (void)setTextViewSpace:(UITextView *)textView withFont:(UIFont *)font;
/**计算文本的高度*/
+ (CGFloat) heightForString:(UITextView *)textView andWidth:(float)width;


/**
 清除webView 缓存
 */
+(void)clearWebViewCache;



//找到当前View所在的VC
- (UIViewController *)findViewController:(UIView *)sourceView;




@end
