//
//  WDContactServiceView.m
//  5dou
//
//  Created by 黄新 on 16/12/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  流量充值记录页面的 联系客服
//


#import "WDContactServiceView.h"

@interface WDContactServiceView ()


@property (nonatomic, strong) UILabel *titleLabel; ///< 标题
@property (nonatomic, strong) UILabel *contentLabel; ///< 显示内容
//@property (nonatomic, strong) UITextView *feedbackTextView;///< 反馈信息
@property (nonatomic, strong) UIImageView *contactPhone; ///< 联系电话的图标
@property (nonatomic, strong) UILabel *phoneLabel;///< 联系电话

@property (nonatomic, strong) UIView *verticalLine;///< 垂直线
@property (nonatomic, strong) UIView *horizontalLine;///< 水平线

@property (nonatomic, strong) UIButton *cancelBtn;///< 取消
@property (nonatomic, strong) UIButton *sendBtn;///< 发送


@end

@implementation WDContactServiceView

- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

#pragma mark ===== 初始化UI
- (void)initUI{
    self.backgroundColor = WDColorFrom16RGB(0xffffff);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(14);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(20);
        make.centerX.mas_equalTo(self);
    }];
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(9);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.height.mas_equalTo(34);
    }];
    [self addSubview:self.feedbackTextView];
    [self.feedbackTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentLabel);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(90);
    }];
//    [self addSubview:self.contactPhone];
//    [self.contactPhone mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.feedbackTextView);
//        make.width.height.mas_equalTo(14);
//        make.top.mas_equalTo(self.feedbackTextView.mas_bottom).offset(4);
//    }];
    [self addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.feedbackTextView.mas_bottom).offset(4);
        make.left.right.mas_equalTo(self.feedbackTextView);
        make.height.mas_equalTo(18);
    }];
//    [self addSubview:self.horizontalLine];
//    [self.horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0.5);
//        make.right.left.mas_equalTo(self);
//        make.top.mas_equalTo(self.phoneLabel.mas_bottom).offset(12);
//    }];
//    [self addSubview:self.verticalLine];
//    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self);
//        make.top.mas_equalTo(self.horizontalLine.mas_bottom);
//        make.width.mas_equalTo(0.5);
//        make.bottom.mas_equalTo(self.mas_bottom);
//    }];
    
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneLabel.mas_bottom).offset(14);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.mas_left).offset(15);
    }];
    [self addSubview:self.sendBtn];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.mas_equalTo(self.cancelBtn);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
}

#pragma mark ======= ButtonClick

//取消按钮点击事件
- (void)cancelBtnDidClick:(UIButton *)sender{
    if (self.cancelBtnDidClickBlock) {
        self.cancelBtnDidClickBlock();
    }
}
//发动按钮点击事件
- (void)sendBtnDidClick:(UIButton *)sender{
    if (self.sendBtnDidClickBlock) {
        self.sendBtnDidClickBlock();
    }
}

#pragma mark ======= 懒加载
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = WDColorFrom16RGB(0xffc200);
        _titleLabel.text = @"联系客服";
    }
    return _titleLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel  = [[UILabel alloc] init];
        _contentLabel.textColor = WDColorFrom16RGB(0x333333);
        _contentLabel.font = kFont12;
//        @"充值中遇到什么问题可以反馈给我们，5dou君收到消息后会第一时间反馈给您。"
        _contentLabel.text = [NSString stringWithFormat:@"充值中遇到什么问题可以反馈给我们，%@君收到消息后会第一时间反馈给您。",app_Name];
//        _contentLabel.backgroundColor = [UIColor redColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (UITextView *)feedbackTextView{
    if (!_feedbackTextView) {
        _feedbackTextView = [[UITextView alloc] init];
        _feedbackTextView.layer.masksToBounds = YES;
        _feedbackTextView.layer.cornerRadius = 5;
        _feedbackTextView.layer.borderWidth = 0.5;
        _feedbackTextView.layer.borderColor = WDColorFrom16RGB(0x979797).CGColor;
    }
    return _feedbackTextView;
}
- (UIImageView *)contactPhone{
    if (!_contactPhone) {
        _contactPhone = [[UIImageView alloc] init];
        _contactPhone.image = [UIImage imageNamed:@"contacts_phone"];
    }
    return _contactPhone;
}
- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = WDColorFrom16RGB(0x666666);
        _phoneLabel.font = kFont12;
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
//        _phoneLabel.text = @" 联系电话：010-66666666";
        _phoneLabel.text = @"在线客服：公众号“5dou”输入“客服”即可。";
        
    }
    return _phoneLabel;
}

- (UIView *)horizontalLine{
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.backgroundColor = WDColorFrom16RGB(0xcccccc);
    }
    return _horizontalLine;
}
- (UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = WDColorFrom16RGB(0xcccccc);
    }
    return _verticalLine;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kFont15;
        _cancelBtn.layer.cornerRadius = 10;
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.backgroundColor = WDColorFrom16RGB(0xeaeaea);
        [_cancelBtn setTitleColor:WDColorFrom16RGB(0x999999) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = kFont15;
        _sendBtn.layer.cornerRadius = 10;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.backgroundColor = WDColorFrom16RGB(0xffd300);
        [_sendBtn setTitleColor:WDColorFrom16RGB(0x8b572a) forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (void)dealloc{
    YYLog(@"WDContactServiceView----dealloc");
}

@end
