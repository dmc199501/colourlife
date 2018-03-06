//
//  MCExchangViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/15.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCExchangViewController.h"
#import "TPPasswordTextView.h"
@interface MCExchangViewController ()

@end

@implementation MCExchangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"兑换";
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    backView.backgroundColor = DARK_COLOER_ZZ;
    [self.view addSubview:backView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 150, 20)];
    label1.text = @"可兑换额度";
    label1.textColor = [UIColor whiteColor];
    [backView addSubview:label1];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:15];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, SCREEN_WIDTH-120, 20)];
    moneyLabel.text =[NSString stringWithFormat:@"%.2f",[_dataDic[@"split_money"] floatValue]] ;
    moneyLabel.textColor = [UIColor whiteColor];
    [backView addSubview:moneyLabel];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.font = [UIFont systemFontOfSize:15];
    
    addressBackgroundView = [[UIButton alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(backView)+10, SCREEN_WIDTH , 50)];
    [addressBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:addressBackgroundView];
    [addressBackgroundView.layer setBorderColor:LINE_GRAY_COLOR_ZZ.CGColor];
    
    
    
    wMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 50)];
    [addressBackgroundView addSubview:wMoneyLabel];
    [wMoneyLabel setBackgroundColor:[UIColor clearColor]];
    [wMoneyLabel setTextColor:[UIColor blackColor]];
    [wMoneyLabel setFont:[UIFont systemFontOfSize:15]];
    [wMoneyLabel setText:@"金额"];
    
    
    wMoneyField  =[[UITextField alloc] initWithFrame:CGRectMake(100, 0, 100, 50)];
    wMoneyField.backgroundColor = [UIColor clearColor];
    wMoneyField.placeholder = @"输入金额";
    [addressBackgroundView addSubview:wMoneyField];
    wMoneyField.textAlignment = NSTextAlignmentLeft;
    wMoneyField.font = [UIFont systemFontOfSize:13];
    [wMoneyField becomeFirstResponder];
    wMoneyField.keyboardType = UIKeyboardTypeDecimalPad;
    wMoneyField.delegate = self;
    
    UIButton *allButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30*124/46-20, 10, 30*124/46, 30)];
    [allButton setTitle:@"全部兑换" forState:UIControlStateNormal];
    [allButton setTitleColor:BLUK_COLOR_ZAN_MC forState:UIControlStateNormal];
    allButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [addressBackgroundView addSubview:allButton];
    [allButton addTarget:self action:@selector(allMoney) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *withdrawButton = [[UIButton alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(addressBackgroundView)+20, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:withdrawButton];
    withdrawButton.layer.cornerRadius = 4;
    [withdrawButton setTitle:@"确认" forState:UIControlStateNormal];
    withdrawButton.layer.masksToBounds = YES;
    withdrawButton.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204/ 255.0 alpha:1];
    //[withdrawButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, BOTTOM_Y(withdrawButton)+10, 100, 40)];
    [self.view addSubview:forgetButton];
    forgetButton.backgroundColor = [UIColor clearColor];
    [forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgetPassWord) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [forgetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}
- (BOOL)shouldAutorotate {
    return NO;
}




#pragma mark- 忘记支付密码
-(void)forgetPassWord{
    
    [self.view endEditing:YES];
    
    UIAlertView *inputPassword = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入OA密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    inputPassword.alertViewStyle = UIAlertViewStyleSecureTextInput;
    inputPassword.tag = 1006;
    [inputPassword show];
    
   


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1006) {
        
        if (buttonIndex == 0) {
            //确定
            UITextField *textInput = [alertView textFieldAtIndex:0];
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSString *pass = [defaults objectForKey:@"passWord"];
            if ([textInput.text isEqualToString:pass]) {
                
                [self clearPASS];
            }else{
                [SVProgressHUD showErrorWithStatus:@"密码错误"];
            }
            //        DLog(@"%@", textInput.text);
        }

        
    }
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
                    
                    [SVProgressHUD showErrorWithStatus:@"清空支付密码成功,请到我的饭票页面重新设置"];
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

-(void)next{
    
    [self.view endEditing:YES];
    if (!([wMoneyField.text length]>0 &&[wMoneyField.text floatValue])>0 ) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    if ([wMoneyField.text floatValue] > [_dataDic[@"split_money"] floatValue] ) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"余额不足" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
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
    label2.text= @"请输入支付密码";
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
    [leaveButton addTarget:self action:@selector(nextPush) forControlEvents:UIControlEventTouchUpInside];
    [_passWordView addSubview:leaveButton];
    [leaveButton.layer setCornerRadius:4];
    
}

- (void)cancel{
    
    [_backView removeFromSuperview];
    [_passWordView removeFromSuperview];
    
}
- (void)nextPush{
    if (self.passWord.length != 6) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"密码位数不正确请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [_backView removeFromSuperview];
    [_passWordView removeFromSuperview];
    [self verifyPay];
    
    
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
                    
                    [self goWithdrawals];
                    
                }
                
            }
            
        }else{
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)allMoney{

    wMoneyField.text = [NSString stringWithFormat:@"%.2f",[_dataDic[@"split_money"] floatValue]];
}
#pragma mark-提现接口
-(void)goWithdrawals{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *orgToken = [defaults objectForKey:@"orgToken"];
    NSString *username = [defaults objectForKey:@"userName"];
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:_dataDic[@"general_uuid"] forKey:@"general_uuid"];//商户类目UUID
    [sendDictionary setValue:_dataDic[@"business_uuid"] forKey:@"business_uuid"];//商户UUID
    [sendDictionary setValue:orgToken forKey:@"access_token"];//鉴权参数
    [sendDictionary setValue:@2 forKey:@"split_type"];//类型
     [sendDictionary setValue:username forKey:@"split_target"];//账号
    [sendDictionary setValue:_dataDic[@"pano"] forKey:@"finance_pano"];
    [sendDictionary setValue:_dataDic[@"finance_cano"] forKey:@"finance_cano"];
    [sendDictionary setValue:_dataDic[@"atid"] forKey:@"finance_atid"];
     [sendDictionary setValue:wMoneyField.text forKey:@"amount"];
    

    [sendDictionary setValue:@"1027510cc2d51ab847ae8f192e3ae566" forKey:@"arrival_pano"];
    [sendDictionary setValue:@"27" forKey:@"arrival_atid"];
    [sendDictionary setValue:@"1027c29d5b5ec87f4578bf0b9309f250" forKey:@"arrival_cano"];
    [sendDictionary setValue:@"test" forKey:@"arrival_account"];
    
    
    
    NSLog(@"%@",sendDictionary);
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/split/api/withdrawals" parameters:sendDictionary success:^(id responseObject) {
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]]) {
                
                
                NSString *state = dicDictionary[@"content"][@"result"][@"state"];
               
                switch ([state integerValue]) {
                    case 1:
                    {
                        [SVProgressHUD showErrorWithStatus:@"未处理"];
                        
                    }
                        break;
                    case 2:
                    {
                        [SVProgressHUD showSuccessWithStatus:@"提现成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                        break;
                    case 3:
                    {
                        [SVProgressHUD showErrorWithStatus:@"提现失败"];
                    }
                        break;
                        
                    default:
                        break;
                }
                

                
            }
            
            
            
            
            
            
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"message"]];
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    



}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
   
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
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
