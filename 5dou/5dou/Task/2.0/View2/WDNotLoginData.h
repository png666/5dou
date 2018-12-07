//
//  WDNotLoginData.h
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/22.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDNotLoginData : UIView
+ (WDNotLoginData *)view;
@property (weak, nonatomic) IBOutlet UIButton *resgisterBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

- (void)setImage:(UIImage *)image withInfo:(NSString *)infoStr withLeftBtn:(NSString *)leftStr withRightBtn:(NSString *)rightStr;
@end
