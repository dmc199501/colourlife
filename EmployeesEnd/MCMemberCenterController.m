//
//  MCMemberCenterController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCMemberCenterController.h"
#import "MCMemberCenterTableViewCell.h"
#import "MCUserInformationViewController.h"
#import "MCSetUpViewController.h"
#import  "MCSendComplaintAndSuggestViewControler.h"
#import "MyMD5.h"
#import "MCWebViewController.h"
#import "MCTemporarypasswordViewController.h"
#import "MCFanPiaoViewController.h"
#import "DownListViewController.h"
#import "MCMycodeViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "MCDgAccountViewController.h"
@interface MCMemberCenterController ()

@end

@implementation MCMemberCenterController
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        [listMutableArray addObject:@[@{@"": @"", @"title":@""},@{@"icon":@"饭票1", @"title":@"我的饭票"},@{@"icon": @"zfmima-cgj", @"title":@"找回支付密码"}]];
       
        [listMutableArray addObject:@[@{@"icon": @"bangdin-cgj", @"title":@"彩之云账号绑定"},@{@"icon": @"yaoqing-cgj", @"title":@"邀请"}]];
        [listMutableArray addObject:@[@{@"icon": @"xiazai-cgj", @"title":@"我的下载"},@{@"icon": @"shezhi-cgj", @"title":@"设置"}]];
        
        
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"我的";
   
    
    userPhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 11, 67, 67)];
    userPhotoImageView.layer.cornerRadius = 8;
    
    userPhotoImageView.layer.masksToBounds = YES;
    back = [[UIImageView alloc]initWithFrame:CGRectMake(11, 10, 68, 68)];
    [back setImage:[UIImage imageNamed:@"iconBJ"]];;
    
    userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 20, self.view.frame.size.width - 120, 20)];
    // [tableHeaderView addSubview:userNameLabel];
    [userNameLabel setTextAlignment:NSTextAlignmentLeft];
    [userNameLabel setBackgroundColor:[UIColor clearColor]];
    [userNameLabel setTextColor:[UIColor whiteColor]];
    [userNameLabel setFont:[UIFont systemFontOfSize:16]];
    [userNameLabel setText:@""];
    
    jobNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 50, self.view.frame.size.width - 120, 20)];
    // [tableHeaderView addSubview:userNameLabel];
    [jobNameLabel setTextAlignment:NSTextAlignmentLeft];
    [jobNameLabel setBackgroundColor:[UIColor clearColor]];
    [jobNameLabel setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
    [jobNameLabel setFont:[UIFont systemFontOfSize:14]];
    [jobNameLabel setText:@""];

    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64  ) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    listTableView.scrollEnabled = YES;
    // Do any additional setup after loading the view.
}



-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@avatar?uid=%@", USER_ICON_URL,username]];
    UIImage *defaultImage = [UIImage imageNamed:@"default.png"];
    NSLog(@"%@",url);
    [userPhotoImageView sd_setImageWithURL:url placeholderImage:defaultImage options:SDWebImageRefreshCached];

   
    
    
       [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row) {
                case 0:{
                    return 97.5;
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
    return 50;

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
            return 10;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return ((NSArray *)([listMutableArray objectAtIndex:section])).count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    NSString *indentifier = [NSString stringWithFormat:@"cell%@%@",@(indexPath.section), @(indexPath.row)];
    MCMemberCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCMemberCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
        [cell.iconImageView setImage:[UIImage imageNamed:[[[listMutableArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"icon"]]];
        [cell.titleLabel setText:[[[listMutableArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"title"]];
        
        
    }
    if (indexPath.section ==0) {
        if (indexPath.row == 0) {
            cell.line2.hidden = YES;
            cell.backgroundColor = DARK_COLOER_ZZ;
            [cell addSubview:back];
            [cell addSubview:userPhotoImageView];
            
            [cell addSubview:jobNameLabel];
            [cell addSubview:userNameLabel];
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSDictionary *dics = [defaults objectForKey:@"userInfo"];
            NSDictionary *userInfoDictionary = [MCPublicDataSingleton sharePublicDataSingleton].userDictionary;
            NSLog(@"%@",userInfoDictionary);
            [userNameLabel setText:[NSString stringWithFormat:@"%@",[dics objectForKey:@"realname"]]];
            [jobNameLabel setText:[NSString stringWithFormat:@"%@",[dics objectForKey:@"jobName"]]];
            
            cell.arrowImageView.hidden = YES;
            UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake( SCREEN_WIDTH- 30,32.5, 10, 15)];
            [cell addSubview:arrowImageView];
            [arrowImageView  setImage:[UIImage imageNamed:@"huise"]];
            
//            
            
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    MCMemberCenterTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if ([cell.titleLabel.text isEqualToString:@""])
    {
        MCUserInformationViewController *userInformationViewController = [[MCUserInformationViewController alloc]init];
        userInformationViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:userInformationViewController animated:YES];
        
    }
    if ([cell.titleLabel.text isEqualToString:@"更多设置"])
    {
        MCSetUpViewController *SetViewController = [[MCSetUpViewController alloc]init];
        SetViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:SetViewController animated:YES];
        
    }
    if ([cell.titleLabel.text isEqualToString:@"邀请"])
    {
        MCMycodeViewController *codevc = [[MCMycodeViewController alloc]init];
        codevc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:codevc animated:YES];
        
//        MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:@"http://iceapi.colourlife.com:8081/v1/caiguanjia/qrcode"]  titleString:@"邀请"];
//        webViewController.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:webViewController animated:YES];
    }
    if ([cell.titleLabel.text isEqualToString:@"获取临时密码"])
    {
        
        MCTemporarypasswordViewController *tpassVC = [[MCTemporarypasswordViewController alloc]init];
        tpassVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tpassVC animated:YES];
        
        
        
        
    }
    if ([cell.titleLabel.text isEqualToString:@"找回支付密码"])
    {
        
        UIAlertView *inputPassword = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入OA密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        inputPassword.alertViewStyle = UIAlertViewStyleSecureTextInput;
        inputPassword.delegate = self;
        [inputPassword show];
        
        
        
    }
    if ([cell.titleLabel.text isEqualToString:@"彩之云账号绑定"])
    {
        
        [self getoauth1];
        
        
        
        
    }
    if ([cell.titleLabel.text isEqualToString:@"设置"])
    {
        
        
        
        MCSetUpViewController *SetViewController = [[MCSetUpViewController alloc]init];
        SetViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:SetViewController animated:YES];
        
        
    }
    
    if ([cell.titleLabel.text isEqualToString:@"我的饭票"])
    {
        
        
       MCFanPiaoViewController  *fpViewController = [[MCFanPiaoViewController alloc]init];
        fpViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:fpViewController animated:YES];
        

        
        
        
    }
    if ([cell.titleLabel.text isEqualToString:@"帮助"])
    {
        
        
        
        NSString *url = [NSString stringWithFormat:@"http://www.colourlife.com/Introduction/CgjCall%@",@""];
        MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:url]  titleString:@"帮助"];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
        
        
    }

    if ([cell.titleLabel.text isEqualToString:@"我的下载"])
    {
        
        
        
        DownListViewController *downController = [[DownListViewController alloc]init];
        downController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:downController animated:YES];
        
        
    }
    if ([cell.titleLabel.text isEqualToString:@"分享"])
    {
        NSString *url = [NSString stringWithFormat:@"http://192.168.2.175:40064/testlogin%@",@""];
        MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:url]  titleString:@""];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
        
        
        
    }
    


    



    



}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        //确定
        UITextField *textInput = [alertView textFieldAtIndex:0];
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *pass = [defaults objectForKey:@"passWord"];
        NSLog(@"%@",pass);
        if ([textInput.text isEqualToString:pass]) {
            
            [self clearPASS];
        }else{
        [SVProgressHUD showErrorWithStatus:@"密码错误"];
        }
        //        DLog(@"%@", textInput.text);
        }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clearPASS{

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
   
    NSString *username = [defaults objectForKey:@"userName"];
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:username forKey:@"oa"];
    
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/czywg/employee/clearPayPwd" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                NSString *type = [NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"status"]];
                if ([type integerValue] ==0) {
                    [SVProgressHUD showErrorWithStatus:dicDictionary[@"content"][@"message"]];
                }else{
                
                    [SVProgressHUD showSuccessWithStatus:dicDictionary[@"content"][@"message"]];
                }
                
            }
            
            return ;
            
            
            
        }else{
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
