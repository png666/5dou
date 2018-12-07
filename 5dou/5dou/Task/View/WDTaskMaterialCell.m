//
//  WDTaskMaterialCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/8.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskMaterialCell.h"
#import "SDPhotoBrowser.h"
#import "TZTestCell.h"
#import "ToolClass.h"
@interface WDTaskMaterialCell()<SDPhotoBrowserDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *materialCollection;
@property (nonatomic,strong) NSMutableArray *photoArray;
@end
@implementation WDTaskMaterialCell

- (void)awakeFromNib{
    [super awakeFromNib];
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _materialLabel.userInteractionEnabled = YES;
    [_materialLabel addGestureRecognizer:longPressReger];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    [self becomeFirstResponder];
    UIMenuItem * itemPase = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyAction:)];
    UIMenuController * menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems: @[itemPase]];
    
    CGPoint location = [longPress locationInView:[longPress view]];
    CGRect menuLocation = CGRectMake(location.x, location.y, 0, 0);
    [menuController setTargetRect:menuLocation inView:[longPress view]];
    menuController.arrowDirection = UIMenuControllerArrowDown;
    [menuController setMenuVisible:YES animated:YES];
}


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action == @selector(copyAction:)) {
        return YES;
    }
    
    return NO;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}


#pragma mark 进行拷贝
- (void)copyAction:(id)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:_materialLabel.text];
    [ToolClass showAlertWithMessage:@"复制成功"];
}

- (void)setMaterialModel:(WDTaskMaterialModel *)materialModel{
    _materialModel = materialModel;
    _materialLabel.text = materialModel.materialInfo;
    NSInteger imageCount = materialModel.materialPics.count;
    _photoArray = [NSMutableArray arrayWithCapacity:0];
    if (imageCount > 0) {
        _materialCollection.hidden = NO;
    }else{
        _materialCollection.hidden = YES;
    }
    self.photoArray = [NSMutableArray arrayWithArray:materialModel.materialPics];
}


#pragma mark UICollectionViewDataSource,UICollectionDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    [_materialCollection registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.deleteBtn.hidden = YES;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_materialModel.materialPics[indexPath.row]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _materialModel.materialPics.count;
}


#pragma mark 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.materialCollection;
    browser.imageCount = self.photoArray.count ;
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


- (void)setMaterialStr:(NSString *)materialStr{
    _materialStr = materialStr;
    _materialLabel.text = materialStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
