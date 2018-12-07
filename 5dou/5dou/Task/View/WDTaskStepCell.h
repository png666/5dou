//
//  WDTaskStepCell.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/8.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTaskStepModel.h"
typedef void (^StepImageClickBlock) (NSString *imageUrl,NSInteger index);
@interface WDTaskStepCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic,strong) WDTaskStepModel *stepModel;
@property (weak, nonatomic) IBOutlet UIImageView *stepImageView;
@end
