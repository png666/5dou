//
//  WDMemberTopView.h
//  5dou
//
//  Created by rdyx on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDMemberTopView : UIView

@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,strong)UILabel *loginLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *IDLabel;
@property(nonatomic,strong)UIImageView *genderImage;

@property(nonatomic,strong)UIView *doubiView;
@property(nonatomic,strong)UIView *taskCardView;
@property(nonatomic,strong)UIView *myTaskView;
@property(nonatomic,strong)UILabel *doubiCountLabel;
@property(nonatomic,strong)UILabel *cardCountLabel;
@property(nonatomic,strong)UILabel *myTaskCountLabel;

@end
