//
//  WDFourIconViewCell.h
//  5dou
//
//  Created by rdyx on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDFourIconModel.h"
@interface WDFourIconViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel *nameLabel;

//

//网络方式
-(void)configData:(WDFourIconModel *)model;

@end
