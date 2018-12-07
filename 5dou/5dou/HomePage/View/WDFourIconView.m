
//
//  WDFourIconView.m
//  5dou
//
//  Created by rdyx on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDFourIconView.h"
#import "WDFourIconViewCell.h"
@interface WDFourIconView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *iconCollectionView;
@property(nonatomic,strong)NSArray *imageViewArray;

@end

static NSString *iconCellID = @"icon";

@implementation WDFourIconView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
//        [self makeUI];
        
    }
    
    return self;
    
}

-(void)setIconArray:(NSArray *)iconArray{
    
    _iconArray = iconArray;
    
    //数据接收完成后再开始布局
    [self makeUI];
    
    _iconCollectionView.dataSource = self;
    
    
}

-(void)makeUI{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置itemSize
    
        layout.itemSize = CGSizeMake(ScreenWidth/4,90.f);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    //这三个属性至关重要
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //2.初始化collectionView
    _iconCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,self.frame.size.height) collectionViewLayout:layout];
    _iconCollectionView.bounces = false;
    _iconCollectionView.delegate = self;
    _iconCollectionView.backgroundColor = kWhiteColor;
    [_iconCollectionView registerClass:[WDFourIconViewCell class] forCellWithReuseIdentifier:iconCellID];
    
    [self addSubview:_iconCollectionView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _iconArray.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WDFourIconViewCell *cell = (WDFourIconViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:iconCellID forIndexPath:indexPath];
    
    cell.iconImage.image = WDImgName(self.iconArray[indexPath.row]);
    cell.nameLabel.text = self.titleArray[indexPath.row];
    
//    if (_iconArray.count > indexPath.row) {
//        WDFourIconModel *model = _iconArray[indexPath.row];
//        [cell configData:model];
//    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WDFourIconModel *model = self.iconArray[indexPath.row];
    if (_indexBlock) {
        
        YYLog(@"%ld",(long)indexPath.row);
        
        _indexBlock(indexPath.row,model);
        
    }
    
}

@end
