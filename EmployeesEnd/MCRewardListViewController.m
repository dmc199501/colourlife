//
//  MCRewardListViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/8.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRewardListViewController.h"
#import "MCRewarListTableViewCell.h"
#import "MCJTDetailsViewController.h"
#import "MCPQTableViewCell.h"
@interface MCRewardListViewController ()<MCRewarListTableViewCellDelegate,MCPQTableViewCellDelegate>

@end

@implementation MCRewardListViewController
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
    self.navigationItem.title = @"集体奖罚明细";
    [self getdata];
    
    
    // Do any additional setup after loading the view.
}
- (void)setUI{

    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,-40, self.view.frame.size.width, self.view.frame.size.height+40) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor whiteColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    
    

}
- (void)getdata{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];
    
    
    NSDictionary *sendDict = @{
                               @"oauser":username,
                              
                                                             };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/oa/collective" parameters:sendDict success:^(id responseObject) {
       
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
            {
                
                [listMutableArray setArray:dicDictionary[@"content"]];
                [listTableView reloadData];
                //[self setRedView];
                if (listMutableArray.count>0) {
                    
                    self.isPQ = [dicDictionary[@"content"][0][@"pcbfee"] integerValue];
                }
                
                
                [listTableView.mj_header endRefreshing];
                
                [self setUI];
            }
            
        }else{
            [listMutableArray setArray:dicDictionary[@"content"]];
            [listTableView reloadData];
            self.isPQ = 0;
            //[self setRedView];
            [listTableView.mj_header endRefreshing];
            [self setUI];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       
        
        
    }];
    


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (self.isPQ == 0) {
        return   241;
    }else{
    return 291;
    }

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
    bgView.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    bgView.textAlignment = NSTextAlignmentCenter;
    bgView.font = [UIFont systemFontOfSize:14];
    bgView.text = @"--把社区服务做到家--";
    
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
    if (self.isPQ == 0) {
        
        static NSString *indentifier = @"cell";
        MCRewarListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil)
        {
            cell = [[MCRewarListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            cell.delegate = self;
        }
        
        NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
        [cell.dateLabel setText:[NSString stringWithFormat:@"%@年-%@月",dataDictionary[@"year"],dataDictionary[@"month"]]];
        [cell.budgetLabel setText:[NSString stringWithFormat:@"%.2f",[dataDictionary[@"chaoys"] floatValue]]];//超预算
        [cell.basisLabel setText:[NSString stringWithFormat:@"%.2f",[dataDictionary[@"jthbfee"] floatValue]]];//基础
        [cell.rewardLabel setText:[NSString stringWithFormat:@"%.2f",[dataDictionary[@"jtjl"] floatValue]]];//奖励
        [cell.ChargeLabel setText:[NSString stringWithFormat:@"%.2f",[dataDictionary[@"jtkk"] floatValue]]];//扣款
        [cell.totalLabel setText:[NSString stringWithFormat:@"+%.2f",[dataDictionary[@"jthbactfee"] floatValue]]];//
        
        return cell;

    }else{
        static NSString *indentifier = @"cell2";
        MCPQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil)
        {
            cell = [[MCPQTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            cell.delegate = self;
        }
        
        NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
        [cell.dateLabel setText:[NSString stringWithFormat:@"%@年-%@月",dataDictionary[@"year"],dataDictionary[@"month"]]];
        [cell.budgetLabel setText:[NSString stringWithFormat:@"%.2f",[dataDictionary[@"chaoys"] floatValue]]];//超预算
        [cell.basisLabel setText:[NSString stringWithFormat:@"%.2f",[dataDictionary[@"jthbfee"] floatValue]]];//基础
        [cell.rewardLabel setText:[NSString stringWithFormat:@"%.2f",[dataDictionary[@"jtjl"] floatValue]]];//奖励
        [cell.ChargeLabel setText:[NSString stringWithFormat:@"%.2f",[dataDictionary[@"jtkk"] floatValue]]];//扣款
        [cell.totalLabel setText:[NSString stringWithFormat:@"+%.2f",[dataDictionary[@"jthbactfee"] floatValue]]];//
        
        [cell.PQtotalLabel setText:[NSString stringWithFormat:@"%.2f",[dataDictionary[@"pcbfee"] floatValue]]];//
        
        return cell;

    }
    
}

- (void)MCRewarListTableViewCell:(MCRewarListTableViewCell *)rewarListTableViewCell details:(UIButton *)Button{

    NSIndexPath *indexPath = [listTableView indexPathForCell:rewarListTableViewCell];
   NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    NSLog(@"---%ld",indexPath.row);
    MCJTDetailsViewController *JTvc = [[MCJTDetailsViewController alloc]init];
    JTvc .jtDic = dataDictionary;
    JTvc.type = @"0";
    [self.navigationController pushViewController:JTvc animated:YES];
}
- (void)MCPQTableViewCell:(MCPQTableViewCell *)PQListTableViewCell details:(UIButton *)Button{
    
    NSIndexPath *indexPath = [listTableView indexPathForCell:PQListTableViewCell];
        NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    NSLog(@"---%@",dataDictionary);
    MCJTDetailsViewController *JTvc = [[MCJTDetailsViewController alloc]init];
    
    JTvc .jtDic = dataDictionary;
    JTvc.type = @"0";
    [self.navigationController pushViewController:JTvc animated:YES];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
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
