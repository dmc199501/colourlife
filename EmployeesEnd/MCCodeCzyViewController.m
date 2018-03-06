//
//  MCCodeCzyViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/14.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCCodeCzyViewController.h"
#import "MCTransferMoneyViewController.h"
@interface MCCodeCzyViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *codeTextField;

@end

@implementation MCCodeCzyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getCode];
  UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 20)];
    nameLabel.text = @"我们已经发送了验证码到您的手机:";
    nameLabel.textColor = [UIColor blackColor];
    [self.view addSubview:nameLabel];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:15];
    
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 20)];
    phoneLabel.text = _dataDic[@"mobile"];;
    phoneLabel.textColor = BLUK_COLOR_ZAN_MC;
    [self.view addSubview:phoneLabel];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.font = [UIFont systemFontOfSize:15];

    _codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 90, SCREEN_WIDTH-20, 20)];
    [_codeTextField setPlaceholder:@"请输入验证码"];

    [_codeTextField setTextAlignment:NSTextAlignmentLeft];
    [_codeTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_codeTextField setBackgroundColor:[UIColor clearColor]];
    [_codeTextField setFont:[UIFont systemFontOfSize:15]];
    [_codeTextField setDelegate:self];
    [self.view addSubview:_codeTextField];
    
    
    UIButton *czyButton = [[UIButton alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(_codeTextField)+20, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:czyButton];
    czyButton.layer.cornerRadius = 4;
    [czyButton setTitle:@"下一步" forState:UIControlStateNormal];
    czyButton.layer.masksToBounds = YES;
    czyButton.backgroundColor = BLUK_COLOR_ZAN_MC;
    [czyButton addTarget:self action:@selector(verifySms) forControlEvents:UIControlEventTouchUpInside];

    
    // Do any additional setup after loading the view.
}

- (void)getCode{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   
    [dic setValue:@0 forKey:@"type"];
    [dic setValue:_dataDic[@"mobile"] forKey:@"mobile"];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/sms" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            
            
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"message"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    


}
-(void)verifySms{
    if ([_codeTextField.text length] == 0 )
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入验证码再提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:_codeTextField.text forKey:@"code"];
    [dic setValue:_dataDic[@"mobile"] forKey:@"mobile"];
    [MCHttpManager PutWithIPString:BASEURL_AREA urlMethod:@"/sms" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            [self getBind];
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"message"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];

}
-(void)getBind{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:_dataDic[@"mobile"] forKey:@"mobile"];
    [dic setValue:key forKey:@"key"];
    [dic setValue:secret forKey:@"secret"];
     [dic setValue:_dataDic[@"id"] forKey:@"customer_id"];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/hongbao/bindColourLife" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
            NSArray *vcArray = self.navigationController.viewControllers;
            
            
            for(UIViewController *vc in vcArray)
            {
                if ([vc isKindOfClass:[MCTransferMoneyViewController class]] )
                {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }

        }else{
            
            
            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"message"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
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
