//
//  MCDgAccountViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/9/5.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCDgAccountViewController.h"
#import "MCDgAccountTableViewCell.h"
#import "MyMD5.h"
#import "MCDGmxViewController.h"
#import "MCDgSearchViewController.h"
#import "MCDhAccountViewController.h"
@interface MCDgAccountViewController ()<MCDgAccountTableViewCellDelegate>
@property(nonatomic,strong)NSString *appToken;
@property (nonatomic, assign) int page;  //请求页码

@end

@implementation MCDgAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"对公账户";
    //[self getdata];
    _page = 0;
   
   [self setListView];
    [self therRefresh];
    
    // Do any additional setup after loading the view.
}
- (void)therRefresh{
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAuthApp)];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松手立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"数据加载中..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置刷新控件
    listTableView.mj_header = header;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti1) name:@"DGZHLOAD" object:nil];
    


}
-(void)noti1{
  
   [self getAuthApp];
   

}
-(void)setListView{

    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];


}
- (void)setErrorUI{


    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 100, 150, 150)];
    [self.view addSubview:imageView];
    //imageView.backgroundColor = [UIColor yellowColor];
    [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",@"kong"]]];
    
    

}
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        nameMutableArray = [NSMutableArray array];
        
    }
    
    return self;
}
#pragma mark - 2.0授权
/**
 *
 */
- (void)getAuthApp{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *corp = [defaults objectForKey:@"corpId"];
    NSString *ts = [defaults objectForKey:@"ts"];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   // ICEXCGJ0-5F89-4E17-BC44-7A0DB101B245",ts,@"AXPHrD48LRa8xYVkgV4c
    [dic setValue:@"ICEXCGJ0-5F89-4E17-BC44-7A0DB101B245" forKey:@"app_uuid"];//app分配id
    [dic setValue:corp forKey:@"corp_uuid"];//租户ID
    
    NSString *singe = [NSString stringWithFormat:@"%@%@%@",@"ICEXCGJ0-5F89-4E17-BC44-7A0DB101B245",ts,@"AXPHrD48LRa8xYVkgV4c"];
    
    NSString *  signature = [MyMD5 md5:singe];//签名=( APPID +ts +appSecret)md5
    [dic setValue:signature forKey:@"signature"];
    [dic setValue:ts forKey:@"timestamp"];//时间戳
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/authms/auth/app" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        
        
        if ([dicDictionary[@"code"] integerValue] == 0 &&[dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
        {
           
            [self getdata:[dicDictionary[@"content"] objectForKey:@"accessToken"]];
            _appToken = [dicDictionary[@"content"] objectForKey:@"accessToken"];
            
            
            
        }else{
            
            [self setErrorUI];

        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    
    
    
}
#pragma -mark 1.0授权
/**
 *1.0授权token接口
 */
- (void)getAuthApp1{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
       NSString *ts = [defaults objectForKey:@"ts"];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:@"ZrmOyoAMgIdzKbHCHKwJ" forKey:@"appkey"];//app分配id
    //[dic setValue:corp forKey:@"corp_uuid"];//租户ID
    
    NSString *singe = [NSString stringWithFormat:@"%@%@%@",@"ZrmOyoAMgIdzKbHCHKwJ",ts,@"m6AHElkzVBHltuzrjADZIhZTT6W1hTa4"];
    
    NSString *  signature = [MyMD5 md5:singe];//签名=( APPID +ts +appSecret)md5
    [dic setValue:signature forKey:@"signature"];
    [dic setValue:ts forKey:@"timestamp"];//时间戳
    NSLog(@"%@",dic);
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/jqfw/app/auth" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        
        
        if ([dicDictionary[@"code"] integerValue] == 0 &&[dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
        {
            
          
            NSString *token = [NSString stringWithFormat:@"%@",[dicDictionary[@"content"] objectForKey:@"access_token"]];
            
            [self getAppsdetail:token];
            
        }else{
            
            [self setErrorUI];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    
    
    
}
-(void)getAppsdetail:(NSString *)token{

    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
   
    [sendDictionary setValue:token forKey:@"access_token"];
    
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/split/api/appdetail" parameters:sendDictionary success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"][@"result"] isKindOfClass:[NSArray class]])
            {
                
            [nameMutableArray setArray:dicDictionary[@"content"][@"result"]];
                
                [self setListArray];
                
                
            }
            
        }else{
            
            [self setErrorUI];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [self setErrorUI];
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请求超时"];

        NSLog(@"****%@", error);
        
        
        
    }];


}
#pragma mark -整理两个数组数据
-(void)setListArray{
    
   
    for (int i=0; i<listMutableArray.count; i++)
        
    {
        
        for (int j=0; j<nameMutableArray.count; j++) {
            
            if ([[[listMutableArray objectAtIndex:i] objectForKey:@"pano"] isEqualToString:[[nameMutableArray objectAtIndex:j] objectForKey:@"pano"]]) {
                
                NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary:[listMutableArray objectAtIndex:i]] ;
                
                [dic setValue:[[nameMutableArray objectAtIndex:j] objectForKey:@"general_name"] forKey:@"sourceName"];
                
                [listMutableArray replaceObjectAtIndex:i withObject:dic];
                
                
            }
            
        }
        
    }
   
    NSLog(@"%@",listMutableArray);
    [listTableView reloadData];
    
    
    [listTableView.mj_header endRefreshing];


}
-(void)loadMoreData{

    _page += 10;
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"userInfo"];
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:[dic objectForKey:@"uuid"] forKey:@"userId"];
    [sendDictionary setValue:@1 forKey:@"userType"];
    [sendDictionary setValue:_appToken forKey:@"token"];
    [sendDictionary setValue:@1 forKey:@"showmoney"];
    [sendDictionary setValue:@1 forKey:@"status"];
    [sendDictionary setValue:@(_page) forKey:@"skip"];
    [sendDictionary setValue:@10 forKey:@"limit"];
    NSLog(@"参数%@",sendDictionary);
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/dgzh/account/search4web" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                if ([[dicDictionary[@"content"] objectForKey:@"list"] count]==0) {
                    [listTableView.mj_footer endRefreshing];
                    listTableView.mj_footer.state = MJRefreshStateNoMoreData;
                    
                }else{
                   

                    NSArray *array = [dicDictionary[@"content"] objectForKey:@"list"];
                   
                    for (int k=0; k<array.count; k++) {
                        if ([[[array objectAtIndex:k] objectForKey:@"adminLevel"] integerValue] ==1) {
                            [listMutableArray addObject:[array objectAtIndex:k]];
                        }
                    }

                    [self getAppsdetail:_appToken];
                    [listTableView.mj_footer endRefreshing];
                }
                
                
            }
            
        }else{
            
            [self setErrorUI];
             [listTableView.mj_footer endRefreshing];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
         [listTableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"请求超时"];
        
        
    }];
    


}
- (void)getdata:(NSString *)token{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"userInfo"];

    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:[dic objectForKey:@"uuid"] forKey:@"userId"];
    [sendDictionary setValue:@1 forKey:@"userType"];
    [sendDictionary setValue:token forKey:@"token"];
     [sendDictionary setValue:@1 forKey:@"showmoney"];
    [sendDictionary setValue:@1 forKey:@"status"];
    [sendDictionary setValue:@0 forKey:@"skip"];
    [sendDictionary setValue:@10 forKey:@"limit"];
   
//     [sendDictionary setValue:@1 forKey:@"userType"];
//    [sendDictionary setValue:@1 forKey:@"familyType"];

    //[SVProgressHUD showWithStatus:@"数据加载中,请稍后..."];
       [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/dgzh/account/search4web" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
           NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                if ([[dicDictionary[@"content"] objectForKey:@"total"] integerValue]==0) {
                     [self setErrorUI];
                   [listTableView.mj_header endRefreshing];
                }else{
                    NSArray *array = [dicDictionary[@"content"] objectForKey:@"list"];
                //[listMutableArray setArray:[dicDictionary[@"content"] objectForKey:@"list"]];
                for (int k=0; k<array.count; k++) {
                        if ([[[array objectAtIndex:k] objectForKey:@"adminLevel"] integerValue] ==1) {
                  [listMutableArray addObject:[array objectAtIndex:k]];
                        }
                    }

                [self getAppsdetail:token];
                }
                
            }
            
        }else{
            
            [self setErrorUI];

        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        [SVProgressHUD showErrorWithStatus:@"请求超时"];
        
        
    }];
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 260;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    return footView;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
//{
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//    UILabel *bgView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
//    bgView.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
//    bgView.textAlignment = NSTextAlignmentCenter;
//    bgView.font = [UIFont systemFontOfSize:14];
//    bgView.text = @"--把社区服务做到家--";
//    return bgView;
//    
//}
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
    MCDgAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCDgAccountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.delegate = self;
    }
    NSDictionary *dataDic = [listMutableArray objectAtIndex:indexPath.row];
    [cell.accountName setText:[NSString stringWithFormat:@"账户名:%@",[dataDic objectForKey:@"name"]]];
    [cell.carNumber setText:[NSString stringWithFormat:@"卡号:%@",[dataDic objectForKey:@"ano"]]];
    [cell.typeLabel setText:[NSString stringWithFormat:@"种类:%@",[dataDic objectForKey:@"typeName"]]];
    
    [cell.moneyLabel setText:[NSString stringWithFormat:@"%.2f",[[dataDic objectForKey:@"money"] doubleValue] ]];
    NSString *sourceName = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"sourceName"]];
    if ([sourceName isEqualToString:@"(null)"]) {
       
        [cell.sourceLabel setText:[NSString stringWithFormat:@"来源:%@",[dataDic objectForKey:@"pid"]]];
    }else{
        
      [cell.sourceLabel setText:[NSString stringWithFormat:@"来源:%@",[dataDic objectForKey:@"sourceName"]]];
      
       
    
    }
    
    NSString *adminLevel = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"adminLevel"]];
    NSString *pano = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"pano"]];
    NSString *atid = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"atid"]];
    
    if ([pano isEqualToString:@"107126107b3f36d446a6addf4242b9c5"] && [atid isEqualToString:@"71"] &&[adminLevel isEqualToString:@"1"]) {
         cell.dhButton.backgroundColor = BLUK_COLOR_ZAN_MC;
        cell.dhButton.userInteractionEnabled = YES;
    }else{
        cell.dhButton.userInteractionEnabled = NO;
        cell.dhButton.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204/ 255.0 alpha:1];
    }
    if ([adminLevel isEqualToString:@"0"]) {
       
        cell.syButton.userInteractionEnabled = NO;
        cell.syButton.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204/ 255.0 alpha:1];
        
    }else{
        
        cell.syButton.backgroundColor = BLUK_COLOR_ZAN_MC;

    }

    
   
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
}
#pragma mark-、明细点击事件代理方法
-(void)MCDgAccountTableViewCell:(MCDgAccountTableViewCell *)MCDgAccountTableViewCell exchange:(UIButton *)Button{
    
    NSIndexPath *indexPath = [listTableView indexPathForCell:MCDgAccountTableViewCell];
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    
    MCDGmxViewController *mVC = [[MCDGmxViewController alloc]init];
    mVC.dic = dataDictionary;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-、使用转账点击事件代理方法

-(void)MCDgAccountTableViewCell:(MCDgAccountTableViewCell *)MCDgAccountTableViewCell transfer:(UIButton *)Button{
    
    NSIndexPath *indexPath = [listTableView indexPathForCell:MCDgAccountTableViewCell];
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];

   
    
    MCDgSearchViewController *DgSearchVC = [[MCDgSearchViewController alloc]init];
    DgSearchVC.dataDic = dataDictionary;
    [self.navigationController pushViewController:DgSearchVC animated:YES];
}
#pragma mark-、使用兑换点击事件代理方法

-(void)MCDgAccountTableViewCell:(MCDgAccountTableViewCell *)MCDgAccountTableViewCell dhAccount:(UIButton *)Button{
    
    NSIndexPath *indexPath = [listTableView indexPathForCell:MCDgAccountTableViewCell];
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    
    MCDhAccountViewController *dhVC = [[MCDhAccountViewController alloc]init];
    dhVC.dataDic = dataDictionary;
    [self.navigationController pushViewController:dhVC animated:YES];
    
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
