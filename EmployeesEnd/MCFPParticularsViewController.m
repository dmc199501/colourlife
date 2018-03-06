//
//  MCFPParticularsViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/12.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCFPParticularsViewController.h"
#import "MCFPParticularsTableViewCell.h"
@interface MCFPParticularsViewController ()

@end

@implementation MCFPParticularsViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"分配详情";
    
    UILabel *totle = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300, 30)];
    totle.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:totle];
    [totle setBackgroundColor:[UIColor clearColor]];
    [totle setTextColor:GRAY_COLOR_ZZ];
    [totle setFont:[UIFont systemFontOfSize:13]];
    [totle setText:[NSString stringWithFormat:@"收入:%.2f",[_datadic[@"split_money"] floatValue]]];

    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-64-20) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    //[listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
     [self getlistData];
    // Do any additional setup after loading the view.
}
#pragma mark- 领取列表数据获取
-(void)getlistData{
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *orgToken = [defaults objectForKey:@"orgToken"];
    NSString *username = [defaults objectForKey:@"userName"];
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
     [sendDictionary setValue:_datadic[@"general_uuid"] forKey:@"general_uuid"];
    [sendDictionary setValue:username forKey:@"split_target"];//账号
    [sendDictionary setValue:orgToken forKey:@"access_token"];
    [sendDictionary setValue:@2 forKey:@"split_type"];
     [sendDictionary setValue:@999999 forKey:@"pagesize"];
    [sendDictionary setValue:@1 forKey:@"page"];
    
    
    
    
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/split/api/bill" parameters:sendDictionary success:^(id responseObject) {
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            
            if ([dicDictionary[@"content"][@"list"] isKindOfClass:[NSArray class]])
            {
                
                [listMutableArray setArray:dicDictionary[@"content"][@"list"]];
                [listTableView reloadData];
                
                
            }
            
            
            
            
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"message"]];
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UILabel *bgView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    //    bgView.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    //    bgView.textAlignment = NSTextAlignmentCenter;
    //    bgView.font = [UIFont systemFontOfSize:14];
    //    bgView.text = @"--把社区服务做到家--";
    
    return bgView;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return listMutableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *indentifier = @"cell";
    MCFPParticularsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCFPParticularsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    NSDictionary *dataDic = [listMutableArray objectAtIndex:indexPath.row];
    [cell.dateLabel setText:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"time_at"]]];
    [cell.nameLabel setText:[NSString stringWithFormat:@"来源:%@-%@",[dataDic objectForKey:@"tag_name"],[dataDic objectForKey:@"community_name"]]];
    [cell.moneyLabel setText:[NSString stringWithFormat:@"+%.2f",[[dataDic objectForKey:@"split_account_amount"] floatValue]]];
    [cell.oderLabel setText:[NSString stringWithFormat:@"业务订单号:%@",[dataDic objectForKey:@"out_trade_no"]]];
    [cell.tradingLabel setText:[NSString stringWithFormat:@"交易流水号:%@",[dataDic objectForKey:@"orderno"]]];
    
    
    
    return cell;
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
