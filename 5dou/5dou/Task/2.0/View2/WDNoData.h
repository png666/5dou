//
//  WDNoData.h
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/22.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDNoData : UIView
+ (WDNoData *)view;
@property (weak, nonatomic) IBOutlet UIButton *goMakeMoneyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

- (void)setImage:(UIImage *)image withInfo:(NSString *)infoStr withBtn:(NSString *)btnStr;
@end
