

//
//  WDMineViewController.m
//  5dou
//
//  Created by rdyx on 16/8/27.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
#import "WDHTTPServer.h"
#import "WDMineViewController.h"
#import "WDMemeberCenterCell.h"
#import "WDLoginViewController.h"
#import "WDMemberCenterViewController.h"
#import "WDMyCollectionViewController.h"
#import "WDNormalQuestionViewController.h"
#import "WDFeebbackViewController.h"
#import "WDAbout5douViewController.h"
#import "WDMemberTopView.h"
#import "AFToast.h"
#import "DQAlertView.h"
#import "ToolClass.h"
#import "WDDoubiViewController.h"
#import "WDTaskCardViewController.h"
#import "WDMyTaskViewController.h"
#import "XHNetworkCache.h"
#import "WDLoginViewController.h"
#import "WDRegisterViewController.h"
#import "WDH5MyTaskController.h"
#import "WDH5MyDouBiController.h"
#import "WDH5MyTaskCardController.h"
#import "WDLoginViewController.h"
#import "WDUserInfoModel.h"
#import "WDRebateH5ViewController.h"
#import "WDDoubiViewController.h"
#import "WDMessageViewController.h"
#import "WDQuestionController.h"
#import "WDH5QuestionController.h"
#import "ZFActionSheet.h"
#import "ZFImagePicker.h"
#import "WDCashBarView.h"
#import "CKAlertViewController.h"
#import "WDH5SignViewController.h"
#import "WDH5MyTaskCardController.h"
#import "WDH5RankingViewController.h"
//////添加消息未读的标记
#import "WDUnReadMessageModel.h"
#import "UIBarButtonItem+Badge.h"
#import "WDHorizontalTable.h"
///////测试量充值
#import "WDFlowRechargeViewController.h"

@interface WDMineViewController ()<UITableViewDelegate,UITableViewDataSource,DQAlertViewDelegate,ZFActionSheetDelegate,ZFImagePickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *firstTitleArray;
@property(nonatomic,strong)NSArray *secondTitleArray;
@property(nonatomic,strong)NSArray *firstImageArray;
@property(nonatomic,strong)NSArray *secondImageArray;
@property(nonatomic,strong)UILabel *cacheLabel;
@property(nonatomic,strong)WDMemberTopView *headerView;
@property(nonatomic,strong)NSDictionary *memeberAcountDic;
@property(nonatomic,assign)NSInteger taskCardNum;//任务卡
@property(nonatomic,assign)NSInteger mytaskNum;//我的任务
@property(nonatomic,assign)CGFloat walletAmount;//
@property(nonatomic,copy)NSString *headImageUrl;
@property(nonatomic,assign)BOOL isFirstLoad;

@property(nonatomic,strong)UIView *tapCoverView;
@property(nonatomic,strong)UIView *animationView;

@property(nonatomic,strong)NSMutableArray *interesTagArray;
@property(nonatomic,strong)WDCashBarView *cashBarView;
@property(nonatomic,copy)NSString *sign;


@property (nonatomic, strong)UIImagePickerController *imgpicker;

@end

static NSString *cellID = @"cellIdentifier";
static NSString *cacheTitle = @"确定清除缓存";
#define kTAG_BASE_VALUE 90
#define KTagWidth 50
#define KTagHeight 20



@implementation WDMineViewController

-(UIImagePickerController *)imgpicker{
    if (!_imgpicker) {
        _imgpicker=[[UIImagePickerController alloc]init];
        _imgpicker.allowsEditing = YES;
        _imgpicker.delegate=self;
    }
    return _imgpicker;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -1, ScreenWidth, ScreenHeight-64-49) style:UITableViewStyleGrouped];
        [_tableView registerClass:[WDMemeberCenterCell class] forCellReuseIdentifier:cellID];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = false;
        _tableView.rowHeight = 50.f;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

///测试代码
- (void)addNavigationLeftBtn {
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, 50, 50);
    view.backgroundColor = [UIColor lightGrayColor];
    [self.navigationController.navigationBar addSubview:view];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    img.image = [UIImage imageNamed:@"message_list_icon_red"];
    [view addSubview:img];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 10, 10)];
    label.backgroundColor = [UIColor redColor];
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    [view addSubview:label];
    
}


#define TabbarItemNums 4
- (void)addTabbarSubView:(NSInteger)index {
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 4;
    view.layer.masksToBounds = YES;
    CGRect tabFram = self.tabBarController.tabBar.frame;
    float percentX = (index+0.6)/TabbarItemNums;
    CGFloat x = ceilf(percentX*tabFram.size.width);
    CGFloat y = ceilf(0.1*tabFram.size.height);
    view.frame = CGRectMake(x, y, 8, 8);
    [self.tabBarController.tabBar addSubview:view];
    [self.tabBarController.tabBar bringSubviewToFront:view];
    
}

- (void)viewDidLoad {
    
    //逆序反转
    //  NSArray *tempArr = [[weakSelf.dataArray reverseObjectEnumerator] allObjects];

    [super viewDidLoad];
    
    NSLog(@"%@",self.tabBarController.tabBar.selectedItem);
    
    [self addNavigationLeftBtn];
    
//    [self addTabbarSubView:2];
    
    self.interesTagArray = [NSMutableArray array];
    [self.navigationItem setItemWithTitle:@"" textColor:kWhiteColor fontSize:19 itemType:center];
    self.navigationItem.leftBarButtonItem = nil;
    _firstImageArray = @[@"ranking",@"feddback",@"qu",@"clear",@"about"];
    _firstTitleArray = @[@"排行榜",@"意见反馈",@"常见问题",@"清除缓存",@"关于我们"];
    
    [self.view addSubview:self.tableView];
    
    
    [self addNavigationLeftButtonFrame:CGRectMake(0, 0, 20, 20) Image:WDImgName(@"shezhi") AndHighLightImage:nil AndText:nil Target:self Action:@selector(setActon:)];
    
    [self addNavgationRightButtonWithFrame:CGRectMake(0, 0, 22, 22) title:nil Image:@"home_icon_message" selectedIMG:nil tartget:self action:@selector(messageActon:)];
    
    WDMemberTopView *headrView = [[WDMemberTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 190.f)];
    self.headerView = headrView;
    self.tableView.tableHeaderView = headrView;
    
    WDCashBarView *cashView = [[WDCashBarView alloc]initWithFrame:CGRectMake(0, 130.f, ScreenWidth, 62.f)];
    WeakStament(wself);
    self.cashBarView = cashView;
    cashView.block = ^(NSInteger index){
        YYLog(@"%ld",(long)index);
        [wself cashBarAction:index];
    };
    [headrView addSubview:cashView];
    
    //添加头部点击视图
    self.tapCoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 2, 80, 80)];
    self.tapCoverView.centerX = ScreenWidth/2;
    self.tapCoverView.backgroundColor = kClearColor;
    //    [self.animationView addSubview:self.tapCoverView];
    [headrView addSubview:self.tapCoverView];
    //添加手势
    [self addTapGestures];
    
     [self judgeIsAuthentication];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[WDDefaultAccount getUserInfo] objectForKey:@"memberId"]) {
        //获取消息未读个数=====标记消息小红点
        [self requestUnReadMssageWithStatus:@"0"];
    }else{
        //退出登陆之后取消消息按钮的红点
        [self.rightBarButtonItem setBadgeValue:@"0"];
    }
    
    
    [MobClick beginLogPageView:@"我的"];
    self.navigationController.navigationBar.barTintColor = kMainColor;
    //delete 黑丝
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    
    self.cacheLabel.text = [ToolClass getImageCache];
    
    //首次注册回到此界面没有昵称问题解决
    self.headerView.nameLabel.text = [WDUserInfoModel shareInstance].nickName;

    //解决退出登录后头标还是以前的情况
    //    [self.headerView.headerImage setImage:[UIImage imageNamed:@"head"]];
    
    //登录状态显示的内容
    if ([WDUserInfoModel shareInstance].memberId) {
        //登录成功后发起请求
//        if (!self.isFirstLoad) {
             [self loadMememberData];
//        }
        [self.tableView setContentOffset:CGPointZero];
        //消除右侧提示信息位置错乱
        [self.tableView reloadData];
        //头像
        self.headerView.loginLabel.hidden = YES;
        self.headerView.nameLabel.hidden = false;
        self.headerView.IDLabel.hidden = false;
        self.headerView.genderImage.hidden = false;
        //        self.headerView.crownImage.hidden = false;
        NSString *gender = [WDUserInfoModel shareInstance].gender;
        if ([gender isEqualToString:@"F"]) {
            self.headerView.genderImage.image = WDImgName(@"woman");
        }else if([gender isEqualToString:@"M"])
        {
            self.headerView.genderImage.image = WDImgName(@"man");
            
        }else{
            
            self.headerView.genderImage.image = nil;
            
        }
        
        self.headerView.IDLabel.text = [NSString stringWithFormat:@"ID:%@",[WDUserInfoModel shareInstance].mobile];
    }
    //未登录状态时显示的
    else{
        
        self.headerView.loginLabel.hidden = false;
        self.headerView.nameLabel.hidden = YES;
        self.headerView.IDLabel.hidden = YES;
        self.headerView.genderImage.hidden = YES;
        
        [self.headerView.headerImage setImage:WDImgName(@"head")];
        //        self.headerView.crownImage.hidden = YES;
        
    }
    
}

#pragma mark - ZFImagePickerDelegate
- (void)imagePickerDidFinishWithImage:(UIImage *)image andType:(NSString *)type
{
    NSLog(@"--> %@ %@", image, type);
}

#pragma mark - 签到所在的Bar
-(void)cashBarAction:(NSInteger)index
{
    NSString *mid = [WDUserInfoModel shareInstance].memberId;
    switch (index) {
        case 1001:
        {
            if (!mid) {
                [self callLoginVC];
            }else{
                WDH5MyTaskCardController *taskCardVC = [[WDH5MyTaskCardController alloc] init];
                taskCardVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:taskCardVC animated:true];
            }
        }
            break;
        case 1002:
        {
            if (!mid) {
                [self callLoginVC];
            }else{
                WDDoubiViewController *dou = [WDDoubiViewController new];
                dou.hidesBottomBarWhenPushed = true;
                [self.navigationController pushViewController:dou animated:true];
            }
            
        }
            break;
        case 1003:
        {
            if (!mid) {
                [self callLoginVC];
            }else{
                //签到页面跳转处
                WDH5SignViewController *signVC = [[WDH5SignViewController alloc] init];
                signVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:signVC animated:YES];
            }
            
        }
            break;
        default:
            break;
    }
}

/**
 个人信息设置

 @param btn
 */
-(void)setActon:(UIButton *)btn
{
    YYLog(@"set");
    NSString *userId = [WDUserInfoModel shareInstance].memberId;
    if (userId) {
        WDMemberCenterViewController *member = [WDMemberCenterViewController new];
        member.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:member animated:YES];
    }else{
        [self callLoginVC];
    }
}

/**
 消息界面

 @param btn
 */
-(void)messageActon:(UIButton *)btn
{
//    YYLog(@"mes");
    NSString *userId = [WDUserInfoModel shareInstance].memberId;
    if (userId) {
        WDMessageViewController *messageVC = [[WDMessageViewController alloc]init];
        messageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageVC animated:YES];
    }else{
        [self callLoginVC];
    }
  
}
#pragma mark --- 获取未读消息
/**
 *  @brief 获取未读消息
 *
 *  @param status 消息状态 0 未读 1 已读 3 禁用
 */
- (void)requestUnReadMssageWithStatus:(NSString *)status{
    NSString *mi = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    NSDictionary *dic = @{@"mi":mi,
                          @"status":status,
                          };
    WeakStament(wself);
    [WDNetworkClient postRequestWithBaseUrl:kUnReadMssageUrl setParameters:dic success:^(id responseObject) {
        WDUnReadMessageModel *model = [[WDUnReadMessageModel alloc] initWithDictionary:responseObject error:nil];
//        self.messageModel = model;
        if ([model.result.code isEqualToString:@"1000"]) {
            //设置消息角标
            [wself.rightBarButtonItem setBadgeBGColor:WDColorFrom16RGB(0xfa4141)];
        }else{
            
        }
    } fail:^(NSError *error) {
        
    } delegater:nil];
}
#pragma mark - 登录成功后请求用户信息
-(void)loadMememberData
{
    [WDNetworkClient postRequestWithBaseUrl:kGetUserInfoUrl setParameters:nil success:^(id responseObject) {
        YYLog(@"%@",responseObject);
        if (responseObject) {
            NSDictionary *result = responseObject[@"result"];
            if ([result[@"code"]isEqualToString:@"1000"]) {
                
                //
                self.isFirstLoad = YES;
                
                NSDictionary  *dataDic = responseObject[@"data"];
                //签到字段
                [WDUserInfoModel shareInstance].isSign = [dataDic[@"signed"] boolValue];
                [WDUserInfoModel shareInstance].gender = dataDic[@"memberInfo"][@"gender"];
                [WDUserInfoModel shareInstance].nickName =dataDic[@"memberInfo"][@"nickName"];
                
                [WDUserInfoModel shareInstance].schoolName = dataDic[@"memberDetail"][@"school"];
                [WDUserInfoModel shareInstance].inviteCode = dataDic[@"memberInfo"][@"inviteCode"];
                
                //会员基本信息从中获取头像链接
                self.headImageUrl = dataDic[@"memberInfo"][@"headImg"];
                //单例中也添加一份，在其他界面使用
                [WDUserInfoModel shareInstance].headImg = self.headImageUrl;
                
                //
                [[SDImageCache sharedImageCache]clearDisk];
                [[SDImageCache sharedImageCache]clearMemory];
                
                [self.headerView.headerImage sd_setImageWithURL:[NSURL URLWithString:self.headImageUrl] placeholderImage:WDImgName(@"head")];
                
                //兴趣标签
                NSArray *tags = dataDic[@"myTagLibs"];
                [self.interesTagArray removeAllObjects];
                [self.interesTagArray addObjectsFromArray:tags];
                
                //任务卡相关
                self.taskCardNum = [dataDic[@"taskCardNum"] integerValue];
//                self.mytaskNum = [dataDic[@"mytaskNum"] integerValue];
                
                //钱包钱数
                NSDictionary *accountDic = dataDic[@"memberAccount"];
                self.walletAmount = [accountDic[@"walletAmount"] floatValue];
                [WDUserInfoModel shareInstance].alipayAccount = accountDic[@"alipayAccount"];
                
            }
        }else{
           NSDictionary *dic = responseObject[@"result"];
            [ToolClass showAlertWithMessage:dic[@"msg"]];
        }
    } fail:^(NSError *error) {
        
        YYLog(@"%@",error);
        
    } delegater:nil];
    
}
#pragma mark - 此方法存在未知bug,将布局换到其他方法
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.headerView.nameLabel.text = [WDUserInfoModel shareInstance].nickName;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //判断是否支付宝实名认证和微信认证
    
    [super judgeIsAuthentication];
    [super weixinAuth];

    if ([WDUserInfoModel shareInstance].memberId) {
        
        self.headerView.nameLabel.text = [WDUserInfoModel shareInstance].nickName;
        self.cashBarView.cardNumLabel.text = [NSString stringWithFormat:@"%ld",(long)self.taskCardNum];
        self.cashBarView.cashNumLabel.text = [NSString stringWithFormat:@"%.2f",self.walletAmount];
        if ([WDUserInfoModel shareInstance].isSign) {
            self.cashBarView.isSignLabel.text = @"已签";
        }else{
             self.cashBarView.isSignLabel.text = @"签到";
        }
        
    }else
    {
        self.cashBarView.cardNumLabel.text = @"0";
        self.cashBarView.cashNumLabel.text = @"0";
        self.cashBarView.isSignLabel.text = @"签到";
        self.headerView.nameLabel.hidden = YES;
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.barTintColor = kNavigationBarGrayColor;

}

- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的"];
    self.navigationController.navigationBar.shadowImage = nil;
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    
    
}

#pragma mark - 添加手势
-(void)addTapGestures
{
    
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeaderImage:)];
    self.tapCoverView.userInteractionEnabled = YES;
    [self.tapCoverView addGestureRecognizer:tapHeader];
    
}

#pragma mark - delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image =[info objectForKey:UIImagePickerControllerEditedImage];
        YYLog(@"我的图片信息是:%@",image);
    }];
//    [picker dismissViewControllerAnimated:YES completion:nil];
    
    

    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    NSLog(@"取消");
    
    //如果直接传一个picker会挂掉  说 self.picker 是空的
    //这是为了处理点击消失慢的问题
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
}

#pragma mark - 头部点击 拍照或相册
-(void)tapHeaderImage:(UITapGestureRecognizer *)tap
{
    
    
    //这几行代码为测试代码
    
    self.imgpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //这里 _imagePicer 和 self.imagePicker 是完全不同的东西
    
    [self presentViewController:self.imgpicker animated:YES completion:nil];
    
    
//    if ([WDUserInfoModel shareInstance].memberId) {
    
//        ZFActionSheet *sheet = [ZFActionSheet actionSheetWithTitle:nil confirms:@[@"拍照",@"相册"] cancel:@"取消" style:ZFActionSheetStyleDefault];
//        sheet.delegate = self;
//        [sheet show];

//        WDMemberCenterViewController *center = [[WDMemberCenterViewController alloc]init];
//        center.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:center animated:YES];
//    }else{
//        [self callLoginVC];
//    }
    
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
                wself.headerView.headerImage.image = image;
                [ToolClass showAlertWithMessage:@"头像修改成功"];
            }
            
        } fail:^(NSError *error) {
            
            YYLog(@"%@",error);
            
        } delegater:nil];
    };
    // 4、弹出界面
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - login
-(void)callLoginVC{
    
    WDLoginViewController *login = [[WDLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    //解决present延迟弹出
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:nav animated:YES completion:^{
        }];
    });
}
#pragma mark - datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDMemeberCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.nameLabel.text = _firstTitleArray[indexPath.row];
    cell.headImage.image = WDImgName(_firstImageArray[indexPath.row]);
    
    if (indexPath.row==3) {
        //慎用全局变量，会有各种不知道原因的问题
        UILabel *label = [cell.contentView viewWithTag:3333];
        [label removeFromSuperview];
        //避免重复遮盖
        label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-77.f, 14.5f,60.f ,20.f)];
        label.text = [ToolClass getImageCache];
        label.textColor = kGrayColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kFont14;
        label.tag = 3333;
        self.cacheLabel = label;
        [cell.contentView addSubview:label];
    }
    if (indexPath.row==4) {
        cell.lineView.hidden = YES;
    }
    return cell;
}

#pragma mark- delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *userId = [WDUserInfoModel shareInstance].memberId;
    
    if (indexPath.section==0) {
        
        switch (indexPath.row) {
                
            case 0:
            {
                WDH5RankingViewController *rankingVC = [WDH5RankingViewController new];
                rankingVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController: rankingVC animated:YES];
                
            }
                break;
            case 1:
            {
                if (userId) {
                    WDFeebbackViewController *feedback = [WDFeebbackViewController new];
                    feedback.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController: feedback animated:YES];
                }else{
                    
                    [self callLoginVC];
                    
                }
                
            }
                break;
                
            case 2:
            {
               // WDQuestionController *question = [[WDQuestionController alloc]init];
                WDH5QuestionController *question = [[WDH5QuestionController alloc] init];
                question.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:question animated:YES];
            }
                break;
            case 3:
            {
                //清除缓存
                
                ZFActionSheet *sheet = [ZFActionSheet actionSheetWithTitle:nil confirms:@[@"拍照",@"相册"] cancel:@"取消" style:ZFActionSheetStyleDefault];
                sheet.delegate = self;
                [sheet show];
                
                if ([self.cacheLabel.text isEqualToString:@"0B"]) {
                    [ToolClass showAlertWithMessage:@"您的缓存已清空"];
                    return;
                }
//                DQAlertView *alert = [[DQAlertView alloc]initWithTitle:cacheTitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
//                [alert show];
                WeakStament(ws);
                CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:cacheTitle];
                CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
                    YYLog(@"ca");
                    
                }];
                CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确认" handler:^(CKAlertAction *action) {
                    YYLog(@"sur");
                   [ws clearCache];
                }];
                [alertVC addAction:cancel];
                [alertVC addAction:sure];
                //优化present界面弹出慢的问题
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:alertVC animated:false completion:nil];
                });
                
            }
                break;
            case 4:
            {
                //关于我们
                WDAbout5douViewController *ab = [WDAbout5douViewController new];
                ab.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ab animated:true];
                
//                WDHorizontalTable *table = [WDHorizontalTable new];
//                table.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:table animated:YES];
                
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - DQAlertView delegate
-(void)otherButtonClickedOnAlertView:(DQAlertView *)alertView
{
    //清除缓存
    [self clearCache];
}

-(void)clearCache
{
    [ToolClass clearImageCache];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [ToolClass showAlertWithMessage:@"清除成功"];
    [MobClick event:@"clearCache"];
}

@end
