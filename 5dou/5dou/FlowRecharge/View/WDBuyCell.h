//
//  WDBuyCell.h
//  5dou
//
//  Created by 黄新 on 16/12/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDFlowPackageModel.h"

//购买按钮的block
typedef void(^BuyBtnDidClickBlock)(UIButton *sender ,WDFlowWholeKeyModel *model, BOOL discountBtnSelected);
//点击流量抵扣的时候刷新流量的售价
typedef void(^ReloadPriceCountBlock)(UIButton *sender ,WDFlowWholeKeyModel *model);


@class WDFlowWholeKeyModel;

@interface WDBuyCell : UITableViewCell

@property (nonatomic, strong) UILabel *priceLabel;///< 所需支付的金额
@property (nonatomic, strong) UILabel *discountLabel;///< 逗币抵扣

@property (nonatomic, copy) BuyBtnDidClickBlock buyBtnDidClickBlock;
@property (nonatomic, copy) ReloadPriceCountBlock reloadPriceCountBlock;

- (void)configValuesWith:(WDFlowWholeKeyModel *)model WalletAmount:(NSString *)walletAmount IndexPath:(NSIndexPath *)indexPath;

@end
