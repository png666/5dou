//
//  MJRefreshGifHeader+Ext.m
//  5dou
//
//  Created by ChunXin Zhou on 16/10/12.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "MJRefreshGifHeader+Ext.h"

@implementation MJRefreshGifHeader (Ext)
+(void)initGifImage:(MJRefreshHeader *)header{
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:8];
    for (int index = 7; index >= 0; index--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d",index]];
        [imageArray addObject:image];
    }
    MJRefreshGifHeader *mjGiftHeader = (MJRefreshGifHeader *)header;

    [mjGiftHeader setImages:imageArray forState:MJRefreshStatePulling];
  
    [mjGiftHeader setImages:imageArray forState:  MJRefreshStateIdle];
    mjGiftHeader.stateLabel.textColor = WDColorFrom16RGB(0x666666);
    mjGiftHeader.stateLabel.font = [UIFont systemFontOfSize:14];
    mjGiftHeader.backgroundColor = WDColorFrom16RGB(0xF2F2F2);
  // mjGiftHeader.stateLabel.hidden = YES;
    mjGiftHeader.lastUpdatedTimeLabel.hidden = YES;
    mjGiftHeader.backgroundColor = kWhiteColor;
    
    
}
@end
