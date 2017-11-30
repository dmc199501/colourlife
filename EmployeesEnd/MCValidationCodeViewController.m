//
//  MCValidationCodeViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/9/15.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCValidationCodeViewController.h"
#import "MCChanggePassWordViewController.h"
#import "MyMD5.h"
@interface MCValidationCodeViewController ()
@property(nonatomic,strong)NSString *token;
@end

@implementation MCValidationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    
    IDTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 20, self.view.frame.size.width - 30, 40)];
    [self.view addSubview:IDTextField];
    [IDTextField setPlaceholder:@"请输入当账号"];
    [IDTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [IDTextField setBackgroundColor:[UIColor whiteColor]];
    [IDTextField setFont:[UIFont systemFontOfSize:14]];
    [IDTextField setDelegate:self];
    [IDTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [IDTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    //[IDTextField setSecureTextEntry:YES];
    [IDTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [IDTextField becomeFirstResponder];
    
    
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 70, self.view.frame.size.width - 30, 40)];
    [self.view addSubview:nameTextField];
    [nameTextField setPlaceholder:@"请输入姓名"];
    [nameTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [nameTextField setBackgroundColor:[UIColor whiteColor]];
    [nameTextField setFont:[UIFont systemFontOfSize:14]];
    [nameTextField setDelegate:self];
    //[nameTextField setSecureTextEntry:YES];
    [nameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [nameTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [nameTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 120, self.view.frame.size.width - 30, 40)];
    [self.view addSubview:phoneTextField];
    [phoneTextField setPlaceholder:@"请确认手机号"];
    [phoneTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [phoneTextField setBackgroundColor:[UIColor whiteColor]];
    [phoneTextField setFont:[UIFont systemFontOfSize:14]];
    [phoneTextField setDelegate:self];
    //[phoneTextField setSecureTextEntry:YES];
    [phoneTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [phoneTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [phoneTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-340*SCREEN_WIDTH/375)/2, BOTTOM_Y(phoneTextField)+28, 340*SCREEN_WIDTH/375, 40)];
    [loginButton setBackgroundColor:BLUK_COLOR_ZAN_MC];
    
    [loginButton setTitle:@"下一步" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginButton addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    [loginButton.layer setCornerRadius:4];
    // Do any additional setup after loading the view.
}

- (void)changePassword{
    MCChanggePassWordViewController *changgeVC = [[MCChanggePassWordViewController alloc]init];
    changgeVC.username = IDTextField.text;
    [self.navigationController pushViewController:changgeVC animated:YES];
    if ([IDTextField.text length] == 0 )
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入OA账号再提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([nameTextField.text length] == 0 )
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入姓名再提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ( [phoneTextField.text length] !=11)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确手机号再提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:IDTextField.text forKey:@"userName"];
    
    [dic setValue:nameTextField.text forKey:@"realname"];
    [dic setValue:phoneTextField.text forKey:@"mobile"];
   
    
   
    
    [SVProgressHUD showWithStatus:@"正在获取验证码..."];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/orgms/voice/sendSMS" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        [SVProgressHUD dismiss];
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            MCChanggePassWordViewController *changgeVC = [[MCChanggePassWordViewController alloc]init];
            changgeVC.username = IDTextField.text;
            [self.navigationController pushViewController:changgeVC animated:YES];
        
        }else{
            
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    
    
    


}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    
    return YES;
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
