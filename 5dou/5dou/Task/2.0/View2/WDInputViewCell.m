//
//  WDInputViewCell.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDInputViewCell.h"

@interface WDInputViewCell()<UITextViewDelegate>


@end
@implementation WDInputViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _inputTextView.layer.cornerRadius = 5.0f;
    _inputTextView.layer.borderColor = kThirdLevelBlack.CGColor;
    _inputTextView.layer.borderWidth = 1.0f;
    _inputTextView.clipsToBounds = YES;
    _inputTextView.delegate = self;
    [self.layer setMasksToBounds:YES];
    self.layer.cornerRadius = 10;
    
    // Initialization code
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        if (textView.text.length > 200) {
            textView.text = [textView.text substringToIndex:200];
            return;
        }
        _inputPlaceLabel.hidden = YES;
    }else{
        _inputPlaceLabel.hidden = NO;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
