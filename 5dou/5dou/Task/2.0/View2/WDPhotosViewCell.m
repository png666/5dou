//
//  WDPhotoViewCell.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDPhotosViewCell.h"
#import "SDPhotoBrowser.h"
#import "TZTestCell.h"
@interface WDPhotosViewCell()<SDPhotoBrowserDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@end
@implementation WDPhotosViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _photoCollectionView.layer.borderColor = WDColorFrom16RGB(0xf8e71c).CGColor;
//    _photoCollectionView.layer.borderWidth = 1.0f;
//    _photoCollectionView.layer.cornerRadius = 3.0f;
    [self.layer setMasksToBounds:YES];
    self.layer.cornerRadius = 10;
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;

}


#pragma mark UICollectionViewDataSource,UICollectionDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    [_photoCollectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.deleteBtn.hidden = YES;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_photoArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"task_failphoto"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photoArray.count;
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
