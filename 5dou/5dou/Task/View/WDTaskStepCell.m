//
//  WDTaskStepCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/8.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskStepCell.h"
#import "ToolClass.h"
#import "TZTestCell.h"
#import "SDPhotoBrowser.h"

@interface WDTaskStepCell()<UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stepName;
@property (weak, nonatomic) IBOutlet UIView *stepView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic,strong) NSMutableArray *photoArray;

@property (weak, nonatomic) IBOutlet UITextView *stepTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoBottomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomHeight;

/**任务的状态*/
@property (weak, nonatomic) IBOutlet UIImageView *taskStatus;
/**任务的条幅*/
@property (weak, nonatomic) IBOutlet UIImageView *taskFlag;
/**任务的获取逗币*/
@property (weak, nonatomic) IBOutlet UILabel *taskReward;
@property (weak, nonatomic) IBOutlet UIView *taskFlagBg;

@end
@implementation WDTaskStepCell

- (void)awakeFromNib{
    [super awakeFromNib];
    _stepView.layer.cornerRadius = 6;
    _stepView.clipsToBounds = YES;
    
    [self.layer setMasksToBounds:YES];
    self.layer.cornerRadius = 10;
}
- (void)setStepModel:(WDTaskStepModel *)stepModel{
    _stepModel = stepModel;
    _stepName.text = stepModel.stepName;
    //给标题设值并且给计算高度
    _titleHeight.constant = [ToolClass getCellHeight:stepModel.stepName withFont:16 withWidth:ScreenWidth - 70];
    
    //给任务文本设值并且计算高度
    _stepTextView.editable = false;
    _stepTextView.scrollEnabled = NO;
    _stepTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //后台的HTML脚本解析成正常文字
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[stepModel.stepInfo dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _stepTextView.attributedText = attributedString;
    [ToolClass setTextViewSpace:_stepTextView withFont:[UIFont systemFontOfSize:14]];
    _textViewHeight.constant = [ToolClass heightForString:_stepTextView andWidth:ScreenWidth - 50];
    if ([stepModel.stepInfo isEqualToString:@""]) {
        _textViewHeight.constant = 0;
    }
    if (_textViewHeight.constant != 0) {
        _textViewBottomHeight.constant = 10;
    }else{
        _textViewBottomHeight.constant = 0;
    }

    _photoArray = [NSMutableArray arrayWithCapacity:0];
    //如果存在图片的情况下，应该让图片展示，并且进行加载
    if ([stepModel.isImg isEqualToString:@"1"]) {
        _photoCollectionView.hidden = NO;
        _photoArray = [NSMutableArray arrayWithArray:_stepModel.images];
        _photoBottomHeight.constant = 10;
        [_photoCollectionView reloadData];
    }else{
        _photoCollectionView.hidden = YES;
        _photoBottomHeight.constant = 0;
    }
    //给前面的设置特殊的字体
    _stepLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:20];
    
    //如果是专属任务的情况下，如果是激活状态，就显示正常的颜色，如果没有激活，就显示灰色
    if ([stepModel.isActive isEqualToString:@"0"]) {
     
        _stepView.backgroundColor = WDColorFrom16RGB(0xCACACA);
        _stepName.textColor = WDColorFrom16RGB(0xCACACA);
        _stepTextView.textColor = WDColorFrom16RGB(0xCACACA);
        _taskStatus.hidden = NO;
        _taskFlagBg.hidden = NO;
        if ([_stepModel.taskStatusStr isEqualToString:@"2"]) {
             _taskFlag.image = [UIImage imageNamed:@"taskRed"];
        }else{
             _taskFlag.image = [UIImage imageNamed:@"taskGray"];
        }
        _taskReward.text = [NSString stringWithFormat:@"+%@逗币",_stepModel.doubi];
        _taskStatus.image = [self statusImage:_stepModel.taskStatusStr];
    }else if([stepModel.isActive isEqualToString:@"1"]){
        _stepView.backgroundColor = WDColorFrom16RGB(0xFFC200);
        _stepName.textColor = WDColorFrom16RGB(0x8B572A);
        _stepTextView.textColor = WDColorFrom16RGB(0x666666);
        _taskStatus.hidden = NO;
        _taskFlagBg.hidden = NO;
        _taskFlag.image = [UIImage imageNamed:@"taskRed"];
        _taskReward.text = [NSString stringWithFormat:@"+%@逗币",_stepModel.doubi];
        _taskStatus.image = [self statusImage:_stepModel.taskStatusStr];
    }else{
        _stepView.backgroundColor = WDColorFrom16RGB(0xFFC200);
        _stepName.textColor = WDColorFrom16RGB(0x8B572A);
        _stepTextView.textColor = WDColorFrom16RGB(0x666666);
        _taskStatus.hidden = YES;
        _taskFlagBg.hidden = YES;
    }
    //constant 相关
    [self layoutIfNeeded];
}


- (UIImage *)statusImage:(NSString *)status{
    UIImage *image;
    if ([status isEqualToString:@"4"]) {
        image = [UIImage imageNamed:@"taskCommit"];
    }else if([status isEqualToString:@"3"]){
        image = [UIImage imageNamed:@"taskGiveUp"];
    }else if([status isEqualToString:@"5"]){
        image = [UIImage imageNamed:@"taskPass"];
    }else if([status isEqualToString:@"2"]){
        image = [UIImage imageNamed:@"taskFinish"];
    }
    return image;
}


#pragma mark UICollectionViewDataSource,UICollectionDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    [_photoCollectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.deleteBtn.hidden = YES;

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_stepModel.images[indexPath.row]] placeholderImage:[UIImage imageNamed:@"task_failphoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _stepModel.images.count;
}


#pragma mark 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.sourceImagesContainerView = self.photoCollectionView;
        browser.imageCount =  _photoArray.count;
        browser.currentImageIndex = indexPath.row;
        browser.delegate = self;
        [browser show];
}

#pragma mark SDBrowserDelegate
//返回高清图
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return nil;
};

//返回占位图
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_photoArray[index]]]];
};

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
