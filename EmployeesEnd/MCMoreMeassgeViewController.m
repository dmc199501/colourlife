//
//  MCMoreMeassgeViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/7/6.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCMoreMeassgeViewController.h"
#import "MCsousuoTableViewCell.h"
#import "MCHomePageController.h"
#import "MCContactViewController.h"
#import "MCWebViewController.h"

@interface MCMoreMeassgeViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *resultArray;
@property(nonatomic,strong)NSArray *dataArray;

//@property(nonatomic,strong)NSString *keyword;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MCMoreMeassgeViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        personnellistMutableArray = [NSMutableArray array];
        messagelistMutableArray = [NSMutableArray array];
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    
        self.navigationItem.title = @"相关消息";
    
    messagelistMutableArray  = self.array;
    //[self getsearch];
    if (messagelistMutableArray.count>0) {
        [self.view addSubview:self.tableView];
    }else{
        
        UILabel *titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width , 36)];
        [self.view addSubview:titleLabel];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:20]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:GRAY_LIGHT_COLOR_ZZ];
        titleLabel.text = @"暂无更多内容";
        [titleLabel setTag:1213];
        
    }
    
    
    // Do any additional setup after loading the view.
}
-(UITableView *)tableView{
    
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -30, SCREEN_WIDTH,SCREEN_HEIGHT-20) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = 44;
        _tableView.layer.cornerRadius = 5;
        //_tableView.tableHeaderView = [self headView];
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
- (void)getsearch{
    
    if ([_type integerValue] == 1) {
        NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
        [sendDictionary setValue:self.souStr forKey:@"keyword"];
        
        [SVProgressHUD showWithStatus:@"加载..."];
        [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/phonebook/search" parameters:sendDictionary success:^(id responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *dicDictionary = responseObject;
            NSLog(@"%@",dicDictionary);
            if ([dicDictionary[@"code"] integerValue] == 0 )
            {
                if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
                {
                    
                    [messagelistMutableArray setArray:dicDictionary[@"content"]];
                    
                    
                    [self.view addSubview:self.tableView];
                    
                    [_tableView reloadData];
                    
                    
                }
                
                return ;
                
                
                
            }else{
                
                [personnellistMutableArray setArray:dicDictionary[@"content"]];
                [_tableView reloadData];
                
            }
            
            
            NSLog(@"----%@",responseObject);
            
        } failure:^(NSError *error) {
            
            NSLog(@"****%@", error);
            
        }];
        
    }else{
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *username = [defaults objectForKey:@"userName"];
        
        
        NSDictionary *sendDict = @{
                                   @"username":username,
                                   @"page_num":@1,
                                   @"page_size":@9999,
                                   @"keyword":self.souStr
                                   };
        
        [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/homelist" parameters:sendDict success:^(id responseObject) {
            
            NSDictionary *dicDictionary = responseObject;
            NSLog(@"%@",dicDictionary);
            if ([dicDictionary[@"code"] integerValue] == 0 )
            {
                if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
                {
                    
                    
                    [messagelistMutableArray setArray:dicDictionary[@"content"]];
                    
                    
                    
                    
                    
                    
                    [_tableView reloadData];
                    //[self setRedView];
                    [_tableView.mj_header endRefreshing];
                    
                    
                    
                }
                
            }else{
                
                [messagelistMutableArray setArray:dicDictionary[@"content"]];
                [_tableView reloadData];
                //[self setRedView];
                [_tableView.mj_header endRefreshing];
                
            }
            
            
            
            
        } failure:^(NSError *error) {
            
            
            NSLog(@"****%@", error);
            
            
            
        }];
        
        
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 50;
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
    
    //    return listMutableArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return messagelistMutableArray.count;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *indentifier = [NSString stringWithFormat:@"cell%@%@",@(indexPath.section), @(indexPath.row)];
    MCsousuoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCsousuoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
        
    }
    
    
    
        
        NSDictionary *dataDictionary =[messagelistMutableArray  objectAtIndex:indexPath.row];
        
        [cell.titleLabel setText:[NSString stringWithFormat:@"%@(%@)",dataDictionary[@"comefrom"],dataDictionary[@"owner_name"]]];
        [cell.jobLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"title"]]];
        
        [cell.iconImageView setClipsToBounds:NO];
        cell.iconImageView.frame = CGRectMake(10, 5, 40, 40);
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataDictionary[@"ICON"]] placeholderImage:[UIImage imageNamed:@"moren"]];
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
        
        
        NSDictionary *dataDictionary = [messagelistMutableArray objectAtIndex:indexPath.row];
        NSLog(@"%@",dataDictionary);
        NSString * URLString = [NSString stringWithFormat:@"%@",dataDictionary[@"url"]];
        
        NSString *code = [NSString stringWithFormat:@"%@",dataDictionary[@"client_code"]];
        NSString *type = [NSString stringWithFormat:@"%@",dataDictionary[@"auth_type"]];
        if ([type integerValue]==0) {
            [self getoauth1:URLString andTitle:dataDictionary[@"comefrom"] andClientCode:code];
        }else{
            [self getoauth2:URLString andTitle:dataDictionary[@"comefrom"] anddeveloperCode:code];}
        
    
    
    
    
    
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
                    NSLog(@"%@",URLstring);
                }else{
                    
                    URLstring = [NSString stringWithFormat:@"%@?username=%@&access_token=%@",url,username,dic[@"access_token"]];
                    
                }
                
                
                NSLog(@"%@",name);
                
                
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
