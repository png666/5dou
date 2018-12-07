//
//  WDFlowPackageCell.m
//  5dou
//
//  Created by 黄新 on 16/12/13.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  流量充值页面 流量包CollectionCell
//
//

#import "WDFlowPackageCell.h"
#import "WDFlowPackageModel.h"

@interface WDFlowPackageCell ()

@property (nonatomic, strong) UIImageView *bgimgView;
@property (nonatomic, strong) UILabel *flowPackageLabel;///< 流量包

@end

@implementation WDFlowPackageCell

#pragma mark - /*** 更新UI ***/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
    
}
#pragma mark ==== 初始化视图
- (void)initUI {
    [self.contentView addSubview:self.bgimgView];
    [self.bgimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.contentView addSubview:self.flowPackageLabel];
    [self.flowPackageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgimgView);
        make.height.width.right.mas_equalTo(self.bgimgView);
    }];
}
#pragma mark === 设置cell的选中状态
- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.flowPackageLabel.textColor = WDColorFrom16RGB(0x8b572a);
        self.bgimgView.image = [UIImage imageNamed:@"flowpage_selected"];
    }else {
        self.flowPackageLabel.textColor = WDColorFrom16RGB(0x565656);
        self.bgimgView.image = [UIImage imageNamed:@"flowpage_nor"];
    }
}

- (void)configValueWith:(WDFlowListModel *)model{
    self.flowPackageLabel.text = [NSString stringWithFormat:@"%@",model.flow];
}

#pragma mark ====== 懒加载

- (UIImageView *)bgimgView{
    if (!_bgimgView) {
        _bgimgView = [[UIImageView alloc] init];
        _bgimgView.image = [UIImage imageNamed:@"flowpage_selected"];
    }
    return _bgimgView;
}
- (UILabel *)flowPackageLabel{
    if (!_flowPackageLabel) {
        _flowPackageLabel = [[UILabel alloc] init];
        _flowPackageLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:24];
        _flowPackageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _flowPackageLabel;
}


@end
