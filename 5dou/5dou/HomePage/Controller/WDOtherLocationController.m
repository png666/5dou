//
//  WDOtherLocationController.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/6.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDOtherLocationController.h"
#import "WDDefaultAccount.h"

@interface WDOtherLocationController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *indexSource;
@property (nonatomic,strong) NSMutableArray *searchList;
@property (nonatomic,strong) UITableView *cityTableView;
@end
@implementation WDOtherLocationController{
    /**
     *  搜索条
     */
    UISearchBar *_searchBar;
    /**
     *  搜索控制器
     */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UISearchDisplayController *_searchController;
#pragma clang diagnostic pop
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"选择其他城市" textColor:[UIColor whiteColor] fontSize:19 itemType:center];
    
    [self prepareData];
    [self prepareUI];
    // Do any additional setup after loading the view.
}


- (void)prepareData{
    _dataSource = [NSMutableArray array];
    _indexSource = [NSMutableArray array];
    _searchList = [NSMutableArray array];
    WeakStament(weakSelf);
    
    //判断是否有存储的信息，如果有，直接使用
//    if ([WDDefaultAccount cityList] && [WDDefaultAccount indexList]) {
//        _dataSource = [WDDefaultAccount cityList];
//        _indexSource = [WDDefaultAccount indexList];
//        [self.cityTableView reloadData];
//        YYLog(@"没有进行数据请求");
//        return;
//    }
    NSDictionary *param = @{@"queryType":@2};
    [WDNetworkClient postRequestWithBaseUrl:kGetCityInfo setParameters:param success:^(id responseObject) {
        YYLog(@"进行了数据请求");
        NSDictionary *allCity = responseObject[@"data"][@"allCity"];
        NSMutableArray *newArray = [NSMutableArray array];
        for (char index = 'A'; index <= 'Z'; index++) {
            NSArray *cityArray = [allCity objectForKey:[NSString stringWithFormat:@"%c",index]];
            if (cityArray.count != 0) {
                [newArray addObjectsFromArray:cityArray];
            }
        }
        //进行排序
        newArray = [weakSelf sortArray:newArray];
        //存储信息
        _dataSource = newArray;
        //[WDDefaultAccount setCityList:_dataSource andIndexList:_indexSource];
        [weakSelf.cityTableView reloadData];
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}


-(NSMutableArray *)sortArray:(NSMutableArray *)arrayToSort {
    NSMutableArray *arrayForArrays = [[NSMutableArray alloc] init];
    
    //根据拼音对数组排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"prefix" ascending:YES]];
    //排序
    [arrayToSort sortUsingDescriptors:sortDescriptors];
    NSMutableArray *tempArray = nil;
    BOOL flag = NO;
    //分组
    for (int i = 0; i < arrayToSort.count; i++) {
        NSString *prefix = [arrayToSort[i] objectForKey:@"prefix"];
        if (![_indexSource containsObject:[prefix uppercaseString]]) {
            [_indexSource addObject:[prefix uppercaseString]];
            tempArray = [[NSMutableArray alloc] init];
            flag = NO;
        }
        if ([_indexSource containsObject:[prefix uppercaseString]]) {
            [tempArray addObject:arrayToSort[i]];
            if (flag == NO) {
                [arrayForArrays addObject:tempArray];
                flag = YES;
            }
        }
    }
    return arrayForArrays;
}


- (void)prepareUI{
    [self.view addSubview:self.cityTableView];
    //安装搜索栏
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _searchBar.placeholder = @"请输入城市的中文名称";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    ;
#pragma clang diagnostic pop
    _searchController.searchResultsDelegate = self;
    _searchController.searchResultsDataSource = self;
    [self.view addSubview:_searchController.searchBar];
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.cityTableView) {
        return self.dataSource.count;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.cityTableView) {
        return [self.dataSource[section] count];

    }else{
        // 进行筛选
        _searchList = [NSMutableArray array];
        for (NSArray *cityArray in self.dataSource) {
            for (NSDictionary *cityDict in cityArray) {
                if ([cityDict[@"cityName"] containsString:_searchBar.text]) {
                    [_searchList addObject:cityDict];
                }
            }
        }
        return _searchList.count;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.cityTableView) {
        return [_indexSource objectAtIndex:section];
    }else{
        return nil;
    }
    
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == self.cityTableView) {
        return _indexSource;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"selectedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    if (tableView == self.cityTableView) {
         cell.textLabel.text = [[self.dataSource[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"cityName"];
    }else{
        cell.textLabel.text = [self.searchList[indexPath.row] objectForKey:@"cityName"];
    }
    return cell;
}


- (UITableView *)cityTableView{
    if (!_cityTableView) {
        _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _cityTableView.dataSource = self;
        _cityTableView.delegate = self;
        _cityTableView.sectionIndexColor = [UIColor redColor];
    }
    return _cityTableView;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *selectCity;
    if (tableView == self.cityTableView) {
        selectCity = _dataSource[indexPath.section][indexPath.row];
    }else{
        selectCity = _searchList[indexPath.row];
    }
    //设置推送的标签 ---- 以城市名、城市Code、省份ID做标签
    NSString *provinceId = nil;
    if ([selectCity[@"provinceId"] isKindOfClass:[NSString class]]) {
        provinceId = provinceId;
    }
    //进行定位的存储
    [WDDefaultAccount setCityName:selectCity[@"cityName"]];
    [WDDefaultAccount setCityId:selectCity[@"cityCode"]];
    [WDDefaultAccount setProvinceId:provinceId];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
