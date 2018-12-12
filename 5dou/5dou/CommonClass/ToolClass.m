


//
//  ToolClass.m
//  5dou
//
//  Created by rdyx on 16/8/29.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "ToolClass.h"
#import "KeyChainStore.h"
#import "WSAlertCenter.h"
#import <AdSupport/AdSupport.h>
#import "WDCustomSearchBar.h"
#import "WDUserInfoModel.h"

static NSString *IDFA = @"IDFA";
@interface ToolClass ()

@end

@implementation ToolClass
#define SLCachePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

+(instancetype)shareInstance{
    
    static ToolClass *_toolClass = nil;
    static dispatch_once_t t;
    dispatch_once(&t,^{
        _toolClass = [[ToolClass alloc]init];
    });
    return _toolClass;
}

#pragma mark- 设置view 边框
+ (void)setView:(UIView *)theView withRadius:(float )radius andBorderWidth:(float )borderWidth andBorderColor:(UIColor *)borderColor{
    theView.layer.cornerRadius = radius;
    theView.layer.borderWidth  = borderWidth;
    theView.layer.borderColor  = borderColor.CGColor;
    theView.layer.masksToBounds = YES;
}



//检查字符串长度
+ (BOOL)checkStringLength:(NSString *)str andMin:(int) min andMax:(int)max andAlertStr:(NSString *)alertStr{
    BOOL eff = YES;
    
    if ([str length] == 0) {
        eff = NO;
        //alert
        NSString *con = [NSString stringWithFormat:@"%@不能为空",alertStr];
        [ToolClass showAlertWithMessage:con];
    }else if ([str length] <min){
        eff = NO;
        //alert
        NSString *con = [NSString stringWithFormat:@"%@不能少于%d位",alertStr,min];
        [ToolClass showAlertWithMessage:con];
    }else if ([str length]>max){
        eff = NO;
        //alert
        NSString *con = [NSString stringWithFormat:@"%@不能多于%d位",alertStr,max];
        [ToolClass showAlertWithMessage:con];
    }
    
    return eff;
}

//检查特殊字符
+ (BOOL)checkStringSpecial:(NSString *)str andAlertStr:(NSString *)alertStr andNeedShow:(BOOL)show{
    BOOL eff = YES;
    
    NSTextCheckingResult *result = [ToolClass returnRegExpWithString:str];
    if (result == nil) {
        eff = NO;
        //alert
        NSString *con = [NSString stringWithFormat:@"%@不能包含特殊字符",alertStr];
        if (show) {
            [ToolClass showAlertWithMessage:con];
        }
    }
    return eff;
}

/**
 判断手机运营商

 @param mobileNum 手机号

 @return 运营商种类
 */
+ (NSString *)mobileOperator:(NSString *)mobileNum{
    
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:mobileNum];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:mobileNum];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:mobileNum];
    if (isMatch1 || isMatch2 || isMatch3) {
        if (isMatch1) {
            //移动--CM
            return @"中国移动";
        }else if (isMatch2) {
            //联通---CU
            return @"中国联通";
        }else {
            //电信---CT
            return @"中国电信";
        }
    }else{
        return @"请输入正确的手机号码";
    }
}

+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    /**
     * 补充新号段:
     * （147、181、183、184、176、177、178、1700、1705、1709）
     */
    NSString *latestMobile = @"^1((47|8[134]|7[678])[0-9]|700|705|709)\\d{7}$";
    
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL reu1 = [regextestmobile evaluateWithObject:mobileNum];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    BOOL reu2 = [regextestcm evaluateWithObject:mobileNum];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    BOOL reu3 = [regextestcu evaluateWithObject:mobileNum];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL reu4 = [regextestct evaluateWithObject:mobileNum];
    
    NSPredicate *regextestlatest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", latestMobile];
    BOOL reu5 = [regextestlatest evaluateWithObject:mobileNum];
    
    if (reu1 || reu2 || reu3 || reu4 || reu5)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)validateMail:(NSString *)mail
{
    //   ^[A-Za-zd]+([-_.][A-Za-zd]+)*@([A-Za-zd]+[-.])+[A-Za-zd]{2,5}$
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:mail];
}

+(BOOL)validateTwoDots:(NSString *)text
{
    NSString *check = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    NSPredicate *dotsCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",check];
    return [dotsCheck evaluateWithObject:text];
}


+ (BOOL)validatePassWord:(NSString *)psd//验证密码（只支持数字、字母、下划线，字母区分大小写，不支持特殊字符）^[0-9a-zA-Z_]{1,}$
{
    NSString *psdZZ = @"^[0-9a-zA-Z_]{1,}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", psdZZ];
    BOOL reu1 = [regextestmobile evaluateWithObject:psd];
    
    return reu1;
}
+ (BOOL)judgePassWord:(NSString *)psd//验证密码只支持数字、字母
{
    NSString *psdZZ = @"^[A-Za-z0-9]+$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", psdZZ];
    BOOL reu1 = [regextestmobile evaluateWithObject:psd];
    return reu1;
}


///判断是否为纯汉字 
+ (BOOL)judgeChineseWord:(NSString *)text{
    
    NSString *psdZZ = @"[^\u4e00-\u9fa5]";
    //    NSString *psdZZ = @"^[1-9]/d*/./d*|0/./d*[1-9]/d*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", psdZZ];
    BOOL reu1 = [regextestmobile evaluateWithObject:text];
    return reu1;
}
/**
 只支持是整数

 @param text

 @return
 */
///"


+ (BOOL)validateNumberAndDot:(NSString *)text
{
    
    NSString *psdZZ = @"^[1-9]/d*$";
//    NSString *psdZZ = @"^[1-9]/d*/./d*|0/./d*[1-9]/d*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", psdZZ];
    BOOL reu1 = [regextestmobile evaluateWithObject:text];
    return reu1;
}


+ (BOOL)validateIdCard:(NSString *)idCard//判断身份证格式
{
    NSString *psdZZ = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$|^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|[X|x])$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", psdZZ];
    BOOL reu1 = [regextestmobile evaluateWithObject:idCard];
    
    return reu1;
}

//正则表达式判断是否有特殊字符
+ (NSTextCheckingResult*)returnRegExpWithString:(NSString *)string
{
    NSString *expStr = nil;
    NSError *err = nil;
    NSRegularExpression *regEx;
    NSTextCheckingResult *result;
    
    expStr = [NSString stringWithFormat: @"^[a-zA-Z0-9_]{%d,%d}$",0,16];
    regEx  =[NSRegularExpression regularExpressionWithPattern:expStr options:0 error:&err];
    result =[regEx firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    
    return result;
}


#pragma mark-
+ (void)showAlertWithMessage:(NSString *)message{
    
//    [AFToast  showText:message];
    [[WSAlertCenter defaultCenter]postAlertWithMessage:message];
    
}

//label动态行高计算
+ (CGFloat)getCellHeight:(NSString *)str
                withFont:(CGFloat)fontSize
               withWidth:(CGFloat)width{
    CGSize size = CGSizeMake(width,MAXFLOAT); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize labelsize = [str boundingRectWithSize:size options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return ceil(labelsize.height);

}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
//    __block BOOL returnValue = NO;
//    
//    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
//                               options:NSStringEnumerationByComposedCharacterSequences
//                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//                                const unichar hs = [substring characterAtIndex:0];
//                                if (0xd800 <= hs && hs <= 0xdbff) {
//                                    if (substring.length > 1) {
//                                        const unichar ls = [substring characterAtIndex:1];
//                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
//                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
//                                            returnValue = YES;
//                                        }
//                                    }
//                                } else if (substring.length > 1) {
//                                    const unichar ls = [substring characterAtIndex:1];
//                                    if (ls == 0x20e3) {
//                                        returnValue = YES;
//                                    }
//                                } else {
//                                    if (0x2100 <= hs && hs <= 0x27ff) {
//                                        returnValue = YES;
//                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
//                                        returnValue = YES;
//                                    } else if (0x2934 <= hs && hs <= 0x2935) {
//                                        returnValue = YES;
//                                    } else if (0x3297 <= hs && hs <= 0x3299) {
//                                        returnValue = YES;
//                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
//                                        returnValue = YES;
//                                    }
//                                }
//                            }];
    
//    return returnValue;
    return NO;
}


#pragma mark- 基础控件快捷创建
+ (UIButton *)buttonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:(title!=nil)?title:@"aButton" forState:UIControlStateNormal];
    [button setTitleColor:(titleColor!=nil)?titleColor:kBlackColor forState:UIControlStateNormal];
    
    return button;
    
}
+ (UIButton *)buttonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andNorImage:(NSString *)norImage andHiImage:(NSString *)hiImage{
    UIButton *button = [ToolClass buttonWithFrame:frame andTitle:title andTitleColor:titleColor];
    
    if (norImage) {
        [button setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    }
    
    if (hiImage) {
        [button setImage:[UIImage imageNamed:hiImage] forState:UIControlStateHighlighted];
    }
    
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andBgImage:(NSString *)bgImage
{
    UIButton *button = [ToolClass buttonWithFrame:frame andTitle:title andTitleColor:titleColor];
    button.titleLabel.font = kFont14;
    if (bgImage) {
        [button setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
    }
    button.userInteractionEnabled = false;
    return button;
}

+ (UILabel *)labelWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = (title!=nil)?title:@"aLabel";
    label.textColor = (titleColor!=nil)?titleColor:kBlackColor;
    label.font = kFont12;
    return label;
}
+ (UILabel *)labelWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andTextAlignment:(NSTextAlignment)alignment andFont:(UIFont *)font{
    UILabel *label = [ToolClass labelWithFrame:frame andTitle:title andTitleColor:titleColor];
    label.textAlignment = alignment;
    label.backgroundColor = [UIColor clearColor];
    label.font = (font!=nil)?font:[UIFont systemFontOfSize:16];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

//获取广告标志符
+(NSString *)getIDFA
{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSUserDefaults *defalt = [NSUserDefaults standardUserDefaults];
    [defalt setValue:adId forKey:IDFA];
    [defalt synchronize];
    return adId;
}
//替换成广告标志符
+(NSString *)getUUID
{
    NSString * strUUID = (NSString *)[KeyChainStore load:@"com.company.app.usernamepassword"];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [KeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
    return strUUID;
}


+ (NSString *)getAllCacheSize{
    double cacheSize = [self fileSizeWithPath:SLCachePath];
    if(cacheSize < 1.0){ // 如果小于1M，则单位显示为K
        return [NSString stringWithFormat:@"%ldK", (long)(cacheSize * 1000)];
    }
    return [NSString stringWithFormat:@"%0.2fM", cacheSize];
}

+ (void)clearAllCache{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:SLCachePath]){
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:SLCachePath error:nil];
        // 目录
        if([fileAttributes[NSFileType] isEqualToString:NSFileTypeDirectory]){
            for(NSString *fileName in [fileManager subpathsAtPath:SLCachePath]){
                NSString *fileAbsolutePath = [SLCachePath stringByAppendingPathComponent:fileName];
                // 只删除txt的文件
                if([fileAbsolutePath hasSuffix:@".txt"]){
                    [fileManager removeItemAtPath:fileAbsolutePath error:nil];
                }
            }
        }
    }
}

+ (double)fileSizeWithPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    double cacheSize = 0.0f;
    if ([fileManager fileExistsAtPath:path]){
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
        // 目录
        if([fileAttributes[NSFileType] isEqualToString:NSFileTypeDirectory]){
            NSArray *subPaths = [fileManager subpathsAtPath:path];
            long long fileSize = 0;
            for(NSString *fileName in subPaths){
                NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
                if([fileAbsolutePath hasSuffix:@".txt"]){
                    fileSize += [[fileManager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
                }
            }
            cacheSize = (double)fileSize;
        }else{
            cacheSize = (double)[fileAttributes fileSize];
        }
    }
    return cacheSize / (1000.0 * 1000.0);
}

//快速设置图片
+(UIImage *)setImage:(UIImage *)image WithTintColor:(UIColor *)color
{
    CGSize imageSize = image.size;
    CGFloat scale = image.scale;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, imageSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//快速创建搜索框
+(UITextField *)showSearchBarWithPlaceHolder:(NSString *)placeHolder{
    
    CGFloat barItemWidth = 40;
    CGFloat padding = 10;
    CGFloat width = ScreenWidth - (barItemWidth + 2*padding);
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    textField.font = [UIFont systemFontOfSize:14.0];
    textField.placeholder = placeHolder;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    UIImage *searchImage = WDImgName(@"search_icon");
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [searchImageView setImage:searchImage];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    searchImageView.center =leftView.center;
    [leftView addSubview:searchImageView];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

//搜索框样式改进-用下面的方法

+(UIView *)getSearchBarWithPlaceholder:(NSString *)placeholder hasLeftButton:(BOOL)haveButton
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 350, 30)];
    bgView.backgroundColor = kClearColor;
    
//    WDCustomSearchBar *searchBar = [[WDCustomSearchBar alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth>375?280: (ScreenWidth>320?250:200), 30)];
    WDCustomSearchBar *searchBar;
    if (haveButton) {
        searchBar = [[WDCustomSearchBar alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth>375?(ScreenWidth - 135):(ScreenWidth-120), 30)];
 
    }else{
        searchBar = [[WDCustomSearchBar alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth>375?(ScreenWidth - 80):(ScreenWidth - 80), 30)];
    }
  
    searchBar.layer.cornerRadius = 15;
    searchBar.layer.masksToBounds = YES;
    [searchBar.layer setBorderWidth:0.5];
    searchBar.placeholder = placeholder;
    searchBar.tag = 201;
    [searchBar.layer setBorderColor:[UIColor clearColor].CGColor];
    [bgView addSubview:searchBar];
    return bgView;
}

//cell动态行高
+(NSInteger)getStrHeightWithStr:(NSString *)str andWidth:(NSInteger)width andWithFont:(UIFont *)font{
    CGSize size = CGSizeMake(width,MAXFLOAT); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize labelsize = [str boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return ceil(labelsize.height);
}


+ (NSString *)getImageCache
{
    NSInteger sizeInteger = [[SDImageCache sharedImageCache]getSize];
    
   return [self fileSizeWithInterge:sizeInteger];
    
}


//计算出缓存大小
+ (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

+(void)clearImageCache
{
    [[SDImageCache sharedImageCache]clearDisk];
     [[SDImageCache sharedImageCache]clearMemory];
    
}
/**
 *   获取当前显示控制器
 *
 *  @return <#return value description#>
 */
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIImage *)captureImageFromView:(UIView *)view

{
    
    CGRect screenRect = [view bounds];
    
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}


+ (UIImage *)captureView:(UIView *)view
{
    
    // 创建一个context
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    
    //把当前的全部画面导入到栈顶context中并进行渲染
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 从当前context中创建一个新图片
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return img;
}

//旋转动画
+(void)startAnimationWithView:(UIView *)view
{
    CABasicAnimation* anim = [CABasicAnimation animation];
    //    self.anim = anim;
    anim.delegate = (id)self;
    // 2.设置核心动画的操作
    anim.keyPath = @"transform.rotation.y";
    //    anim.fromValue = @(100); // 从哪
    //    anim.toValue = @(300); // 到哪
    anim.byValue = @(2 * M_PI);
    anim.duration = 0.7;
    anim.repeatCount = 2; // 重复次数
    // 动画完毕以后不回到原来的位置
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    // 3.添加到layer上
    [view.layer addAnimation:anim forKey:nil];
}
//获取app版本号
+(NSString *)getAPPVersion
{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return  app_Version;
    
}

+(void)NetWorkMonitoring
{
    WeakStament(ws);
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                [ws showAlertWithMessage:@"亲,您的网络开小差了"];
                [WDUserInfoModel shareInstance].isReachable = false;
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                
                [WDUserInfoModel shareInstance].isReachable = YES;
//                [ws showAlertWithMessage:@"您的网络为手机网络"];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                
                [WDUserInfoModel shareInstance].isReachable = YES;
//                [ws showAlertWithMessage:@"您当前为WIFI网络"];
            }
                break;
                
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
}

//操作系统版本
+(CGFloat )currentSystemVersion
{
   return  [[[UIDevice currentDevice] systemVersion]floatValue];
}

//设备名称
+(NSString *)currentDeviceModel
{
    return  [[UIDevice currentDevice] model];
}

//暂时没写
+(NSString *)currentDetailDeviceModel
{
    return @"";
}

+(void)animateWithCell:(UITableViewCell *)cell
{
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (60.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ - 600; //透视
    rotation.m31 = 1.0/ - 600; //旋转
    rotation.m13 = 1.0/ - 600; //旋转
    cell.layer.transform = rotation;
    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];

}

+(NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}


+ (NSString *)getTimestamp

{
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSString *timeStampString = [NSString stringWithFormat:@"%.0f", timeInterval];
    return timeStampString;
    
}


+(NSString *)changeFloat:(NSString *)stringFloat
{
    NSUInteger length = [stringFloat length];
    for(int i = 1; i<=6; i++)
    {
        NSString *subString = [stringFloat substringFromIndex:length - i];
        if(![subString isEqualToString:@"0"])
        {
            return stringFloat;
        }
        else
        {
            stringFloat = [stringFloat substringToIndex:length - i];
        }
        
    }
    return [stringFloat substringToIndex:length - 7];
}



+ (void)setLayerAndBezierPathCutCircularWithView:(UIView *) view
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = view.bounds;
    layer.path = path.CGPath;
    view.layer.mask = layer;
}

+ (void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font{
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:[ToolClass textDict:font]];
    label.attributedText = attributeStr;
}

//计算UILabel的高度(带有行间距的情况)
+ (CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, ScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:[ToolClass textDict:font] context:nil].size;
    return size.height;
}


+ (void)setTextViewSpace:(UITextView *)textView withFont:(UIFont *)font{
     textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:[ToolClass textDict:font]];
    textView.textColor = WDColorFrom16RGB(0x666666);
}


+ (NSDictionary *)textDict : (UIFont *)font{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.2f
                          };
    return dic;
}


+ (CGFloat) heightForString:(UITextView *)textView andWidth:(float)width{
    if (textView.text.length == 0) {
        return 0;
    }
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

/**
 清除webView缓存
 */
+(void)clearWebViewCache{
    
    //ios 9之后清除缓存API(清除所有的wkweb缓存)
    if (iOS9OrLater) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
         }];
    }else{
        //iOS9之前
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
//    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
//                                                               NSUserDomainMask, YES)[0];
//    NSString *bundleId  =  [[NSBundle mainBundle] bundleIdentifier];
//    NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
//    NSString *webKitFolderInCaches = [NSString
//                                      stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
//    
//    NSError *error;
//    /* iOS8.0 WebView Cache的存放路径 */
//    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
//    [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];

}


#pragma mark - 找到当前view所在的控制器
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}


@end
