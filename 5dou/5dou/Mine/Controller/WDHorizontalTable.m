



//
//  WDHorizontalTable.m
//  5dou
//
//  Created by macfai on 2018/9/18.
//  Copyright © 2018年 吾逗科技. All rights reserved.
//

#import "WDHorizontalTable.h"

@interface WDHorizontalTable ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UITableView *MyTableView;

@end

@implementation WDHorizontalTable

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationItem setItemWithTitle:@"横向table" textColor:kWhiteColor fontSize:19 itemType:center];
    self.MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 50,ScreenWidth/4) style:UITableViewStylePlain];
    self.MyTableView.dataSource=self;
    self.MyTableView.delegate=self;
    //对TableView要做的设置
    self.MyTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
    self.MyTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.MyTableView];
    // Do any additional setup after loading the view.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FyCell"];
    }
    //对Cell要做的设置
    cell.backgroundColor=kLightGrayColor;
    cell.textLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
    cell.textLabel.text= @"tableview竖向滚动";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth/4; // 返回的是宽度
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
