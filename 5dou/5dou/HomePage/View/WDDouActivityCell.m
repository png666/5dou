




//
//  WDDouActivityCell.m
//  5dou
//
//  Created by rdyx on 16/11/23.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDDouActivityCell.h"
@interface WDDouActivityCell()
@property(nonatomic,strong)UIImageView *bigImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *eyeCountLabel;
@property(nonatomic,strong)UILabel *commentCountLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UIImageView *topImg;//置顶
@property(nonatomic,strong)UIImageView *hotImg;//火热
@property(nonatomic,strong)UIImageView *stateImg;//状态
@property(nonatomic,strong)UILabel *tagLabel;

@end

@implementation WDDouActivityCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configCell];
        self.backgroundColor = kClearColor;
    }
    return  self;
}

-(void)configCell
{
    UIView *bgView = [UIView new];
    bgView.backgroundColor = kWhiteColor;
    bgView.layer.cornerRadius = 5.f;
    bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.top.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.height.equalTo(@170);
    }];
    
    UIImageView *bigImage = [UIImageView new];
    bigImage.contentMode = UIViewContentModeScaleAspectFill;
    //添加这句代码是为了和上面的模式配合，不然图片直接延伸到下面去了，很奇怪
    bigImage.layer.masksToBounds = YES;
    [bgView addSubview:bigImage];
    [bigImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left);
        make.top.mas_equalTo(bgView.mas_top);
        make.right.mas_equalTo(bgView.mas_right);
        make.height.equalTo(@140);
    }];
    self.bigImage = bigImage;
    
    //置顶
    UIImageView *topImg = [UIImageView new];
    topImg.image = WDImgName(@"top");
    topImg.tag = 201;
    self.topImg = topImg;
    topImg.hidden = YES;
    [bgView addSubview:topImg];
    
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bigImage.mas_bottom).offset(7);
        make.left.mas_equalTo(bigImage.mas_left).offset(5);
        make.width.and.height.equalTo(@15);
    }];
    
    UIImageView *hot = [UIImageView new];
    hot.image = WDImgName(@"huo");
    hot.hidden = YES;
    hot.tag = 301;
    self.hotImg = hot;
    [bgView addSubview:hot];
    
    [hot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bigImage.mas_bottom).offset(7);
        make.left.mas_equalTo(bigImage.mas_left).offset(5);
        make.width.and.height.equalTo(@15);
    }];

    
    //状态标签:进行中 已停止 或 已结束
    UIImageView *stateImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-60.f, 10.f, 50.f, 19.f)];
//    stateImage.image = WDImgName(@"jinxing");
//    stateImage.hidden = YES;
    stateImage.tag = 401;
    self.stateImg = stateImage;
    [self.contentView addSubview:stateImage];
    
    //类型
    UILabel *tagLabel = [UILabel new];
    tagLabel.font = kFont14;
    tagLabel.textColor = kGrayColor;
    self.tagLabel = tagLabel;
    [bgView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topImg.mas_right).offset(2);
        make.top.equalTo(topImg.mas_top);
    }];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = kFont14;
    nameLabel.textColor = kGrayColor;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel = nameLabel;
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tagLabel.mas_right).offset(2);
        make.top.mas_equalTo(tagLabel.mas_top);
//        make.right.mas_equalTo(bgView.mas_right).offset(-3);
    }];
    self.selectionStyle = 0;
}

-(void)configData:(WDActivityModel *)model
{
    [self.bigImage sd_setImageWithURL:WDURL(model.thumbUrl) placeholderImage:WDImgName(@"activity_failphoto")];
    
    NSString *startTime =   [model.startDate substringWithRange:NSMakeRange(0, 10)];
    NSString *nowTime =   [model.nowDate substringWithRange:NSMakeRange(0, 10)];
    NSString *endTime =   [model.endDate substringWithRange:NSMakeRange(0, 10)];
    if ([nowTime compare:startTime]==NSOrderedDescending&&[nowTime compare:endTime]==NSOrderedAscending) {
        //进行中
        self.stateImg.image = WDImgName(@"jinxing");
        
    }else if ([nowTime compare:startTime]==NSOrderedAscending){
        
        self.stateImg.image = WDImgName(@"weikaishi");
        
    }else{
        
        self.stateImg.image = WDImgName(@"yijieshu");
        
    }
    if ([model.isTop isEqualToString:@"1"]) {
        self.topImg.hidden = false;
    }
    self.nameLabel.text = model.title;
    self.tagLabel.text = model.activityTag;
}
@end
