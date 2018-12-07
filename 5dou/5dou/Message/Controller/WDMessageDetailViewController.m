//
//  WDMessageDetailViewController.m
//  5dou
//
//  Created by 黄新 on 16/9/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  消息详情
//

#import "WDMessageDetailViewController.h"
#import "WDMessageTypeCell.h"
#import "WDDefaultAccount.h"
#import "WDMessageInfoModel.h"
#import "ToolClass.h"


@interface WDMessageDetailViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;


@property (nonatomic, strong) UIView *bgview;

@property (nonatomic, strong) WDMessageInfoModel *messageInfoModel;///< 存放消息详情按钮
@property (nonatomic, assign) CGFloat contentLabelHeight;///< 计算字体的高度

@end

@implementation WDMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setItemWithTitle:@"消息详情" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    
    [self requestData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataModel) {
        self.contentLabelHeight = [ToolClass getStrHeightWithStr:self.dataModel.msgDesc andWidth:ScreenWidth - 50 andWithFont:kFont12];
    }
    [self initUI];
    
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:DISMISS_MESSAGE_BADGE object:nil];
}

- (void)initUI{
    //时间
    [self.view addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(15.f);
        make.top.mas_equalTo(self.view.mas_top).offset(5.f);
        make.width.mas_equalTo(160.f);
    }];
    
    [self.view addSubview:self.bgview];
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10.f);
        make.left.mas_equalTo(self.view.mas_left).offset(10.f);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(5.f);
        make.height.mas_equalTo(self.contentLabelHeight+50.f);
    }];
    //标题
    [self.bgview addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgview.mas_left).offset(15.f);
        make.right.mas_equalTo(self.bgview.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.bgview.mas_top).mas_equalTo(15.f);
        make.height.mas_equalTo(16.f);
    }];
    //内容
    [self.bgview addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(self.contentLabelHeight);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5.f);
    }];
}
//- (void)configModel:(MemberDataModel *)model{
//    _timeLabel.text = model.sendTime;
//    _contentLabel.text = model.msgDesc;
//    _titleLabel.text = model.msgTitle;
//}
#pragma mark ===== 绑定数据信息
- (void)configModel:(WDMessageInfoDataModel *)model{
    _timeLabel.text = model.sendTime;
    _contentLabel.text = model.msgDesc;
    _titleLabel.text = model.msgTitle;
}
#pragma mark --- 数据请求
- (void)requestData{
    WeakStament(wself);
    NSDictionary *dic = @{@"messageId":self.messageId};
    [WDNetworkClient postRequestWithBaseUrl:kMessageInfoUrl setParameters:dic success:^(id responseObject) {
        WDMessageInfoModel *model = [[WDMessageInfoModel alloc] initWithDictionary:responseObject error:nil];
        if ([model.result.code isEqualToString:@"1000"]) {
            [wself configModel:model.data];
        }else{
            [ToolClass showAlertWithMessage:@"请求数据失败"];
        }
    } fail:^(NSError *error) {
        YYLog(@"%@",error);
    } delegater:self.view];
}
#pragma mark --- 懒加载
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = WDColorFrom16RGB(0x666666);
        _timeLabel.font = kFont12;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
//        _timeLabel.backgroundColor = [UIColor redColor];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = WDColorFrom16RGB(0x999999);
        _contentLabel.font = kFont12;
        _contentLabel.numberOfLines = 0;
//        _contentLabel.backgroundColor = [UIColor redColor];
        
    }
    return _contentLabel;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont14;
        _titleLabel.textColor = WDColorFrom16RGB(0x666666);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
//        _titleLabel.backgroundColor = [UIColor redColor];
        
    }
    return _titleLabel;
}
- (UIView *)bgview{
    if (!_bgview) {
        _bgview = [[UIView alloc] init];
        _bgview.backgroundColor = WDColorFrom16RGB(0xffffff);
    }
    return _bgview;
}




@end
