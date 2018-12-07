

//
//  WDRebateViewController.m
//  5dou
//
//  Created by rdyx on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  邀请返利
//

#import "WDRebateViewController.h"
#import "ToolClass.h"
#import "WDInviteView.h"
#import "WDRebateHeaderView.h"
#import "WDDefaultAccount.h"
#import "WDLoginViewController.h"
#import "WDRegisterViewController.h"
#import "WDIncomeViewController.h"
#import "WDNotLoginData.h"
#import "WDInviteRebateModel.h"
#import "UMCustomManager.h"
#import "WDUserInfoModel.h"
@interface WDRebateViewController ()

@property (nonatomic, strong) WDRebateHeaderView *rebateHeaderView;///< 头部
@property (nonatomic, strong) WDInviteView *inviteView;///< 邀请
@property (nonatomic, assign) CGFloat headerH;///< 头部高度
///邀请好友
@property (nonatomic, strong) UIView *inviteBgView;
@property (nonatomic, strong) UIImageView *inviteImg;
@property (nonatomic, strong) UILabel *inviteInfo;

@property (nonatomic, strong) WDNotLoginData  *notLoginView; ///< 未登录状态显示缺省页

@property (nonatomic, strong) WDInviteRebateDataModel *inviteModel;///< 数据源

@end

@implementation WDRebateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setItemWithTitle:@"邀请返利" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self initUI];
    [self.navigationItem setItemWithTitle:@"" textColor:kWhiteColor fontSize:19 itemType:center];
    self.navigationItem.leftBarButtonItem = nil;
    
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor = kMainColor;
//    //delete 黑丝
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = YES;
    if ([[WDDefaultAccount  getUserInfo] objectForKey:@"memberId"]) {
        [self requestData];//请求数据
        self.notLoginView.alpha = 0;
        self.inviteView.alpha = 1;
    }else{
        self.notLoginView.alpha = 1;
        self.inviteView.alpha = 0;
        [self.rebateHeaderView configValue:nil];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)initUI{
    self.headerH = 130;
    if (device_is_iphone_4||device_is_iphone_5) {
        self.headerH = 130;
    }else if (device_is_iphone_6){
        self.headerH = 160;
    }else if (device_is_iphone_6p){
        self.headerH = 180;
    }

    [self.view addSubview:self.rebateHeaderView];
    [self.rebateHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(0);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(self.headerH);
    }];
    [self.view addSubview:self.inviteBgView];
    [self.inviteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rebateHeaderView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(55);
    }];
    [self.inviteBgView addSubview:self.inviteImg];
    [self.inviteImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.inviteBgView);
        make.centerX.mas_equalTo(self.inviteBgView.centerX).offset(-60);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(52);
    }];
    [self.inviteBgView addSubview:self.inviteInfo];
    [self.inviteInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inviteImg.mas_right).offset(10);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.centerY.mas_equalTo(self.inviteImg);
    }];

    [self.view addSubview:self.inviteView];
    [self.inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.inviteBgView.mas_bottom);
    }];
    //没有登录的时候
    [self.view addSubview:self.notLoginView];
    [self.notLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rebateHeaderView.mas_bottom);
        make.right.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}


- (void)configValue:(WDInviteRebateDataModel *)model{
    [self.rebateHeaderView configValue:model];
    [self.inviteView configValue:model];
    self.inviteModel = model;
}

#pragma mark ======= 登录注册
- (void)loginAction:(UIButton *)sender{
//    WDLoginViewController *loginVC = [[WDLoginViewController alloc] init];
//    loginVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:loginVC animated:YES];
    WDLoginViewController *loginVC = [[WDLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)registerAction:(UIButton *)sender{
    WDRegisterViewController *registerVC = [[WDRegisterViewController alloc] init];
    registerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark ========== 数据请求
- (void)requestData{
    NSDictionary *dic = @{@"pageInfo.pageSize":@"15",
                          @"pageInfo.toPage":@"0"
                          };
    WeakStament(wself);
    [WDNetworkClient postRequestWithBaseUrl:kInviteRebateUrl setParameters:dic success:^(id responseObject) {
        WDInviteRebateModel *model = [[WDInviteRebateModel alloc] initWithDictionary:responseObject error:nil];
        if ([model.result.code isEqualToString:@"1000"]) {
            [wself configValue:model.data];
            wself.inviteModel = model.data;
        }else{
           NSDictionary *result =  responseObject[@"result"];
            [ToolClass showAlertWithMessage:result[@"msg"]];
        }
    } fail:^(NSError *error) {

    } delegater:nil];
}
#pragma mark ====== 懒加载

- (WDRebateHeaderView *)rebateHeaderView{
    if (!_rebateHeaderView) {
        _rebateHeaderView = [[WDRebateHeaderView alloc] init];
        WeakStament(wself);
        _rebateHeaderView.inviteNumBtnDidClickBlock = ^(UIButton *sender){
            if ([[WDDefaultAccount getUserInfo] objectForKey:@"memberId"]) {
                WDIncomeViewController *incomeVC = [[WDIncomeViewController alloc] init];
                incomeVC.inviteModel = wself.inviteModel;
                incomeVC.dataArray = wself.inviteModel.moneyRankList;/// 好友收益列表
                incomeVC.hidesBottomBarWhenPushed = YES;
                [wself.navigationController pushViewController:incomeVC animated:YES];
            }else{
                //未登录状态
                WDLoginViewController *loginVC = [[WDLoginViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
                [wself presentViewController:nav animated:YES completion:nil];
            }
            
        };
    }
    return _rebateHeaderView;
}

- (WDInviteView *)inviteView{
    if (!_inviteView) {
        _inviteView = [[WDInviteView alloc] init];
        WeakStament(wself);
        //分享
        UIImage *shareImg = [UIImage imageNamed:@"iicon"];
        _inviteView.inviteBtnDidClickBlock = ^(UIButton *sender){
            
           [WDUserInfoModel shareInstance].isRebateShareToTimeLine = YES;
            [WDUserInfoModel shareInstance].timeLineContent = wself.inviteModel.share_pyq_content;
//            [UMCustomManager shareWebWithViewController:wself
//                                             ShareTitle:app_Name
//                                                Content:wself.inviteModel.share_content
//                                             ThumbImage:shareImg
//                                                    Url:wself.inviteModel.share_url];
            
        };
    }
    return _inviteView;
}

- (UIView *)inviteBgView{
    if (!_inviteBgView) {
        _inviteBgView = [[UIView alloc] init];
        _inviteBgView.backgroundColor = WDColorFrom16RGB(0xffffff);
    }
    return _inviteBgView;
}

- (UIImageView *)inviteImg{
    if (!_inviteImg) {
        _inviteImg = [[UIImageView alloc] init];
        _inviteImg.image = [UIImage imageNamed:@"rebate_invite_img"];
    }
    return _inviteImg;
}

- (UILabel *)inviteInfo{
    if (!_inviteInfo) {
        _inviteInfo = [[UILabel alloc] init];
        _inviteInfo.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
        _inviteInfo.textColor = WDColorFrom16RGB(0x666666);
        _inviteInfo.textAlignment = NSTextAlignmentLeft;
        _inviteInfo.text = @"邀请好友扫码注册";
    }
    return _inviteInfo;
}

///没有数据的时候

- (WDNotLoginData *)notLoginView{
    if (!_notLoginView) {
        _notLoginView = [WDNotLoginData view];
        _notLoginView.backgroundColor = WDColorFrom16RGB(0xffffff);
        _notLoginView.alpha = 0;
        _notLoginView.infoLabel.numberOfLines = 0;
        _notLoginView.infoLabel.textAlignment = NSTextAlignmentCenter;
        [_notLoginView setImage:[UIImage imageNamed:@"invitation_friend"]
                       withInfo:@"邀请好友注册，\n最高可获得好友收益15%的额外奖励。"
                    withLeftBtn:@"注册"
                   withRightBtn:@"登录"];
        
        NSString *textString = @"邀请好友注册，\n最高可获得好友收益15%的额外奖励。";
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:textString];
        NSRange highlightRang = [textString rangeOfString:@"15%"];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:highlightRang];
        _notLoginView.infoLabel.attributedText = attributeString;
        
        _notLoginView.resgisterBtn.layer.cornerRadius = 15;
        _notLoginView.resgisterBtn.layer.masksToBounds = YES;
        _notLoginView.resgisterBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_notLoginView.resgisterBtn setTitleColor:WDColorFrom16RGB(0xfdbb00) forState:UIControlStateNormal];
        _notLoginView.resgisterBtn.layer.borderColor = WDColorFrom16RGB(0xfdbb00).CGColor;
        _notLoginView.resgisterBtn.layer.borderWidth = 1.f;
        [_notLoginView.resgisterBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _notLoginView.loginBtn.layer.cornerRadius = 15;
        _notLoginView.loginBtn.layer.masksToBounds = YES;
        _notLoginView.loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_notLoginView.loginBtn setTitleColor:WDColorFrom16RGB(0x86572a) forState:UIControlStateNormal];
        _notLoginView.loginBtn.layer.borderColor = WDColorFrom16RGB(0x86572a).CGColor;
        _notLoginView.loginBtn.layer.borderWidth = 1.f;
        [_notLoginView.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _notLoginView;
}



@end
