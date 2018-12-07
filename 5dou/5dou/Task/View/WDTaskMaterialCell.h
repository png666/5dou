//
//  WDTaskMaterialCell.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/8.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTaskMaterialModel.h"

@interface WDTaskMaterialCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *materialHeight;

@property (nonatomic,strong) WDTaskMaterialModel *materialModel;
@property (nonatomic,copy) NSString *materialStr;
@end
