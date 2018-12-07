//
//  PayWayView.h
//  tesssst
//
//  Created by rdyx on 16/12/13.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^payBlock)(NSInteger index);

@interface PayWayView : UIView



@property (weak, nonatomic) IBOutlet UIButton *btn;
@property(nonatomic,copy)payBlock  block;

@end
