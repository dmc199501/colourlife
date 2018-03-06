//
//  MCJSFPListViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/12.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCJSFPListViewController.h"
#import "MCJSFPTableViewCell.h"
#import "MCFPParticularsViewController.h"
#import "MyMD5.h"
#import "MCExchangeRecordViewController.h"
#import "MCExchangViewController.h"
@interface MCJSFPListViewController ()<MCJSFPTableViewCellDelegate>

@end

@implementation MCJSFPListViewController
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
    self.navigationItem.title = @"即时分配";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"兑换记录" style:UIBarButtonItemStylePlain target:self action:@selector(certain)];
    
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
        [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    [self getlistData];

   
    
   // [listTableView setTableHeaderView:self.view];

    // Do any additional setup after loading the view.
}
#pragma mark -获取资源2.0授权
- (void)getAuthApp{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *corp = [defaults objectForKey:@"corpId"];
    NSString *ts = [defaults objectForKey:@"ts"];
    

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"33f09c7ca5e6491fbcdfd363cf58851e" forKey:@"app_uuid"];//app分配id
    [dic setValue:corp forKey:@"corp_uuid"];//租户ID
    NSString *singe = [NSString stringWithFormat:@"%@%@%@",@"33f09c7ca5e6491fbcdfd363cf58851e",ts,@"48a8c06966fb40e3b1c55c95692be1d8"];
    
    NSString *  signature = [MyMD5 md5:singe];//签名=( APPID +ts +appSecret)md5
    [dic setValue:signature forKey:@"signature"];
    [dic setValue:ts forKey:@"timestamp"];//时间戳
    
    
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/authms/auth/app" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 &&[dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
        {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dicDictionary[@"content"] objectForKey:@"accessToken"] forKey:@"orgToken"];
            [defaults synchronize];
            [self getlistData];
            
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    
    
    
}
#pragma mark- 领取列表数据获取
-(void)getlistData{
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *orgToken = [defaults objectForKey:@"orgToken"];
    NSString *username = [defaults objectForKey:@"userName"];
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:username forKey:@"split_target"];//账号
    [sendDictionary setValue:orgToken forKey:@"access_token"];
    [sendDictionary setValue:@2 forKey:@"split_type"];
    
    
    
    
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/split/api/account" parameters:sendDictionary success:^(id responseObject) {
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            
            if ([dicDictionary[@"content"][@"detail"] isKindOfClass:[NSArray class]])
            {
               
                [listMutableArray setArray:dicDictionary[@"content"][@"detail"]];
                if (listMutableArray.count == 0) {
                    imagew = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70)/2, 100, 70, 70)];
                    [imagew setImage:[UIImage imageNamed:@"sp_wugg"]];
                    [self.view addSubview:imagew];
                    
                    labelw = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(imagew)+10, SCREEN_WIDTH, 20)];
                    labelw.text = @"当前暂无数据";
                    labelw.textAlignment = NSTextAlignmentCenter;
                    labelw.textColor = GRAY_COLOR_BACK_ZZ;
                    [self.view addSubview:labelw];

                }else{
                    [listTableView reloadData];
                }
               
                
            }
            
            
            
            
        }else{
            

            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"message"]];
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    

}
#pragma mark- 兑换记录点击事件
-(void)certain{
    MCExchangeRecordViewController *exVC = [[MCExchangeRecordViewController alloc]init];
    [self.navigationController pushViewController:exVC animated:YES];



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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
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
    MCJSFPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCJSFPTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.delegate = self;
    }
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    [cell.nameLabel setText:[NSString stringWithFormat:@"应用:%@",dataDictionary[@"general_name"]]];
    [cell.moneyLabel setText:[NSString stringWithFormat:@"+%.2f",[dataDictionary[@"split_money"] floatValue]]];
  
    
    return cell;
}


#pragma mark-兑换按钮点击事件代理方法
-(void)MCJSFPTableViewCell:(MCJSFPTableViewCell *)JSFPListTableViewCell exchange:(UIButton *)Button{
    
    NSIndexPath *indexPath = [listTableView indexPathForCell:JSFPListTableViewCell];
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    NSLog(@"---%@",dataDictionary);
    MCExchangViewController *ExVC = [[MCExchangViewController alloc]init];
    
    ExVC.dataDic = dataDictionary;
    [self.navigationController pushViewController:ExVC animated:YES];



}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    
    MCFPParticularsViewController *ParticularsVC = [[MCFPParticularsViewController alloc]init];
    ParticularsVC.datadic = dataDictionary;
    [self.navigationController pushViewController:ParticularsVC animated:YES];
    
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
