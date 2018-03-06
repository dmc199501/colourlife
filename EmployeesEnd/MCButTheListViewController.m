//
//  MCButTheListViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2018/1/10.
//  Copyright © 2018年 邓梦超. All rights reserved.
//

#import "MCButTheListViewController.h"
#import "MCButTheTableViewCell.h"
#import "MCDgListViewController.h"
@interface MCButTheListViewController ()

@end

@implementation MCButTheListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收款方信息";
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];

    
    // Do any additional setup after loading the view.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0.001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    return footView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *indentifier = @"cell";
    MCButTheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCButTheTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
       
    }
    NSDictionary *dataDic = [_listArray objectAtIndex:indexPath.row];
    [cell.typeLabel setText:[NSString stringWithFormat:@"%@",dataDic[@"typeName"]]];
    [cell.zhLabel setText:[NSString stringWithFormat:@"%@",dataDic[@"name"]]];
     [cell.cardLabel setText:[NSString stringWithFormat:@"%@",dataDic[@"ano"]]];
    
    
    
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *dataDic = [_listArray objectAtIndex:indexPath.row];
    MCDgListViewController *dgVC = [[MCDgListViewController alloc]init];
    dgVC.dic = dataDic;
    dgVC.dataDic = _dataDic;
    [self.navigationController pushViewController:dgVC animated:YES];
    
    
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
