//
//  WDModifyNickNameViewController.h
//  5dou
//
//  Created by rdyx on 16/9/2.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"

typedef void (^ nickNameBlock)(NSString *nickNameString);

@interface WDModifyNickNameViewController : WDBaseViewController

@property(nonatomic,copy)nickNameBlock nickNameBlock;
@property(nonatomic,copy) NSString *nickName;
@end
