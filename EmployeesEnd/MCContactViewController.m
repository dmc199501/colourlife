//
//  MCContactViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/12/16.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCContactViewController.h"
#import "MCWebViewController.h"
#import "UIBarButtonItem+Item.h"
#import <MessageUI/MessageUI.h>
@interface MCContactViewController ()<UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate>
@property(nonatomic,strong)NSDictionary *dataDic;
@end

@implementation MCContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"员工名片";
        [self getContact];
   
    
    // Do any additional setup after loading the view.
}

- (void)getContact{


    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"userName"];
    

    NSDictionary *sendDict = [NSDictionary dictionary];
    if (self.type == 3) {
        sendDict = @{
                     @"uid":uid,
                     
                     @"appID":@"colourlife",
                     @"contactsID":_dataDictionary[@"username"],
                     
                                   };

    }else{
        
      sendDict = @{
                                   @"uid":uid,
                                   
                                   @"appID":@"colourlife",
                                  @"contactsID":_dataDictionary[@"username"],
                                   
                                   };

    
    
    }
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/phonebook/contacts" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                self.dataDic = dicDictionary[@"content"];
                
                [self setUI];
                
                
            }
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    



}
- (void)setUI{
    
    if ([_dataDic[@"isFavorite"] integerValue]==1) {
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"shoucang_2mp"] highImage:[UIImage imageNamed:@"shoucang_2mp"] target:self action:@selector(deletePeople) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"shoucang_mp"] highImage:[UIImage imageNamed:@"shoucang_mp"] target:self action:@selector(addPeople) forControlEvents:UIControlEventTouchUpInside];
    }
    

    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 210)];
    backView.backgroundColor = DARK_COLOER_ZZ;
    [self.view addSubview:backView];
    
   UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 30, 80, 80)];
    [backView addSubview:iconImageView];
    [iconImageView setClipsToBounds:YES];
    [iconImageView.layer setCornerRadius:iconImageView.frame.size.width / 2];
    if ([ _dataDic[@"avatar"] isKindOfClass:[NSString class]] &&[_dataDic[@"avatar"] length]>0) {
        [iconImageView sd_setImageWithURL:_dataDic[@"avatar"] placeholderImage:[UIImage imageNamed:@"moren_geren"]];
    }else{
        
        [iconImageView setImage:[UIImage imageNamed:@"moren_geren"]];
    }
    
    
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(iconImageView)+20, SCREEN_WIDTH, 20)];
    nameLabel.textColor = [UIColor whiteColor];
    [nameLabel setFont:[UIFont systemFontOfSize:17]];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [nameLabel setText:[NSString stringWithFormat:@"%@(%@)",_dataDic[@"realname"],_dataDic[@"username"]]];
    [backView addSubview:nameLabel];
    
    
    UILabel *jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(nameLabel)+20, SCREEN_WIDTH/2, 20)];
    jobLabel.textColor = GRAY_COLOR_BACK_ZZ;
    [jobLabel setFont:[UIFont systemFontOfSize:15]];
    jobLabel.textAlignment = NSTextAlignmentCenter;
    [jobLabel setText:[NSString stringWithFormat:@"%@",_dataDic[@"jobName"]]];
    [backView addSubview:jobLabel];
    
    
    UILabel *departmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, BOTTOM_Y(nameLabel)+20, SCREEN_WIDTH/2, 20)];
    departmentLabel.textColor = GRAY_COLOR_BACK_ZZ;
    [departmentLabel setFont:[UIFont systemFontOfSize:15]];
    departmentLabel.textAlignment = NSTextAlignmentCenter;
    [departmentLabel setText:[NSString stringWithFormat:@"%@",_dataDic[@"orgName"]]];
    [backView addSubview:departmentLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, BOTTOM_Y(nameLabel)+22, 1, 15)];
    [backView addSubview:line];
    line.backgroundColor =  GRAY_COLOR_BACK_ZZ;
    
    
    
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(backView)+10, SCREEN_WIDTH, 70)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneView];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 20)];
    [phoneLabel setText:[NSString stringWithFormat:@"%@",_dataDic[@"mobile"]]];
    [phoneView addSubview:phoneLabel];
    phoneLabel.font = [UIFont systemFontOfSize:15];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *phoneLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 200, 20)];
    [phoneLabel2 setText:[NSString stringWithFormat:@"%@",@"手机号码"]];
    [phoneView addSubview:phoneLabel2];
    [phoneLabel2 setTextColor:GRAY_COLOR_ZZ];
    phoneLabel2.font = [UIFont systemFontOfSize:15];
    phoneLabel2.textAlignment = NSTextAlignmentLeft;
    
    UIButton *phoneButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 20, 30, 30)];
    [phoneView addSubview:phoneButton];
    [phoneButton setBackgroundImage:[UIImage imageNamed:@"dianhua_mp"] forState:UIControlStateNormal];
    phoneButton.tag = 1011;
    [phoneButton addTarget:self action:@selector(tell:) forControlEvents:UIControlEventTouchUpInside];
    
   
    
    //座机
    UIView *landlineView = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(phoneView)+1, SCREEN_WIDTH, 70)];
    landlineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:landlineView];
    
    UILabel *landlineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 20)];
    [landlineLabel setText:[NSString stringWithFormat:@"%@",_dataDic[@"landline"]]];
    [landlineView addSubview:landlineLabel];
    landlineLabel.font = [UIFont systemFontOfSize:15];
    landlineLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *landlineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 200, 20)];
    [landlineLabel2 setText:[NSString stringWithFormat:@"%@",@"座机"]];
    [landlineView addSubview:landlineLabel2];
    [landlineLabel2 setTextColor:GRAY_COLOR_ZZ];
    landlineLabel2.font = [UIFont systemFontOfSize:15];
    landlineLabel2.textAlignment = NSTextAlignmentLeft;
    
    UIButton *landlineButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 20, 30, 30)];
    [landlineView addSubview:landlineButton];
    [landlineButton setBackgroundImage:[UIImage imageNamed:@"zuoji_mp"] forState:UIControlStateNormal];
    landlineButton.tag = 1012;
    [landlineButton addTarget:self action:@selector(tell:) forControlEvents:UIControlEventTouchUpInside];
    //部门
    
    UIView *departmentView = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(landlineView)+10, SCREEN_WIDTH, 50)];
    departmentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:departmentView];
    
    UILabel *departments = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 20)];
    [departments setText:[NSString stringWithFormat:@"%@",@"所属部门"]];
    [departmentView addSubview:departments];
    [departments setTextColor:[UIColor blackColor]];
    departments.font = [UIFont systemFontOfSize:15];
    departments.textAlignment = NSTextAlignmentLeft;
    
    UILabel *departments2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, 15, 150, 20)];
    [departments2 setText:[NSString stringWithFormat:@"%@",_dataDic[@"orgName"]]];
    [departmentView addSubview:departments2];
    [departments2 setTextColor:GRAY_COLOR_ZZ];
    departments2.font = [UIFont systemFontOfSize:15];
    departments2.textAlignment = NSTextAlignmentRight;
    
    //发邮件 发短信
    
    UIView *mailView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40-64, SCREEN_WIDTH, 40)];
    [self.view addSubview:mailView];
    mailView.backgroundColor = [UIColor whiteColor];
   
    
    UILabel *mailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH/2, 20)];
    [mailLabel setText:[NSString stringWithFormat:@"%@",@"发邮件"]];
    [mailView addSubview:mailLabel];
    [mailLabel setTextColor:[UIColor blackColor]];
    mailLabel.font = [UIFont systemFontOfSize:15];
    mailLabel.textAlignment = NSTextAlignmentCenter;

    
    UIImageView *mailImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4 -40 , 12, 15, 15)];
    [mailImage setImage:[UIImage imageNamed:@"youjian_mp"]];
    [mailView addSubview:mailImage];
    
    UIButton *mailButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 40)];
    [mailView addSubview:mailButton];
    [mailButton addTarget:self action:@selector(GOmail) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 12.5, 1, 15)];
    [mailView addSubview:line2];
    line2.backgroundColor =  GRAY_COLOR_BACK_ZZ;
    
    
    UILabel *smsLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 10, SCREEN_WIDTH/2, 20)];
    [smsLabel setText:[NSString stringWithFormat:@"%@",@"发短信"]];
    [mailView addSubview:smsLabel];
    [smsLabel setTextColor:[UIColor blackColor]];
    smsLabel.font = [UIFont systemFontOfSize:15];
    smsLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIImageView *smsImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + SCREEN_WIDTH/4  -40 , 12, 15, 15)];
    [smsImage setImage:[UIImage imageNamed:@"duanxin_mp"]];
    [mailView addSubview:smsImage];
    
    UIButton *smsButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40)];
    [mailView addSubview:smsButton];
    [smsButton addTarget:self action:@selector(GOsms) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    




}
- (void)GOsms{

//   [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",_dataDic[@"mobile"]]]];
    NSString *string = [NSString stringWithFormat:@"%@",_dataDic[@"mobile"]];
   [self showMessageView:[NSArray arrayWithObjects:string, nil] title:@"" body:@""];
   

}
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    switch (result) {
        case MessageComposeResultSent:{
            //信息传送成功
            [self.navigationController popViewControllerAnimated:YES];}
            break;
        case MessageComposeResultFailed:{
            //信息传送失败
            [self.navigationController popViewControllerAnimated:YES];}
            break;
        case MessageComposeResultCancelled:{
            
            //信息被用户取消传送
        }
            break;
        default:
            break;
    }
}


- (void)GOmail{
    
   
        NSString *clientCode = [NSString stringWithFormat:@"%@",@"xyj"];
        NSString *urloauth1 = [NSString stringWithFormat:@"%@",@"http://mail.oa.colourlife.com:40060/login"];
        [self getoauth2:urloauth1 andTitle:@"新邮件" anddeveloperCode:clientCode];
        

    
    
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

- (void)getoauth1:(NSString *)url andTitle:(NSString *)name andClientCode:(NSString *)clientCode{
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *passWord = [defaults objectForKey:@"passWordMI"];//根据键值取出name
    
    [sendDictionary setValue:username forKey:@"username"];
    [sendDictionary setValue:passWord forKey:@"password"];
    [sendDictionary setValue:clientCode forKey:@"clientCode"];
    
    NSLog(@"%@",sendDictionary);
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/auth" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = dicDictionary[@"content"];
                NSString *urlString = [NSString stringWithFormat:@"%@?openID=%@&accessToken=%@",url,dic[@"openID"],dic[@"accessToken"]];
                
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:urlString]  titleString:name];
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

- (void)tell:(UIButton *)button{
    if (button.tag == 1011) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", _dataDic[@"mobile"]]]];
    }else if (button.tag == 1012){
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", _dataDic[@"tel"]]]];
    
    }
    
}
- (void)deletePeople{

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"userName"];  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:uid forKey:@"uid"];
    [dic setValue:_dataDic[@"username"] forKey:@"contactsID"];    [MCHttpManager DeleteWithIPString:BASEURL_AREA urlMethod:@"/phonebook/favoriteContacts" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
             [self getContact];
                
            [SVProgressHUD showSuccessWithStatus:dicDictionary[@"message"]];
           
            
        }else{
        
        
         [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       
        
        
    }];
    
    
    
    

}

- (void)addPeople{
   
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"userName"];  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:uid forKey:@"uid"];
    [dic setValue:_dataDic[@"username"] forKey:@"contactsID"];

    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/phonebook/favoriteContacts" parameters:dic success:^(id responseObject) {
       
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            
            [self getContact];
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            
        }else{
        
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
   // [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
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
