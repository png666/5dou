
//
//  WDMemberCenterViewController.m
//  5dou
//
//  Created by rdyx on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDMemberCenterViewController.h"
#import "WDSubMemeberCenterCell.h"
#import "ToolClass.h"
#import "WDModifyNickNameViewController.h"
#import "ZHPickView.h"
#import "WDSelectSchoolViewController.h"
#import "WDInterestViewController.h"
#import "WDModifyAliPayViewController.h"
#import "WDChangePwdViewController.h"
#import "WDUserInfoModel.h"
#import "ZFActionSheet.h"
#import "ZFImagePicker.h"
#import "DEFINE.h"
#import "WDDefaultAccount.h"
#import "WDBindingAlipayViewController.h"
#import "DQAlertView.h"
#import "WDUserInfoModel.h"
#import "WDSetNewPwdViewController.h"
#import "JPUSHService.h"
#import "CKAlertViewController.h"

@interface WDMemberCenterViewController ()<UITableViewDelegate,UITableViewDataSource,ZFActionSheetDelegate, ZFImagePickerDelegate,DQAlertViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *secondTitleArry;
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSArray *secondIamgeArray;
@property(nonatomic,strong)UIView *tableHeaderView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *genderLabel;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,copy)NSString *genderString;
@property(nonatomic,copy)NSString *birthdayString;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *schoolName;
@property (nonatomic,copy) NSString *interestStr;
@property (nonatomic, copy) NSString *isBindAlipay;///< 判断用户是否绑定支付宝
@property (nonatomic, copy) NSString *judgeIsAuthMsg;///< 判断用户是否绑定支付宝
@property(nonatomic,assign)NSInteger taskCardNum;//任务卡
@property(nonatomic,assign)NSInteger mytaskNum;//我的任务
@property(nonatomic,strong)NSArray *interestTagArray;
@property(nonatomic,strong)NSDictionary *memeberDetailInfo;
@property(nonatomic,strong)NSDictionary *memeberAcount;


@end
static NSString *subMemeberID = @"subMemeber";
static CGFloat tableHeadHeight = 130.f;
#define kDateCount 10
@implementation WDMemberCenterViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorStyle = 0;
        [_tableView registerClass:[WDSubMemeberCenterCell class] forCellReuseIdentifier:subMemeberID];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    _titleArray = @[@"昵称",@"性别",@"生日",@"所在学校",@"兴趣爱好"];

    _secondTitleArry = @[@"修改登录密码",@"修改支付宝账号"];
    
    _imageArray = @[@"personal_icon_name",@"personal_icon_sex",@"personal_icon_birthday",@"personal_icon_school",@"personal_icon_interest"];
    _secondIamgeArray = @[@"personal_icon_password",@"personal_icon_pay"];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    
//    [self configTableHeaderView];
    [self configTableFooterView];
    // Do any additional setup after loading the view.
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[WDUserInfoModel shareInstance].headImg] placeholderImage:WDImgName(@"head")];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    if (ScreenWidth<375) {
//        self.tableView.contentOffset = CGPointMake(0, 22);
//    }
    #pragma mark - 获取用户信息
    [self loadMemmberInfo];

#pragma mark - 页面共用
    if (self.isBindMobile == true) {
        
        [self.navigationItem setItemWithTitle:@"完善信息" textColor:kNavigationTitleColor fontSize:19 itemType:center];
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
        
    }
    else
        
    {
        [self.navigationItem setItemWithTitle:@"个人信息" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    }
    if ([WDUserInfoModel shareInstance].memberId) {
        self.genderString =[WDUserInfoModel shareInstance].gender;
    }
    
    //判断用户是否绑定支付宝账号
    [self judgeIsAuthentication];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)configTableHeaderView

{
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, tableHeadHeight)];
    tableHeaderView.backgroundColor = kNavigationBarColor;
    UIImageView *headImage = [UIImageView new];
    headImage.image = WDImgName(@"head");
    headImage.userInteractionEnabled = YES;
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView = headImage;
    [tableHeaderView addSubview:headImage];
    //先添加视图才能布局，否则他找不到直接崩溃
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tableHeaderView);
        make.centerY.equalTo(tableHeaderView);
        make.height.and.width.equalTo(@50);
    }];
    
    [ToolClass setView:headImage withRadius:25.f andBorderWidth:0.2f andBorderColor:kClearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeader:)];
    [headImage addGestureRecognizer:tap];
    
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = kFont12;
    nameLabel.textColor = kWhiteColor;
    nameLabel.text = @"修改头像";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.nameLabel = nameLabel;
    [tableHeaderView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tableHeaderView);
        make.top.equalTo(headImage.mas_bottom).offset(3);
        make.width.equalTo(@100);
        make.height.equalTo(@18);
        
    }];
    
    self.tableView.tableHeaderView = tableHeaderView;
}

-(void)configTableFooterView
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = kNavigationBarColor;
    
    if (self.isBindMobile == true) {
        
        [btn setTitle:@"开启赚钱之旅" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    }
    
    
    [btn addTarget:self action:@selector(loginOutBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = kFont16;
    [btn setTitleColor:KCoffeeColor forState:UIControlStateNormal];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70.f)];
    //    bgView.backgroundColor = kLightGrayColor;
    [bgView addSubview:btn];
    self.tableView.tableFooterView = bgView;
    [ToolClass setView:btn withRadius:7.0f andBorderWidth:.5f andBorderColor:kNavigationBarColor];
    btn.frame = CGRectMake(30, 30, ScreenWidth-60, 36);
}

#pragma mark - memeberInfoData
//获取会员基本信息
-(void)loadMemmberInfo
{
    NSDictionary *para = @{@"bi.mi":[WDUserInfoModel shareInstance].memberId};
    
    [WDNetworkClient postRequestWithBaseUrl:kGetUserInfoUrl setParameters:para success:^(id responseObject) {
        
        YYLog(@"%@",responseObject);
        if (responseObject) {
            NSDictionary *result = responseObject[@"result"];
            if ([result[@"code"]isEqualToString:@"1000"]) {
                
                NSDictionary  *dataDic = responseObject[@"data"];
                //会员基本信息
                NSDictionary *memeberInfoDic = dataDic[@"memberInfo"];
                
                //头像url
//                NSString *urlString = memeberInfoDic[@"headImg"];
                
//                [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:WDImgName(@"head")];
                
                //昵称
                self.nickName =  memeberInfoDic[@"nickName"];
                self.genderString = memeberInfoDic[@"gender"];
                
            //获取邀请码
                [WDUserInfoModel shareInstance].inviteCode = memeberInfoDic[@"inviteCode"];
                
                YYLog(@"%@",memeberInfoDic);
                //任务卡相关
                self.taskCardNum = [dataDic[@"taskCardNum"] integerValue];
                self.mytaskNum = [dataDic[@"mytaskNum"] integerValue];
                
                //会员详细信息
                self.interestTagArray = dataDic[@"myTagLibs"];
               self.interestStr =  [self.interestTagArray componentsJoinedByString:@","];
                
                [WDUserInfoModel shareInstance].interestTags = self.interestStr;
                
                NSDictionary *memeberDetailDic = dataDic[@"memberDetail"];
                
                //生日
                self.birthdayString = memeberDetailDic[@"birthday"];
                [WDUserInfoModel shareInstance].birthday = self.birthdayString;
//                //大学
//                
                self.schoolName = memeberDetailDic[@"school"];
                YYLog(@"%@",self.schoolName);
                //支付宝和钱包相关
                self.memeberAcount = dataDic[@"memberAccount"];
            }
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
        YYLog(@"%@",error);
        
    } delegater:self.view];
}

-(void)tapHeader:(UITapGestureRecognizer *)tap
{
    ZFActionSheet *sheet = [ZFActionSheet actionSheetWithTitle:nil confirms:@[@"拍照",@"相册"] cancel:@"取消" style:ZFActionSheetStyleDefault];
    sheet.delegate = self;
    [sheet show];
}

#pragma mark - ZFActionSheetDelegate
- (void)clickAction:(ZFActionSheet *)actionSheet atIndex:(NSUInteger)index
{
    
    ZFImagePicker *picker = [[ZFImagePicker alloc] init];
    picker.pickerDelegate = self;
    picker.isEdit = YES;//解决拍照图片逆时针旋转90
    if (index==0) {
        
        if (TARGET_IPHONE_SIMULATOR) {
            [ToolClass showAlertWithMessage:@"请使用真机"];
            return;
        }
        picker.sType = SourceTypeCamera;
    }else if(index==1){
        //图片库
        picker.sType = SourceTypeLibrary;
        
    }else{
        picker.sType = SourceTypeAlbum;
    }
    
    // 实现block回调
    WeakStament(wself);
    picker.pickImage = ^(UIImage *image,NSString *type,NSString *name){
        
        YYLog(@"\nimage:%@\n type:%@",image,type);
        
        [[SDImageCache sharedImageCache]clearMemory];
        [[SDImageCache sharedImageCache]clearDisk];
        
        NSData  *imageData = UIImageJPEGRepresentation(image, 0.1);
        NSString  *base64ImageString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSDictionary *para = @{@"headImg":base64ImageString};
        [WDNetworkClient postRequestWithBaseUrl:kUploadHeadImageUrl setParameters:para success:^(id responseObject) {
            
            YYLog(@"%@",responseObject);
            if ([(responseObject[@"result"][@"code"]) isEqualToString:@"1000"]) {
                
                NSString *headImageUrl = responseObject[@"data"][@"headImg"];
                
//                [[WDUserInfoModel shareInstance] clearHeadImage];
                [WDUserInfoModel shareInstance].headImg = headImageUrl;
                wself.headImageView.image = image;
                [ToolClass showAlertWithMessage:@"头像修改成功"];
            }
            
        } fail:^(NSError *error) {
            
            YYLog(@"%@",error);
            
        } delegater:nil];
    };
    // 4、弹出界面
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - ZFImagePickerDelegate
- (void)imagePickerDidFinishWithImage:(UIImage *)image andType:(NSString *)type
{
    NSLog(@"--> %@ %@", image, type);
}

#pragma mark - delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}
#pragma mark - datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        return 5;
    }
    else
    {
        if (self.isBindMobile == true) {
            
            return 0;
            
        }else
        {
            
        
        return 2;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDSubMemeberCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:subMemeberID forIndexPath:indexPath];
    if (indexPath.section==0) {
    cell.nameLabel.text = _titleArray[indexPath.row];
    cell.iconImage.image = WDImgName(_imageArray[indexPath.row]);
        switch (indexPath.row) {
            case 0:
            {
                cell.messageLabel.hidden =false;
                cell.messageLabel.text = self.nickName;
            }
                break;
            case 1:
            {
                NSString *gender = [WDUserInfoModel shareInstance].gender;
                cell.messageLabel.hidden =false;
                if ([gender isEqualToString:@"O"]) {
                cell.messageLabel.text = @"保密";
                }else if ([gender isEqualToString:@"M"]){
                    cell.messageLabel.text = @"男";
                }else if([gender isEqualToString:@"F"]){
                    cell.messageLabel.text = @"女";
                }
            }
                break;
            case 2:
            {
                //生日
                cell.messageLabel.hidden =false;
                cell.messageLabel.text = self.birthdayString;
            }
                break;
            case 3:
            {
                //学校
                cell.messageLabel.hidden =false;
                cell.messageLabel.text = self.schoolName;
                
            }
                break;
                
            case 4:
            {
                cell.messageLabel.hidden =false;
                cell.messageLabel.text = self.interestStr;
            }
                break;
            default:
                break;
        }
        
    }else
        
    {
        cell.nameLabel.text = _secondTitleArry[indexPath.row];
        cell.iconImage.image = WDImgName(_secondIamgeArray[indexPath.row]);
    }
    return cell;
    
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     WeakStament(wself);
    if (indexPath.section==0) {
        
        switch (indexPath.row) {
            case 0:
            {
                WDModifyNickNameViewController *nickNameCV = [[WDModifyNickNameViewController alloc]init];
                nickNameCV.hidesBottomBarWhenPushed = YES;
                nickNameCV.nickName = self.nickName;
                nickNameCV.nickNameBlock = ^(NSString *nickNameString){
                    
                };
                [self.navigationController pushViewController:nickNameCV animated:YES];
            }
                break;
            case 1:
            {
                ZHPickView *pickView = [[ZHPickView alloc] init];
                [pickView setDataViewWithItem:@[@"男",@"女",@"保密"] title:nil];
                [pickView showPickView:self];
               
                pickView.block = ^(NSString *selectedStr)
                {
                    if ([selectedStr isEqualToString:@"男"]) {
                        wself.genderString = @"M";
                    }else if ([selectedStr isEqualToString:@"女"]){
                        wself.genderString = @"F";
                    }else{
                        wself.genderString = @"O";
                    }
                    [WDUserInfoModel shareInstance].gender = wself.genderString;
                    [self.tableView reloadData];
                    [self updateGenderInfo];
                    
                    YYLog(@"%@",selectedStr);
                };
                
                
            }
                break;
            case 2:
            {
                ZHPickView *pickView = [[ZHPickView alloc] init];
                [pickView setDateViewWithTitle:nil];
                [pickView showPickView:self];
                pickView.block = ^(NSString *selectedStr)
                {
                   NSString *todayStr = [[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:kDateCount];
                    
                    if ([todayStr compare:selectedStr]==NSOrderedAscending) {
                        
                        [ToolClass showAlertWithMessage:@"生日不能大于今天"];
                        return ;
                    }
                    
                    wself.birthdayString = selectedStr;
                    [self.tableView reloadData];
                    
                     [wself updateBirthday];
                    
                    YYLog(@"%@",selectedStr);
                };
                
            }
                break;
            case 3:
            {
                WDSelectSchoolViewController *school = [[WDSelectSchoolViewController alloc]init];
                school.schoolChangeBlock = ^(NSString *schoolName){
                    
                };
                school.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:school animated:YES];
            }
                break;
            case 4:
            {
                WDInterestViewController *interest = [[WDInterestViewController alloc]init];
                interest.hidesBottomBarWhenPushed = YES;
                interest.selectedStr = self.interestStr;
                interest.interestBlock = ^(NSString *str){
                    
                };
                [self.navigationController pushViewController:interest animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }
    
    else if(indexPath.section==1)
    {
        
        switch (indexPath.row) {
            case 0:
            {
                WDChangePwdViewController *password = [[WDChangePwdViewController alloc]init];
                password.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:password animated:YES];
//                WDSetNewPwdViewController *set = [[WDSetNewPwdViewController alloc] init];
//                [self.navigationController pushViewController:set animated:YES];
                
            }
                break;
            case 1:
            {
                if ([self.isBindAlipay isEqualToString:@"1000"]) {
                    //绑定支付宝账号
                    WDBindingAlipayViewController *bindingAlipayVC = [[WDBindingAlipayViewController alloc] init];
                    bindingAlipayVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:bindingAlipayVC animated:YES];
                }else if ([self.isBindAlipay isEqualToString:@"1017"]){
                    //测试绑定页面 --- huangxin 测试代码（错误）
//                    WDBindingAlipayViewController *bindingAlipayVC = [[WDBindingAlipayViewController alloc] init];
//                    bindingAlipayVC.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:bindingAlipayVC animated:YES];
                    //修改支付宝账号
                    WDModifyAliPayViewController *ali = [[WDModifyAliPayViewController alloc]init];
                    ali.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:ali animated:YES];
                }else{
                    [ToolClass showAlertWithMessage:self.judgeIsAuthMsg];
                }
            }
                break;
                
            default:
                break;
        }
        
    }
}


-(void)updateBirthday
{
    //生日
    if (self.birthdayString) {
        
    NSDictionary *para = @{@"birthday":self.birthdayString,@"updateType":@4};
    [WDNetworkClient postRequestWithBaseUrl:kUpdateMemeberInfo setParameters:para success:^(id responseObject) {
        YYLog(@"%@",responseObject);
        NSDictionary *result = responseObject[@"result"];
        if ([result[@"code"] isEqualToString:@"1000"]) {
            [ToolClass showAlertWithMessage:@"修改成功"];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
    
 }
    
}
#pragma mark ---- 退出登录和完善信息
- (void)loginOutBtnDidClickEvent:(UIButton *)sender{
    if (self.isBindMobile == true) {
        
//        [ToolClass showAlertWithMessage:@"开启赚钱之旅"];
//        小问题点击开启赚钱之旅之后跳转的是登陆页面应该跳转到我的页面
        [self.navigationController popToRootViewControllerAnimated:NO];
        //返回到我的页面通知
        [[NSNotificationCenter defaultCenter] postNotificationName:DISMISS_VIEWCONTROLLER object:nil];
        
    }else{
        
        DQAlertView *alert = [[DQAlertView alloc]initWithTitle:@"确定要退出吗？" message:@"温馨提示" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
        [alert show];
        
#if 0
        WeakStament(ws);
        CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:@"确定退出登录?"];
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
            YYLog(@"ca");
        }];
        CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
            YYLog(@"sur");
            //调用退出登录接口
            [ws requestLogout];
            //退出登录
            //清除UserDefaults缓存
            [WDDefaultAccount cleanAccountCache];
            [[WDUserInfoModel shareInstance] clearUserInfo];//清除用户数据
            [[SDImageCache sharedImageCache] clearMemory];//清除图片缓存
            [[SDImageCache sharedImageCache] clearDisk];
            //取消极光推送的别名
            [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                if (iResCode == 0) {
                    YYLog(@"取消别名成功");
                }else{
                    YYLog(@"取消别名失败-errorCode-%d",iResCode);
                }
            }];
            
            [ws.navigationController popViewControllerAnimated:YES];
            
            [ToolClass showAlertWithMessage:@"退出成功"];

        }];
        
        [alertVC addAction:cancel];
        [alertVC addAction:sure];
#endif
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self presentViewController:alertVC animated:false completion:nil];
//        });
        
    }

}


//1.0版本中的提示样式
#pragma mark - DQAlertView delegate
-(void)otherButtonClickedOnAlertView:(DQAlertView *)alertView
{
    //调用退出登录接口
    [self requestLogout];
    //退出登录
    //清除缓存的代码
    [WDDefaultAccount cleanAccountCache];
    [[WDUserInfoModel shareInstance] clearUserInfo];//清除用户数据
    [[SDImageCache sharedImageCache] clearMemory];//清除图片缓存
    [[SDImageCache sharedImageCache] clearDisk];
    //取消极光推送的别名
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        if (iResCode == 0) {
            YYLog(@"取消别名成功");
        }else{
            YYLog(@"取消别名失败-errorCode-%d",iResCode);
        }
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [ToolClass showAlertWithMessage:@"退出成功"];
    
}
#pragma mark ===== 访问退出登录接口
- (void)requestLogout{
    NSString *sid = [WDUserInfoModel shareInstance].sid?[WDUserInfoModel shareInstance].sid:@"";
    NSDictionary *dic = @{@"si":sid};
    [WDNetworkClient postRequestWithBaseUrl:klogoutUrl setParameters:dic success:^(id responseObject) {
        NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
        if ([code isEqualToString:@"10000"]) {
            YYLog(@"退出登录调用接口成功");
        }
    } fail:^(NSError *error) {
        YYLog(@"%@",error);
    } delegater:nil];
}


#pragma mark ---- 判断用户是否绑定支付宝页面

- (void)judgeIsAuthentication{
    WeakStament(weakSelf);
    NSString *mi = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    if (mi) {
        NSDictionary *dic = @{@"mi":mi};
        [WDNetworkClient postRequestWithBaseUrl:kJudgeIsAuthenticationUrl setParameters:dic success:^(id responseObject) {
            weakSelf.isBindAlipay = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
            if ([weakSelf.isBindAlipay isEqualToString:@"1017"]) {
                [WDUserInfoModel shareInstance].isBindAlipay = YES;
            }
            weakSelf.judgeIsAuthMsg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
        } fail:^(NSError *error) {
            YYLog(@"%@",error);
        } delegater:nil];
    }
}
//性别信息
-(void)updateGenderInfo
{
    
    if (self.genderString) {
        
        NSDictionary *para = @{@"gender":self.genderString,@"updateType":@2};
        [WDNetworkClient postRequestWithBaseUrl:kUpdateMemeberInfo setParameters:para success:^(id responseObject) {
            YYLog(@"%@",responseObject);
            NSDictionary *result = responseObject[@"result"];
            if ([result[@"code"] isEqualToString:@"1000"]) {
                [ToolClass showAlertWithMessage:@"修改成功"];
            }
            
        } fail:^(NSError *error) {
            
        } delegater:self.view];
        
    }
    
}

@end
