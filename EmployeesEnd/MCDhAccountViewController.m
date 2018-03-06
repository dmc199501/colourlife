//
//  MCDhAccountViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2018/2/7.
//  Copyright © 2018年 邓梦超. All rights reserved.
//

#import "MCDhAccountViewController.h"
#import "MCFanPiaoViewController.h"
#import "TPPasswordTextView.h"
#import "MCTransferMoneyViewController.h"
#import "MCContactViewController.h"
#import "MCSucceedViewController.h"
#import "MyMD5.h"
#import "MCDgAccountViewController.h"
@interface MCDhAccountViewController ()

@end

@implementation MCDhAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"兑换至饭票";
    
    self.view.userInteractionEnabled = YES;
    [self geOAcno];//OA获取兑换信息
    [self getAuthApp1];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self setUI];

    // Do any additional setup after loading the view.
}
-(void)geOAcno{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:@"userName"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:username forKey:@"oa_username"];
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/newczy/employee/getFinanceByOa" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
       
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                
                _cano = dicDictionary[@"content"][@"cano"];
                
                
                
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
        
    }];


}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_moneyTextField resignFirstResponder];
    [_qqTextField resignFirstResponder];
    
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
    [label2 setText:[NSString stringWithFormat:@"正在兑换给%@",@""]];
    
    UILabel *label31 = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(label2)+5, SCREEN_WIDTH, 20)];
    [zzView addSubview:label31];
    [label31 setFont:[UIFont systemFontOfSize:15]];
    label31.textAlignment= NSTextAlignmentCenter;
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [defaults objectForKey:@"userInfo"];
   
    NSString *username = [defaults objectForKey:@"userName"];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    
        
    [[NSURLCache sharedURLCache] removeAllCachedResponses];NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@avatar?uid=%@", USER_ICON_URL,username]];
        UIImage *defaultImage = [UIImage imageNamed:@"default.png"];
        
    [photoImageView sd_setImageWithURL:url placeholderImage:defaultImage options:SDWebImageRefreshCached];
        
        [label31 setText:[NSString stringWithFormat:@"%@(%@)",userInfo[@"realname"],userInfo[@"mobile"]]];
        
   
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(label2)+30, SCREEN_WIDTH, 200)];
    backView.backgroundColor = [UIColor whiteColor];
    [zzView addSubview:backView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-20, 20)];
    [backView addSubview:label];
    label.text= @"兑换金额";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor =  GRAY_COLOR_ZZ;
    label.font = [UIFont systemFontOfSize:14];
    
    _moneyTextField = [[UITextField alloc]initWithFrame:CGRectMake(60, BOTTOM_Y(label)+40, SCREEN_WIDTH-60, 20)];
    [_moneyTextField setPlaceholder:@"每笔金额不超过五千"];
    [_moneyTextField setTextAlignment:NSTextAlignmentLeft];
    [_moneyTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_moneyTextField setBackgroundColor:[UIColor clearColor]];
    [_moneyTextField setFont:[UIFont systemFontOfSize:15]];
    [_moneyTextField setDelegate:self];
     _moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [backView addSubview:_moneyTextField];
    
    UIImageView *moneyView = [[UIImageView alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(label)+30, 30, 30)];
    [moneyView setImage:[UIImage imageNamed:@"fanpiao-icon"]];
    [backView addSubview:moneyView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(50, BOTTOM_Y(moneyView)+10,SCREEN_WIDTH-100, 1)];
    line.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    [backView addSubview:line];
    
    _qqTextField = [[UITextField alloc]initWithFrame:CGRectMake(60, BOTTOM_Y(line)+10, SCREEN_WIDTH-120, 20)];
    [_qqTextField setPlaceholder:@"备注(30字以内)"];
    [_qqTextField setTextAlignment:NSTextAlignmentLeft];
    [_qqTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_qqTextField setBackgroundColor:[UIColor clearColor]];
    [_qqTextField setFont:[UIFont systemFontOfSize:15]];
    [_qqTextField setDelegate:self];
    [backView addSubview:_qqTextField];
    
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(50, BOTTOM_Y(_qqTextField)+10,SCREEN_WIDTH-100, 1)];
    line2.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    [backView addSubview:line2];
    
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(line2)+10, SCREEN_WIDTH, 20)];
    moneyLabel.backgroundColor = [UIColor clearColor];
    [backView addSubview:moneyLabel];
   
    moneyLabel.text= [NSString stringWithFormat:@"可兑换余额:%@",_dataDic[@"money"]];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    moneyLabel.textColor =  GRAY_COLOR_ZZ;
    moneyLabel.font = [UIFont systemFontOfSize:15];
    
    
    UIButton *leaveButton = [[UIButton alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(backView)+40, SCREEN_WIDTH-40, 40)];
    [leaveButton setBackgroundColor:[UIColor colorWithRed:0 / 255.0 green:157 / 255.0 blue:255/ 255.0 alpha:1]];
    [leaveButton setTitle:@"确认兑换" forState:UIControlStateNormal];
    //[leaveButton setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [leaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leaveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leaveButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [zzView addSubview:leaveButton];
    [leaveButton.layer setCornerRadius:4];
    
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    
    
    if (textField == self.moneyTextField || textField == self.qqTextField )
    {
        
        [zzView setContentOffset:CGPointMake(0, 150*SCREEN_WIDTH/375) animated:YES];
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    
}
-(void)next{
   
    if (!_cano) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"OA账号查询兑换账户失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    
    if ([_moneyTextField.text floatValue] <= 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"输入金额不能小于或者等于0" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([_moneyTextField.text floatValue] >[[_dataDic objectForKey:@"money"] floatValue] ) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"余额不足" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([_moneyTextField.text floatValue] > 5000 ) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"兑换金额单笔限制5000" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    
    
    [self getdata];
}
#pragma -mark 1.0授权
/**
 *1.0授权token接口
 */
- (void)getAuthApp1{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *ts = [defaults objectForKey:@"ts"];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:@"01a2b3c4d5e6f7a8b9c0" forKey:@"appkey"];//app分配id
    //[dic setValue:corp forKey:@"corp_uuid"];//租户ID
    
    NSString *singe = [NSString stringWithFormat:@"%@%@%@",@"01a2b3c4d5e6f7a8b9c0",ts,@"1a2b3c4d5e6f7a8b9c0d1a2b3c4d5e6f"];
    
    NSString *  signature = [MyMD5 md5:singe];//签名=( APPID +ts +appSecret)md5
    [dic setValue:signature forKey:@"signature"];
    [dic setValue:ts forKey:@"timestamp"];//时间戳
    NSLog(@"%@",dic);
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/jqfw/app/auth" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 &&[dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
        {
            
            
            _token = [NSString stringWithFormat:@"%@",[dicDictionary[@"content"] objectForKey:@"access_token"]];
            
            
            
        }else{
            
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    
    
    
}

- (void)getdata{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *ts = [defaults objectForKey:@"ts"];
    
    NSString *orderno = [[NSUUID UUID] UUIDString];//随机字符串
    NSDate *date = [NSDate date]; // 获得时间对象
    
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    
    [forMatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateStr = [forMatter stringFromDate:date];
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    
    [sendDictionary setValue:_token forKey:@"access_token"];
    [sendDictionary setValue:@([_moneyTextField.text floatValue]) forKey:@"money"];
    [sendDictionary setValue:orderno forKey:@"orderno"];
    [sendDictionary setValue:_qqTextField.text forKey:@"content"];
    [sendDictionary setValue:@"71" forKey:@"orgtype"];
    [sendDictionary setValue:_dataDic[@"ano"] forKey:@"orgaccountno"];
    [sendDictionary setValue:@"6" forKey:@"desttype"];
    [sendDictionary setValue:_cano forKey:@"destaccountno"];
    [sendDictionary setValue:@"0" forKey:@"starttime"];
    [sendDictionary setValue:_qqTextField.text forKey:@"detail"];
    
    
    
    [SVProgressHUD showWithStatus:@"兑换中..."];
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/jrpt/transaction/fasttransaction" parameters:sendDictionary success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            [SVProgressHUD showSuccessWithStatus:@"兑换成功"];
            NSArray *vcArray = self.navigationController.viewControllers;
            
            
            for(UIViewController *vc in vcArray)
            {
                if ([vc isKindOfClass:[MCDgAccountViewController class]])
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DGZHLOAD" object:nil];
                    
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            
        }else{
            
            [SVProgressHUD showSuccessWithStatus:@"兑换失败"];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"兑换失败"];
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
}


-(void)getBalancet{
    
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
                
                
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                [userDefaults setObject:[NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"balance"]] forKey:@"fanpiao"];
                [userDefaults synchronize];
                
                
                
                
            }
            
        }else{
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
        
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
