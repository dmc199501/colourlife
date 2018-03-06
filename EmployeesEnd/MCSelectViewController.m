//
//  MCSelectViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/13.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCSelectViewController.h"
#import "MCMyBousTableViewCell.h"
#import "MCAddCardViewController.h"
#import "MCTXjiluViewController.h"
#import "MCWhatTXViewController.h"
@interface MCSelectViewController ()

@end

@implementation MCSelectViewController
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择银行卡";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    [self getdata];
    
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    back.backgroundColor = [UIColor clearColor];
    
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 40)];
    
    addButton.layer.cornerRadius = 4;
    [addButton setTitle:@"新增银行卡" forState:UIControlStateNormal];
    addButton.layer.masksToBounds = YES;
    addButton.backgroundColor =[UIColor colorWithRed:0 / 255.0 green:157 / 255.0 blue:255/ 255.0 alpha:1];
    [back addSubview:addButton];
    [addButton addTarget:self action:@selector(addbank) forControlEvents:UIControlEventTouchUpInside];
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor whiteColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    [listTableView setTableFooterView:back];
    
   
    
    // Do any additional setup after loading the view.
}
- (void)next{
    
    MCTXjiluViewController *txvc = [[MCTXjiluViewController alloc]init];
    [self.navigationController pushViewController:txvc animated:YES];


}
-(void)addbank{

    MCAddCardViewController *addbankVC = [[MCAddCardViewController alloc]init];
    [self.navigationController pushViewController:addbankVC animated:YES];




}
- (void)getdata{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    [SVProgressHUD show];
    NSDictionary *sendDict = @{
                               @"page":@1,
                               @"pagesize":@10,
                               @"key":key,
                               @"secret":secret
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/bindBankList" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                [listMutableArray setArray:dicDictionary[@"content"][@"bankCardList"]];
                [listTableView reloadData];
                //[self setRedView];
                [listTableView.mj_header endRefreshing];
                
            }
            
        }else{
            [listMutableArray setArray:dicDictionary[@"content"][@"bankCardList"]];
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
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
    [cell.bous setText:[NSString stringWithFormat:@"%@",dataDictionary[@"bankName"]]];
    [cell.dateLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"card_num"]]];
    cell.moneyLabel.hidden = YES;
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    
    MCWhatTXViewController *txVC = [[MCWhatTXViewController alloc]init];
    txVC.name = dataDictionary[@"card_holder"];
    txVC.bank = dataDictionary[@"bankName"];
    txVC.card = dataDictionary[@"card_num"];
    txVC.balance = self.balance;
    txVC.cardID = dataDictionary[@"bank_id"];
    txVC.bindID = dataDictionary[@"id"];
    [self.navigationController pushViewController:txVC animated:YES];
    NSLog(@"---%ld",indexPath.row);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
{
    return @"删除";
}

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}
// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
        
        //        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        //    [hub setLabelText:@""];
        //        [hub setDetailsLabelText:@"正在删除......"];
        //        __weak  MBProgressHUD *weakHub = hub;
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *key = [defaults objectForKey:@"key"];
         NSString *secret = [defaults objectForKey:@"secret"];
        
        NSMutableDictionary *sendMutabelDictionary = [NSMutableDictionary dictionary];
       
        [sendMutabelDictionary setValue:key forKey:@"key"];
        [sendMutabelDictionary setValue:secret forKey:@"secret"];
        NSString *url = [NSString stringWithFormat:@"/hongbao/bankDelete/%@",dataDictionary[@"id"]];
        NSLog(@"%@",url);
        //userToken	否	登录的时效身份标识  deviceSN	是	设备唯一序列号   deviceType	否	设备类型   pushID	是	pushID>0只删除当前pushID，不考虑删除全部  deleteAll	是	等于0时，删除pushID数据
        [MCHttpManager DeleteWithIPString:BASEURL_AREA urlMethod:url parameters:sendMutabelDictionary success:^(id responseObject) {
            
            NSDictionary *dicDictionary = responseObject;
            NSLog(@"%@",dicDictionary);
            if ([dicDictionary[@"code"] integerValue] == 0 )
            {
                
                //                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"删除成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                //                [alertView show];
                //                ;
                
                [self getdata];
                [tableView reloadData];
                return;
                
                
                
                
            }
            
            
            
            
            
            
            
            NSLog(@"----%@",responseObject[@"message"]);
            
        } failure:^(NSError *error) {
            
            NSLog(@"****%@", error);
            
        }];
        
    }
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
