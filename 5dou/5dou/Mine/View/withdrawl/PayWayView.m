//
//  PayWayView.m
//  tesssst
//
//  Created by rdyx on 16/12/13.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "PayWayView.h"

@interface PayWayView()
@property (weak, nonatomic) IBOutlet UIButton *aliBtn;

@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property(nonatomic,strong)UIView *a;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation PayWayView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self makeUI];
        //        [self testUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (IBAction)btnAction:(id)sender {
    NSLog(@"heheeh");
}

-(void)makeUI{
    
    //这里的代码是没有效果的
  
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
   
    self.bgView.layer.cornerRadius = 5.f;
    self.bgView.layer.masksToBounds = YES;
    self.weixinBtn.layer.cornerRadius = 25.f;
    self.weixinBtn.backgroundColor = [UIColor colorWithRed:77.f/255.f green:182.f/255.f     blue:33.f/255.f alpha:1];
    self.weixinBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    self.aliBtn.layer.cornerRadius = 25.f;
    self.aliBtn.backgroundColor = [UIColor colorWithRed:42.f/255.f green:138.f/255.f     blue:224.f/255.f alpha:1];
    self.aliBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    self.cancelBtn.layer.cornerRadius = 25.f;
    self.cancelBtn.backgroundColor = [UIColor colorWithRed:235.f/255.f green:235.f/255.f     blue:235.f/255.f alpha:1];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50.f, self.bgView.width, 0.5f)];
    line.backgroundColor = kLightGrayColor;
    [self.bgView addSubview:line];
   
    
    
}


- (IBAction)weixinAction:(UIButton *)sender {
    
    _block(sender.tag);
    
}

-(void)testUI{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 90)];
    _a = aView;
    aView.backgroundColor = [UIColor redColor];
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 添加到窗口
    [window addSubview:aView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [_a removeFromSuperview];
}

@end
