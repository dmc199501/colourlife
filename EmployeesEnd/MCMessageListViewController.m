//
//  MCMessageListViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/27.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCMessageListViewController.h"
#import "MCWebViewController.h"
#import "MCHomePageTableViewCell.h"
@interface MCMessageListViewController ()
@property (nonatomic, assign) int page;  //请求页码
@end

@implementation MCMessageListViewController
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
    _page = 1;
    self.navigationItem.title = self.title;
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor whiteColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    
    
     [self therRefresh];
    [self loadMassage];
    
    //[listTableView setTableHeaderView:headerView];
    // Do any additional setup after loading the view.
}
- (void)changgeIsRed{

    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];
    
    [sendDictionary setValue:self.code forKey:@"client_code"];
    [sendDictionary setValue:username forKey:@"username"];
    
    
    
    [MCHttpManager PutWithIPString:BASEURL_AREA urlMethod:@"/push2/homepush/readhomePush" parameters:sendDictionary success:^(id responseObject)
    
     {
         
         
     } failure:^(NSError *error) {
         
         NSLog(@"****%@", error);
         
     }];
    
    

}
- (void)therRefresh{
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMassage)];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松手立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"努力刷新中" forState:MJRefreshStateRefreshing];
    
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
- (void)getoauth1:(NSString *)url andTitle:(NSString *)name andClientCode:(NSString *)clientCode{
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *passWord = [defaults objectForKey:@"passWordMI"];//根据键值取出name
    
    [sendDictionary setValue:username forKey:@"username"];
    [sendDictionary setValue:passWord forKey:@"password"];
    [sendDictionary setValue:clientCode forKey:@"clientCode"];
    
    NSLog(@"%@",sendDictionary);
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak  MBProgressHUD *weakHub = hub;
    hub.opacity = 1.0;
    [hub setDetailsLabelText:@"正在获取授权..."];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/auth" parameters:sendDictionary success:^(id responseObject) {
        [weakHub hide:YES];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                NSString *URLstring = @"";
                NSDictionary *dic = dicDictionary[@"content"];
                if ([url rangeOfString:@"?"].location != NSNotFound) {
                    URLstring = [NSString stringWithFormat:@"%@&openID=%@&accessToken=%@",url,dic[@"openID"],dic[@"accessToken"]];
                }else{
                    
                    URLstring = [NSString stringWithFormat:@"%@?openID=%@&accessToken=%@",url,dic[@"openID"],dic[@"accessToken"]];
                    
                }
                
                
               
                
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring]  titleString:name];
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
                
                
                
            }
            
            return ;
            
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
    
}
- (void)getoauth2:(NSString *)url andTitle:(NSString *)name anddeveloperCode:(NSString *)developerCode{
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *passWord = [defaults objectForKey:@"passWordMI"];//根据键值取出name
    
    [sendDictionary setValue:username forKey:@"username"];
    [sendDictionary setValue:passWord forKey:@"password"];
    [sendDictionary setValue:developerCode forKey:@"developerCode"];
    [sendDictionary setValue:@"cgj" forKey:@"accountType"];
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak  MBProgressHUD *weakHub = hub;
    hub.opacity = 1.0;
    [hub setDetailsLabelText:@"正在获取授权..."];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/auth2" parameters:sendDictionary success:^(id responseObject) {
        [weakHub hide:YES];
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                NSString *URLstring = @"";
                NSDictionary *dic = dicDictionary[@"content"];
                if ([url rangeOfString:@"?"].location != NSNotFound) {
                    URLstring = [NSString stringWithFormat:@"%@&username=%@&access_token=%@",url,username,dic[@"access_token"]];
                   
                }else{
                    
                    URLstring = [NSString stringWithFormat:@"%@?username=%@&access_token=%@",url,username,dic[@"access_token"]];
                    
                }
                
                               
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring]  titleString:name];
                webViewController.iosURL = URLstring;
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
                
                
            }
            
            return ;
            
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    bgView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245/ 255.0 alpha:1];
    return bgView;
    
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
    static NSString *indentifier = @"cell";
    MCHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCHomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    
    
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    NSLog(@"%@",dataDictionary);
    [cell.titleLabel setText:[NSString stringWithFormat:@"%@(%@)", [dataDictionary objectForKey:@"comefrom"],dataDictionary[@"owner_name"]]];
    
    [cell.contentLabel setText:[NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"title"]]];
    NSString *notread = [NSString stringWithFormat:@"%@",dataDictionary[@"notread"]];
    if ([notread integerValue] == 0 && notread != NULL) {
        NSLog(@"%@",dataDictionary);
        cell.noReadImageView.hidden = NO;
        
        //
    }else{
        
        cell.noReadImageView.hidden = YES;
        
    }
    cell.numberLabel.hidden = YES;
    //首先创建格式化对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //然后创建日期对象
    
    NSDate *date1 = [dateFormatter dateFromString:[dataDictionary objectForKey:@"homePushTime"]];
    
    NSDate *date = [NSDate date];
    
    //计算时间间隔（单位是秒）
    
    NSTimeInterval time = [date1 timeIntervalSinceDate:date];
    
    //计算天数、时、分、秒
    
    int days = ((int)time)/(3600*24);
    
    int hours = ((int)time)%(3600*24)/3600;
    
    int minutes = ((int)time)%(3600*24)%3600/60;
    
    int seconds = ((int)time)%(3600*24)%3600%60;
    
    NSString *dateContent = [[NSString alloc] initWithFormat:@"仅剩%i天%i小时%i分%i秒",days,hours,minutes,seconds];
    NSLog(@"%@",dateContent);
    if (days == 0 && hours == 0 && minutes <=10) {
        
        [cell.dateLabel setText:@"刚刚"];
        
    }else if (days == 0 ){
        
        NSString *dateString2 = [dataDictionary objectForKey:@"homePushTime"];
        
        [cell.dateLabel setText:[dateString2 substringFromIndex:10]];
        
        
    }else{
        
        NSString *dateString1 = [dataDictionary objectForKey:@"homePushTime"];
        
        [cell.dateLabel setText:[dateString1 substringToIndex:10]];
        
        
        NSLog(@"%@",[dateString1 substringToIndex:10]);
    }
    
    
    
    
    NSString *urlString = [dataDictionary objectForKey:@"ICON"];
    if ([urlString isKindOfClass:[NSString class]] && [urlString length] > 0)
    {
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"moren"]];
        
    }
    
    
    
   
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    [self loadMassage];
    
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    NSLog(@"%@",dataDictionary);
    NSString * URLString = [NSString stringWithFormat:@"%@",dataDictionary[@"url"]];
    
    NSString *code = [NSString stringWithFormat:@"%@",dataDictionary[@"client_code"]];
    NSString *type = [NSString stringWithFormat:@"%@",dataDictionary[@"auth_type"]];
    if ([type integerValue]==0) {
        [self getoauth1:URLString andTitle:dataDictionary[@"comefrom"] andClientCode:code];
    }else{
        [self getoauth2:URLString andTitle:dataDictionary[@"comefrom"] anddeveloperCode:code];}
    
    
    
    
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
        
        
        NSMutableDictionary *sendMutabelDictionary = [NSMutableDictionary dictionary];
        NSString * messageID = [NSString stringWithFormat:@"%@",[dataDictionary objectForKey:@"id"]];
        
        [sendMutabelDictionary setValue:messageID forKey:@"msgid"];
       
        
        //userToken	否	登录的时效身份标识  deviceSN	是	设备唯一序列号   deviceType	否	设备类型   pushID	是	pushID>0只删除当前pushID，不考虑删除全部  deleteAll	是	等于0时，删除pushID数据
        [MCHttpManager DeleteWithIPString:BASEURL_AREA urlMethod:@"/push2/homepush" parameters:sendMutabelDictionary success:^(id responseObject) {
            
            NSDictionary *dicDictionary = responseObject;
            NSLog(@"%@",dicDictionary);
            if ([dicDictionary[@"code"] integerValue] == 0 )
            {
                
               
                
                [self loadMassage];
                [tableView reloadData];
                return;
                
                
                
                
            }
            
            
            
            
            
            
            
            NSLog(@"----%@",responseObject[@"message"]);
            
        } failure:^(NSError *error) {
            
            NSLog(@"****%@", error);
            
        }];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 判断要显示的控制器是否是自己
//    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
//
//
//    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
//}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//
//
//
//     [self loadMassage];
//}
- (void)loadMassage{
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];
    

    NSString *corpType = [defaults objectForKey:@"corpType"];
    NSString *corpID = @"";
    if ([corpType isEqualToString:@"100"] && corpType.length>0) {
        //通用皮肤
        corpID = [defaults objectForKey:@"corpId"];
        
    } else
        
        if([corpType isEqualToString:@"101"] && corpType.length>0){
            corpID = [defaults objectForKey:@"corpId"];
            //彩管家4.0
        }else{
            // 中柱
            corpID = [defaults objectForKey:@"corpId"];
            
        }

    
    NSDictionary *sendDict = @{
                               @"username":username,
                               @"corp_id":corpID,
                               @"page":@1,
                               @"pagesize":@10,
                               @"client_code":self.code
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/push2/homepush" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                [listMutableArray setArray:dicDictionary[@"content"][@"data"]];
                
                                
                
                
                [listTableView reloadData];
                [self changgeIsRed];
                //[self setRedView];
                [listTableView.mj_header endRefreshing];
                
            }
            
        }else{
//            [listMutableArray setArray:dicDictionary[@"content"][@"data"]];
            [listTableView reloadData];
            //[self setRedView];
            [listTableView.mj_header endRefreshing];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       
        
        
    }];
    
    
    
    
}

- (void)loadMoreData{
    
    
    _page += 1;
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];
    NSString *corpType = [defaults objectForKey:@"corpType"];
    NSString *corpID = @"";
    if ([corpType isEqualToString:@"100"] && corpType.length>0) {
        //通用皮肤
        corpID = [defaults objectForKey:@"corpId"];
        
    } else
        
        if([corpType isEqualToString:@"101"] && corpType.length>0){
            
            //彩管家4.0
        }else{
            // 中柱
            corpID = [defaults objectForKey:@"corpId"];
            
        }
    
    
    
    NSDictionary *sendDict = @{
                               @"username":username,
                               @"page":@(_page),
                               @"pagesize":@10,
                               @"client_code":self.code,
                               @"corp_id":corpID
                               };
    
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/push2/homepush" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                [listMutableArray addObjectsFromArray:dicDictionary[@"content"][@"data"]];
                
                
                [listTableView reloadData];
                [listTableView.mj_footer endRefreshing];
                
                
                
                
            }
            
            
            
            
        }else{
            
            [listMutableArray addObjectsFromArray:dicDictionary[@"content"][@"data"]];
            
            
            [listTableView reloadData];
            [listTableView.mj_footer endRefreshing];
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
    
    [listTableView.mj_footer endRefreshing];
    
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
