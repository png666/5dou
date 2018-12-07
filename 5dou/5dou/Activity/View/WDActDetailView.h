//
//  WDActDetailView.h
//  5dou
//
//  Created by ChunXin Zhou on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActUpdateFrameBlock) (NSInteger height);
typedef void (^OpenWebViewBlock) (NSString *url);
typedef void (^CommentBlock)(NSString *commentStr);
@interface WDActDetailView : UIView
+ (WDActDetailView *)view;
@property (nonatomic,strong) NSDictionary *actDetailDict;
@property (nonatomic,copy) ActUpdateFrameBlock actUpdateFrameBlock;
@property (nonatomic,copy) OpenWebViewBlock openWebViewBlock;
@property (nonatomic,copy)
CommentBlock commentBlock;
@property (weak, nonatomic) IBOutlet UILabel *commetNumberLabel;
/**评论框*/
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@end
