//
//  PTSProgressHUD.m
//  LoadingTest
//
//  Created by 黄杰 on 15/11/27.
//  Copyright © 2015年 黄杰. All rights reserved.
//

#import "PTSProgressHUD.h"
#import <ImageIO/ImageIO.h>

NSString * const PTSProgressHUDDidReceiveTouchEventNotification = @"PTSProgressHUDDidReceiveTouchEventNotification";
NSString * const PTSProgressHUDDidTouchDownInsideNotification = @"PTSProgressHUDDidTouchDownInsideNotification";
NSString * const PTSProgressHUDWillDisappearNotification = @"PTSProgressHUDWillDisappearNotificationn";
NSString * const PTSProgressHUDDidDisappearNotificationn = @"PTSProgressHUDDidDisappearNotificationn";
NSString * const PTSProgressHUDWillShowAnimationNotificationn = @"PTSProgressHUDWillShowAnimationNotificationn";
NSString * const PTSProgressHUDDidShowAnimationNotificationn = @"PTSProgressHUDDidShowAnimationNotificationn";

NSString * const PTSProgressHUDStatusUserInfoKey = @"PTSProgressHUDStatusUserInfoKey";

@interface PTSProgressHUD () {
    BOOL _isInitializing;
}
@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIView *hudView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSLayoutConstraint *gitImageCenterX;
@property (nonatomic, strong) NSLayoutConstraint *gitImageCenterY;
@property (nonatomic, assign) BOOL hasLoadImg;

@end

#define Size            64
#define FadeDuration    0.5
#define GifSpeed        0.1

#define APPDELEGATE     ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif



#pragma mark - UIImage Animated GIF


@implementation UIImage (animatedGIF)

static int delayCentisecondsForImageAtIndex(CGImageSourceRef const source, size_t const i) {
    int delayCentiseconds = 1;
    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
    if (properties) {
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        if (gifProperties) {
            NSNumber *number = fromCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
            if (number == NULL || [number doubleValue] == 0) {
                number = fromCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            }
            if ([number doubleValue] > 0) {
                // Even though the GIF stores the delay as an integer number of centiseconds, ImageIO “helpfully” converts that to seconds for us.
                delayCentiseconds = (int)lrint([number doubleValue] * 100);
            }
        }
        CFRelease(properties);
    }
    return delayCentiseconds;
}

static void createImagesAndDelays(CGImageSourceRef source, size_t count, CGImageRef imagesOut[count], int delayCentisecondsOut[count]) {
    for (size_t i = 0; i < count; ++i) {
        imagesOut[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        delayCentisecondsOut[i] = delayCentisecondsForImageAtIndex(source, i);
    }
}

static int sum(size_t const count, int const *const values) {
    int theSum = 0;
    for (size_t i = 0; i < count; ++i) {
        theSum += values[i];
    }
    return theSum;
}

static int pairGCD(int a, int b) {
    if (a < b)
        return pairGCD(b, a);
    while (true) {
        int const r = a % b;
        if (r == 0)
            return b;
        a = b;
        b = r;
    }
}

static int vectorGCD(size_t const count, int const *const values) {
    int gcd = values[0];
    for (size_t i = 1; i < count; ++i) {
        // Note that after I process the first few elements of the vector, `gcd` will probably be smaller than any remaining element.  By passing the smaller value as the second argument to `pairGCD`, I avoid making it swap the arguments.
        gcd = pairGCD(values[i], gcd);
    }
    return gcd;
}

static NSArray *frameArray(size_t const count, CGImageRef const images[count], int const delayCentiseconds[count], int const totalDurationCentiseconds) {
    int const gcd = vectorGCD(count, delayCentiseconds);
    size_t const frameCount = totalDurationCentiseconds / gcd;
    UIImage *frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i) {
        UIImage *const frame = [UIImage imageWithCGImage:images[i]];
        for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
            frames[f++] = frame;
        }
    }
    return [NSArray arrayWithObjects:frames count:frameCount];
}

static void releaseImages(size_t const count, CGImageRef const images[count]) {
    for (size_t i = 0; i < count; ++i) {
        CGImageRelease(images[i]);
    }
}

static UIImage *animatedImageWithAnimatedGIFImageSource(CGImageSourceRef const source) {
    size_t const count = CGImageSourceGetCount(source);
    CGImageRef images[count];
    int delayCentiseconds[count]; // in centiseconds
    createImagesAndDelays(source, count, images, delayCentiseconds);
    int const totalDurationCentiseconds = sum(count, delayCentiseconds);
    NSArray *const frames = frameArray(count, images, delayCentiseconds, totalDurationCentiseconds);
    UIImage *const animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
    releaseImages(count, images);
    return animation;
}

static UIImage *animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceRef CF_RELEASES_ARGUMENT source) {
    if (source) {
        UIImage *const image = animatedImageWithAnimatedGIFImageSource(source);
        CFRelease(source);
        return image;
    } else {
        return nil;
    }
}

+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)data {
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithData(toCF data, NULL));
}

+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)url {
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithURL(toCF url, NULL));
}

@end

@implementation PTSProgressHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isInitializing = YES;
        
        self.translatesAutoresizingMaskIntoConstraints = YES;
        self.userInteractionEnabled = NO;
        _bgColor = [UIColor whiteColor];
        _titleColor = [UIColor blackColor];
        _titleSize = [UIFont systemFontOfSize:17];
        _titleMargin = 10;
        _gifImgRatio = 0.2;
        self.alpha = 0.0;
        
        _isInitializing = NO;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  设置单例
 */
+ (PTSProgressHUD *)shareView {
    static dispatch_once_t onceToken;
    static PTSProgressHUD *shareView;
    
#if !defined(SV_APP_EXTENSIONS)
    dispatch_once(&onceToken, ^{
        shareView = [[self alloc] initWithFrame:[[UIApplication sharedApplication].delegate window].bounds];
    });
#else
    dispatch_once(&onceToken, ^{
        shareView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
#endif
    
    return shareView;
}

#pragma mark - Show/Hide
+ (void)show
{
    [self showWithGifImagePath:@"PTS80.bundle/default.gif" withTitle:nil];
}

+ (void)showWithGifImagePath:(NSString *)imagePath withTitle:(NSString *)title
{
    [[self shareView] showProgressWithImagePath:imagePath title:title];
}

+ (void)showToView:(UIView *)toView
{
    [self showWithGifImagePath:@"PTS80.bundle/default.gif" withTitle:nil toView:toView];
}

+ (void)showWithGifImagePath:(NSString *)imagePath withTitle:(NSString *)title toView:(UIView *)toView
{
    if (toView) {
        [self setToView:toView];
    }
    
    [[self shareView] showProgressWithImagePath:imagePath title:title];
}

+ (void)hide
{
    if ([self isVisible]) {
        [[self shareView] dismiss];
    }
}

#pragma mark - SET/GET
- (void)setGifImageName:(NSString *)gifImageName
{
    if (!_isInitializing) {
        _gifImageName = gifImageName;
    }
}
- (void)setTitleStr:(NSString *)titleStr
{
    if (!_isInitializing) {
        _titleStr = titleStr;
    }
}
- (void)setTitleColor:(UIColor *)titleColor
{
    if (!_isInitializing) {
        _titleColor = titleColor;
    }
}
- (void)setTitleSize:(UIFont *)titleSize
{
    if (!_isInitializing) {
        _titleSize = titleSize;
    }
}
- (void)setTitleMargin:(CGFloat)titleMargin
{
    if (!_isInitializing) {
        _titleMargin = titleMargin;
    }
}
- (void)setGifImgRatio:(CGFloat)gifImgRatio
{
    if (!_isInitializing) {
        _gifImgRatio = gifImgRatio;
    }
}
- (void)setBgColor:(UIColor *)bgColor
{
    if (!_isInitializing) {
        _bgColor = bgColor;
        if (self.overlayView) {
            self.overlayView.backgroundColor = bgColor;
        }
    }
}
- (void)setViewForExtension:(UIView *)viewForExtension
{
    if (!_isInitializing) {
        _viewForExtension = viewForExtension;
    }
}
- (void)setToView:(UIView *)toView
{
    if (!_isInitializing) {
        _toView = toView;
    }
}

- (UIControl *)overlayView
{
    if (!_overlayView) {
        _overlayView = [[UIControl alloc] init];
        _overlayView.translatesAutoresizingMaskIntoConstraints = NO;
        _overlayView.backgroundColor = self.bgColor;
        _overlayView.clipsToBounds = true;
        [_overlayView addTarget:self action:@selector(didReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return _overlayView;
}
- (UIView *)hudView
{
    if (!_hudView) {
        _hudView = [[UIView alloc] init];
        _hudView.translatesAutoresizingMaskIntoConstraints = NO;
        _hudView.backgroundColor = [UIColor clearColor];
        
    }
    
    if (!_hudView.superview) {
        [self.overlayView addSubview:_hudView];
        [self.overlayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[hudView]-0-|" options:0 metrics:nil views:@{@"hudView": _hudView}]];
        [self.overlayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[hudView]-0-|" options:0 metrics:nil views:@{@"hudView": _hudView}]];
    }
    
    return _hudView;
}
- (UIImageView *)gifImageView
{
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc] init];
        _gifImageView.translatesAutoresizingMaskIntoConstraints = NO;
        if (!_gifImageView.superview) {
            [self.hudView addSubview:_gifImageView];
            self.gitImageCenterX = [NSLayoutConstraint constraintWithItem:_gifImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0.0];
            self.gitImageCenterY = [NSLayoutConstraint constraintWithItem:_gifImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.0];
            [self.hudView addConstraint:self.gitImageCenterX];
            [self.hudView addConstraint:self.gitImageCenterY];
        }
    }
    return _gifImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = self.titleSize;
        _titleLabel.textColor = self.titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        if (!_titleLabel.superview) {
            [self.hudView addSubview:_titleLabel];
            [self.hudView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.gifImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0.0]];
            [self.hudView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.gifImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:self.titleMargin]];
            [self.hudView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
            [self.hudView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.hudView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        }
    }
    return _titleLabel;
}

#pragma mark - Public Method
+ (void)setGifImageName:(NSString *)gifImageName
{
    [self shareView].gifImageName = gifImageName;
}
+ (void)setTitleStr:(NSString *)titleStr
{
    [self shareView].titleStr = titleStr;
}
+ (void)setTitleColor:(UIColor *)titleColor
{
    [self shareView].titleColor = titleColor;
}
+ (void)setTitleSize:(UIFont *)titleSize
{
    [self shareView].titleSize = titleSize;
}
+ (void)setTitleMargin:(CGFloat)titleMargin
{
    [self shareView].titleMargin = titleMargin;
}
+ (void)setGifImgRatio:(CGFloat)gifImgRatio
{
    [self shareView].gifImgRatio = MAX(-1, MIN(gifImgRatio, 1));
}
+ (void)setBgColor:(UIColor *)bgColor
{
    [self shareView].bgColor = bgColor;
}
+ (void)setviewForExtension:(UIView *)viewForExtension
{
    [self shareView].viewForExtension = viewForExtension;
}
+ (void)setToView:(UIView *)toView
{
    [self shareView].toView = toView;
}

#pragma mark - Private Method
- (void)showProgressWithImagePath:(NSString *)imagePath title:(NSString *)title
{
    // 监听通知
    [self addNotification];
    
    if (!self.overlayView.superview) { // 如果UIControl的父控件不存在
#if !defined(SV_APP_EXTENSIONS)
        
        // 如果指定的view存在
        if (self.toView) {
            [self.toView addSubview:self.overlayView];
            [self.toView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[overlayView]-0-|" options:0 metrics:nil views:@{@"overlayView": self.overlayView}]];
            [self.toView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[overlayView]-0-|" options:0 metrics:nil views:@{@"overlayView": self.overlayView}]];
        } else {
            NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
            for (UIWindow *window in frontToBackWindows) {
                BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
                BOOL windowIsVisible = !window.hidden && window.alpha > 0;
                BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
                
                if(windowOnMainScreen && windowIsVisible && windowLevelNormal){
                    [window addSubview:self.overlayView];
                    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[overlayView]-0-|" options:0 metrics:nil views:@{@"overlayView": self.overlayView}]];
                    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[overlayView]-0-|" options:0 metrics:nil views:@{@"overlayView": self.overlayView}]];
                    break;
                }
            }
        }
        
        
#else
        if (self.viewForExtension) {
            [self.viewForExtension addSubView:self.overlayView];
            [self.viewForExtension addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[overlayView]-0-|" options:0 metrics:nil views:@{@"overlayView": self.overlayView}]];
            [self.viewForExtension addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[overlayView]-0-|" options:0 metrics:nil views:@{@"overlayView": self.overlayView}]];
        }
#endif
    } else { // 如果UIControl的父控件存在
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    // 如果view的父控件不存在
    if (!self.superview) {
        [self.overlayView addSubview:self];
    }
    
    if (!self.hasLoadImg) {
        // 添加gif图片
        if (self.gifImageName) {
            self.gifImageView.image = [UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:self.gifImageName withExtension:nil]];
        } else {
            if (imagePath) {
                self.gifImageView.image = [UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:imagePath withExtension:nil]];
            } else {
                self.gifImageView.image = [UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"PTSProgressHUD.bundle/default.gif" withExtension:nil]];
            }
        }
        
        // 添加文字
        if (self.titleStr) {
            self.titleLabel.text = self.titleStr;
        } else {
            if (title) {
                self.titleLabel.text = title;
            }
        }
        
        // 调整图片和文字的位置
        [self updateImageAndTitleFrame];
        
        self.hasLoadImg = YES;
        
    }
    
    // 展示
    if (self.alpha != 1 || self.overlayView.alpha != 1) {
        // 发送通知
        NSDictionary *userInfo = [self notificationUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:PTSProgressHUDWillShowAnimationNotificationn object:nil userInfo:userInfo];
        
        // 增加动画
        self.overlayView.alpha = 1.0;
        self.alpha = 1.0;
        [[NSNotificationCenter defaultCenter] postNotificationName:PTSProgressHUDDidShowAnimationNotificationn object:nil userInfo:userInfo];
//        [UIView animateWithDuration:0.3 animations:^{
////            self.hudView.transform = CGAffineTransformMakeScale(1, 1);
//            self.overlayView.alpha = 1.0;
//            self.alpha = 1.0;
//        } completion:^(BOOL finished) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:PTSProgressHUDDidShowAnimationNotificationn object:nil userInfo:userInfo];
//        }];

    }
    
    
}

- (void)didReceiveTouchEvent:(id)sender forEvent:(UIEvent *)event
{
    // 点击了UIControl时发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:PTSProgressHUDDidReceiveTouchEventNotification object:event];
    
    UITouch *touch = event.allTouches.anyObject;
    CGPoint touchLocation = [touch locationInView:self];
    
    // 点击了hubView发送通知
    if (CGRectContainsPoint(self.hudView.frame, touchLocation)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PTSProgressHUDDidTouchDownInsideNotification object:event];
    }
}

- (void)updateImageAndTitleFrame
{
    // 获取图片的高度
    CGFloat gifImgH = self.gifImageView.image.size.height;
    // 重新设置约束
    CGFloat newImageCenterY = -gifImgH * self.gifImgRatio;
    self.gitImageCenterY.constant = newImageCenterY;
    
    [self layoutIfNeeded];
}

+ (BOOL)isVisible{
    return ([self shareView].alpha == 1);
}

- (NSDictionary*)notificationUserInfo{
    return (self.titleLabel.text ? @{PTSProgressHUDStatusUserInfoKey : self.titleLabel.text} : nil);
}

- (void)dismiss
{
    // 发送即将隐藏通知
    NSDictionary *userInfo = [self notificationUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:PTSProgressHUDWillDisappearNotification object:nil userInfo:userInfo];
    
    // 取消动画
    [UIView animateWithDuration:0.5 delay:0 options:(UIViewAnimationOptions) (UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction) animations:^{
        //        self.hudView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.alpha = 0.0;
        self.overlayView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.overlayView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:PTSProgressHUDDidDisappearNotificationn object:nil userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTouchEvent) name:PTSProgressHUDDidReceiveTouchEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHubViewEvent) name:PTSProgressHUDDidTouchDownInsideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hubViewWillShow) name:PTSProgressHUDWillShowAnimationNotificationn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hubViewDidShow) name:PTSProgressHUDDidShowAnimationNotificationn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hubViewWillHide) name:PTSProgressHUDWillDisappearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hubViewDidHide) name:PTSProgressHUDDidDisappearNotificationn object:nil];
}

- (void)didReceiveTouchEvent
{
    [self willSendStatusToDelegate:PTSProgressStatusClickUIControl];
}

- (void)didHubViewEvent
{
    [self willSendStatusToDelegate:PTSProgressStatusClickHudView];
}

- (void)hubViewWillShow
{
    [self willSendStatusToDelegate:PTSProgressStatusWillShowHudView];
}

- (void)hubViewDidShow
{
    [self willSendStatusToDelegate:PTSProgressStatusDidShowHudView];
}

- (void)hubViewWillHide
{
    [self willSendStatusToDelegate:PTSProgressStatusWillHideHudView];
}

- (void)hubViewDidHide
{
    [self willSendStatusToDelegate:PTSProgressStatusDidHideHudView];
}

- (void)willSendStatusToDelegate:(PTSProgressStatus)status
{
    if ([self.delegate respondsToSelector:@selector(PTSProgressHUDGetHudViewStatus:)]) {
        [self.delegate PTSProgressHUDGetHudViewStatus:status];
    }
    
    if (self.statusBlock) {
        self.statusBlock(status);
    }
}

@end
