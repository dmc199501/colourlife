//
//  MCMessageVIiewControler.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/9.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCMessageVIiewControler.h"
#import "MCHomePageTableViewCell.h"
#import "MCWebViewController.h"
@implementation MCMessageVIiewControler
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
    }
    
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title =  self.titleString;
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor whiteColor]];
    [listTableView setBackgroundView:nil];
    //    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMeaasgeData)];
    
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



}
- (void)loadMeaasgeData{

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];

    
    NSDictionary *sendDict = @{
                               @"weiappcode":self.codeString,
                               @"uid":uid,
                               @"appID":@"colourlife",
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/homepush/gethomePushByweiappId" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
            {
                
                
                [listMutableArray setArray:dicDictionary[@"content"]];
                NSLog(@"%@",listMutableArray);
                [listTableView reloadData];
                [listTableView.mj_header endRefreshing];
                
                
                
            }
            
        }else{
            [listMutableArray setArray:dicDictionary[@"content"]];
            NSLog(@"%@",listMutableArray);
            [listTableView reloadData];
            [listTableView.mj_header endRefreshing];
        
        }
        
        
        
        
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
    return 1;
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
    [cell.titleLabel setText:[NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"content"]]];
    
    [cell.contentLabel setText:[NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"homePushTime"]]];
    cell.dateLabel.hidden = YES;
    NSString *urlString = [dataDictionary objectForKey:@"icon"];
    if ([urlString isKindOfClass:[NSString class]] && [urlString length] > 0)
    {
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"moren"]];
        
    }
    cell.noReadImageView.hidden = nil;
    if ([dataDictionary[@"isread"] integerValue]== 1) {
        cell.noReadImageView.hidden = YES;
    }
    cell.noReadImageView.frame= CGRectMake(40, 12, 10, 10);
    [cell.noReadImageView.layer setCornerRadius:5];
    cell.numberLabel.hidden = YES;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *password = [defaults objectForKey:@"passWord"];
    //根据键值取出
    
    NSString *token  = [defaults objectForKey:@"access_token"];
    NSString *token_p = [NSString stringWithFormat:@"%@",[MCPublicDataSingleton sharePublicDataSingleton].token];
    if (token_p.length>0) {
        token = [NSString stringWithFormat:@"%@",token_p];
    }
    NSString * URLString = dataDictionary[@"HTML5url"];
    NSString *URLstring = @"";
    if ([URLString rangeOfString:@"?"].location != NSNotFound) {
        URLstring = [NSString stringWithFormat:@"%@&username=%@&access_token=%@",URLString,username,token];
    }else{
        URLstring = [NSString stringWithFormat:@"%@?username=%@&access_token=%@",URLString,username,token];
        
    }
    
    
    
    NSLog(@"%@",URLstring);
    MCWebViewController *wbViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring] titleString:dataDictionary[@"content"]];
    wbViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wbViewController animated:YES];
   
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self loadMeaasgeData];
}
@end
