//
//  MCWhatTXViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/14.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCWhatTXViewController.h"
#import "TPPasswordTextView.h"
#import "MCCGViewController.h"
@interface MCWhatTXViewController ()

@end

@implementation MCWhatTXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我要提现";
    
    
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];
    
    
    userName = [[UILabel alloc]initWithFrame:CGRectMake(16,20, SCREEN_WIDTH-32, 20)];
    
    userName.textColor = [UIColor colorWithRed:51 / 255.0 green:52 / 255.0 blue:51/ 255.0 alpha:1];
    userName.backgroundColor = [UIColor clearColor];
    userName.textAlignment = NSTextAlignmentLeft;
    [userName setFont:[UIFont systemFontOfSize:15]];
    userName.text = [NSString stringWithFormat:@"持卡人: %@",self.name];
    [back addSubview:userName];
    
    bank = [[UILabel alloc]initWithFrame:CGRectMake(16,45, SCREEN_WIDTH-32, 20)];
    
    bank.textColor = [UIColor colorWithRed:51 / 255.0 green:52 / 255.0 blue:61/ 255.0 alpha:1];
    bank.backgroundColor = [UIColor clearColor];
    bank.textAlignment = NSTextAlignmentLeft;
    [bank setFont:[UIFont systemFontOfSize:15]];
    bank.text = [NSString stringWithFormat:@"银行: %@",self.bank];
    [back addSubview:bank];
    
    card = [[UILabel alloc]initWithFrame:CGRectMake(16,70, SCREEN_WIDTH-32, 20)];
    card.textColor = [UIColor colorWithRed:51 / 255.0 green:52 / 255.0 blue:61/ 255.0 alpha:1];
    card.backgroundColor = [UIColor clearColor];
    card.textAlignment = NSTextAlignmentLeft;
    [card setFont:[UIFont systemFontOfSize:15]];
    card.text = [NSString stringWithFormat:@"卡号: %@",self.card];;
    [back addSubview:card];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(card)+21,SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    [back addSubview:line];
    
    
    _moneyTextField = [[UITextField alloc]initWithFrame:CGRectMake(60, BOTTOM_Y(line)+40, SCREEN_WIDTH-60, 20)];
    [_moneyTextField setPlaceholder:@"每笔金额不超过五千"];
    [_moneyTextField setTextAlignment:NSTextAlignmentLeft];
    [_moneyTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_moneyTextField setBackgroundColor:[UIColor clearColor]];
    [_moneyTextField setFont:[UIFont systemFontOfSize:15]];
    [back addSubview:_moneyTextField];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(line)+30, 30, 30)];
    label3.backgroundColor = [UIColor clearColor];
    [back addSubview:label3];
    label3.text= @"¥";
    label3.textAlignment = NSTextAlignmentLeft;
    label3.textColor =  [UIColor blackColor];
    label3.font = [UIFont systemFontOfSize:35];
    
    UIButton *TXbutton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-150, BOTTOM_Y(line)+40, 120, 20)];
    [back addSubview:TXbutton];
    [TXbutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [TXbutton setTitle:@"全部体现" forState:UIControlStateNormal];
    [TXbutton setTitleColor:[UIColor colorWithRed:0 / 255.0 green:157 / 255.0 blue:255/ 255.0 alpha:1] forState:UIControlStateNormal];
    [TXbutton addTarget:self action:@selector(all) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(50, BOTTOM_Y(label3)+20,SCREEN_WIDTH-100, 1)];
    line2.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    [back addSubview:line2];
    
    UILabel *daoz = [[UILabel alloc]initWithFrame:CGRectMake(16,BOTTOM_Y(line2)+20, 100, 20)];
    daoz.textColor = [UIColor colorWithRed:51 / 255.0 green:52 / 255.0 blue:61/ 255.0 alpha:1];
    daoz.backgroundColor = [UIColor clearColor];
    daoz.textAlignment = NSTextAlignmentLeft;
    [daoz setFont:[UIFont systemFontOfSize:14]];
    daoz.text = @"到账金额:";
    [back addSubview:daoz];
    
    dzLabel = [[UILabel alloc]initWithFrame:CGRectMake(116,BOTTOM_Y(line2)+20, SCREEN_WIDTH-32, 20)];
    dzLabel.textColor = [UIColor colorWithRed:244 / 255.0 green:52 / 255.0 blue:61/ 255.0 alpha:1];
    dzLabel.backgroundColor = [UIColor clearColor];
    dzLabel.textAlignment = NSTextAlignmentLeft;
    [dzLabel setFont:[UIFont systemFontOfSize:15]];
    dzLabel.text = @"";
    [back addSubview:dzLabel];
    
    
    UILabel *yue = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-220,BOTTOM_Y(line2)+20, 200, 20)];
    yue.textColor = [UIColor colorWithRed:51 / 255.0 green:52 / 255.0 blue:61/ 255.0 alpha:1];
    yue.backgroundColor = [UIColor clearColor];
    yue.textAlignment = NSTextAlignmentRight;
    [yue setFont:[UIFont systemFontOfSize:13]];
    yue.text = [NSString stringWithFormat:@"可用余额:%@",self.balance];
    [back addSubview:yue];
    
    UIButton *TXButton = [[UIButton alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(back)+20, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:TXButton];
    TXButton.layer.cornerRadius = 4;
    [TXButton setTitle:@"确认" forState:UIControlStateNormal];
    TXButton.layer.masksToBounds = YES;
    TXButton.backgroundColor =[UIColor colorWithRed:0 / 255.0 green:157 / 255.0 blue:255/ 255.0 alpha:1];
    [TXButton addTarget:self action:@selector(withdraw) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(16,BOTTOM_Y(TXButton)+20, SCREEN_WIDTH-32, 40)];
    label4.textColor = [UIColor colorWithRed:51 / 255.0 green:52 / 255.0 blue:61/ 255.0 alpha:1];
    label4.numberOfLines =2;
    label4.backgroundColor = [UIColor clearColor];
    label4.textAlignment = NSTextAlignmentLeft;
    [label4 setFont:[UIFont systemFontOfSize:13]];
    label4.text = @"遵循国家法律规定,提现至银行卡账户需缴纳提现金额的20%作为所得税,提现申请日期依据审批而定,节假日顺延";
    [self.view addSubview:label4];


    
    // Do any additional setup after loading the view.
}

-(void)next{
    
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
                    
                    [self setOrad];
                    
                }
                
            }
            
        }else{
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       
        
        
    }];
    
    
    
}


-(void)withdraw{
   
    if (dzLabel.text.length>0) {
        
         [self next];
    }else{
        [self koushui];
       
    }

}
- (void)setOrad{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    
    NSDictionary *sendDict = @{
                               
                               
                               @"bind_bank_id":self.bindID,
                               @"card_holder":self.name,
                               @"bank_id":self.cardID,
                               @"card_num":self.card,
                               @"red_packet":_moneyTextField.text,
                               @"real_money":dzLabel.text,
                               @"real_rate":@"0.8",
                               @"key":key,
                               @"secret":secret
                               };
    [SVProgressHUD showWithStatus:@"创建订单中..."];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/hongbao/orderCreate" parameters:sendDict success:^(id responseObject)
     {
         [SVProgressHUD dismiss];
         NSDictionary *dicDictionary = responseObject;
         NSLog(@"---%@",dicDictionary);
         
         if ([dicDictionary[@"code"] integerValue] == 0 )
         {
             if ([dicDictionary[@"code"][@"ok"] integerValue] == 1) {
                 
                 MCCGViewController *cg = [[MCCGViewController alloc]init];
                 cg.card = self.bank;
                 cg.money = _moneyTextField.text;
                 cg.money2 = dzLabel.text ;
                 [self.navigationController pushViewController:cg animated:YES];
                 
             }
                          
             
             
         }else{
             
             [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
             
         }
         
         
         
     } failure:^(NSError *error) {
         
         NSLog(@"****%@", error);
         
     }];
    
    

 
}
- (void)koushui{

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    
    
    
    
    
    [sendDict setValue:key forKey:@"key"];
    [sendDict setValue:secret forKey:@"secret"];
    [sendDict setValue:_moneyTextField.text forKey:@"amount"];
    
    [SVProgressHUD showWithStatus:@"扣税计算中..."];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/getRealMoney" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
            dzLabel.text = [NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"realMoney"]];
                    
                    
                    
                    
            }
            else{
                    
                    [SVProgressHUD showSuccessWithStatus:dicDictionary[@"message"]];
                }
                
            
            
        }else{
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       
        
        
    }];
    



}
- (void)all{

_moneyTextField.text = self.balance;

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
