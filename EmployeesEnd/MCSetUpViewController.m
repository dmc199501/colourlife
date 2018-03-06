//
//  MCSetUpViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/12/15.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCSetUpViewController.h"
#import "MCLoginViewControler.h"
#import "MCAboutAPPViewController.h"
#import "MCFeedbackViewController.h"
#import "MCChangePasswordViewController.h"
@interface MCSetUpViewController ()
@property(nonatomic,strong)NSString *douwnUrl;

@end

@implementation MCSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更多设置";
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  ) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    //    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    
    
    UIButton *leaveButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 210, SCREEN_WIDTH-40, 40)];
    [leaveButton setBackgroundColor:BLUK_COLOR_ZAN_MC];
    
    [leaveButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [leaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leaveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [leaveButton addTarget:self action:@selector(leave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leaveButton];
    [leaveButton.layer setCornerRadius:4];
    
       

    // Do any additional setup after loading the view.
}

- (void)leave{
    
    [MCPublicDataSingleton sharePublicDataSingleton].userDictionary = nil;
    [MCPublicDataSingleton sharePublicDataSingleton].isLogin = NO;
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passWord"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ts"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isOrgName"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"applistone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"applisttwo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token1.0"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"openID1.0"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token2.0"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"oauth1time"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"oauth2time"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"expires"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"secret"];//饭票相关的key
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"key"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fpquanxian"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"contactList"];//收藏联系人列表
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cardlist"];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fencheng"];
    [[NSUserDefaults standardUserDefaults] synchronize];
        MCLoginViewControler *LoginView = [[MCLoginViewControler alloc]init];
    
    
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];  // 获得根窗口
    
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:LoginView];
        window.rootViewController = nav;
    
    return;
    
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    return 45;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    switch (section)
    {
        case 0:
        {
            return 1;
        }
            break;
            
        default:
        {
            return 1;
        }
            break;
    }
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
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
    switch (section)
    {
        case 0:
        {
            return 4;
        }
            break;
            
        default:
        {
            return 1;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *indentifier = [NSString stringWithFormat:@"cell%@%@",@(indexPath.section), @(indexPath.row)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        [cell.textLabel setTextColor:BLACK_COLOR_ZZ];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        
        switch (indexPath.section)
        {
            case 0:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        [cell.textLabel setText:@"关于我们"];
                        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 22, 15, 10, 15)];
                        [arrowImageView setImage:[UIImage imageNamed:@"huise"]];
                        [cell addSubview:arrowImageView];
//                        }
                    }
                        break;
                        
                    case 5:
                    {
//                        [cell.textLabel setText:@"意见反馈"];
//                        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 22, 17, 10, 10)];
//                        [arrowImageView setImage:[UIImage imageNamed:@"huise"]];
//                        [cell addSubview:arrowImageView];
                                            }
                        break;
                        
                    case 1:
                    {
                        [cell.textLabel setText:@"修改密码"];
                       UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 22, 15, 10, 15)];
                        [arrowImageView setImage:[UIImage imageNamed:@"huise"]];
                    [cell addSubview:arrowImageView];
                    }
                        break;
                    case 2:
                    {
                        [cell.textLabel setText:@"清空首页列表"];
                        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 22, 15, 10, 15)];
                        [arrowImageView setImage:[UIImage imageNamed:@"huise"]];
                        [cell addSubview:arrowImageView];
                    }
                        break;
                    case 3:
                    {
                        [cell.textLabel setText:@"版本检测"];
                        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 22, 15, 10, 15)];
                        [arrowImageView setImage:[UIImage imageNamed:@"huise"]];
                        [cell addSubview:arrowImageView];
                        
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-185, 12.5, 150, 20)];
                        label.textAlignment = NSTextAlignmentRight;
                        label.font = [UIFont systemFontOfSize:13];
                        [label setTextColor:GRAY_COLOR_ZZ];
                        [cell addSubview:label];
                        label.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                
            }
                break;
                
                
            default:
            {
                //                [cell.textLabel setText:@"退出登录"];
                //                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                
            }
                break;
        }
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                   
                    MCAboutAPPViewController *aboutVC = [[MCAboutAPPViewController alloc]init];
                    [self.navigationController pushViewController:aboutVC animated:YES];
                }
                    break;
                case 1:
                {
                    MCChangePasswordViewController *ChangePasswordVC = [[MCChangePasswordViewController alloc]init];
                    [self.navigationController pushViewController:ChangePasswordVC animated:YES];
                }
                    break;
                case 2:
                {
                    
                    

                    UIAlertView *inputPassword = [[UIAlertView alloc] initWithTitle:@"" message:@"确认清空首页消息列表？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                    inputPassword.alertViewStyle = UIAlertViewStyleDefault;
                    inputPassword.delegate = self;
                    [inputPassword show];
                    
                    
                   
                }
                    break;
                case 3:
                {
                     [self VersionUpdate];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
       
        default:
            {
                
            }
            break;
        }
    
}




- (void)VersionUpdate{
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSString *Version = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [sendDictionary setValue:@"ios" forKey:@"type"];
    [sendDictionary setValue:Version forKey:@"version"];
    
    NSLog(@"%@",sendDictionary);
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/czywg/version" parameters:sendDictionary success:^(id responseObject)
     {
         
         NSDictionary *dicDictionary = responseObject;
         NSLog(@"---%@",dicDictionary);
         
         if ([dicDictionary[@"code"] integerValue] == 0 )
         {
             
             NSString *result = dicDictionary[@"content"][@"result"];
             _douwnUrl = dicDictionary[@"content"][@"info"][0][@"download_url"];
             
             
             NSString *string = @"";
             
             
             
             if ([result integerValue] ==1) {
                 
                 
                 [SVProgressHUD showSuccessWithStatus:@"最新版本"];
                 
             }
             if ([result integerValue] ==-1) {
                 NSArray *array = dicDictionary[@"content"][@"info"][0][@"func"];
                 if (array.count>=1) {
                     string = [array componentsJoinedByString:@","];
                 }
                 
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"检查更新:彩管家" message:string delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:nil, nil];
                 alert.tag = 1005;
                 [alert show];
                 
                 
             }
             if ([result integerValue] ==0 ) {
                 NSArray *array = dicDictionary[@"content"][@"info"][0][@"func"];
                 if (array.count>=1) {
                     string = [array componentsJoinedByString:@","];
                 }
                 NSString *titelStr = @"检查更新:彩管家";
                 NSString *messageStr = @"发现新版本是否更新";
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titelStr message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更新", nil];
                 alert.tag = 1006;
                 [alert show];
                 
             }
             
             
             
         }
         
         
         
     } failure:^(NSError *error) {
         
         NSLog(@"****%@", error);
         
     }];
    
    
}
- (void)delayMethod{

  [SVProgressHUD dismiss];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag - 1000 == 5||alertView.tag - 1000 ==6)
    {
        if (buttonIndex ==1)
        {
            
                        
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_douwnUrl]];
            
        }
        
    }else{
        if (buttonIndex == 0) {
            
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSString *username = [defaults objectForKey:@"userName"];
            
            NSMutableDictionary *sendMutabelDictionary = [NSMutableDictionary dictionary];
            
            
            [sendMutabelDictionary setValue:username forKey:@"username"];
            
            //userToken	否	登录的时效身份标识  deviceSN	是	设备唯一序列号   deviceType	否	设备类型   pushID	是	pushID>0只删除当前pushID，不考虑删除全部  deleteAll	是	等于0时，删除pushID数据
            [SVProgressHUD showWithStatus:@"清空消息中..."];
            [MCHttpManager DeleteWithIPString:BASEURL_AREA urlMethod:@"/push2/homepush/deleteall" parameters:sendMutabelDictionary success:^(id responseObject) {
                [SVProgressHUD dismiss];
                NSDictionary *dicDictionary = responseObject;
                NSLog(@"%@",dicDictionary);
                if ([dicDictionary[@"code"] integerValue] == 0 )
                {
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                   
                    [defaults setObject:@"yes" forKey:@"isClean"];
                    [SVProgressHUD showSuccessWithStatus:@"成功"];
                    [MCPublicDataSingleton sharePublicDataSingleton].isclean = @"1";
                    return;
                    
                    
                    
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:@"清空失败"];
                
                }
                
                
                
                
                
                
                
                NSLog(@"----%@",responseObject[@"message"]);
                
            } failure:^(NSError *error) {
                
                NSLog(@"****%@", error);
                
            }];

        }
    
    }
    
    
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
