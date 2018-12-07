
//
//  WDHTTPServer.h
//  5dou
//
//  Created by rdyx on 16/8/28.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//hheh
#define debug

#if debug 0
//Https 环境

//#define HTTP_IP  @"apitest.5dou.cn"
//#define HTTP_BASE [NSString stringWithFormat:@"https://%@",HTTP_IP]

//Http 环境

#define HTTP_IP  @"123.57.6.158"
#define HTTP_LOCAL @"8080"
#define HTTP_BASE [NSString stringWithFormat:@"http://%@:%@",HTTP_IP,HTTP_LOCAL]

#define H5Url @"h5test.5dou.cn"

//H5开发中本机的地址
#define H5LocalUrl @"192.168.1.28:8080"

#else

//*************************************预发布环境
#define H5Url @"h5pre.5dou.cn"//H5预发布
#define HTTP_IP @"apipre.5dou.cn"//预发布环境,用户看不到的正式环境

//*************************************下面为正式环境
//#define H5Url @"h5.5dou.cn"
//#define HTTP_IP @"api.5dou.cn"
//H5开发中本机的地址
#define H5LocalUrl @"192.168.1.28:8080"

#define HTTP_BASE [NSString stringWithFormat:@"https://%@",HTTP_IP]

#endif
