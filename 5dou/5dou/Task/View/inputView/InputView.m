//
//  InputView.m
//  TableViewDemo
//
//  Created by dudongge on 14-7-21.
//  Copyright (c) 2014年 dudongge. All rights reserved.
//



#import "InputView.h"
#import "ToolClass.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define ORINGIN_X(view) view.frame.origin.x
#define ORINGIN_Y(view) view.frame.origin.y
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define VIEW_HEIGHT(view)  view.frame.size.height

@implementation InputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [_inputTextView setFont:[UIFont fontWithName:@"BauhausITC" size:14.0]];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.palceLabel.alpha = 1.0;
    [ToolClass setView:self.inputTextView withRadius:8 andBorderWidth:1 andBorderColor:kNavigationBarColor];
    [ToolClass setView:self.publishButton withRadius:8 andBorderWidth:0 andBorderColor:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    
    
    //  CGRect keyboardEndFrameView = [self convertRect:keyboardEndFrameWindow fromView:nil];
    // 参数 ：速度  高度，时间
    if ([self.delegate respondsToSelector:@selector(keyboardWillShow:keyboardHeight:animationDuration:animationCurve:)]) {
        
        [self.delegate keyboardWillShow:self keyboardHeight:keyboardEndFrameWindow.size.height animationDuration:keyboardTransitionDuration animationCurve:keyboardTransitionAnimationCurve];
    }
    
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;// 获取键盘的速度
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&keyboardTransitionAnimationCurve];
    if ([self.delegate respondsToSelector:@selector(keyboardWillHide:keyboardHeight:animationDuration:animationCurve:)]) {
        
        [self.delegate keyboardWillHide:self keyboardHeight:keyboardEndFrameWindow.size.height animationDuration:keyboardTransitionDuration animationCurve:keyboardTransitionAnimationCurve];
    }
    
    self.palceLabel.alpha = 1;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //判断是否是emoji文字
    if ([ToolClass stringContainsEmoji:text]) {
        [ToolClass showAlertWithMessage:@"不支持输入Emoji表情文字"];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //该判断用于联想输入
    if ([ToolClass stringContainsEmoji:textView.text]) {
        [ToolClass showAlertWithMessage:@"不支持输入Emoji表情文字"];
        textView.text = [textView.text substringToIndex:textView.text.length - 2];
    }
    NSString* tureText = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //计算空格数
   

    NSInteger whiteSpaceNum = textView.text.length - tureText.length;
    if (tureText.length > 200)
    {
        [ToolClass showAlertWithMessage:@"评论最多200个字哦"];
        textView.text = [textView.text substringToIndex:200 + whiteSpaceNum];
        return;
    }
    
    if (textView.text.length != 0) {
        _palceLabel.alpha = 0;
    }else{
        _palceLabel.alpha = 1;
    }
    //计算文本的高度
    CGSize constraintSize = CGSizeMake(textView.frame.size.width-16, 60);
    CGRect sizeFrame = CGRectZero;
    
    NSDictionary *attributes = @{NSFontAttributeName:textView.font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    sizeFrame = [textView.text boundingRectWithSize:constraintSize options:options attributes:attributes context:NULL];
    
    sizeFrame.size.height += textView.font.lineHeight;
    textView.height = sizeFrame.size.height;
    [textView scrollRectToVisible:CGRectMake(0, textView.contentSize.height-10, textView.contentSize.width, 10) animated:NO];
    //重新调整textView的高度
    if ([self.delegate respondsToSelector:@selector(textViewHeightDidChange:)]) {
        [self.delegate textViewHeightDidChange:textView.size.height];
    }
    
}

- (IBAction)recordButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(recordButtonDidClick:)]) {
        [self.delegate recordButtonDidClick:sender];
    }
}

- (IBAction)addButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addButtonDidClick:)]) {
        [self.delegate addButtonDidClick:sender];
    }
}

- (IBAction)publishButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(publishButtonDidClick:)]) {
        [self.delegate publishButtonDidClick:sender];
    }
}

- (void)resetInputView
{
    self.height = 44;
    self.inputTextView.height = 30;
    [self setNeedsLayout];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.publishButton.top = self.height/2 - self.publishButton.height/2;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
