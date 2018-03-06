//
//  MCLoginViewControler.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCLoginViewControler.h"
#import "MCTabBarController.h"
#import "MCHttpManager.h"
#import "MyMD5.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "SPTabBarController.h"
#import "MCValidationCodeViewController.h"

#import <GT3Captcha/GT3Captcha.h>
#import <WebKit/WebKit.h>

#import "CustomButton.h"
#import "TextField.h"
#import "TipsView.h"

#import "NSAttributedString+AttributedString.h"

//网站主部署的用于验证登录的接口 (api_1)
#define api_1 @"http://www.geetest.com/demo/gt/register-click"
//网站主部署的二次验证的接口 (api_2)
#define api_2 @"http://www.geetest.com/demo/gt/validate-click"
@interface MCLoginViewControler()<GT3CaptchaManagerDelegate, CaptchaButtonDelegate>
@property (nonatomic, strong) GT3CaptchaButton *captchaButton;


@property(nonatomic,strong)UITextField *IDField;
@property(nonatomic,strong)UITextField *passwordField;
@property(nonatomic,strong)NSString *IPString;
@end
@interface MCLoginViewControler ()

@end

@implementation MCLoginViewControler
- (GT3CaptchaButton *)captchaButton {
    if (!_captchaButton) {
        //创建验证管理器实例
        GT3CaptchaManager *captchaManager = [[GT3CaptchaManager alloc] initWithAPI1:api_1 API2:api_2 timeout:5.0];
        captchaManager.delegate = self;
        captchaManager.maskColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        
        //debug mode
        //        [captchaManager enableDebugMode:YES];
        //创建验证视图的实例
        _captchaButton = [[GT3CaptchaButton alloc] initWithFrame:CGRectMake(0, 0, 260, 40) captchaManager:captchaManager];
    }
    return _captchaButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTs];
    
    
    self.navigationItem.title = @"登录";
    self.navigationController.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
   // [self deviceIPAdress];
    
    
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 20)];
    loginLabel.text = @"登录";
    loginLabel.textColor = [UIColor blackColor];
    [self.view addSubview:loginLabel];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.font = [UIFont systemFontOfSize:18];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-340*SCREEN_WIDTH/375)/2, 100, 200, 20)];
    label.text = @"彩管家账号登录";
    label.textColor = GRAY_LIGHT_COLOR_ZZ;
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    
    UIView *IDView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-340*SCREEN_WIDTH/375)/2, BOTTOM_Y(label)+24, 340*SCREEN_WIDTH/375, 40)];
    [self.view addSubview:IDView];
    IDView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    IDView.layer.cornerRadius = 6;
    IDView.layer.masksToBounds = YES;
    
    
    
    UILabel *zhanghaoLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 50, 20)];
    zhanghaoLab.text = @"账号";
    zhanghaoLab.textColor = GRAY_LIGHT_COLOR_ZZ;
    [IDView addSubview:zhanghaoLab];
    zhanghaoLab.textAlignment = NSTextAlignmentLeft;
    zhanghaoLab.font = [UIFont systemFontOfSize:16];
    
    _IDField  =[[UITextField alloc] initWithFrame:CGRectMake(RIGHT_X(zhanghaoLab)+20, 10, 220, 20)];
    _IDField.backgroundColor = [UIColor clearColor];
    _IDField.placeholder = @"";
    [IDView addSubview:_IDField];
    _IDField.font = [UIFont systemFontOfSize:16];
    [_IDField becomeFirstResponder];
    _IDField.delegate = self;
    _IDField.keyboardType = UIKeyboardTypeURL;
    
    passwordView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-340*SCREEN_WIDTH/375)/2, BOTTOM_Y(IDView)+18, 340*SCREEN_WIDTH/375, 40)];
    [self.view addSubview:passwordView];
    passwordView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    passwordView.layer.cornerRadius = 6;
    passwordView.layer.masksToBounds = YES;
    
    UILabel *passwordLaber = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 50, 20)];
    passwordLaber.text = @"密码";
    passwordLaber.textColor = GRAY_LIGHT_COLOR_ZZ;
    [passwordView addSubview:passwordLaber];
    passwordLaber.textAlignment = NSTextAlignmentLeft;
    passwordLaber.font = [UIFont systemFontOfSize:16];
    
    _passwordField  =[[UITextField alloc] initWithFrame:CGRectMake(RIGHT_X(passwordLaber)+20, 10, 220, 20)];
    _passwordField.backgroundColor = [UIColor clearColor];
    _passwordField.placeholder = @"";
    [passwordView addSubview:_passwordField];
    _passwordField.font = [UIFont systemFontOfSize:16];
    [_passwordField becomeFirstResponder];
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-340*SCREEN_WIDTH/375)/2, BOTTOM_Y(passwordView)+28, 340*SCREEN_WIDTH/375, 40)];
    [loginButton setBackgroundColor:BLUK_COLOR_ZAN_MC];
    
    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginButton addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:loginButton];
    [loginButton.layer setCornerRadius:4];
    
    UIImageView *finishImage = [[UIImageView alloc]initWithFrame:CGRectMake((loginButton.frame.size.width/2)-50, 12, 15, 15)];
    [finishImage setImage:[UIImage imageNamed:@"tijiao"]];
    [loginButton addSubview:finishImage];
    
    UIButton *forgetButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, self.view.frame.size.height -100, 100, 40)];
    [self.view addSubview:forgetButton];
    forgetButton.backgroundColor = [UIColor clearColor];
    [forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgetPassWord) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [forgetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self setupLoginButton];
    // Do any additional setup after loading the view.
}
-(void)forgetPassWord{
    MCValidationCodeViewController * ValidationCodeVC = [[MCValidationCodeViewController alloc]init];
    [self.navigationController pushViewController:ValidationCodeVC animated:YES];
    
}
- (void)getTs{
    
      
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/timestamp" parameters:nil success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:dicDictionary[@"content"] forKey:@"ts"];
            
            
        }
        
        
        NSLog(@"%@",dicDictionary);
        
        
        
        
        
    } failure:^(NSError *error) {
        
        
       
        
    }];
    
    
}


    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)userLogin{
    
    if ([_IDField.text length] == 0 )
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确账号再提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([_passwordField.text length] == 0 )
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入密码再提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    NSString *password = [MyMD5 md5:_passwordField.text];
    
    NSDictionary *sendDict1 = @{
                               @"username":_IDField.text,
                               @"password":password,
                               
                               };
   ;
   
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/orgms/loginAccount" parameters:sendDict1 success:^(id responseObject) {
        
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"%@",dicDictionary);
                NSString *status = [NSString stringWithFormat:@"%@",[dicDictionary[@"content"] objectForKey:@"status"]];
                if ([status isEqualToString:@"0"]) {
                    NSString *loginType = dicDictionary[@"content"][@"corpId"];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:loginType forKey:@"corpId"];
                    [defaults setObject:dicDictionary[@"content"][@"username"] forKey:@"userName"];
                    [defaults setObject:@"yes" forKey:@"ispush"];
                    [defaults setObject:dicDictionary[@"content"][@"accountUuid"] forKey:@"uid"];
                    //[defaults setObject:dicDictionary[@"content"] forKey:@"userInfo"];
                    [defaults setObject:_passwordField.text forKey:@"passWord"];
                    [defaults setObject:password forKey:@"passWordMI"];
                    [defaults synchronize];
                    [self getConfig:loginType];//获取皮肤包接口
                    

                    
                }else{
                
                    [SVProgressHUD showErrorWithStatus:@"账号异常,请联系管理员"];
                
                }
                
            }
            
        }else{
        
        NSString *messageString = dicDictionary[@"message"];
        [SVProgressHUD showErrorWithStatus:messageString];
        
        }
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
       
        
        
    }];

    
    
    
    
    

}
- (void)getConfig:(NSString *)cprpID{
    
    NSDictionary *sendDict = @{
                               
                               @"corp_id":cprpID,
                              
                               
                               };
   
   
    MBProgressHUD *hub1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak  MBProgressHUD *weakHub1 = hub1;
    NSLog(@"%@",sendDict);
    [weakHub1 setDetailsLabelText:@"正在登录....."];

    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newoa/config/skin" parameters:sendDict success:^(id responseObject) {
        
        [weakHub1 hide:YES];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                NSString *corpType = [NSString stringWithFormat:@"%@",[[dicDictionary objectForKey:@"content"] objectForKey:@"skin_code"]];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:corpType forKey:@"corpType"];
                 [defaults synchronize];
                 [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                [MCPublicDataSingleton sharePublicDataSingleton].isLogin = YES;
                
                
                MCTabBarController *tabBarViewController = [[MCTabBarController alloc]init];
                
                ZZKeyWindow.rootViewController = tabBarViewController;
                

                            }
            
        }else{
        
        
            [SVProgressHUD showSuccessWithStatus:@"获取皮肤包失败"];
        
        }
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
    }];

    
    
}
- (void)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
        NSLog(@"手机的IP是：%@", address);
    _IPString = address;
    
    
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
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}





- (void)setupLoginButton {
    CustomButton *button = [[CustomButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-340*SCREEN_WIDTH/375)/2, BOTTOM_Y(passwordView)+28, 340*SCREEN_WIDTH/375, 40)];
    button.delegate = self;
    button.backgroundColor = BLUK_COLOR_ZAN_MC;
    [button setClipsToBounds:YES];
        NSAttributedString *attrString = [NSAttributedString generate:@"立即登录" fontSize:16.0 color:[UIColor whiteColor]];
    
    button.layer.cornerRadius = 2.0;
    button.titleLabel.attributedText = attrString;
    [button setTitle:@"立即登录" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    //button.center = CGPointMake(self.view.center.x, self.view.center.y + 74);
    
    [self.view addSubview:button];
    
}

- (void)login {
    
}

#pragma MARK - CaptchaButtonDelegate

- (BOOL)captchaButtonShouldBeginTapAction:(CustomButton *)button {
    if ([_IDField.text length] == 0 ||[_passwordField.text length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确账号或密码再提交验证" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;

       
    }else{
       
        [self.view endEditing:YES];
    

        return YES;

    
    }
    
   
    return NO;
 
   

   }

- (void)captcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error {
    //演示中全部默认为成功, 不对返回做判断
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([dataString containsString:@"success"]&&[dataString containsString:@"登录成功"]) {
        [self userLogin];
    }
    NSLog(@"\ndata: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    //    [TipsView showTipOnKeyWindow:@"DEMO: 登录成功"];
}

#pragma MARK - GT3CaptchaManagerDelegate

- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    //处理验证中返回的错误
    if (error.code == -999) {
        // 请求被意外中断, 一般由用户进行取消操作导致, 可忽略错误
    }
    else if (error.code == -10) {
        // 预判断时被封禁, 不会再进行图形验证
    }
    else if (error.code == -20) {
        // 尝试过多
    }
    else {
        // 网络问题或解析失败, 更多错误码参考开发文档
    }
    [TipsView showTipOnKeyWindow:error.error_code fontSize:12.0];
}

- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    NSLog(@"User Did Close GTView.");
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy))decisionHandler {
    if (!error) {
        //处理你的验证结果
        NSLog(@"\ndata: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //成功请调用decisionHandler(GT3SecondaryCaptchaPolicyAllow)
        decisionHandler(GT3SecondaryCaptchaPolicyAllow);
        //失败请调用decisionHandler(GT3SecondaryCaptchaPolicyForbidden)
        //decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        
           }
    else {
        //二次验证发生错误
        decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        [TipsView showTipOnKeyWindow:error.error_code fontSize:12.0];
    }
}


- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(NSURLRequest *)originalRequest withReplacedHandler:(void (^)(NSURLRequest *))replacedHandler {
    NSMutableURLRequest *mRequest = [originalRequest mutableCopy];
    NSString *newURL = [NSString stringWithFormat:@"%@?t=%.0f", originalRequest.URL.absoluteString, [[[NSDate alloc] init]timeIntervalSince1970]];
    mRequest.URL = [NSURL URLWithString:newURL];
    
    replacedHandler(mRequest);
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
