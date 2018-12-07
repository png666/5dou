

//
//  WDAbout5douViewController.m
//  5dou
//
//  Created by rdyx on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDAbout5douViewController.h"
#import "HMScannerController.h"
#import "ToolClass.h"
#import "Colours.h"
#import "WDAboutPlatformViewController.h"
#import "WDLottoryViewController.h"
@interface WDAbout5douViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIImageView *QRCodeImageView;
@property(nonatomic,strong)UILabel *companyLabel;
@property(nonatomic,strong)UILabel *englishCompaneyLaebl;
@property(nonatomic,strong)UILabel *versionLabel;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *dataArray;
@end

static NSString *cellId = @"cellId";
#define tableRowHeight 50.f;

@implementation WDAbout5douViewController
{
    UIView *background;
}

-(UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.rowHeight = tableRowHeight;
        _table.separatorStyle = 0;
        [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    }
    return _table;
}

//测试通知
- (void)postNotificatino {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabb" object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self postNotificatino];
    [self.navigationItem setItemWithTitle:@"关于我们" textColor:kBlackColor fontSize:19 itemType:center];
    _dataArray = @[@"当前版本",@"微信公众号",@"平台说明"];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 50.f, ScreenWidth, 200.f)];
    bgView.backgroundColor = kWhiteColor;
//    bgView.centerX = self.view.centerX;
//    [self.view addSubview:bgView];
    
    //二维码图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 50.f, 100.f, 100.f)];
    
    NSString *Url = [NSString stringWithFormat:@"http://weixin.qq.com/r/fDgdBX7E-SOCrTpm921u"];
    UIImage *avatar = [UIImage imageNamed:@"iicon"];
    [HMScannerController cardImageWithCardName:Url avatar:avatar scale:0.2 completion:^(UIImage *image) {
        imageView.image = image;
        
    }];

    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapQRCode)];
    [imageView addGestureRecognizer:tap];
    
    imageView.centerX = bgView.centerX;;
    [bgView addSubview:imageView];

    

    UIView *headBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 125.f)];
    
    UIImageView *wxImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,25.f, 390.f/2, 143.f/2)];
    wxImageView.image = WDImgName(@"yellow_logo");
    wxImageView.centerX = headBgView.centerX;
    headBgView.backgroundColor = [WDColorRGB(221.f, 221.f, 221.f)colorWithAlphaComponent:0.3];
    [headBgView addSubview:wxImageView];
//    [bgView addSubview:wxImageView];
    
    
//    UILabel *wxLabel = [ToolClass labelWithFrame:CGRectMake(wxImageView.right, 15.f, 150.f, 20.f) andTitle:@"微信公众号:5dou" andTitleColor:kGrayColor andTextAlignment:1 andFont:kFont15];
//    [bgView addSubview:wxLabel];
    
    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, wxImageView.bottom+6, ScreenWidth-40, 0.5)];
//    line.backgroundColor = WDColorRGB(221.f, 221.f, 221.f);
//    [bgView addSubview:line];
    
//    UILabel *tipLabel = [ToolClass labelWithFrame:CGRectMake(0, imageView.bottom+10.f, 200.f, 20.f) andTitle:@"欢迎关注5dou微信公众号" andTitleColor:kGrayColor andTextAlignment:1 andFont:kFont13];
//    tipLabel.centerX = bgView.centerX;
//    [bgView addSubview:tipLabel];
    
//    NSString *version = [NSString stringWithFormat:@"当前版本 : %@",[ToolClass getAPPVersion]];
//    UILabel *versionLabel = [ToolClass labelWithFrame:CGRectMake(0, tipLabel.bottom+7.f, 200.f, 20.f) andTitle:version andTitleColor:kGrayColor andTextAlignment:1 andFont:kFont14];
//    versionLabel.centerX = bgView.centerX;
//    self.versionLabel = versionLabel;
//    [bgView addSubview:versionLabel];

    
    UILabel *companeyLaebl = [ToolClass labelWithFrame:CGRectMake(0, imageView.bottom+15.f, 200.f, 20.f) andTitle:@"上海吾逗网络科技有限公司" andTitleColor:kGrayColor andTextAlignment:NSTextAlignmentCenter andFont:kFont12];
    self.companyLabel = companeyLaebl;
    companeyLaebl.centerX = bgView.centerX;
    [bgView addSubview:companeyLaebl];
    
    UILabel *englishCompaneyLaebl = [ToolClass labelWithFrame:CGRectMake(0, companeyLaebl.bottom+2, 370.f, 20.f) andTitle:@"Shanghai 5dou Network Technology Co.,Ltd" andTitleColor:kGrayColor andTextAlignment:NSTextAlignmentCenter andFont:kFont12];

    self.englishCompaneyLaebl = englishCompaneyLaebl;
    englishCompaneyLaebl.centerX = bgView.centerX;
    [bgView addSubview:englishCompaneyLaebl];
    
    
    [self.view addSubview:self.table];
    self.table.tableFooterView = bgView;
    self.table.tableHeaderView = headBgView;
    
}

//点击二维码放大
-(void)tapQRCode
{
    YYLog(@"your");
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth , ScreenHeight)];
    background = bgView;
    bgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.3];
    [self.view addSubview:bgView];
    
    //创建显示图像的视图
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    imgView.centerX = bgView.centerX;
    imgView.centerY = bgView.centerY-50.f;
    NSString *Url = [NSString stringWithFormat:@"http://weixin.qq.com/r/fDgdBX7E-SOCrTpm921u"];
    UIImage *avatar = [UIImage imageNamed:@"iicon"];
    [HMScannerController cardImageWithCardName:Url avatar:avatar scale:0.2 completion:^(UIImage *image) {
        imgView.image = image;
        
    }];

    //添加长按手势识别二维码
    imgView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [imgView addGestureRecognizer:longPress];
    
    [bgView addSubview:imgView];
        //添加点击手势（即点击后退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];

    [bgView addGestureRecognizer:tapGesture];
    
    [self shakeToShow:bgView];//放大过程中的动画
    
}

-(void)closeView{
    [background removeFromSuperview];
}
//放大过程中动画
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

#pragma mark-> 长按识别二维码
-(void)longPressAction:(UIGestureRecognizer*)gesture{
    
    if(gesture.state==UIGestureRecognizerStateBegan){
        
        UIImageView*tempImageView=(UIImageView*)gesture.view;
        if(tempImageView.image){
            //1. 初始化扫描仪，设置设别类型和识别质量
            CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
            //2. 扫描获取的特征组
            NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:tempImageView.image.CGImage]];
            //3. 获取扫描结果
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:scannedResult delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:@"您还没有生成二维码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else if (gesture.state==UIGestureRecognizerStateEnded){
        
    }
}
#pragma mark table datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = kFont16;
    cell.selectionStyle = 0;
    //
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.f, ScreenWidth, 0.5)];
    line.backgroundColor = WDColorRGB(236.f, 236.f, 236.f);
    [cell.contentView addSubview:line];
    
    if (indexPath.row==0) {
        
        UILabel *version = [UILabel new];
        version.frame = CGRectMake(ScreenWidth-75.f, 15, 50.f, 20.f);
        version.textColor = kLightGrayColor;
        version.textAlignment = 2;
        version.font = kFont16;
        version.text = [ToolClass getAPPVersion];
        [cell.contentView addSubview:version];
        
    }else if (indexPath.row==1){
        UILabel *officialAccount = [UILabel new];
        officialAccount.frame = CGRectMake(ScreenWidth-75.f, 15, 50.f, 20.f);
        officialAccount.textColor = kLightGrayColor;
        officialAccount.font = kFont16;
        officialAccount.textAlignment = 2;
        officialAccount.text = @"5dou";
        [cell.contentView addSubview:officialAccount];
    }else if(indexPath.row==2){
        cell.accessoryType = 1;
//        [self joinGroup:nil key:nil];
    }
    return cell;
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {

        WDAboutPlatformViewController *p = [WDAboutPlatformViewController new];
        p.hidesBottomBarWhenPushed = YES;
        p.isAbout5dou = YES;
        [self.navigationController pushViewController:p animated:YES];
    }
}

//加入qq群
- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    //597769272 //第一个是群号  第二个是appkey
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"340452063",@"408469436da08bdda67a1159f52b7b8a672a65ba1f7e641431a649e3fa5b084c"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}

@end
