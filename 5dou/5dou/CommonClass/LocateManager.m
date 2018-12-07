

//
//  LocateManager.m
//  oc
//
//  Created by macfai on 16/4/8.
//  Copyright © 2016年 macfaith. All rights reserved.
//

#import "LocateManager.h"
#import <CoreLocation/CoreLocation.h>
#import "ToolClass.h"

@interface LocateManager()<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)NSTimer *timer;

@end
@implementation LocateManager



+(instancetype)shareInstance{
    
    static LocateManager *_locateManager = nil;
    static dispatch_once_t t;
    dispatch_once(&t,^{
        _locateManager = [[LocateManager alloc]init];
    });
    return _locateManager;
}


-(void)locateWithSuccessBlock:(LocateSuccessBlock)successBlock failBlock:(LocateFailBlock)failBlock{
    self.successblock = successBlock;
    self.failBlock = failBlock;
    [self startLocation];
}

-(void)startLocation{
    
    //开始定位后设置定时器为了让15秒后终止定位
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(stopLocation) userInfo:nil repeats:NO];
    
//    [PPHudView show];
    if ([CLLocationManager locationServicesEnabled]){
        
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 10.0f;
        self.locationManager.pausesLocationUpdatesAutomatically = false;
        
        //iOS7的判断
        
        if ([ToolClass currentSystemVersion]>=8.0) {
                        [self.locationManager requestAlwaysAuthorization];
//            [self.locationManager requestWhenInUseAuthorization];
        }
        //这个打开被拒可能很大一般应用都用不到
        if ([ToolClass currentSystemVersion]>=9.0) {
            [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        }
        if(![CLLocationManager locationServicesEnabled]){
            NSLog(@"请开启定位:设置 > 隐私 > 位置 > 定位服务");
        }
        
        
        
        [self.locationManager startUpdatingLocation];
        
    }else{
        
        
        [AFToast showText:@"定位失败,请检查定位服务是否开启"];
//        [PPHudView dismiss];
        
    }
}

-(void)stopLocation{
    
    [self.timer invalidate];
//    [PPHudView dismiss];
}
#pragma mark - location delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    //获取当前所在城市
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //根据经纬度反向编制出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error){
        
        if (error||placemarks.count==0) {
            YYLog(@"%@",error);
            return ;
        }
        if (placemarks.count>0) {
            
            CLPlacemark *placeMark = [placemarks firstObject];
            
            //获取省
//            NSString *province = placeMark.administrativeArea;
            //获取城市
            NSString *city = placeMark.locality;
            
//            if ([city containsString:@"市"]) {
//                [city substringToIndex:city.length-2];
//            }
            
            _successblock(city);
            
            YYLog(@"%@",city);
            
        }else if (error == nil && [placemarks count] == 0)
            
        {
            
            //(@"No results were returned.");
            _failBlock(error);
            
        }
        
        else if (error != nil)
            
        {
            
            _failBlock(error);
            YYLog(@"%@",error);
            
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    
    [manager stopUpdatingLocation];
}

/**
 *  定位失败的代理
 *
 *  @param manager
 *  @param error
 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    YYLog(@"定位失败:%@",error);
    
}


@end
