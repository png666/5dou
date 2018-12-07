//
//  TKAlertCenter.m
//  Created by Devin Ross on 9/29/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */


#import "WSAlertCenter.h"
#import "UIView+TKCategory.h"

#define kBackgroundViewTag 12000

@interface WSAlertCenter()
@property (nonatomic,retain) NSMutableArray *alerts;
@end






@implementation WSAlertCenter
@synthesize alerts;

+ (WSAlertCenter*) defaultCenter {
	static WSAlertCenter *defaultCenter = nil;
	if (!defaultCenter) {
		defaultCenter = [[WSAlertCenter alloc] init];
	}
	return defaultCenter;
}

- (id) init{
	if(!(self=[super init])) return nil;
	
	self.alerts = [NSMutableArray array];
	alertView = [[WSAlertView alloc] init];
	alertView.alpha = 0.0f;
	active = NO;
	
	[[UIApplication sharedApplication].keyWindow addSubview:alertView];

	return self;
}
- (void) showAlerts{
	
	if([self.alerts count] < 1) {
		active = NO;
		return;
	}
	
	active = YES;
	
	alertView.transform = CGAffineTransformIdentity;
	alertView.alpha = 0;
	/*
	UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	backgroundView.backgroundColor = [UIColor clearColor];
	backgroundView.tag = kBackgroundViewTag;
	[backgroundView addSubview:alertView];
	[[UIApplication sharedApplication].keyWindow addSubview:backgroundView];
	[backgroundView release];
	*/
	
	[[UIApplication sharedApplication].keyWindow addSubview:alertView];
	
	NSArray *ar = [self.alerts objectAtIndex:0];
	
	UIImage *img = nil;
	if([ar count] > 1) img = [[self.alerts objectAtIndex:0] objectAtIndex:1];
	
	[alertView setImage:img];

	if([ar count] > 0) [alertView setMessageText:[[self.alerts objectAtIndex:0] objectAtIndex:0]];
	
	alertView.center = [UIApplication sharedApplication].keyWindow.center;
    
	
	
	CGRect rr = alertView.frame;
	rr.origin.x = (int)rr.origin.x;
	rr.origin.y = (int)rr.origin.y;
	alertView.frame = rr;
	
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat degrees = 0;
	if(o == UIInterfaceOrientationLandscapeLeft ) degrees = -90;
	else if(o == UIInterfaceOrientationLandscapeRight ) degrees = 90;
	else if(o == UIInterfaceOrientationPortraitUpsideDown) degrees = 180;
	alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	alertView.transform = CGAffineTransformScale(alertView.transform, 2, 2);
	
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStep2)];
	

	alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	alertView.frame = CGRectMake((int)alertView.frame.origin.x, (int)alertView.frame.origin.y, alertView.frame.size.width, alertView.frame.size.height);
	
	alertView.alpha = 1;
	[UIView commitAnimations];
}
- (void) animationStep2{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:1.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStep3)];
	
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat degrees = 0;
	if(o == UIInterfaceOrientationLandscapeLeft ) degrees = -90;
	else if(o == UIInterfaceOrientationLandscapeRight ) degrees = 90;
	else if(o == UIInterfaceOrientationPortraitUpsideDown) degrees = 180;
	alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	alertView.transform = CGAffineTransformScale(alertView.transform, 0.5, 0.5);
	
	alertView.alpha = 0;
	[UIView commitAnimations];
}

- (void) animationStep3{
	
	[alertView removeFromSuperview];
	[alerts removeObjectAtIndex:0];
	//UIView *backView = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:kBackgroundViewTag];
	//[backView removeFromSuperview];
	[self showAlerts];
	
}
- (void) postAlertWithMessage:(NSString*)message image:(UIImage*)image{
	if (![self.alerts containsObject:[NSArray arrayWithObjects:message,image,nil]]) {
		[self.alerts addObject:[NSArray arrayWithObjects:message,image,nil]];
		if(!active) [self showAlerts];
	}
}
- (void) postAlertWithMessage:(NSString*)message{
    if (message.length>0) {
        [self postAlertWithMessage:message image:nil];
    }
}
- (void) postAlertWithMessage:(NSString *)message afterDelay:(CGFloat)delay {
	[self performSelector:@selector(postAlertWithMessage:) withObject:message afterDelay:delay];
}
- (void) dealloc{
//	[alerts release];
//	[alertView release];
//	[super dealloc];
}
- (void) postAlertWithMessageStaus:(NSInteger)status{
    
    NSString *conten = @"";
    switch (status) {
        case 1:
            conten = @"商品开抢前会给你发送提醒";
            break;
        case 4:
        case 3:
            conten = @"已抢光，重新开卖会给你发送提醒";
            break;
        default:
            conten = @"收藏成功";
            break;
    }
	[self postAlertWithMessage:conten image:nil];
}
@end





@implementation WSAlertView

- (id) init{
	
	if(!(self = [super initWithFrame:CGRectMake(0, 0, 100, 100)])) return nil;
	
	messageRect = CGRectInset(self.bounds, 3, 3);
	self.backgroundColor = [UIColor clearColor];
	
	return self;
	
}
- (void) adjust{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	CGSize s = [text sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(160,200) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
	float imageAdjustment = 0;
	if (image) {
		imageAdjustment = 7+image.size.height;
	}
	
	self.bounds = CGRectMake(0, 0, s.width+40, s.height+15+15+imageAdjustment);
	
	messageRect.size = s;
	messageRect.size.height += 5;
	messageRect.origin.x = 20;
	messageRect.origin.y = 15+imageAdjustment;

	[self setNeedsLayout];
	[self setNeedsDisplay];
	
}
- (void) setMessageText:(NSString*)str{
    text = str;
	[self adjust];
}
- (void) setImage:(UIImage*)img{
    image = img;
	
	[self adjust];
}
//-fno-objc-arc
- (void) drawRect:(CGRect)rect{
	//
	//[UIColor colorWithWhite:0 alpha:0.8]
	[UIView drawRoundRectangleInRect:rect withRadius:4 color:[UIColor colorWithWhite:0.f alpha:0.5]];
	[[UIColor whiteColor] set];
	[text drawInRect:messageRect withFont:[UIFont boldSystemFontOfSize:13] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
	
	CGRect r = CGRectZero;
	r.origin.y = 15;
	r.origin.x = (rect.size.width-image.size.width)/2;
	r.size = image.size;
	
	[image drawInRect:r];
}

@end
