//
//  WDCashBarView.h
//  5dou
//
//  Created by rdyx on 16/11/19.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^barBlock)(NSInteger index);
@interface WDCashBarView : UIView
@property(nonatomic,strong)UIView *cardView;
@property(nonatomic,strong)UIView *cashView;
@property(nonatomic,strong)UIView *signView;
@property(nonatomic,strong)UILabel *cardNumLabel;
@property(nonatomic,strong)UILabel *cashNumLabel;
@property(nonatomic,strong)UILabel *isSignLabel;
@property(nonatomic,copy)barBlock block;
@property(nonatomic,assign)BOOL isDoubiIView;
@end
