//
//  WDMyDoubiBarView.h
//  5dou
//
//  Created by rdyx on 16/10/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDMyDoubiBarView : UIControl

@property(nonatomic,strong)UILabel *titleLabel;

-(instancetype)initWithTitle:(NSString *)titleName withSize:(CGSize)size;

@end
