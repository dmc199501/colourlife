//
//  MCCZYViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/14.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCCZYViewController.h"
#import "MCFanPiaoViewController.h"
#import "TPPasswordTextView.h"
#import "MCTransferMoneyViewController.h"
@interface MCCZYViewController ()

@end

@implementation MCCZYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"转到彩之云账户";
    [self setUI];
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view.
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_moneyTextField resignFirstResponder];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUI{
    
    zzView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    zzView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+150*SCREEN_HEIGHT/375);
    
    [self.view addSubview:zzView];

    UIImageView *  photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70)/2, 20, 70, 70)];
    [zzView addSubview:photoImageView];
    [photoImageView setClipsToBounds:YES];
    [photoImageView.layer setCornerRadius:photoImageView.frame.size.width / 2];
    
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(photoImageView)+20, SCREEN_WIDTH, 20)];
    [zzView addSubview:label2];
    label2.textColor = [UIColor colorWithRed:149 / 255.0 green:149 / 255.0 blue:149/ 255.0 alpha:1];
    [label2 setFont:[UIFont systemFontOfSize:12]];
    label2.textAlignment= NSTextAlignmentCenter;
    [label2 setText:[NSString stringWithFormat:@"转到我的彩之云%@",@""]];
    
    UILabel *label31 = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(label2)+5, SCREEN_WIDTH, 20)];
    [zzView addSubview:label31];
    [label31 setFont:[UIFont systemFontOfSize:15]];
    label31.textAlignment= NSTextAlignmentCenter;
    
    
   
        NSString *username = self.dataDic[@"username"];//根据键值取出name
        [[[SDWebImageManager sharedManager] imageCache] clearMemory];
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@avatar?uid=%@", USER_ICON_URL,username]];
        UIImage *defaultImage = [UIImage imageNamed:@"default.png"];
        
        [photoImageView sd_setImageWithURL:url placeholderImage:defaultImage options:SDWebImageRefreshCached];
        
        [label31 setText:[NSString stringWithFormat:@"%@",self.dataDic[@"mobile"]]];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(label2)+30, SCREEN_WIDTH, 160)];
    backView.backgroundColor = [UIColor whiteColor];
    [zzView addSubview:backView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-20, 20)];
    [backView addSubview:label];
    label.text= @"赠送金额";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor =  GRAY_COLOR_ZZ;
    label.font = [UIFont systemFontOfSize:14];
    
    _moneyTextField = [[UITextField alloc]initWithFrame:CGRectMake(60, BOTTOM_Y(label)+40, SCREEN_WIDTH-60, 20)];
    [_moneyTextField setPlaceholder:@"每笔金额不超过五千"];
    [_moneyTextField setTextAlignment:NSTextAlignmentLeft];
    [_moneyTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_moneyTextField setBackgroundColor:[UIColor clearColor]];
    [_moneyTextField setFont:[UIFont systemFontOfSize:15]];
    _moneyTextField.delegate = self;
    [backView addSubview:_moneyTextField];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(label)+30, 30, 30)];
    label3.backgroundColor = [UIColor clearColor];
    [backView addSubview:label3];
    label3.text= @"¥";
    label3.textAlignment = NSTextAlignmentLeft;
    label3.textColor =  [UIColor blackColor];
    label3.font = [UIFont systemFontOfSize:35];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(50, BOTTOM_Y(label3)+20,SCREEN_WIDTH-100, 1)];
    line.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    [backView addSubview:line];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(line)+10, SCREEN_WIDTH, 20)];
    money.backgroundColor = [UIColor clearColor];
    [backView addSubview:money];
    money.text= [NSString stringWithFormat:@"可用余额:%@",self.balance];
    money.textAlignment = NSTextAlignmentLeft;
    money.textColor =  GRAY_COLOR_ZZ;
    money.font = [UIFont systemFontOfSize:15];
    
    
    UIButton *leaveButton = [[UIButton alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(backView)+40, SCREEN_WIDTH-40, 40)];
    [leaveButton setBackgroundColor:[UIColor colorWithRed:0 / 255.0 green:157 / 255.0 blue:255/ 255.0 alpha:1]];
    [leaveButton setTitle:@"确认转账" forState:UIControlStateNormal];
    //[leaveButton setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [leaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leaveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leaveButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [zzView addSubview:leaveButton];
    [leaveButton.layer setCornerRadius:4];
    
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    NSLog(@"%@",@"zzzz");
    
    if (textField == self.moneyTextField )
    {
        NSLog(@"%@",@"ssss");
        [zzView setContentOffset:CGPointMake(0, 150*SCREEN_WIDTH/375) animated:YES];
        
    }
    
}
-(void)next{
    
    if ([_moneyTextField.text floatValue] == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"输入金额不能为0" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([_moneyTextField.text integerValue] >5000 ) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"输入金额不能大于5000" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([_moneyTextField.text integerValue] >[self.balance integerValue] ) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"余额不足" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    
    _backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.tabBarController.view addSubview:_backView];
    _backView.alpha = 0.5;
    _backView.backgroundColor = BLACKS_COLOR_ZZ;
    
    
    _passWordView = [[UIView alloc]initWithFrame:CGRectMake(40, (SCREEN_HEIGHT-200)/2, SCREEN_WIDTH-80, 200)];
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
                    [self next1];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }
            
        }else{
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
}
- (void)next1{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    
    
        

    [sendDict setValue:self.dataDic[@"customer_id"] forKey:@"receiver_id"];
    [sendDict setValue:key forKey:@"key"];
    [sendDict setValue:secret forKey:@"secret"];
    [sendDict setValue:@1 forKey:@"type"];
    [sendDict setValue:_moneyTextField.text forKey:@"amount"];
    
    [SVProgressHUD showWithStatus:@"转账中..."];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/hongbao/carryOrderCreate" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                if ([dicDictionary[@"content"][@"ok"] integerValue] ==1) {
                    [SVProgressHUD showSuccessWithStatus:@"成功"];
                    
                    NSArray *vcArray = self.navigationController.viewControllers;
                    
                    
                    for(UIViewController *vc in vcArray)
                    {
                        if ([vc isKindOfClass:[MCTransferMoneyViewController class]])
                        {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                    
                }else{
                    
                    [SVProgressHUD showSuccessWithStatus:dicDictionary[@"message"]];
                }
                
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
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
