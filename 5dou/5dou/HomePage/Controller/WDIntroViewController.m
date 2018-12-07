

//
//  WDIntroViewController.m
//  5dou
//
//  Created by rdyx on 16/9/16.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDIntroViewController.h"
#import "WDMainTabBarController.h"
#import "AppDelegate.h"

@interface WDIntroViewController ()<UIScrollViewDelegate>

{
    UIPageControl *_control;
    UIScrollView *_scrollView;
}


@end

@implementation WDIntroViewController
#define count 3
#define iPhone5 568
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    // Do any additional setup after loading the view.
}


-(void)configUI
{
    
    //    self.navigationController.navigationBarHidden = YES;
    //    self.view.backgroundColor = [UIColor clearColor];
    //    //
    //    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    //    statusBarView.backgroundColor=[UIColor whiteColor];
    //    [self.view addSubview:statusBarView];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    UIScrollView *uiScrollview = [[UIScrollView alloc] init];
    uiScrollview.frame = self.view.bounds;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    [self.view addSubview:uiScrollview];
    
    for (int i = 0; i < count; i++) {
        
        //        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"introduction_%d" ofType:@"png"];
        //        UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
        
        NSString *imageName = [NSString  stringWithFormat:@"guideImage%d.jpg" ,i+1];
//         NSString *imageName = [NSString  stringWithFormat:@"guide%d" ,i+1];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake(i*width, 0, width, height);
        [uiScrollview addSubview:imageView];
        
        CGFloat startBtnBottom = 95;
        if (device_is_iphone_4||device_is_iphone_5) {
            startBtnBottom = 95;
        }else if (device_is_iphone_6){
            startBtnBottom = 110;
        }else if (device_is_iphone_6p){
            startBtnBottom = 123;
        }
        
        if (i == count-1) {
            UIButton* startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            startBtn.frame = CGRectMake(100, ScreenHeight - startBtnBottom, ScreenWidth - 150, 50);
//            startBtn.center = CGPointMake(ScreenWidth/2, ScreenHeight-90);
            startBtn.centerX = self.view.centerX;
            startBtn.layer.cornerRadius = 5;
//            startBtn.layer.borderWidth = 0.5;
            startBtn.layer.masksToBounds = YES;
            [startBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [startBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
            [startBtn setBackgroundColor:kClearColor];
//            [startBtn setTitle:@"开始体验" forState:UIControlStateNormal];
            [imageView addSubview:startBtn];
        }
        
    }
    _scrollView = uiScrollview;
    uiScrollview.showsHorizontalScrollIndicator = NO;
    uiScrollview.showsVerticalScrollIndicator = NO;
    uiScrollview.contentSize = CGSizeMake(count*width, height);
    uiScrollview.pagingEnabled = YES;
    uiScrollview.bounces = NO;
    uiScrollview.backgroundColor = [UIColor clearColor];
    uiScrollview.delegate = self;
    
    UIPageControl *control = [[UIPageControl alloc] init];
    control.numberOfPages = count;
    control.bounds = CGRectMake(0, 0, 200, 50);
    control.center = CGPointMake(width*0.5, height-50);
    control.currentPage = 0;
    control.layer.cornerRadius = 8;
    control.pageIndicatorTintColor = [UIColor lightGrayColor];
    control.currentPageIndicatorTintColor = [UIColor orangeColor];
    //    control.backgroundColor = [UIColor orangeColor];
    
    _control = control;
    [_control addTarget:self action:@selector(onPointClick) forControlEvents:UIControlEventValueChanged];
    
    //因为设计图直接给了小点，所以将小点去掉
    
//    [self.view addSubview:control];
    
    
#if 0
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(80, 400, 80, 40);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:loginBtn];
    
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(160, 400, 80, 40);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:registerBtn];
#endif

    
}


-(void)loginBtnClicked:(UIButton *)btn{
    
    //    LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    //    [self.navigationController pushViewController:login animated:YES];
    //    [UIApplication sharedApplication].keyWindow.rootViewController = login;
    //    [self presentViewController:login animated:YES completion:nil];
    
    
    
}

-(void)registerBtnClicked:(UIButton *)btn{
    
    //       RegisterViewController *regis = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    //    regis.flag = @"f";
    ////    [UIApplication sharedApplication].keyWindow.rootViewController = regis;
    ////    [self presentViewController:regis animated:YES completion:nil];
    //
    //    [self.navigationController pushViewController:regis animated:YES];
    
}

-(void)closeView{
    
    //因为这些控制器没有交给导航来管理所以点击没有反应
    //    TabBarViewController *tab = [[TabBarViewController alloc]init];
    [UIView animateWithDuration:.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        //        AppDelegate *app = [UIApplication sharedApplication].delegate;
        WDMainTabBarController *tab = [[WDMainTabBarController alloc]init];
        AppDelegate *appDelegate = (id)([UIApplication sharedApplication].delegate);
        appDelegate.window.rootViewController = tab;
        //        [appDelegate initRootViewCtrlByTabBar];
        
    }];
}

- (void) onPointClick
{
    CGFloat offsetX = _control.currentPage * _scrollView.frame.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentOffset = CGPointMake(offsetX, 0);
    }];
    
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
