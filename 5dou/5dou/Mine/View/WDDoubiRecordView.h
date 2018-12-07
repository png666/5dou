//
//  WDDoubiRecordView.h
//  5dou
//
//  Created by rdyx on 16/10/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDDoubiRecordView;
@protocol WDDoubiRecordViewDelegate <NSObject>

-(void)doubiRecordView:(WDDoubiRecordView *)view atIndexPath:(NSIndexPath *)indexPath;

@end

@interface WDDoubiRecordView : UIView

@property(nonatomic,strong)UITableView *recordTableView;
@property(nonatomic,copy)NSString * tradeType;
@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,assign)id<WDDoubiRecordViewDelegate>delegate;

//系统默认走这个方法
//- (instancetype)initWithFrame:(CGRect)frame;

@end
