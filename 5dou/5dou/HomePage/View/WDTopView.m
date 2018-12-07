

//
//  WDTopView.m
//  5dou
//
//  Created by rdyx on 16/8/29.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTopView.h"
#import "SDCycleScrollView.h"
#import "WDFourIconView.h"
#import "ToolClass.h"
#import "WDUserInfoModel.h"
#import "CCPScrollView.h"
@interface WDTopView()<SDCycleScrollViewDelegate>

@property(nonatomic,strong)SDCycleScrollView *cycleView;
@property(nonatomic,strong)WDFourIconView *fourIconView;
@property(nonatomic,strong)UILabel *sepratorLabel;
@property(nonatomic,strong)UIImageView *bottomImageView;
@property(nonatomic,strong)UIImageView *noticeImg;
@property(nonatomic,strong)UIView *VerticalView;
@property(nonatomic,strong)UILabel *xiaodouLabel;

@end


@implementation WDTopView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        self.backgroundColor = WDColorRGB(230.f, 230.f, 230.f);
        
    }
    return self;
}

-(void)setupUI{
    
    //1添加轮播图
    _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth>320?200:150) delegate:self placeholderImage:[UIImage imageNamed:@"loop.png"]];
    _cycleView.currentPageDotColor = WDColorRGB(253.f, 80.f, 115.f);
    _cycleView.pageDotColor = kLightGrayColor;
    _cycleView.autoScrollTimeInterval = 5;
    [self addSubview:_cycleView];
    
    
    //添加iconView
    WeakStament(wself);
    NSInteger iconViewHeight;
    iconViewHeight = 90.f;
    _fourIconView = [[WDFourIconView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_cycleView.frame), ScreenWidth, iconViewHeight)];

    _fourIconView.iconArray = @[@"mmoney",@"activ",@"news",@"rank"];
    _fourIconView.titleArray = @[@"去挣钱",@"逗活动",@"逗新闻",@"排行榜"];
    _fourIconView.indexBlock = ^(NSInteger num,WDFourIconModel *model){
        
        YYLog(@"%ld,%@",(long)num,model);
        
        if (wself.topViewBlock) {
            
            wself.topViewBlock(num,model);

        }
    };
    [self addSubview:_fourIconView];
    
    UIView *verticalBannerView = [UIView new];
    verticalBannerView.backgroundColor = kWhiteColor;
    self.VerticalView = verticalBannerView;
    [self addSubview:verticalBannerView];
    
    //吾逗小报
    UIImageView *img = [UIImageView new];
    img.image = WDImgName(@"notice");
    self.noticeImg = img;
    [verticalBannerView addSubview:img];
    
    CCPScrollView *notice = [[CCPScrollView alloc] initWithFrame:CGRectMake(85, 0, ScreenWidth-50, 40)];
    notice.titleArray = @[@"iPhone7上线256G内存手机你怎么看？",@"5dou上新任务了,先到先得啊😄"];
    notice.titleFont = 13;
    notice.titleColor = kBlackColor;
    notice.BGColor = kWhiteColor;
    [verticalBannerView addSubview:notice];
    
    UILabel *xiaodouLabel = [UILabel new];
    xiaodouLabel.font = kFont12;
    xiaodouLabel.textColor = kBlackColor;
    xiaodouLabel.text = @"小逗播报:";
    self.xiaodouLabel = xiaodouLabel;
    [verticalBannerView addSubview:xiaodouLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 0.5)];
    line.backgroundColor = WDColorRGB(221.f, 221.f, 221.f);
    [verticalBannerView addSubview:line];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
     self.VerticalView.frame = CGRectMake(0, _fourIconView.bottom+10, ScreenWidth, 40.f);
    self.noticeImg.frame = CGRectMake(10, 12, 15, 15);
    self.xiaodouLabel.frame = CGRectMake(28.f, 9.f, 55.f, 20.f);
}

//轮播图数据设置
-(void)setBannerArray:(NSArray *)bannerArray{
    
    _bannerArray = bannerArray;
    
    NSMutableArray* arr = [NSMutableArray array];
    
    for (WDBannerModel* model in bannerArray) {
        
        NSString *url = model.imageUrl;
        
        [arr addObject:url];
    }
    _cycleView.imageURLStringsGroup = arr;
}

//四个icon数据设置
#pragma mrak - SDCycleScrollViewDelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (_bannerBlock) {
    _bannerBlock(index);
    }
}

@end
