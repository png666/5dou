//
//  WDTaskButton.h
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/17.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDTaskButton : UIButton
- (void)createWithTitle:(NSString *)title
              withImage:(NSString *)image
        withSelectImage:(NSString *)selectImage
       withDisableImage:(NSString *)disableImage
          withBackImage:(NSString *)backImageView;
@end
