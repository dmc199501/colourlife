//
//  MCChangePasswordViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/12/15.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCChangePasswordViewController.h"
#import "MCLoginViewControler.h"
#import "MyMD5.h"
@interface MCChangePasswordViewController ()

@end

@implementation MCChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(changePassword)];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 1)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 20, self.view.frame.size.width - 30, 40)];
    [scrollView addSubview:passwordTextField];
    [passwordTextField setPlaceholder:@"请输入当前密码"];
    [passwordTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [passwordTextField setBackgroundColor:[UIColor whiteColor]];
    [passwordTextField setFont:[UIFont systemFontOfSize:14]];
    [passwordTextField setDelegate:self];
    [passwordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [passwordTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [passwordTextField setSecureTextEntry:YES];
    [passwordTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [passwordTextField becomeFirstResponder];
    
    
    NewpasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 70, self.view.frame.size.width - 30, 40)];
    [scrollView addSubview:NewpasswordTextField];
    [NewpasswordTextField setPlaceholder:@"请输入新密码"];
    [NewpasswordTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [NewpasswordTextField setBackgroundColor:[UIColor whiteColor]];
    [NewpasswordTextField setFont:[UIFont systemFontOfSize:14]];
    [NewpasswordTextField setDelegate:self];
    [NewpasswordTextField setSecureTextEntry:YES];
    [NewpasswordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [NewpasswordTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [NewpasswordTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    repeatTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 120, self.view.frame.size.width - 30, 40)];
    [scrollView addSubview:repeatTextField];
    [repeatTextField setPlaceholder:@"请确认密码"];
    [repeatTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [repeatTextField setBackgroundColor:[UIColor whiteColor]];
    [repeatTextField setFont:[UIFont systemFontOfSize:14]];
    [repeatTextField setDelegate:self];
    [repeatTextField setSecureTextEntry:YES];
    [repeatTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [repeatTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [repeatTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    
    // Do any additional setup after loading the view.
}
- (void)changePassword{
    if ([passwordTextField.text length] == 0 )
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入当前密码再提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([NewpasswordTextField.text length] == 0 )
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入新密码再提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    if ([repeatTextField.text length] == 0 )
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请确认密码再提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (![repeatTextField.text isEqualToString:NewpasswordTextField.text]  )
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }



    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"userName"];
    [sendDictionary setValue:uid forKey:@"username"];
    NSString *password = [MyMD5 md5:passwordTextField.text];
    NSString *Newpassword = [MyMD5 md5:NewpasswordTextField.text];

    [sendDictionary setValue:password forKey:@"oldpassword"];
    [sendDictionary setValue:Newpassword forKey:@"newpassword"];
    
    
    
    [MCHttpManager PutWithIPString:BASEURL_AREA urlMethod:@"/account/password" parameters:sendDictionary success:^(id responseObject)
     {
         
         NSDictionary *dicDictionary = responseObject;
         NSLog(@"---%@",dicDictionary);
         
         if ([dicDictionary[@"code"] integerValue] == 0 )
         {
             [SVProgressHUD showSuccessWithStatus:@"修改密码成功"];
             [self leave];
             
         }else{
         
             [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
         }
         
         
         
         
         
     } failure:^(NSError *error) {
         
         NSLog(@"****%@", error);
         
     }];
    
    
    
    
    
}
    // Do any additional setup after loading the view.
- (void)leave{
    
    [MCPublicDataSingleton sharePublicDataSingleton].userDictionary = nil;
    [MCPublicDataSingleton sharePublicDataSingleton].isLogin = NO;
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passWord"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fencheng"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ts"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    MCLoginViewControler *LoginView = [[MCLoginViewControler alloc]init];
    
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];  // 获得根窗口
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:LoginView];
    window.rootViewController = nav;
    
    return;
    
    
    
    
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
