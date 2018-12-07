//
//  WDHelpTaskView.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDHelpTaskView.h"
#import "WDHelpTaskCell.h"
#import "UITableViewCell+Ext.h"
#import "ToolClass.h"
@interface WDHelpTaskView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *stepTableView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation WDHelpTaskView

+ (WDHelpTaskView *)view{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"WDHelpTaskView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib{
    _stepTableView.delegate = self;
    _stepTableView.dataSource = self;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [ToolClass setView:_bgView withRadius:10 andBorderWidth:0 andBorderColor:nil];
    [super awakeFromNib];
}

- (void)setStepArray:(NSMutableArray *)stepArray{
    _stepArray = stepArray;
    NSMutableArray *noImageArray = [NSMutableArray arrayWithCapacity:0];
    for (WDTaskStepModel *stepModel in _stepArray) {
        if ([stepModel.isImg isEqualToString:@"1"]) {
            [noImageArray addObject:stepModel];
        }
    }
    
    [_stepArray removeObjectsInArray:noImageArray];
    [_stepTableView reloadData];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WDHelpTaskCell *taskHelpCell = [WDHelpTaskCell cellWithTableView:tableView];
    taskHelpCell.stepModel = _stepArray[indexPath.row];;
    taskHelpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return taskHelpCell;
    }


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     WDTaskStepModel *model = _stepArray[indexPath.row];
    return [ToolClass getCellHeight:model.stepInfo withFont:14 withWidth:ScreenWidth - 60] + 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _stepArray.count;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
