//
//  WDTextField.m
//  5dou
//
//  Created by 黄新 on 16/9/12.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  底层TextField  设置一些基本的属性
// 

#import "WDTextField.h"
#import "ToolClass.h"


@interface WDTextField ()<UITextFieldDelegate>

@end

@implementation WDTextField

- (instancetype)init{
    if (self = [super init]) {
        self.textColor = WDColorFrom16RGB(0x666666);
        self.font = kFont14;
        self.delegate = self;
        [self setValue:WDColorFrom16RGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        [self setValue:kFont15 forKeyPath:@"_placeholderLabel.font"];
//        self.backgroundColor = [UIColor redColor];
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}
/**
 *  @brief 屏蔽emoji表情
 *
 *  @param textField textField description
 *  @param range     <#range description#>
 *  @param string    <#string description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *lang = [[textField textInputMode] primaryLanguage];
    if ([lang isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField {
    if ([ToolClass stringContainsEmoji:textField.text]) {
        textField.text = [textField.text substringToIndex:textField.text.length - 2];
    }
}


@end
