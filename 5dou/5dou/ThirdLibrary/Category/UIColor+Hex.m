//
//  UIColor+Hex.m
//  HomeSchoolCom
//
//  Created by lijian on 14-12-15.
//  Copyright (c) 2014年 lijian. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex: (NSString *)hexColor
{
    
//    unsigned int red,green,blue;
//	NSRange range;
//	range.length = 2;
//	
//	range.location = 0;
//	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
//	
//	range.location = 2;
//	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
//	
//	range.location = 4;
//	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
//	
//	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
    
    NSString *cleanString = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];

}

@end
