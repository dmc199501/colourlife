//
//  MCBindingCZYViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/14.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCBindingCZYViewController.h"
#import "MCCodeCzyViewController.h"
@interface MCBindingCZYViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *czyTextField;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSDictionary *datadic;
@end

@implementation MCBindingCZYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定彩之云";
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *czyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 20)];
    czyLabel.text = @"彩之云账号";
    [self.view addSubview:czyLabel];
    czyLabel.textAlignment = NSTextAlignmentLeft;
    czyLabel.font = [UIFont systemFontOfSize:15];
    
    _czyTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH-60, 20)];
    [_czyTextField setPlaceholder:@"请填写您的彩之云手机号"];
    [_czyTextField setTextAlignment:NSTextAlignmentLeft];
    [_czyTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_czyTextField setBackgroundColor:[UIColor clearColor]];
    [_czyTextField setFont:[UIFont systemFontOfSize:15]];
    [_czyTextField setDelegate:self];
    [self.view addSubview:_czyTextField];
    _czyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [_czyTextField becomeFirstResponder];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,40, SCREEN_WIDTH, 1)];
    line.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
    [self.view addSubview:line];
   
    
   
    [_czyTextField addTarget:self action:@selector(showtextFiledContents) forControlEvents:UIControlEventEditingChanged];
    
    
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 80)];
    backView.hidden = YES;
    [self.view addSubview:backView];
    
    
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 20)];
    nameLabel.text = @"手机号码";
    nameLabel.textColor = GRAY_COLOR_ZZ;
    [backView addSubview:nameLabel];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:15];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 1)];
    line2.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
    [backView addSubview:line2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 81, SCREEN_WIDTH, 1)];
    line3.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
    [backView addSubview:line3];

    
    areLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 150, 20)];
    areLabel.text = @"小区";
    [backView addSubview:areLabel];
    areLabel.textColor = GRAY_COLOR_ZZ;
    areLabel.textAlignment = NSTextAlignmentLeft;
    areLabel.font = [UIFont systemFontOfSize:15];
    
    
    UIButton *czyButton = [[UIButton alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(backView)+20, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:czyButton];
    czyButton.layer.cornerRadius = 4;
    [czyButton setTitle:@"下一步" forState:UIControlStateNormal];
    czyButton.layer.masksToBounds = YES;
    czyButton.backgroundColor = BLUK_COLOR_ZAN_MC;
    [czyButton addTarget:self action:@selector(nextBindin) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Do any additional setup after loading the view.
}
-(void)nextBindin{
    if ([_code isEqualToString:@"yes"]) {
        MCCodeCzyViewController *codeVC = [[MCCodeCzyViewController alloc]init];
        codeVC.dataDic = _datadic;
        [self.navigationController pushViewController:codeVC animated:YES];
        

    }else{
    
        [SVProgressHUD showErrorWithStatus:@"请先输入您的手机号验证信息"];
    
    }
   }
-(void)showtextFiledContents{

    if (_czyTextField.text.length == 11) {
        [self getCzyinfo];
    }

}
-(void)getCzyinfo{

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:_czyTextField.text forKey:@"mobile"];
    [dic setValue:key forKey:@"key"];
    [dic setValue:secret forKey:@"secret"];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/hongbao/getCustomerInfo" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            _code = @"yes";
            backView.hidden = NO;
            _datadic =dicDictionary[@"content"][@"customerInfo"];
            [nameLabel setText:[NSString stringWithFormat:@"用户名:%@",dicDictionary[@"content"][@"customerInfo"][@"name"]]];
            [areLabel setText:[NSString stringWithFormat:@"小区:%@",dicDictionary[@"content"][@"customerInfo"][@"community"]]];
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
