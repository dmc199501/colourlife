//
//  MCFanPiaoViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/8.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCFanPiaoViewController.h"
#import "MCRewardListViewController.h"
#import "MCMyBousViewController.h"
#import "MCFPDetailsViewController.h"
#import "MCTransferMoneyViewController.h"
@interface MCFanPiaoViewController ()
@property(nonatomic,strong)NSString *balance;
@end

@implementation MCFanPiaoViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        
        datalistMutableArray = [NSMutableArray array];
       
        
        
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的饭票";
   
    //第一段头像加姓名
    UIView *oneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneView];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@avatar?uid=%@", USER_ICON_URL,username]];
    UIImage *defaultImage = [UIImage imageNamed:@"default.png"];
    UIImageView *PhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 38.5, 38.5)];
    [self.view addSubview:PhotoImageView];
    [PhotoImageView sd_setImageWithURL:url placeholderImage:defaultImage options:SDWebImageRefreshCached];

    
    UILabel *nameJOB = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, SCREEN_WIDTH-100, 20)];
    nameJOB.font = [UIFont systemFontOfSize:15];
    nameJOB.textColor = [UIColor colorWithRed:46 / 255.0 green:54 / 255.0 blue:63/ 255.0 alpha:1] ;
    nameJOB.textAlignment = NSTextAlignmentLeft;
    [oneView addSubview:nameJOB];
    
    NSDictionary *userInfoDictionary = [MCPublicDataSingleton sharePublicDataSingleton].userDictionary;
    [nameJOB setText:[NSString stringWithFormat:@"%@(%@)",userInfoDictionary[@"realname"],userInfoDictionary[@"jobName"]]];
    
    //第2段奖金
    UIView *twoView = [[UIView alloc]initWithFrame:CGRectMake(0,BOTTOM_Y(oneView)+10, SCREEN_WIDTH, 197)];
    twoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:twoView];
    
    UIImageView *moneyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 12.5, 23, 25)];
    [twoView addSubview:moneyImageView];
    [moneyImageView setImage:[UIImage imageNamed:@"奖金包"]];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, SCREEN_WIDTH-100, 20)];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = @"本月集体净发奖金包";
    label1.font = [UIFont systemFontOfSize:15];
    label1.textColor = [UIColor colorWithRed:46 / 255.0 green:54 / 255.0 blue:63/ 255.0 alpha:1];
    [twoView addSubview:label1];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0,50, SCREEN_WIDTH, 1)];
    line1.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240/ 255.0 alpha:1];
    [twoView addSubview:line1];
    
    money = [[UILabel alloc]initWithFrame:CGRectMake(0, 83, SCREEN_WIDTH, 30)];
    money.textAlignment = NSTextAlignmentCenter;
    //money.text = @"0.00";
    
    
    money.font = [UIFont systemFontOfSize:15];
    
    
    NSString *string = [NSString stringWithFormat:@" %@",[MCPublicDataSingleton sharePublicDataSingleton].honbao];
    //[money setAttributedText:[self changeLabelWithText:string]];
    self.balance = [NSString stringWithFormat:@"%@",string];
    
    money.textColor = [UIColor colorWithRed:244 / 255.0 green:56 / 255.0 blue:21/ 255.0 alpha:1];
    [twoView addSubview:money];
    
   
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0,147, SCREEN_WIDTH, 1)];
    line2.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240/ 255.0 alpha:1];
    [twoView addSubview:line2];
    
    UIButton *jitiButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 147+15, SCREEN_WIDTH/2, 20)];
    //jitiButton.backgroundColor = [UIColor yellowColor];
    [jitiButton setTitle:@"集体惩罚明细" forState:UIControlStateNormal];
    [jitiButton setTitleColor:[UIColor colorWithRed:46 / 255.0 green:54 / 255.0 blue:63/ 255.0 alpha:1] forState:UIControlStateNormal];
    [jitiButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [twoView addSubview:jitiButton];
    [jitiButton addTarget:self action:@selector(Reward) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *meButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 147+15, SCREEN_WIDTH/2, 20)];
    //jitiButton.backgroundColor = [UIColor yellowColor];
    [meButton setTitle:@"我的奖金包明细" forState:UIControlStateNormal];
    [meButton setTitleColor:[UIColor colorWithRed:46 / 255.0 green:54 / 255.0 blue:63/ 255.0 alpha:1] forState:UIControlStateNormal];
    [meButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [twoView addSubview:meButton];
    [meButton addTarget:self action:@selector(myBous) forControlEvents:UIControlEventTouchUpInside];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,147, 1, 49)];
    line3.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240/ 255.0 alpha:1];
    [twoView addSubview:line3];
    
    
    //第3段饭票越
    UIView *YEView = [[UIView alloc]initWithFrame:CGRectMake(0,BOTTOM_Y(twoView)+10, SCREEN_WIDTH, 197)];
    YEView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:YEView];
    
    UIImageView *yeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 12.5, 23, 25)];
    [YEView addSubview:yeImageView];
    [yeImageView setImage:[UIImage imageNamed:@"饭票余额"]];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, SCREEN_WIDTH-100, 20)];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.text = @"我的饭票余额";
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = [UIColor colorWithRed:46 / 255.0 green:54 / 255.0 blue:63/ 255.0 alpha:1];
    [YEView addSubview:label2];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0,50, SCREEN_WIDTH, 1)];
    line4.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240/ 255.0 alpha:1];
    [YEView addSubview:line4];

    yue = [[UILabel alloc]initWithFrame:CGRectMake(0, 83, SCREEN_WIDTH, 30)];
    yue.textAlignment = NSTextAlignmentCenter;
    
    yue.font = [UIFont systemFontOfSize:15];
    
   
    
    yue.textColor = [UIColor colorWithRed:238 / 255.0 green:176 / 255.0 blue:38/ 255.0 alpha:1];
    [YEView addSubview:yue];
    
    UIButton *DetailsButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100, 50)];
    [YEView addSubview:DetailsButton];
    [DetailsButton setTitleColor:[UIColor colorWithRed:167 / 255.0 green:167 / 255.0 blue:167/ 255.0 alpha:1] forState:UIControlStateNormal];
    DetailsButton.layer.cornerRadius = 4;
    [DetailsButton setTitle:@"明细" forState:UIControlStateNormal];
    DetailsButton.layer.masksToBounds = YES;
    [DetailsButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    DetailsButton.backgroundColor =[UIColor clearColor];
    [DetailsButton addTarget:self action:@selector(fpDetails) forControlEvents:UIControlEventTouchUpInside];
    

    UIImageView *DetailsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -30, 17.5, 10, 15)];
    [YEView addSubview:DetailsImageView];
    [DetailsImageView setImage:[UIImage imageNamed:@"xiayibu"]];
    
    
    
    UIButton *withdrawButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 140, SCREEN_WIDTH-40, 40)];
    [YEView addSubview:withdrawButton];
    withdrawButton.layer.cornerRadius = 4;
    [withdrawButton setTitle:@"转出与提现" forState:UIControlStateNormal];
    withdrawButton.layer.masksToBounds = YES;
    withdrawButton.backgroundColor =[UIColor colorWithRed:0 / 255.0 green:157 / 255.0 blue:255/ 255.0 alpha:1];
    [withdrawButton addTarget:self action:@selector(withdraw) forControlEvents:UIControlEventTouchUpInside];

    
    // Do any additional setup after loading the view.
}
- (void)withdraw{
   
    MCTransferMoneyViewController *moneyVC = [[MCTransferMoneyViewController alloc]init];
    
    moneyVC.balance = self.balance;
    //moneyVC.datalistMutableArray = datalistMutableArray;
    [self.navigationController pushViewController:moneyVC animated:YES];
    
    


}
-(void)fpDetails{
    MCFPDetailsViewController *fpvc = [[MCFPDetailsViewController alloc]init];
    [self.navigationController pushViewController:fpvc animated:YES];


}
- (void)myBous{

    MCMyBousViewController *bousVC = [[MCMyBousViewController alloc]init];
    [self.navigationController pushViewController:bousVC animated:YES];


}
//集体奖罚
- (void)Reward{
    MCRewardListViewController *RewardVC = [[MCRewardListViewController alloc]init];
    [self.navigationController pushViewController:RewardVC animated:YES];

}
-(NSMutableAttributedString*)changeLabelWithText:(NSString*)needText

{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    
    UIFont *font = [UIFont systemFontOfSize:18];
    
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,1)];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36] range:NSMakeRange(1,needText.length-1)];
    
    
    
    return attrString;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
 
    
    
    NSString *fanpiao  = [userDefaults objectForKey:@"fanpiao"];
    NSString *hongbao  = [userDefaults objectForKey:@"hongbao"];
    NSString *quanxian  = [userDefaults objectForKey:@"fpquanxian"];
    if (fanpiao != nil ) {
        NSString *string2 = [NSString stringWithFormat:@" %@",fanpiao];
        [yue setAttributedText:[self changeLabelWithText:string2]];
    }
    
    if (hongbao != nil) {
        NSString *string = [NSString stringWithFormat:@" %@",hongbao];
        [money setAttributedText:[self changeLabelWithText:string]];
    }
   
    NSLog(@"%@",quanxian);
    if ([quanxian isEqualToString:@"wu"]) {
        
    }else{
        [self getBalance];
        [self getHongbao];
    }
//    [self getBalance];
    



}

- (void)getBalance{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:key forKey:@"key"];
    [dic setValue:secret forKey:@"secret"];
    NSLog(@"%@",dic);
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/getBalance" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                [datalistMutableArray setArray:dicDictionary[@"content"][@"activityInfo"]];
                self.balance = [NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"balance"]];
                [yue setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@" %@",self.balance]]];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                [userDefaults setObject:[NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"balance"]] forKey:@"fanpiao"];
                [userDefaults synchronize];

                

                
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
             // [yue setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@" %@",@"0.00"]]];
                   }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        [SVProgressHUD showErrorWithStatus:@"饭票余额请求超时"];
        
        
    }];
    
    
    
    
}

- (void)getHongbao{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:key forKey:@"key"];
    [dic setValue:secret forKey:@"secret"];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/getHBUserList" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                NSString *string = [NSString stringWithFormat:@" %@",dicDictionary[@"content"][@"fee"]];
                [money setAttributedText:[self changeLabelWithText:string]];
                

                
                
            }
            
        }else{
            
          // [money setAttributedText:[self changeLabelWithText:[NSString stringWithFormat:@" %@",@"0.00"]]];

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
