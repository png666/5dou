//
//  WDContactServiceView.h
//  5dou
//
//  Created by 黄新 on 16/12/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

//取消按钮回调
typedef void(^CancelBtnDidClickBlock)();
//发送按钮回调
typedef void(^SendBtnDidClickBlock)();

@interface WDContactServiceView : UIView

@property (nonatomic, strong) UITextView *feedbackTextView;///< 反馈信息输入框;

@property (nonatomic, copy) CancelBtnDidClickBlock  cancelBtnDidClickBlock;
@property (nonatomic, copy) SendBtnDidClickBlock sendBtnDidClickBlock;

@end
