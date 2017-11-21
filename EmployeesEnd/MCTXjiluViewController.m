//
//  MCTXjiluViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/13.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCTXjiluViewController.h"
#import "MCMyBousTableViewCell.h"
@interface MCTXjiluViewController ()

@end

@implementation MCTXjiluViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        htmlMutableArray = [NSMutableArray array];
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现记录";
    
    [self getdata];
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor whiteColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];

    // Do any additional setup after loading the view.
}
- (void)getdata{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    NSDictionary *sendDict = @{
                               @"page":@1,
                               @"pagesize":@999,
                               @"key":key,
                               @"secret":secret
                               };
    [SVProgressHUD show];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/tiXianOrderList" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                [listMutableArray setArray:dicDictionary[@"content"][@"orderList"]];
                [listTableView reloadData];
                //[self setRedView];
                [listTableView.mj_header endRefreshing];
                
            }
            
        }else{
            [listMutableArray setArray:dicDictionary[@"orderList"][@"receive"]];
            [listTableView reloadData];
            //[self setRedView];
            [listTableView.mj_header endRefreshing];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       
        
        
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 64;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return listMutableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *indentifier = @"cell";
    MCMyBousTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCMyBousTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    
    
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    [cell.bous setText:[NSString stringWithFormat:@"%@",dataDictionary[@"statusName"]]];
    [cell.dateLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"payTime"] ]];
    [cell.moneyLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"payAmount"] ]];
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    NSLog(@"---%ld",indexPath.row);
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