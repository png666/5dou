//
//  InputView.h
//  TableViewDemo
//
//  Created by dudongge on 14-7-21.
//  Copyright (c) 2014年 dudongge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InputView;

@protocol InputViewDelegate <NSObject>

@optional
- (void)keyboardWillShow:(InputView *)inputView keyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)animationCurve;

- (void)keyboardWillHide:(InputView *)inputView keyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)animationCurve;

- (void)recordButtonDidClick:(UIButton *)button;

- (void)addButtonDidClick:(UIButton *)button;

- (void)publishButtonDidClick:(UIButton *)button;

- (void)textViewHeightDidChange:(CGFloat)height;

@end

@interface InputView : UIView <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) id<InputViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *palceLabel;
- (IBAction)publishButtonClick:(id)sender;
- (void)resetInputView;
@end
