//
//  WDBaseViewController.h
//  5dou
//
//  Created by rdyx on 16/8/27.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationItem+CustomItem.h"
@interface WDBaseViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property(nonatomic,strong)UICollectionViewFlowLayout *layout;
@property(nonatomic,strong)UICollectionView *mainCollectionView;

/**
 列表数据量多时候，可以在子类里启动这个开关
 */
@property(nonatomic,assign)BOOL  isShowTabbar;


//左侧
-(UIButton *)addNavigationLeftButtonFrame:(CGRect)frame Image:(UIImage *)normalImage AndHighLightImage:(UIImage *)highLightImage AndText:(NSString *)text Target:(id)target Action:(SEL)action ;

//右侧
-(UIButton *)addNavgationRightButtonWithFrame:(CGRect)frame
                                        title:(NSString*)title
                                        Image:(NSString*)image
                                  selectedIMG:(NSString*)imsel
                                      tartget:(id)target
                                       action:(SEL)action;


- (void)backItemClick;

- (void)prepareDataDetail:(NSString *)taskId;

//实名认证
-(void)judgeIsAuthentication;
//微信认证
-(void)weixinAuth;

@end
