//
//  WDPayResultController.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/12/16.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDPayResultController.h"

@interface WDPayResultController ()
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UIView *successView;
//成功页面
@property (weak, nonatomic) IBOutlet UILabel *telNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//失败页面
@property (weak, nonatomic) IBOutlet UILabel *errorReason;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;

@end

@implementation WDPayResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_isSuccess) {
        _errorView.hidden = YES;
    }else{
        _successView.hidden = YES;
    }
    
    self.view.backgroundColor = kWhiteColor;
    
    [self.navigationItem setItemWithTitle:@"充值中心" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    self.returnButton.layer.cornerRadius = 3.0f;
    self.returnButton.clipsToBounds = YES;
    
    _flowNumberLabel.text = _selectedFlow;
    _errorReason.text = _errorStr;
    _telNumberLabel.text = _telephoneStr;
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f逗币",self.money];
}

//重写父类方法
-(void)backItemClick
{
    NSArray * ctrlArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:ctrlArray[1] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
