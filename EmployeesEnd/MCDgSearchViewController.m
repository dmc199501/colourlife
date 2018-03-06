//
//  MCDgSearchViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2018/1/10.
//  Copyright © 2018年 邓梦超. All rights reserved.
//

#import "MCDgSearchViewController.h"
#import "MyMD5.h"
#import "MCButTheListViewController.h"
@interface MCDgSearchViewController ()
@property (nonatomic, strong)UITextField *moneyTextField;//
@property (nonatomic, strong)NSString *orgStirng;
@end

@implementation MCDgSearchViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        listSearchArray = [NSMutableArray array];
        namelistMutableArray = [NSMutableArray array];
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"对公账户";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *homlist  = [userDefaults objectForKey:@"cardlist"];
    [listMutableArray setArray:homlist];
    
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    backView1.backgroundColor = [UIColor colorWithWhite:242 / 255.0 alpha:1];
    [self.view addSubview:backView1];
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 30)];
    backView.backgroundColor = [UIColor whiteColor];
    [backView1 addSubview:backView];
    [backView.layer setCornerRadius:4];
    
    UIImageView *ssimage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    [ssimage setImage:[UIImage imageNamed:@"colour_ss"]];
    [backView addSubview:ssimage];
    
    _moneyTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH-70, 30)];
    [_moneyTextField setPlaceholder:@"搜索当前架构/卡号"];
    [_moneyTextField setTextAlignment:NSTextAlignmentLeft];
    [_moneyTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [_moneyTextField setBackgroundColor:[UIColor whiteColor]];
    [_moneyTextField setFont:[UIFont systemFontOfSize:15]];
    [backView addSubview:_moneyTextField];
    
    
    UIView *soo = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(backView)+10, SCREEN_WIDTH, 30)];
    soo.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100, 30)];
    [soo addSubview:button];
    [button addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *imageS = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 5, 20, 20)];
    [imageS setImage:[UIImage imageNamed: @"colour_delete"]];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16,5 , 200, 20)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"历史搜索";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:46 / 255.0 green:54 / 255.0 blue:63/ 255.0 alpha:1];
    [soo addSubview:label];
    [soo addSubview:imageS];

    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50  ) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [listTableView setTableHeaderView:soo];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    listTableView.scrollEnabled = YES;

  
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
       return 40;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0.001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if ([tableView isEqual:ZZlistTableView]) {
         return namelistMutableArray.count;
    }else{
        return listMutableArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([tableView isEqual:listTableView]) {
        NSString *indentifier = [NSString stringWithFormat:@"cell"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        
        
        if (cell == nil)
        {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            
            
        }
        [cell.textLabel setTextColor:BLACK_COLOR_ZZ];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[listMutableArray objectAtIndex:indexPath.row]]];
        
        return cell;
    }else{
        NSString *indentifier = [NSString stringWithFormat:@"cell2"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        
        
        if (cell == nil)
        {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            
            
        }
        [cell.textLabel setTextColor:BLACK_COLOR_ZZ];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[[namelistMutableArray objectAtIndex:indexPath.row] objectForKey:@"name"]]];
        
        return cell;

        
    }
    return nil;
   
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([tableView isEqual:listTableView]) {
       
        if ([self isIncludeChineseInString:[listMutableArray objectAtIndex:indexPath.row]]) {
            _moneyTextField.text = [listMutableArray objectAtIndex:indexPath.row];
            [self setZZUI];
            
        }else{
            _moneyTextField.text = [listMutableArray objectAtIndex:indexPath.row];
            [self getAuthApp];
        
        }
       

    }else{
        
        _orgStirng = [[namelistMutableArray objectAtIndex:indexPath.row] objectForKey:@"uuid"];
        [self getAuthApp];
    
    }
}

-(void)next{

    if ([_moneyTextField.text length] ==0 ) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入架构/卡号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
   
    [self saveData];
    
    if ([self isIncludeChineseInString:_moneyTextField.text]) {
        [self setZZUI];
    }else{
        [self getAuthApp];
    }
    
    
   
   

}

-(void)setZZUI{
    
    [listTableView removeFromSuperview];
    [ZZlistTableView removeFromSuperview];
    ZZlistTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50-36, self.view.frame.size.width, self.view.frame.size.height -50 ) style:UITableViewStyleGrouped];
    [self.view addSubview:ZZlistTableView];
    [ZZlistTableView setBackgroundColor:[UIColor clearColor]];
    [ZZlistTableView setBackgroundView:nil];
    [ZZlistTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [ZZlistTableView setDelegate:self];
    [ZZlistTableView setDataSource:self];
    ZZlistTableView.scrollEnabled = YES;
    
    [self getOrg];

}
-(void)getOrg{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:_moneyTextField.text forKey:@"keyword"];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/org/page" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
               
                [namelistMutableArray setArray:dicDictionary[@"content"][@"list"]];
                if (namelistMutableArray.count>0) {
                    for (int i = 0; i<namelistMutableArray.count;i++ ){
                        
                        if ([[_dataDic objectForKey:@"name"] isEqualToString:[[namelistMutableArray objectAtIndex:i] objectForKey:@"name"]]) {
                            
                            [namelistMutableArray removeObjectAtIndex:i];
                        }
                    }
                }
                
                [ZZlistTableView reloadData];
            }
            
        }else{
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    



}
-(void)saveData{
    
    
    NSString *card = [NSString stringWithFormat:@"%@",_moneyTextField.text];
    
    NSString *string = [listMutableArray componentsJoinedByString:@","];
    
    if (string.length>0) {
        
        if (![string containsString:card]){
            
            [listMutableArray addObject:card];
        }

    }else{
        
     [listMutableArray addObject:card];
    }
   
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array1 = [listMutableArray copy];
    
    [userDefaults setObject:array1 forKey:@"cardlist"];
    [userDefaults synchronize];
    [listTableView reloadData];

    
}

-(void)deleteData{

    UIAlertView *inputPassword = [[UIAlertView alloc] initWithTitle:@"" message:@"确认清空历史搜索？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    inputPassword.alertViewStyle = UIAlertViewStyleDefault;
    inputPassword.delegate = self;
    [inputPassword show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
if (buttonIndex == 0) {
            
            
                
                
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cardlist"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [listMutableArray removeAllObjects];
   
    [listTableView reloadData];
   
    
                
            
        }
        
    
    
    
}


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
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 &&[dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
        {
            
            [self getdata:[dicDictionary[@"content"] objectForKey:@"accessToken"]];
            
            
            
            
        }else{
            
           
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    
    
    
}

-(BOOL)isIncludeChineseInString:(NSString*)str {
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}
- (void)getdata:(NSString *)token{
   
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    
    [sendDictionary setValue:token forKey:@"token"];
    [sendDictionary setValue:@1 forKey:@"showmoney"];
    [sendDictionary setValue:@1 forKey:@"status"];
    if ([self isIncludeChineseInString:_moneyTextField.text]) {
        [sendDictionary setValue:_orgStirng forKey:@"familyUuid"];
    }else{
     [sendDictionary setValue:_moneyTextField.text forKey:@"ano"];
    }
    
   [SVProgressHUD showWithStatus:@"查询中"];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/dgzh/account/search4web" parameters:sendDictionary success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                NSArray *array = dicDictionary[@"content"][@"list"];
                if (array.count>0) {
                    MCButTheListViewController *listVC = [[MCButTheListViewController alloc]init];
                   
                   
                    for (int i = 0; i<array.count; i++) {
                        if ([[_dataDic objectForKey:@"typeName"] isEqualToString:[[array objectAtIndex:i] objectForKey:@"typeName"]
                             ] && ![[_dataDic objectForKey:@"ano"] isEqualToString:[[array objectAtIndex:i] objectForKey:@"ano"]
                                  ] ) {
                            
                            [listSearchArray addObject:[array objectAtIndex:i]];
                            
                        }
                    }
                    if (listSearchArray.count>0) {
                        listVC.listArray = listSearchArray;
                        listVC.dataDic = _dataDic;
                        [self.navigationController pushViewController:listVC animated:YES];
                    }else{
                    
                     [SVProgressHUD showErrorWithStatus:@"未找到账户信息"];
                    }
                    
                }else{
                    
                [SVProgressHUD showErrorWithStatus:@"未找到账户信息"];
                    
                }
                
                
            }
            
        }else{
            
           
           [SVProgressHUD showErrorWithStatus:@"未找到账户信息"];        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"未找到账户信息"];
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
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
