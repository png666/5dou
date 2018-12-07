//
//  WDQuestion.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/6.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDQuestionModel : NSObject
@property (nonatomic,copy) NSString *questionId;
@property (nonatomic,copy) NSString *question;
@property (nonatomic,copy) NSString *answer;
@property (nonatomic,copy) NSString *type;

- (NSNumber *)getAnswerHeight:(NSString *)answer;
@end
