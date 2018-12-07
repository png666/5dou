

//
//  UIFont+WDCustom.m
//  5dou
//
//  Created by rdyx on 16/10/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "UIFont+WDCustom.h"

@implementation UIFont (WDCustom)

+ (UIFont *)fontOfSize:(CGFloat)fontSize
{
    if (ScreenWidth>375) {
        
        return [UIFont systemFontOfSize :(fontSize+3.0f)];
    }else
    {
        return [UIFont systemFontOfSize:fontSize];
    }

}


@end
