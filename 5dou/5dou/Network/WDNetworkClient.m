//
//  WDNetworkClient.m
//  5dou
//
//  Created by rdyx on 16/8/28.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDNetworkClient.h"
#import "WDHTTPServer.h"
#import "WD_API.h"
#import "ToolClass.h"
#import "WDUserInfoModel.h"
#import "WDThirdUserInfoModel.h"
#import "SVProgressHUD.h"
#import "IPhoneTypeModel.h"
#import "NSString+MD5.h"
#import "PTSProgressHUD.h"
//#import "NSString+ThreeDES.h"
static  NSString *GETMethod = @"get";
static NSString *netFailTips = @"亲,您的网络开小差了";

//渠道号杨哲个人帐号（当前使用的渠道号）
static NSString *CHANNEL = @"IOS_YANG";
static NSString *CHANNELPWD = @"991654FE2CB8DE4F7CBF1B8EF99F4459";

//第一个渠道号下架的那个渠道号
//static NSString *CHANNEL = @"WUDOU_IOS";
//static NSString *CHANNELPWD = @"E4D7D52C1DE0F2CD323838AE4875BB9B";



static  AFHTTPSessionManager *manager;

@interface WDNetworkClient()
{
    NSURLSessionDownloadTask *_downloadTask;
}

//@property(nonatomic,copy)NSString *channel;


@end

@implementation WDNetworkClient


/**
 *  对AFHTTPSessionManager启用单例模式
 *
 *  @return 单例
 */
+ (AFHTTPSessionManager*)sharedManager{
    
    static WDNetworkClient* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
        manager = [AFHTTPSessionManager manager];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30;
        //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/javascript",@"application/json",@"text/html", nil];
        //申明请求的数据是json类型
//        manager.requestSerializer=[AFJSONRequestSerializer serializer];
               });
    return manager;
}

///post请求
+(void)postRequestWithBaseUrl:(NSString *)url setParameters:(NSDictionary *)paraDic success:(void (^)(id))success fail:(void (^)(NSError *))fail delegater:(UIView *)view
{
    NSError *error;
    if (!url) {
        fail(error);
        return;
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",HTTP_BASE,url];
    //添加公共参数
    NSMutableDictionary *dic;
    
    NSString *userId = [WDUserInfoModel shareInstance].memberId;
    //解决三方等登录问题
    if (userId == nil) {
        userId = [WDThirdUserInfoModel shareInstance].memberId;
        if (userId == nil) {
            userId = @"";
        }
    }
    //ai.cc 渠道-杨哲个人帐号
    
    [WDUserInfoModel shareInstance].channel = CHANNEL;
    if (paraDic) {
        dic = [[NSMutableDictionary alloc]initWithDictionary:paraDic];
        dic[@"ai.cc"] = CHANNEL;
        dic[@"bi.ct"] = [ToolClass getIDFA];
        dic[@"bi.dv"] = @"IOS";
        dic[@"bi.ov"] = [NSString stringWithFormat:@"%.2f",[ToolClass currentSystemVersion]];
        dic[@"bi.dm"] = [IPhoneTypeModel iphoneType],
        dic[@"bi.av"] = [ToolClass getAPPVersion];
        //登录状态下传
        if (userId) {
            dic[@"bi.mi"] = userId;
        }
    }
    else
    {
        if (userId) {
    
            NSDictionary *commanDic = @{@"ai.cc":CHANNEL,
                                        @"bi.ct":[ToolClass getIDFA],@"bi.dv":@"IOS",@"bi.ov":@([ToolClass currentSystemVersion]),@"bi.dm":[IPhoneTypeModel iphoneType],@"bi.av":[ToolClass getAPPVersion],@"bi.mi":userId};
            dic = [[NSMutableDictionary alloc]initWithDictionary:commanDic];
            
        }else
        {
            
            NSDictionary *commanDic = @{@"ai.cc":CHANNEL,
                                        @"bi.ct":[ToolClass getIDFA],@"bi.dv":@"IOS",@"bi.ov":@([ToolClass currentSystemVersion]),@"bi.dm":[IPhoneTypeModel iphoneType],@"bi.av":[ToolClass getAPPVersion]};
             dic = [[NSMutableDictionary alloc]initWithDictionary:commanDic];
            
        }
       
    }
    
    [self postRequestWithUrl:requestUrl setParameters:dic success:^(id responseObject) {
        
        if (success) {
             success(responseObject);
        }
       
    } fail:^(NSError *error) {
        
        fail(error);
        YYLog(@"%@",error);
        
    } delegater:view];

}

+(void)postRequestWithUrl:(NSString *)url setParameters:(NSDictionary *)paraDic success:(void (^)(id))success fail:(void (^)(NSError *))fail delegater:(UIView *)view
{
    
    if (view) {
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];//设置HUD的Style
//        [SVProgressHUD setForegroundColor:kWhiteColor];//设置HUD和文本的颜色
//        [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:254/255.0 green:210/255.0 blue:48/255.0 alpha:0.5]];
//        [SVProgressHUD show];
        [PTSProgressHUD showWithGifImagePath:@"doubiHUD.gif" withTitle:@"" toView:view];
        UIImageView *imageView = [PTSProgressHUD shareView].gifImageView;
        
        imageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        imageView.layer.cornerRadius = 8.0;
        imageView.clipsToBounds = YES;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(90, 90));
        }];

        [PTSProgressHUD setTitleMargin:15];
        [PTSProgressHUD setBgColor:[UIColor clearColor]];
        [PTSProgressHUD show];
    }
    
    //渠道密码
    NSString *channelPwd = CHANNELPWD;
    NSString *timestamp = [ToolClass getTimestamp];
    //对参数进行首字母排序
    NSArray *keys = [paraDic allKeys];
    NSMutableArray *valueArray = [NSMutableArray array];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *categoryId in sortedArray) {
        YYLog(@"[dict objectForKey:categoryId] === %@",[paraDic objectForKey:categoryId]);
        [valueArray addObject:[paraDic objectForKey:categoryId]];
    }
    NSString *encrypedString = [[valueArray componentsJoinedByString:@""] MD5];
    NSString *sign = [[NSString stringWithFormat:@"%@%@",CHANNEL,encrypedString] MD5];
    //单例初始化一次，防止内存问题
    AFHTTPSessionManager *manager = [self sharedManager];
    //请求头中设置四个参数

    //渠道密码，时间戳，sid(注册或登录成功后后台返回给前端)，sign生成的签名串,https下，请求头里有 . 的话不能识别，所以ai.cp换成aicp
    NSArray *headerkeys = @[@"aicp",@"timestamp",@"sid",@"sign"];
    NSArray *values = @[channelPwd,timestamp,[WDUserInfoModel shareInstance].sid?[WDUserInfoModel shareInstance].sid:@"",sign];
    for (int i = 0; i<4; i++) {
        [manager.requestSerializer setValue:values[i] forHTTPHeaderField:headerkeys[i]];
    }

    //注释掉173-176后认证方式为单向认证
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"5dou.cn" ofType:@".cer"];
//    NSData *dataCer = [NSData dataWithContentsOfFile:cerPath];
//    NSSet *set = [NSSet setWithObjects:dataCer, nil];
//    securityPolicy.pinnedCertificates = set;
    
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    [manager POST:url parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
                [PTSProgressHUD hide];

            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
        if (view) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
                 [PTSProgressHUD hide];
            });
        }
    }];
}

//图片上传没有用这个方法，直接用了post方法
+(void)uploadImage:(UIImage *)image url:(NSString *)urlString{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",HTTP_BASE,urlString];
    
    AFHTTPSessionManager *manager = [self sharedManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //上传图片/文字，POST
    
    NSString *userId = [WDUserInfoModel shareInstance].memberId;
    
    NSDictionary *commanDic = @{@"ai.cc":CHANNEL,@"ai.cp":@"6C07A7D7C49F0E3FE692B5FF66715086",@"bi.ct":[ToolClass getIDFA],@"bi.dv":@"IOS",@"bi.mi":userId?userId:@""};
    NSDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:commanDic];
    
    
    [manager POST:requestUrl parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
        //对于图片进行压缩
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
        [formData appendPartWithFileData:data name:@"1" fileName:@"image.jpg" mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        YYLog(@"uploadProgress = %@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        YYLog(@"%@",obj);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YYLog(@"error = %@",error);
    }];
}
//下载功能
- (void)downFileFromServerFromURl:(NSString *)urlString{
    //远程地址
    //@"http://www.baidu.com/img/bdlogo.png"
    NSURL *URL = [NSURL URLWithString:urlString];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        
        // 给Progress添加监听 KVO
        YYLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
            
//            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        
//        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
//        UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
//        self.imageView.image = img;
        
    }];
}

///get请求
+(void)getRequestWithBaseUrl:(NSString *)url setParameters:(NSDictionary *)paraDic success:(void (^)(id))success fail:(void (^)(NSError *))fail delegater:(UIView *)view
{
    NSError *error;
    if (!url) {
        fail(error);
        return;
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",HTTP_BASE,url];
    
    [self getRequestWithUrl:requestUrl setParameters:paraDic success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } fail:^(NSError *error) {
        fail(error);
    } delegater:view];
    
}
+(void)getRequestWithUrl:(NSString *)url setParameters:(NSDictionary *)paraDic success:(void (^)(id))success fail:(void (^)(NSError *))fail delegater:(UIView *)view
{
    
    if (view) {
        //        [MBProgressHUD showHUDAddedTo:view animated:YES];
        [SVProgressHUD show];
    }
    AFHTTPSessionManager *manager = [self sharedManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/javascript",@"application/json",@"text/html", nil];
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    [manager GET:url parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //因为是异步所以会延迟一下才显示出来
        if (success) {
            success(responseObject);
            //            [MBProgressHUD hideHUDForView:view animated:YES];
            [SVProgressHUD dismiss];
        }
        
        YYLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YYLog(@"fail");
        fail(error);
        if (view) {
            
            //    [MBProgressHUD hideHUDForView:view animated:YES];
            [SVProgressHUD dismiss];
        }
    }];
    
}


#pragma mark - 下载备用方法
///
- (void)downLoad{
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.确定请求的URL地址
    NSURL *url = [NSURL URLWithString:@""];
    
    //3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //打印下下载进度
        YYLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载地址
        YYLog(@"默认下载地址:%@",targetPath);
        
        //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        return [NSURL URLWithString:filePath];
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        //下载完成调用的方法
        YYLog(@"下载完成：");
        YYLog(@"%@--%@",response,filePath);
        
    }];
    
    //开始启动任务
    [task resume];
    
}

///微信登录第一步获取code
+(void)wechatAuth:(NSString *)code{
    
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WX_APPID, WX_APPSECRET, code];
    WeakStament(ws);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:accessUrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        YYLog(@"%@",responseObject);
        NSDictionary *dic = (NSDictionary *)responseObject;
        [WDUserInfoModel shareInstance].openid = dic[@"openid"];
        [WDUserInfoModel shareInstance].access_token = dic[@"access_token"];
        //通过令牌token去获取用户信息
        [ws wechatGetUserInfoAfterAuth];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

///微信登录第二步：根据access_token和openid获取用户信息
+(void)wechatGetUserInfoAfterAuth{
    
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, [WDUserInfoModel shareInstance].access_token, [WDUserInfoModel shareInstance].openid];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:accessUrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        [WDUserInfoModel shareInstance].nickName = dic[@"nickname"];
        [WDUserInfoModel shareInstance].headImg = dic[@"headimgurl"];
        //和微信服务器交互后拿到用户信息，然后通知和自己的服务器交互，将用户信息存储
        [[NSNotificationCenter defaultCenter]postNotificationName:kSaveWechatUserInfo object:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];

}


@end
