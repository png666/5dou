//
//  WDInputViewCell.h
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDInputViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *inputTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *inputPlaceLabel;

@end
