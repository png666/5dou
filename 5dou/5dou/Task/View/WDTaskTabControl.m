//
//  WDTaskTabControl.m
//  5dou
//
//  Created by ChunXin Zhou on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskTabControl.h"

@interface WDTaskTabControl()
@property (weak, nonatomic) IBOutlet UIImageView *kindArrow;
@property (weak, nonatomic) IBOutlet UIImageView *sortArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortPadding;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kindPadding;
@end
@implementation WDTaskTabControl
+ (WDTaskTabControl *)view{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"WDTaskTabControl" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.autoresizingMask =
    //UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    //UIViewAutoresizingFlexibleRightMargin |
    //UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight
    //UIViewAutoresizingFlexibleBottomMargin
    ;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    
    if (device_is_iphone_4) {
        _sortPadding.constant = 30;
        _kindPadding.constant = 30;
    }else if (device_is_iphone_5) {
        _sortPadding.constant = 35;
        _kindPadding.constant = 35;
    }else if(device_is_iphone_6){
        _sortPadding.constant = 40;
        _kindPadding.constant = 40;
    }else if(device_is_iphone_6p){
        _sortPadding.constant = 45;
        _kindPadding.constant = 45;
    }
   
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}
- (IBAction)kindButtonClick:(UIButton *)sender {
    [self buttonClick:TaskFilterKind];
}

- (IBAction)sortButtonClick:(UIButton *)sender {
    [self buttonClick:TaskFilterTypeSort];
}


- (void)buttonClick:(TaskFilterType )taskFilterType{
    if (taskFilterType == TaskFilterKind) {
        //如果选中的状态，应该取消
        if (_kindButton.isSelected) {
            _controlBlock(TaskFilterRemove);
        } else{
            if (_sortButton.isSelected) {
                _sortButton.selected = NO;
                _sortArrow.image = [UIImage imageNamed:@"down_gray"];
                [self flipWithView:_sortArrow];
            }
            _controlBlock(TaskFilterKind);
        }
        _kindButton.selected = !_kindButton.isSelected;
        //如果选中，应该设为蓝色并选中180度
        if (_kindButton.selected) {
            _kindArrow.image = [UIImage imageNamed:@"down_pink"];
        }else{
            _kindArrow.image = [UIImage imageNamed:@"down_gray"];
        }
        [self flipWithView:_kindArrow];
    }else if(taskFilterType == TaskFilterTypeSort){
        if (_sortButton.isSelected) {
            _controlBlock(TaskFilterRemove);
        }else{
            if (_kindButton.isSelected) {
                _kindButton.selected = NO;
                _kindArrow.image = [UIImage imageNamed:@"down_gray"];
                [self flipWithView:_kindArrow];
            }
            _controlBlock(TaskFilterTypeSort);
        }
        _sortButton.selected = !_sortButton.isSelected;
        
        if (_sortButton.selected) {
            _sortArrow.image = [UIImage imageNamed:@"down_pink"];
        }else{
            _sortArrow.image = [UIImage imageNamed:@"down_gray"];
        }
        [self flipWithView:_sortArrow];
    }
}

- (void)closeFilterView{
    if (_kindButton.isSelected) {
        [self buttonClick:TaskFilterKind];
    }
    if (_sortButton.isSelected) {
        [self buttonClick:TaskFilterTypeSort];
    }
}

//- (void)rotateWithView:(UIView *)view withAngle:(long long)angle{
//    [UIView animateWithDuration:0.25 animations:^{
//        view.transform = CGAffineTransformMakeRotation(angle);
//    }];
//}

- (void)flipWithView:(UIView *)view{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationTransition:  UIViewAnimationTransitionFlipFromLeft forView:view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];

}
@end
