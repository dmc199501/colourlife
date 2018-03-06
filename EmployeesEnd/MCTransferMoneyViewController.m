//
//  MCTransferMoneyViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/9.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCTransferMoneyViewController.h"
#import "MCTransferMoneyTableViewCell.h"
#import "MCRedEnvelopesViewController.h"
#import "MCSelectViewController.h"
#import "MCCZYViewController.h"
#import "TPPasswordTextView.h" 
#import "MCAddCardViewController.h"
#import "MCWebViewController.h"
#import "MCBindingCZYViewController.h"
@interface MCTransferMoneyViewController ()

@end

@implementation MCTransferMoneyViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
       
        [listMutableArray addObject:@[@{@"icon":@"tongshi", @"title":@"给同事发红包", @"content":@"红包互转,轻松自在"}]];
        [listMutableArray addObject:@[@{@"icon":@"zhuanCZY-", @"title":@"转到彩之云账户", @"content":@"在彩之云平台消费红包无需扣税"}]];
        
        [listMutableArray addObject:@[@{@"icon":@"tixian-", @"title":@"提现到我的银行卡", @"content":@"遵循国家法律规定，提现至银行卡账户需缴纳提现金额的20%作为所得税，提现申请日期依据审批而定，节假日顺延"}]];
        
        
    }
    return  self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"转出与提现";
    [self getBalance];
        // Do any additional setup after loading the view.
}
- (void)getBalance{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:key forKey:@"key"];
    [dic setValue:secret forKey:@"secret"];
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/getBalance" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                if ([dicDictionary[@"content"][@"activityInfo"] isKindOfClass:[NSArray class]])
                {
                    _datalistMutableArray  = dicDictionary[@"content"][@"activityInfo"];
                    self.balance = [NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"balance"]];
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    
                    [userDefaults setObject:[NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"balance"]] forKey:@"fanpiao"];
                    [userDefaults synchronize];
                    
                    [self setUI];

                }
               
                
                
            }
            
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        [SVProgressHUD showErrorWithStatus:@"请求超时"];
        
        
    }];
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
}

- (void)setUI{

    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -44, self.view.frame.size.width, self.view.frame.size.height  ) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    listTableView.scrollEnabled = YES;


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    switch (indexPath.section)
    {
        case 2:
        {
            return 108;        }
            break;
            
        default:
        {
            
        }
            break;
    }
    return 80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    switch (section)
    {
        case 0:
        {
            return 0.000001;
        }
            break;
            
        default:
        {
            return 0.0000001;
        }
            break;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return listMutableArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    return footView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return ((NSArray *)([listMutableArray objectAtIndex:section])).count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    NSString *indentifier = [NSString stringWithFormat:@"cell%@%@",@(indexPath.section), @(indexPath.row)];
    MCTransferMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCTransferMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
        [cell.iconImageView setImage:[UIImage imageNamed:[[[listMutableArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"icon"]]];
        
        [cell.titleLabel setText:[[_datalistMutableArray objectAtIndex:indexPath.section] objectForKey:@"title"]];
        [cell.contentLabel setText:[[_datalistMutableArray objectAtIndex:indexPath.section] objectForKey:@"describe"]];
        
        
    }
   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    MCTransferMoneyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    [self paymentPasswordIsHave:[NSString stringWithFormat:@"%ld",indexPath.section]];
    }

- (void)paymentPasswordIsHave:(NSString *)type{

    if ([self.balance floatValue]==0.0) {
        [SVProgressHUD showErrorWithStatus:@"饭票余额不足" duration:1.0];
    }else{
       
        [self getIsSetPassWord:type];
     
    }

}

- (void)getIsSetPassWord:(NSString *)type{

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    
    NSDictionary *sendDict = @{
                               @"position":type,
                               @"key":key,
                               @"secret":secret
                               };
    NSLog(@"%@",sendDict);
    [SVProgressHUD show];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/hongbao/isSetPwd" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                if ([dicDictionary[@"content"][@"state"] isEqualToString:@"hasPwd"]) {
                    //有密码
                    MCRedEnvelopesViewController *rewardVC = [[MCRedEnvelopesViewController alloc]init];
                    rewardVC.balance = self.balance;
                    [self.navigationController pushViewController:rewardVC animated:YES];
                    
                }else if ([dicDictionary[@"content"][@"state"] isEqualToString:@"noPwd"]){
                
                    [self next:@"0"];
                
                }else if ([dicDictionary[@"content"][@"state"] isEqualToString:@"hasBind"]){
                //已经绑定彩之云
                    
                    MCCZYViewController *czyVC = [[MCCZYViewController alloc]init];
                    czyVC.balance = self.balance;
                    czyVC.dataDic = dicDictionary[@"content"][@"list"];
                    [self.navigationController pushViewController:czyVC animated:YES];
                
                }else if ([dicDictionary[@"content"][@"state"] isEqualToString:@"noBind"]){
                //去绑定彩之云
                    
                    MCBindingCZYViewController *bingVC = [[MCBindingCZYViewController alloc]init];
                    [self.navigationController pushViewController:bingVC animated:YES];
                
                }
                else if ([dicDictionary[@"content"][@"state"] isEqualToString:@"hasCard"]){
                    //银行卡
                    MCSelectViewController *selecVC = [[MCSelectViewController alloc]init];
                    selecVC.balance = self.balance;
                    [self.navigationController pushViewController:selecVC animated:YES];
                   
                    
                }else if ([dicDictionary[@"content"][@"state"] isEqualToString:@"noCard"]){
                    //去绑定
                    
                    MCAddCardViewController *addVC = [[MCAddCardViewController alloc]init];
                    addVC.balance = self.balance;
                    [self.navigationController pushViewController:addVC animated:YES];
                    
                    
                }


                
            }
            
        }else{
           
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       [SVProgressHUD dismiss];
        
        
    }];
    
    
    

}
- (void)getoauth1{
    NSString *url = @"http://www.colourlife.com/bindCustomer";
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *passWord = [defaults objectForKey:@"passWordMI"];//根据键值取出name
    
    [sendDictionary setValue:username forKey:@"username"];
    [sendDictionary setValue:passWord forKey:@"password"];
    [sendDictionary setValue:@"bdczy" forKey:@"clientCode"];
    
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
                
                
                NSLog(@"----:%@",URLstring);
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring]  titleString:@"绑定彩之云"];
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
                
                
                
            }
            
            return ;
            
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        [weakHub hide:YES];
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
        NSLog(@"****%@", error);
        
    }];
    
    
    
}

-(void)next:(NSString *)type{
    
    _backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.tabBarController.view addSubview:_backView];
    _backView.alpha = 0.5;
    _backView.backgroundColor = BLACKS_COLOR_ZZ;
    
    
    if (SCREEN_WIDTH == 320) {
        _passWordView = [[UIView alloc]initWithFrame:CGRectMake(40, (SCREEN_HEIGHT-420)/2, SCREEN_WIDTH-80, 200)];
    }else{
        _passWordView = [[UIView alloc]initWithFrame:CGRectMake(40, (SCREEN_HEIGHT-320)/2, SCREEN_WIDTH-80, 200)];}
    _passWordView.backgroundColor = [UIColor whiteColor];
    //[_userPhotoImageView setUserInteractionEnabled:NO];
    [_passWordView.layer setCornerRadius:5];
    
    [_passWordView setClipsToBounds:YES];
    [self.tabBarController.view addSubview:_passWordView];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(_passWordView.frame.size.width -70, 10, 50, 25);
    [_passWordView addSubview:cancelButton];
    
    [cancelButton setImage:[UIImage imageNamed:@"guanbii"] forState:UIControlStateNormal];
    
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(cancelButton)+10, _passWordView.frame.size.width, 20)];
    [_passWordView addSubview:label2];
    if ([type integerValue] == 0) {
        label2.text= @"请设置支付密码";
    }else{
     label2.text= @"请输入支付密码进行验证";
    }
    
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor =  [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:13];
    
    TPPasswordTextView *view2 = [[TPPasswordTextView alloc] initWithFrame:CGRectMake(20,BOTTOM_Y(label2)+20, _passWordView.frame.size.width-40, 44)];
    view2.elementCount = 6;
    //view2.center = CGPointMake(center.x, 100);
    view2.elementBorderColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1];
    [_passWordView addSubview:view2];
    view2.passwordDidChangeBlock = ^(NSString *password) {
        NSLog(@"%@",password);
        self.passWord = password;
        
    };
    
    UIButton *leaveButton = [[UIButton alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(view2)+20, _passWordView.frame.size.width-40, 40)];
    [leaveButton setBackgroundColor:[UIColor colorWithRed:0 / 255.0 green:157 / 255.0 blue:255/ 255.0 alpha:1]];
    
    [leaveButton setTitle:@"完成" forState:UIControlStateNormal];
    [leaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leaveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leaveButton addTarget:self action:@selector(nextPush:)
          forControlEvents:UIControlEventTouchUpInside];
    if ([type integerValue] == 0) {
        leaveButton.tag = 1000;
    }else{
    leaveButton.tag = 1001;
    }
    [_passWordView addSubview:leaveButton];
    [leaveButton.layer setCornerRadius:4];
    
}

- (void)cancel{
    
    [_backView removeFromSuperview];
    [_passWordView removeFromSuperview];
    
}
- (void)nextPush:(UIButton *)button{
    
    [_backView removeFromSuperview];
    [_passWordView removeFromSuperview];
    if (button.tag == 1000) {
        [self verifyPay];
    }else{
    
    //验证支付密码
        [self yzPAY];
    }
    
    
    
}

- (void)yzPAY{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    NSDictionary *sendDict = @{
                               @"password":self.passWord,
                               @"key":key,
                               @"secret":secret
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/checkPayPwd" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                if ([dicDictionary[@"content"][@"state"] isEqualToString:@"no"]) {
                    [SVProgressHUD showErrorWithStatus:@"密码错误"];
                }else{
                    
                  
                }
                
            }
            
        }else{
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    



}
- (void)verifyPay{
    
    
        
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    NSDictionary *sendDict = @{
                               @"password":self.passWord,
                               @"key":key,
                               @"secret":secret
                               };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/hongbao/setPwd" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                if ([dicDictionary[@"content"][@"state"] isEqualToString:@"ok"]) {
                    [SVProgressHUD showSuccessWithStatus:@"设置成功"];
                    [self cancel];
                    MCRedEnvelopesViewController *rewardVC = [[MCRedEnvelopesViewController alloc]init];
                    rewardVC.balance = self.balance;
                    [self.navigationController pushViewController:rewardVC animated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
                }
                
            }
            
        }else{
            
            
        }
        
        
        
        
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
