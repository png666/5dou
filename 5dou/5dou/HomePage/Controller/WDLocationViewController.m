

//
//  WDLocationViewController.m
//  5dou
//
//  Created by rdyx on 16/9/1.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDLocationViewController.h"
#import "WDOtherLocationController.h"
#import "WDLocView.h"
#import "LocateManager.h"
#import "WDDefaultAccount.h"
#import "ToolClass.h"
#import <CoreLocation/CoreLocation.h>
#import "JPUSHService.h"

@interface WDLocationViewController ()
@property (nonatomic,strong) NSMutableArray *hotCityArray;
@property (nonatomic,strong) UIView *hotCityView;
@property (nonatomic,strong) WDLocView *locationView;
@property (nonatomic,copy) NSString *locationCityName;
@end

@implementation WDLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
    [self loadData];
    //[self prepareData];
}

- (void)loadData{
     WeakStament(weakSelf);
    //进行数据定位
    [[LocateManager shareInstance] locateWithSuccessBlock:^(NSString *cityName) {
        [weakSelf.locationView.nowLocationBtn setTitle:[NSString stringWithFormat:@"定位到当前城市:%@",cityName] forState:UIControlStateNormal];
        weakSelf.locationCityName = cityName;
    } failBlock:^(NSError *error) {
        [weakSelf.locationView.nowLocationBtn setTitle:@"定位失败" forState:UIControlStateNormal];
        weakSelf.locationCityName = @"";
    }];
    
    [self.locationView.nowLocationBtn addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //获取热门城市
    _hotCityArray = [NSMutableArray array];
    NSDictionary *param = @{@"queryType":@1};
   
    [WDNetworkClient postRequestWithBaseUrl:kGetCityInfo setParameters:param success:^(id responseObject) {
        YYLog(@"---%@---",responseObject);
        weakSelf.hotCityArray = responseObject[@"data"][@"hotCity"];
        weakSelf.locationView.height = 185 + ceil(weakSelf.hotCityArray.count / 4.0) * 42.5;
        [weakSelf setupHotCity];
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

#pragma mark 定位城市

- (void)locationButtonClick:(UIButton *)button{
    
    if ([self.locationCityName isEqualToString:@""]  || !self.locationCityName) {
        self.locationCityName = @"上海";
    }
    [self locationCity:_locationCityName];
    
}


- (void)locationCity:(NSString *)cityName{
    NSDictionary *param = @{@"cityName":cityName};
    [WDNetworkClient postRequestWithBaseUrl:kGetCityCodeWithNameUrl setParameters:param success:^(id responseObject) {
        YYLog(@"---%@---",responseObject);
        WeakStament(weakSelf);
        //如果正确的情况下
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            NSString *cityCode = responseObject[@"data"][@"cityCode"];
            NSString *provinceId = nil;
            if ([responseObject[@"data"][@"cityCode"] isKindOfClass:[NSString class]]) {
                provinceId = responseObject[@"data"][@"provinceId"];
            }else{
                provinceId = @"";
            }
            [WDDefaultAccount setCityName:cityName];
            [WDDefaultAccount setCityId:cityCode];
            [WDDefaultAccount setProvinceId:provinceId];
            //设置标签推送的Tag  城市名、城市编码
            NSSet *setTags = [NSSet setWithObjects:cityName,cityCode,provinceId, nil];
            [self setJpushTags:setTags];
            
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [ToolClass showAlertWithMessage:@"定位失败"];
        }
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

- (void)setupHotCity{
    CGFloat buttonHeight = 40;
    CGFloat buttonWidth = (ScreenWidth - 4 * 2.5 - 30) / 4;
    for(int index = 0 ; index < _hotCityArray.count ; index++ ){
        int line = index / 4;
        int row = index % 4;
        NSDictionary *cityDict = _hotCityArray[index];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        button.backgroundColor = kWhiteColor;
        [button setTitle:cityDict[@"cityName"] forState:UIControlStateNormal];
        button.frame = CGRectMake((3.5 + buttonWidth) * row, 42.5 * line, buttonWidth,buttonHeight);
        [button setTitleColor:kGrayColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = 10000 + index;
        [button addTarget:self action:@selector(hotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.locationView.hotCityView addSubview:button];
    }
}


- (void)hotButtonClick:(UIButton *)button{
    NSInteger index = button.tag - 10000;
    NSDictionary *selectDict = _hotCityArray[index];
    [WDDefaultAccount setCityName:selectDict[@"cityName"]];
    [WDDefaultAccount setCityId:selectDict[@"cityCode"]];
    NSString *provinceId = nil;
    if ([selectDict[@"provinceId"] isKindOfClass:[NSString class]]) {
        provinceId = selectDict[@"provinceId"];
    }else{
        provinceId = @"";
    }
    //设置推送的标签
    NSSet *setTags = [NSSet setWithObjects:selectDict[@"cityName"],selectDict[@"cityCode"],provinceId, nil];
    [self setJpushTags:setTags];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)prepareUI{
    [self.navigationItem setItemWithTitle:@"选择城市" textColor:[UIColor whiteColor] fontSize:19 itemType:center];

    _locationView = [WDLocView view];
    _locationView.frame = CGRectMake(0, 0, ScreenWidth, 240);
    [self.view addSubview:_locationView];
    
    [_locationView.otherLocatonBtn addTarget:self action:@selector(goOtherCity:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goOtherCity:(UIButton *)button{
    WDOtherLocationController *otherLocationController = [WDOtherLocationController new];
    [self.navigationController pushViewController:otherLocationController animated:YES];
}

#pragma mark ======== 设置极光推送别名
- (void)setJpushTags:(NSSet *)tags{
    //解决极光没有初始化完成的时候 设置不成功的情况
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JPUSHService setTags:tags alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            if (iResCode == 0) {
                YYLog(@"设置标签成功");
            }else{
                YYLog(@"设置标签失败:%d",iResCode);
            }
            
        }];
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
