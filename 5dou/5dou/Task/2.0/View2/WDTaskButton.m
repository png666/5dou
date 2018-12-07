//
//  WDTaskButton.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/17.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskButton.h"

@implementation WDTaskButton

- (void)createWithTitle:(NSString *)title
                    withImage:(NSString *)image
              withSelectImage:(NSString *)selectImage
             withDisableImage:(NSString *)disableImage
                withBackImage:(NSString *)backImageView{
    [self setTitle:title forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"button_grey"] forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage imageNamed:@"button_tap"] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageNamed:backImageView] forState:UIControlStateNormal];
    
    [self setTitle:title forState:UIControlStateNormal];
    
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    [self setImage:[UIImage imageNamed:disableImage] forState:UIControlStateDisabled];
    
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:WDColorFrom16RGB(0x8B572A) forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setImageEdgeInsets:UIEdgeInsetsMake(12, -5, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(12, 0, 0, 0)];
    [self setAdjustsImageWhenHighlighted:NO];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
