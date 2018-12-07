//
//  WDNoneData.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/13.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^NoneDataViewBlock) ();

/**
 缺省页面
 */
@interface WDNoneData : UIView
+ (WDNoneData *)view;

/**
 点击图片时候响应的block
 */
@property (nonatomic,copy) NoneDataViewBlock noneDataBlock;

/**
 页面显示的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/**
 页面上显示的文字
 */
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end
