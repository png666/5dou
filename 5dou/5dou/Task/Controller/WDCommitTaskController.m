//
//  WDCommitTaskController.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDCommitTaskController.h"
#import "TZTestCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
#import "TZVideoPlayerController.h"
#import "TZImageManager.h"
#import "ToolClass.h"
#import "SDPhotoBrowser.h"
#import "WDUserInfoModel.h"
#import "WDHelpTaskView.h"
#import "UIControl+recurClick.h"
#import "CKAlertViewController.h"

@interface WDCommitTaskController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,TZImagePickerControllerDelegate,UITextViewDelegate,SDPhotoBrowserDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    CGFloat _itemWH;
    CGFloat _margin;
    
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
/**
 *  选择的图片
 */
@property (weak, nonatomic) IBOutlet UICollectionView *selectedPhotoCollection;
/**
 *  素材图片
 */
@property (weak, nonatomic) IBOutlet UICollectionView *materialCollectionView;
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
@property (nonatomic,strong) NSMutableArray *
selectedAssets;
@property (nonatomic,assign) BOOL isSelectOriginalPhoto;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *messagePlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *wordNumber;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (strong,nonatomic) NSMutableArray *materialArray;
@property (weak, nonatomic) IBOutlet UITextField *accountTextFiled;
@property (nonatomic,strong) WDHelpTaskView *helpTaskView;

//进行约束布局
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewHeight;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedPhotoViewHeight;
@property (weak, nonatomic) IBOutlet UIView *selectedPhotoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountViewHeight;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exampleViewHeight;
@property (weak, nonatomic) IBOutlet UIView *exampleView;
@property (nonatomic,assign) NSInteger successPhoto;


@end

@implementation WDCommitTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
    //初始化素材图
    _materialArray = [NSMutableArray arrayWithCapacity:0];
    // Do any additional setup after loading the view from its nib.
    
    //进行约束的判断
    if (_imageArray.count == 0 || !_imageArray) {
        _exampleViewHeight.constant = 0;
        _exampleView.hidden = YES;
    }
    if ([_isNeedPic isEqualToString:@"0"]) {
        _selectedPhotoViewHeight.constant = 0;
        _selectedPhotoView.hidden = YES;
    }
    if ([_isNeedCommet isEqualToString:@"0"]) {
        _commentViewHeight.constant = 0;
        _commentView.hidden = YES;
    }
    if ([_isNeedUserAccount isEqualToString:@"0"]) {
        _accountViewHeight.constant = 0;
        _accountView.hidden = YES;
    }
    [self.view layoutIfNeeded];
    self.accountTextFiled.delegate = self;
    self.messageTextView.delegate = self;
    //帮助按钮
    [self addNavgationRightButtonWithFrame:CGRectMake(0, 0, 29, 29) title:@"" Image:@"help" selectedIMG:@"" tartget:self action:@selector(helpTask)];
    [self.accountTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [topView setBarStyle:0];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyBoard)];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyBoard)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    //添加工具条的关键代码
    [self.accountTextFiled setInputAccessoryView:topView];
    [self.messageTextView setInputAccessoryView:topView];
    _commitButton.uxy_acceptEventInterval = 5.0f;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"提交任务"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"提交任务"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)keyboardWillShow{
    CGRect frame = self.view.frame;
    if ([_isNeedPic isEqualToString:@"1"]) {
        frame.origin.y = - 120;
    }
    self.view.frame = frame;
}



- (void)keyboardWillHide{
    CGRect frame = self.view.frame;
    frame.origin.y = 64;
    self.view.frame = frame;
}


- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

#pragma mark - 提交任务帮助按钮
- (void)helpTask{
    [UIView animateWithDuration:0.5 animations:^{
        self.helpTaskView.alpha = 1;
    }];
}

- (void)prepareUI{
    [self.navigationItem setItemWithTitle:@"提交任务" textColor:[UIColor whiteColor] fontSize:19 itemType:center];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _selectedPhotoCollection.delegate = self;
    _selectedPhotoCollection.dataSource = self;
    [_selectedPhotoCollection registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
    _materialCollectionView.delegate = self;
    _materialCollectionView.dataSource = self;
    [_materialCollectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    _messageTextView.delegate = self;
    _commitButton.layer.cornerRadius = 10;
    _commitButton.layer.masksToBounds = YES;
    _commitButton.clipsToBounds = YES;
    
}

#pragma mark UICollectionDelegate,UICollectionDataSourse
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if ([collectionView isEqual:_selectedPhotoCollection]) {
        
        cell.videoImageView.hidden = YES;
        if (indexPath.row == _selectedPhotos.count) {
            cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
            cell.deleteBtn.hidden = YES;
        } else {
            cell.imageView.image = _selectedPhotos[indexPath.row];
            cell.asset = _selectedAssets[indexPath.row];
            cell.deleteBtn.hidden = NO;
        }
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        WeakStament(weakSelf);
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[indexPath.row]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [weakSelf.materialArray addObject:cell.imageView.image];
        }];
        cell.deleteBtn.hidden = YES;
        return cell;
    }
    
}
#pragma mark 删除的方法
- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_selectedPhotoCollection performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_selectedPhotoCollection deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_selectedPhotoCollection reloadData];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WeakStament(weakSelf);
    if ([collectionView isEqual:_selectedPhotoCollection]) {
        if (indexPath.row == _selectedPhotos.count) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
#pragma clang diagnostic pop
            [sheet showInView:self.view];
        } else { // preview photos or video / 预览照片或者视频
            id asset = _selectedAssets[indexPath.row];
            BOOL isVideo = NO;
            if ([asset isKindOfClass:[PHAsset class]]) {
                PHAsset *phAsset = asset;
                isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            } else if ([asset isKindOfClass:[ALAsset class]]) {
                ALAsset *alAsset = asset;
                isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
#pragma clang diagnostic pop
            }
            if (isVideo) { // perview video / 预览视频
                TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
                TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
                vc.model = model;
                [self presentViewController:vc animated:YES completion:nil];
            } else { // preview photos / 预览照片
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
                imagePickerVc.allowPickingOriginalPhoto = YES;
                imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    weakSelf.selectedPhotos = [NSMutableArray arrayWithArray:photos];
                    weakSelf.selectedAssets = [NSMutableArray arrayWithArray:assets];
                    weakSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
                    [weakSelf.selectedPhotoCollection reloadData];
                }];
                [self presentViewController:imagePickerVc animated:YES completion:nil];
            }
        }
        
    }
    //如果不是选择的照片图片，那么需要放大,并且保存
    else{
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.sourceImagesContainerView = self.materialCollectionView;
        browser.imageCount = _imageArray.count ;
        browser.currentImageIndex = indexPath.item;
        browser.delegate = self;
        [browser show];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:_selectedPhotoCollection]) {
        return _selectedPhotos.count + 1;
    }
    return _imageArray.count;
}


#pragma mark - SDBrowserDelegate
//返回高清图
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return nil;
};

//返回占位图
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return _materialArray[index];
};

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        if (textView.text.length > 200) {
            textView.text = [textView.text substringToIndex:200];
            return;
        }
        _messagePlaceHolder.hidden = YES;
    }else{
        _messagePlaceHolder.hidden = NO;
    }
    _wordNumber.text = [NSString stringWithFormat:@"%ld/200",(unsigned long)textView.text.length];
}


#pragma mark -UITextFiledDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 20) {
        textField.text = [textField.text substringToIndex:20];
    }
}


#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self];
    imagePickerVc.allowTakePicture = NO;
    //设置已经原则的图片
    imagePickerVc.selectedAssets = _selectedAssets;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            YYLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WeakStament(weakSelf);
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) { // 如果保存失败，基本是没有相册权限导致的...
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法保存图片" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                alert.tag = 1;
                [alert show];
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [weakSelf.selectedAssets addObject:assetModel.asset];
                        [weakSelf.selectedPhotos addObject:image];
                        [weakSelf.selectedPhotoCollection reloadData];
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_selectedPhotoCollection reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_selectedPhotoCollection reloadData];
}

#pragma mark Click Event
- (IBAction)taskSubmit:(id)sender {
    if ([_isNeedPic isEqualToString:@"1"]) {
        if (_selectedPhotos.count == 0) {
            [ToolClass showAlertWithMessage:@"没有选择图片哦~"];
            return;
        }else if(_selectedPhotos.count != _imageArray.count && _imageArray){
            [ToolClass showAlertWithMessage:@"选择的图片数量应与截图一致～"];
            return;
        }
    }
    if ([_isNeedUserAccount isEqualToString:@"1"]) {
        if (_accountTextFiled.text.length == 0) {
            [ToolClass showAlertWithMessage:@"请填写上注册帐号信息"];
            return;
        }
    }
    
    //如果不需要上传图片的话
    if ([_isNeedPic isEqualToString:@"0"] || _selectedPhotos.count == 0) {
        [self commenTask];
        return;
    }
    
    _successPhoto = 0;
    //要进行上传了
    
    [self uploadImage];
}


- (void)uploadImage{
    UIImage *image = _selectedPhotos[_successPhoto];
    NSData  *imageData = UIImageJPEGRepresentation(image, 0.1);
    NSString  *base64ImageString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSDictionary *picDict = @{@"taskId":_taskId,@"index":[NSNumber numberWithInteger:(_successPhoto + 1)],@"taskImg":base64ImageString};
    WeakStament(weakSelf);
    [WDNetworkClient postRequestWithBaseUrl:kUploadTaskPicture setParameters:picDict success:^(id responseObject) {
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            _successPhoto++;
            //如果上传成功了以后
            if (_successPhoto == _selectedPhotos.count) {
                [weakSelf commenTask];
            }else{
                [self uploadImage];
            }
        }else{
            [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
            _successPhoto = 0;
        }
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

- (void)commenTask{
    
    
    //判断是否上传成功了，要保证上传的图片和需要的图片一致
    
    [MobClick event:@"commitTask"];
    
    NSDictionary *commitDict = @{@"taskId":_taskId,@"comment":_messageTextView.text,@"userAccount":_accountTextFiled.text};
    WeakStament(weakSelf);
    _successPhoto = 0;
    [WDNetworkClient postRequestWithBaseUrl:kSubmitTask setParameters:commitDict success:^(id responseObject) {
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            
            [ToolClass showAlertWithMessage:@"3天内发布结果，请耐心等待"];
            //如果存在下一步任务
            if ([responseObject[@"data"][@"hasNextTask"] isEqualToString:@"1"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:@"你获得一张专属任务卡，\r\n请到我的－任务卡查看哦!"];
                    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确认" handler:^(CKAlertAction *action) {
                        if (weakSelf.successBlock) {
                            weakSelf.successBlock();
                        }
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                    [alertVC addAction:sure];
                    [self presentViewController:alertVC animated:NO completion:nil];
                });
            }else{
                if (_successBlock) {
                    _successBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }
            
        }
        //自动审核失败
        else if([responseObject[@"result"][@"code"] isEqualToString:@"1023"]){
            [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
             [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (!_helpTaskView) {
        _helpTaskView = [WDHelpTaskView view];
        _helpTaskView.stepArray = [NSMutableArray arrayWithArray:self.stepArray];
        _helpTaskView.alpha = 0;
        [self.view addSubview:_helpTaskView];
    }
    _helpTaskView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dismissKeyBoard{
    if ([self.messageTextView isFirstResponder]) {
        [self.messageTextView resignFirstResponder];
    }
    
    if ([self.accountTextFiled isFirstResponder]) {
        [self.accountTextFiled resignFirstResponder];
    }
}

@end
