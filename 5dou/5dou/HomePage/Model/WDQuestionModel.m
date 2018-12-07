//
//  WDQuestion.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/6.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDQuestionModel.h"
#import "ToolClass.h"
@implementation WDQuestionModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.questionId = value;
    }
}



- (NSNumber *)getAnswerHeight:(NSString *)answer{
    NSInteger labelHeight = [ToolClass getStrHeightWithStr:answer andWidth:ScreenWidth - 20 andWithFont:kFont12];
    return [NSNumber numberWithInteger:(labelHeight + 30)];
}
@end
