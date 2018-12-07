//
//  WDSearchTextCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/10/8.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDSearchTextCell.h"
#import "YYText.h"
@interface WDSearchTextCell()
@property (nonatomic,strong)  YYLabel *searchText;

@end
@implementation WDSearchTextCell

- (void)awakeFromNib{
    [super awakeFromNib];
   
}


- (void)setSearchTextStr:(NSString *)searchTextStr{
    _searchTextStr = searchTextStr;
    
    
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:searchTextStr];
        one.yy_font = [UIFont boldSystemFontOfSize:20];
        one.yy_color = kNavigationTitleColor;
        
        YYTextBorder *border = [YYTextBorder new];
        border.strokeColor = kNavigationTitleColor;
        border.strokeWidth = 2;
        border.lineStyle =   YYTextLineStylePatternCircleDot;
        border.insets = UIEdgeInsetsMake(- 10, -25, - 10, -25);
        border.cornerRadius = 22;
        one.yy_textBackgroundBorder = border;
        
        [text appendAttributedString:one];
    }
    _searchText = [[YYLabel alloc] initWithFrame:CGRectMake(-10, 0, ScreenWidth, 100)];
    _searchText.attributedText = text;
    _searchText.textAlignment = NSTextAlignmentCenter;
    _searchText.clipsToBounds = YES;
    [self.contentView addSubview:_searchText];
    
    self.backgroundColor = kBackgroundColor;
    //创建长按手势
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _searchText.userInteractionEnabled = YES;
    [_searchText addGestureRecognizer:longPressReger];

}

-(void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    [self becomeFirstResponder];
    UIMenuItem * itemPase = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyAction:)];
    UIMenuController * menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems: @[itemPase]];
    
    CGPoint location = [longPress locationInView:[longPress view]];
    CGRect menuLocation = CGRectMake(location.x, location.y, 0, 0);
    [menuController setTargetRect:menuLocation inView:[longPress view]];
    menuController.arrowDirection = UIMenuControllerArrowDown;
    [menuController setMenuVisible:YES animated:YES];
}

#pragma mark 进行拷贝
- (void)copyAction:(id)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:_searchTextStr];
    if ([_delegate respondsToSelector:@selector(didClickedCopyOnSerachTextCell:)]) {
        [_delegate didClickedCopyOnSerachTextCell:self];
    }
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action == @selector(copyAction:)) {
        return YES;
    }
    
    return NO;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}




- (void)copySearchText{
    
}
@end
