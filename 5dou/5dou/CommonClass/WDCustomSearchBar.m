

//
//  WDCustomSearchBar.m
//  CityListDemo
//
//  Created by rdyx on 16/9/20.
//  Copyright © 2016年 林英伟. All rights reserved.
//

#import "WDCustomSearchBar.h"

@implementation WDCustomSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    UITextField *searchField;
    NSArray *subviewArr = self.subviews;
    for(int i = 0; i < subviewArr.count ; i++) {
        UIView *viewSub = [subviewArr objectAtIndex:i];
        NSArray *arrSub = viewSub.subviews;
        for (int j = 0; j < arrSub.count ; j ++) {
            id tempId = [arrSub objectAtIndex:j];
            if([tempId isKindOfClass:[UITextField class]]) {
                searchField = (UITextField *)tempId;
            }
        }
    }
    
    //自定义UISearchBar
    if(searchField) {
        searchField.placeholder = self.placeholder;
        [searchField setBorderStyle:3];
        [searchField setBackgroundColor:[UIColor whiteColor]];
        //占位字符颜色
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setTextAlignment:NSTextAlignmentLeft];
        [searchField setTextColor:[UIColor blackColor]];
        
        searchField.textColor = [UIColor whiteColor];
        
        //背景的一部分
        searchField.backgroundColor = WDColorRGB(252.f, 161.f, 179.f);
        //        searchField.leftView.backgroundColor = [UIColor lightGrayColor];
        SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
        if ([self respondsToSelector:centerSelector])
        {
            NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:centerSelector];
            //[invocation setArgument:&_hasCentredPlaceholder atIndex:2];
            [invocation invoke];
        }

        //自己的搜索图标
        UIImage *image = WDImgName(@"search");
        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        [iView setFrame:CGRectMake(0.0, 0.0, 16.0, 16.0)];
        searchField.leftView = iView;
        

    }
    //外部背景
    UIView *outView = [[UIView alloc] initWithFrame:self.bounds];
    [outView setBackgroundColor:WDColorRGB(252.f, 161.f, 179.f)];
    [self insertSubview:outView atIndex:1];
}


@end
