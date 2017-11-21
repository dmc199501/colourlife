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
@interface MCDgAccountViewController ()

@end

@implementation MCDgAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"对公账户";
    //[self getdata];
    [self getAuthApp];
    [self getAuthApp1];
    // Do any additional setup after loading the view.
}
-(void)setListView{

    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,-36, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
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
            
            [self getdata:[dicDictionary[@"content"] objectForKey:@"accessToken"]];
            
            
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
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 &&[dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
        {
            
          
            NSString *token = [NSString stringWithFormat:@"%@",[dicDictionary[@"content"] objectForKey:@"access_token"]];
            NSLog(@"%@",token);
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
    
    NSLog(@"%@",sendDictionary);
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/splitdivide/api/appsdetail" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
            {
                
                [nameMutableArray setArray:dicDictionary[@"content"]];
                
                [self setListArray];
                
                
            }
            
        }else{
            
            [self setErrorUI];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];


}
#pragma mark -整理两个数组数据
-(void)setListArray{
    NSLog(@"%@-%@",listMutableArray,nameMutableArray);
    for (int i=0; i<listMutableArray.count; i++)
        
    {
        
        for (int j=0; j<nameMutableArray.count; j++) {
            
            if ([[[listMutableArray objectAtIndex:i] objectForKey:@"pano"] isEqualToString:[[nameMutableArray objectAtIndex:j] objectForKey:@"pano"]]) {
                
                NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary:[listMutableArray objectAtIndex:i]] ;
                
                [dic setValue:[[nameMutableArray objectAtIndex:j] objectForKey:@"name"] forKey:@"sourceName"];
                
                [listMutableArray replaceObjectAtIndex:i withObject:dic];
                
                
            }
            
        }
        
    }
   
    if (listMutableArray.count>0) {
        [self setListView];
    }else{
        [self setErrorUI];
    }
    [listTableView reloadData];
    
    
    [listTableView.mj_header endRefreshing];


}
- (void)getdata:(NSString *)token{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"userInfo"];
    NSLog(@"%@",dic);
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:[dic objectForKey:@"uuid"] forKey:@"userId"];
    [sendDictionary setValue:token forKey:@"token"];
   
     [sendDictionary setValue:@1 forKey:@"userType"];
    [sendDictionary setValue:@1 forKey:@"familyType"];

    
  
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/dgzh/account/search4web" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[dicDictionary class]])
            {
                
                [listMutableArray setArray:[dicDictionary[@"content"] objectForKey:@"list"]];
                
                
            }
            
        }else{
            
            [self setErrorUI];

        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
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
        
    }
    NSDictionary *dataDic = [listMutableArray objectAtIndex:indexPath.row];
    [cell.accountName setText:[NSString stringWithFormat:@"账户名:%@",[dataDic objectForKey:@"name"]]];
    [cell.carNumber setText:[NSString stringWithFormat:@"卡号:%@",[dataDic objectForKey:@"ano"]]];
    [cell.typeLabel setText:[NSString stringWithFormat:@"种类:%@",[dataDic objectForKey:@"typeName"]]];
    [cell.moneyLabel setText:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"money"]]];
    NSString *sourceName = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"sourceName"]];
    if ([sourceName isEqualToString:@"(null)"]) {
        
        [cell.sourceLabel setText:[NSString stringWithFormat:@"来源:%@",[dataDic objectForKey:@"pid"]]];
    }else{
    [cell.sourceLabel setText:[NSString stringWithFormat:@"来源:%@",[dataDic objectForKey:@"sourceName"]]];
    
    }
   

    
   
    
    return cell;
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
