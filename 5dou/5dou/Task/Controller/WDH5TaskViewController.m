//
//  WDH5TaskViewController.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDH5TaskViewController.h"
#import "WDTaskCommentController.h"
#import "WDLoginViewController.h"
#import "WDCommitTaskController.h"
#import "WDHTTPServer.h"
#import "AFToast.h"
#import "JWShareView.h"
#import "UMCustomManager.h"
#import "WDTaskDetailModel.h"
#import "WDH5DotaskViewController.h"
#import "SYFavoriteButton.h"
#import "WDUserInfoModel.h"

#import "WDSCWebViewController.h"
@interface WDH5TaskViewController (){
    BOOL hasOperation;
}
@property (nonatomic,strong) WDTaskDetailModel *taskDetailModel;
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) SYFavoriteButton *favoriteButton;
@end

@implementation WDH5TaskViewController

- (void)viewDidLoad {
    [self getMemberId];
    [self prepareData];
    
    self.navTitle = @"任务详情";
    [super viewDidLoad];
    [self prepareUI];
    // Do any additional setup after loading the view.
}


- (void)prepareUI{
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, ScreenHeight - 120, 60, 30)];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _saveButton.backgroundColor = kNavigationBarColor;
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveButton.layer.cornerRadius = 5;
    _saveButton.clipsToBounds = YES;
    [_saveButton addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.hidden = YES;
    [self.view addSubview:_saveButton];
    
    _favoriteButton = [[SYFavoriteButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _favoriteButton.image = [UIImage imageNamed:@"collect_nor"];
    _favoriteButton.duration = 1;
    _favoriteButton.defaultColor = [UIColor whiteColor];
    _favoriteButton.lineColor = [UIColor purpleColor];
    _favoriteButton.favoredColor = [UIColor yellowColor];
    _favoriteButton.circleColor = [UIColor yellowColor];
    _favoriteButton.userInteractionEnabled = YES;
    [_favoriteButton addTarget:self action:@selector(collectionTask) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_favoriteButton];
    self.navigationItem.rightBarButtonItem = item;
}


- (void)savePhoto{
    UIImage *snapImage = [self snapshot:self.view];
    UIImageWriteToSavedPhotosAlbum(snapImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存失败";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    [ToolClass showAlertWithMessage:message];
}


- (void)setTaskId:(NSString *)taskId{
    _taskId = taskId;
    
    self.url = [NSString stringWithFormat:@"http://%@/worklist_html/rwcont.html?taskId=%@",H5Url,_taskId];
}

#pragma mark 实现代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    WeakStament(weakSelf);
    self.context[@"openImg"] = ^(){
        weakSelf.saveButton.hidden = NO;
    };
    self.context[@"closeImg"] = ^(){
        weakSelf.saveButton.hidden = YES;
    };
    self.context[@"dowork"] = ^(){
        //判断是否是调查问卷，如果是调查问卷的话
        if ([weakSelf.taskDetailModel.taskType isEqualToString:@"3"]) {
            WDUserInfoModel *userModel = [WDUserInfoModel shareInstance];
            NSString *surveyUrl =[NSString stringWithFormat:@"%@&taskId=%@&mobile=%@&memberId=%@",weakSelf.taskDetailModel.jumpUrl,weakSelf.taskDetailModel.taskId,userModel.mobile,userModel.memberId];
            dispatch_async(dispatch_get_main_queue(), ^{
                WDSCWebViewController *webViewController = [[WDSCWebViewController alloc] init];
                webViewController.url = surveyUrl;
                webViewController.successblock = ^(){
                    [weakSelf.webView reload];
                };
                [weakSelf.navigationController pushViewController:webViewController animated:YES];
            });
          
            return;
        }
        
        //获取原生的字符串,如果含有itunes.apple.com，需要跳转到应用市场去下载应用
        if ([weakSelf.taskDetailModel.jumpUrl containsString:@"itunes.apple.com"]) {
            NSURL *url = [NSURL URLWithString:weakSelf.taskDetailModel.jumpUrl];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            return;
        }
        
        WDH5DoTaskViewController *doTaskViewController = [[ WDH5DoTaskViewController alloc] init];
        doTaskViewController.url = weakSelf.taskDetailModel.jumpUrl;
        doTaskViewController.navTitle = @"任务详情";
        [weakSelf.navigationController pushViewController:doTaskViewController animated:YES];
        return;
    };
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //拦截地址，js调用oc方法
    NSString *urlStr = [request.URL absoluteString];
    YYLog(@"-----------urlStr = %@-----------",urlStr);
    WeakStament(weakSelf);
    //这个在进行操作
    //没有登录,需要进行登录
    if ([urlStr containsString:@"login_html"]) {
        
        WDLoginViewController *loginController = [WDLoginViewController new];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
        [self presentViewController:navigationController animated:YES completion:nil];
        loginController.successLoginBlock = ^(){
            [weakSelf.webView reload];
            [weakSelf prepareData];
        };
        
        return NO;
    }else if([urlStr containsString:@"worklist_html/pinglun.html"]){
        WDTaskCommentController *commentController = [WDTaskCommentController new];
        commentController.taskId = _taskId ;
        [self.navigationController pushViewController:commentController animated:YES];
        return NO;
    }else if([urlStr containsString:@"worklist_html/rwcommite_pic"]){
        [self commitTask];
        return NO;
        //跳转到appstore
    }else if([urlStr containsString:@"toAppstore"]){
        NSString *appStore = @"itms-apps://itunes.apple.com/app/id1156787913";
        NSURL *url = [NSURL URLWithString:appStore];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        return NO;
    }else if([urlStr containsString:@"worklist_html/share"]){
        UIImage *image = [UIImage imageNamed:@"iicon"];
        
//        [UMCustomManager shareWebWithViewController:self ShareTitle:_taskDetailModel.taskName Content:_taskDetailModel.taskInfo ThumbImage:image Url:_taskDetailModel.shareUrl];
        return NO;
    }else if([urlStr containsString:@"&dowork"]){
        return NO;
    }
    return YES;
};


#pragma mark 提交任务
- (void)commitTask{
    WDCommitTaskController *controller = [[WDCommitTaskController alloc]  init];
    NSArray *images;
    for (NSDictionary *stepDict in self.taskDetailModel.steps) {
        WDTaskStepModel *stepModel = [WDTaskStepModel new];
        [stepModel setValuesForKeysWithDictionary:stepDict];
        if (stepModel.images.count != 0) {
            images = stepModel.images;
        }
    }
    controller.imageArray = images;
    controller.isNeedPic = self.taskDetailModel.isNeedPic;
    controller.isNeedCommet = self.taskDetailModel.isNeedCommet;
    controller.isNeedUserAccount = self.taskDetailModel.isNeedUserAccount;
    controller.taskId = self.taskId;
    controller.stepArray = self.taskDetailModel.steps;
    controller.successBlock = ^(){
        [self.webView reload];
    };
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark 任务收藏
- (void)collectionTask{
    if (!self.memberId || [self.memberId isEqualToString:@""]) {
        WDLoginViewController *loginController = [WDLoginViewController new];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
        [self presentViewController:navigationController animated:YES completion:nil];
        WeakStament(weakSelf);
        loginController.successLoginBlock = ^(){
            [weakSelf.webView reload];
            [weakSelf prepareData];
        };
        return ;
    }
    NSDictionary *param = @{@"bi.mi":self.memberId,@"type":@2,@"productId":_taskId};
    //判断是否是收藏
    WeakStament(weakSelf);
    if ([self.taskDetailModel.isCollected integerValue] == 0) {
        [WDNetworkClient postRequestWithBaseUrl:kAddMemberCollectionUrl setParameters:param  success:^(id responseObject) {
            if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
                [ToolClass showAlertWithMessage:@"收藏成功"];
                weakSelf.favoriteButton.selected = YES;
                weakSelf.taskDetailModel.isCollected = @"1";
            }else{
                [ToolClass showAlertWithMessage:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"msg"]]];
            }
        } fail:^(NSError *error) {
        } delegater:self.view];
    }else{
        [WDNetworkClient postRequestWithBaseUrl:kCancelMemberCollectionUrl setParameters:param  success:^(id responseObject) {
            [ToolClass showAlertWithMessage:@"取消收藏"];
            weakSelf.favoriteButton.selected = NO;
            weakSelf.taskDetailModel.isCollected = @"0";
        } fail:^(NSError *error) {
        } delegater:self.view];
    }
}

#pragma mark 进行数据请求
- (void)prepareData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.memberId forKey:@"bi.mi"];
    [param setObject:_taskId forKey:@"taskId"];
    WeakStament(weakSelf);
    [WDNetworkClient postRequestWithBaseUrl:kTaskDetailUrl setParameters:param success:^(id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSError *error;
        weakSelf.taskDetailModel = [[WDTaskDetailModel alloc] initWithDictionary:dict error:&error];
        YYLog(@"error = %@",error);
        if ([weakSelf.taskDetailModel.isCollected integerValue] == 0) {
            weakSelf.favoriteButton.selected = NO;
        }else{
            weakSelf.favoriteButton.selected = YES;
        }
    } fail:^(NSError *error) {
    } delegater:self.view];
};





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
