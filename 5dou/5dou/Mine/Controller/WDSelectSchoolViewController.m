


//
//  WDSelectSchoolViewController.m
//  5dou
//
//  Created by rdyx on 16/9/4.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
#import "ToolClass.h"
#import "WDSelectSchoolViewController.h"
#import "WDCommCell.h"
#import "UITableViewCell+Ext.h"
#import "WDDefaultAccount.h"
@interface WDSelectSchoolViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    NSString * _cityName;
}
@property (nonatomic,strong) NSArray *schoolArray;
@property (nonatomic,strong) NSMutableArray *searchSchoolList;
@property (nonatomic,strong) UITableView *schoolTableView;
@property (nonatomic,strong) UISearchBar *searchSchoolBar;
@property (nonatomic,strong) NSArray *allSchoolList;
@end

@implementation WDSelectSchoolViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self prepareData];
    [self prepareUI];
    
    
    // Do any additional setup after loading the view.
}

- (void)prepareUI{
    [self.navigationItem setItemWithTitle:@"选择学校" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self.view addSubview:self.schoolTableView];
    [self.view addSubview:self.searchSchoolBar];
    
    _schoolArray = @[@{@"schoolName":@"清华大学"},
                     @{@"schoolName":@"北京大学"},
                     @{@"schoolName":@"南开大学"},
                     @{@"schoolName":@"厦门大学"},
                     @{@"schoolName":@"武汉大学"},
                     @{@"schoolName":@"四川大学"},
                     @{@"schoolName":@"中山大学"},
                     @{@"schoolName":@"其他大学"}];
    [_schoolTableView reloadData];
}


- (void)prepareData{
    _searchSchoolList = [NSMutableArray arrayWithCapacity:0];
    WeakStament(weakSelf);
    [WDNetworkClient postRequestWithBaseUrl:kGetSchoolInfoUrl setParameters:nil success:^(id responseObject) {
        YYLog(@"%@",responseObject);
        //存储所有学校的信息
        weakSelf.allSchoolList = responseObject[@"data"];
    } fail:^(NSError *error) {
        
    } delegater:self.view];
    
}


- (UISearchBar *)searchSchoolBar{
    if (!_searchSchoolBar) {
         CGFloat padding = 20;
        _searchSchoolBar = [[UISearchBar alloc] initWithFrame:CGRectMake(padding, 0, ScreenWidth - 2 * padding, 44)];
        _searchSchoolBar.delegate = self;
        _searchSchoolBar.placeholder = @"请输入关键字搜索";
        _searchSchoolBar.barStyle =  UIBarStyleBlack ;
        _searchSchoolBar.searchBarStyle = UISearchBarStyleMinimal;
        
    }
    return _searchSchoolBar;
}
- (UITableView *)schoolTableView{
    if (!_schoolTableView) {
        CGFloat padding = 20;
        _schoolTableView = [[UITableView alloc] initWithFrame:CGRectMake(padding, 44, ScreenWidth - padding * 2 , ScreenHeight - 44  - 64) style:UITableViewStylePlain];
        _schoolTableView.delegate = self;
        _schoolTableView.dataSource = self;
        _schoolTableView.backgroundColor = [UIColor clearColor];
        _schoolTableView.separatorColor = [UIColor clearColor];
        _schoolTableView.showsVerticalScrollIndicator = NO;
    }
    return _schoolTableView;
}


#pragma mark UITableViewDelegate,UITableViewDataSourse
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WDCommCell *commCell = [WDCommCell cellWithTableView:tableView];
    NSDictionary *schoolDict;
    if (_searchSchoolList.count == 0) {
        schoolDict = _schoolArray[indexPath.row];
    }else{
        schoolDict = _searchSchoolList[indexPath.row];
    }
    commCell.commLabel.text = schoolDict[@"schoolName"];
    commCell.commLabel.font = kFont14;
    commCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return commCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   //进行了点击,获取信息
    NSDictionary *schoolDict;
    if (_searchSchoolList.count == 0) {
        schoolDict = _schoolArray[indexPath.row];
    }else{
        schoolDict = _searchSchoolList[indexPath.row];
    }
    if (_schoolChangeBlock) {
        _schoolChangeBlock(schoolDict[@"schoolName"]);
        NSString *schoolName = schoolDict[@"schoolName"];
            NSDictionary *para = @{@"school":schoolName,@"updateType":@3};
            [WDNetworkClient postRequestWithBaseUrl:kUpdateMemeberInfo setParameters:para success:^(id responseObject) {
                YYLog(@"%@",responseObject);
                NSDictionary *result = responseObject[@"result"];
                if ([result[@"code"] isEqualToString:@"1000"]) {
                    [ToolClass showAlertWithMessage:@"学校修改成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    
                }
                
            } fail:^(NSError *error) {
                
            } delegater:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //没有检索的结果
    if (_searchSchoolList.count == 0) {
        return _schoolArray.count;
    }else{
        return _searchSchoolList.count;
    }
    
}



- (NSMutableArray *)searchSchoolWithKey:(NSString *)key{
    NSMutableArray *searchArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *schoolDict in _allSchoolList)
    {
        NSRange range=[schoolDict[@"schoolName"] rangeOfString:key];
        
        if (range.location!=NSNotFound)
        {
            [searchArray addObject:schoolDict];
        }
    }
    NSDictionary *dict = @{@"schoolName":@"其他学校"};
    [searchArray addObject:dict];
    return searchArray;
}

#pragma mark UISearchDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    YYLog(@"searchText = %@",searchText);
    if (searchText.length == 0) {
        [_searchSchoolList removeAllObjects];
        [_schoolTableView reloadData];
        return;
    }
    _searchSchoolList = [self searchSchoolWithKey:searchText];
    if (_searchSchoolList.count != 0) {
        [_schoolTableView reloadData];
    }
    
}

//点击Cancel按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    //点击返回
    [_searchSchoolBar resignFirstResponder];
    
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
