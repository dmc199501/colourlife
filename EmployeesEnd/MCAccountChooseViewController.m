//
//  MCAccountChooseViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/9.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCAccountChooseViewController.h"
#import "MCOAChooseTableViewCell.h"
#import "MCGivingFPViewController.h"
@interface MCAccountChooseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger rows;

@end

@implementation MCAccountChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账号选择";
    _rows = 0;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(certain)];
    
    
    
    
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    //    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    // Do any additional setup after loading the view.
}
-(void)certain{

 NSDictionary *dicDictionary = [_listArray objectAtIndex:_rows];
    MCGivingFPViewController *ZZvc = [[MCGivingFPViewController alloc]init];
    ZZvc.type =@"1";
   // ZZvc.balance = self.balance;
    ZZvc.dataDic = dicDictionary;
    [self.navigationController pushViewController:ZZvc animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *indentifier = @"cell";
    MCOAChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCOAChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    
    NSDictionary *dataDictionary = [_listArray objectAtIndex:indexPath.row];
    [cell.name setText:[NSString stringWithFormat:@"%@",[dataDictionary objectForKey:@"name"]]];
    [cell.OAlabel setText:[NSString stringWithFormat:@"OA:%@",[dataDictionary objectForKey:@"username"]]];
    NSLog(@"%@",dataDictionary);
       if (indexPath.row == _rows) {
        [cell.stateV setImage:[UIImage imageNamed:@"Selected"]];
        
    }
    else{
        [cell.stateV setImage:[UIImage imageNamed:@"Unchecked"]];
        
    }
   
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"%ld",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _rows = indexPath.row;
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    
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
