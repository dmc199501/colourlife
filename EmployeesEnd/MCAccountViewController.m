//
//  MCAccountViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/27.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCAccountViewController.h"
#import "MCAccountListViewController.h"
@interface MCAccountViewController ()

@end

@implementation MCAccountViewController
- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *fencheng  = [userDefaults objectForKey:@"fencheng"];
    
    [money setText:[NSString stringWithFormat:@"%@",fencheng]];

    [self getacount];
}
- (void)viewDidLoad {
    
    
   
        [super viewDidLoad];
        self.navigationItem.title = @"即时分成";
        
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
        
    
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH-100, 20)];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.text = @"我的即时分成";
        label1.font = [UIFont systemFontOfSize:15];
        label1.textColor = [UIColor colorWithRed:46 / 255.0 green:54 / 255.0 blue:63/ 255.0 alpha:1];
        [twoView addSubview:label1];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0,50, SCREEN_WIDTH, 1)];
        line1.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240/ 255.0 alpha:1];
        [twoView addSubview:line1];
        
        money = [[UILabel alloc]initWithFrame:CGRectMake(0, 83, SCREEN_WIDTH, 30)];
        money.textAlignment = NSTextAlignmentCenter;
    
    
    
        money.font = [UIFont systemFontOfSize:30];
        
        
    
        money.textColor = [UIColor colorWithRed:244 / 255.0 green:56 / 255.0 blue:21/ 255.0 alpha:1];
        [twoView addSubview:money];
        
    UIButton *DetailsButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100, 50)];
    [twoView addSubview:DetailsButton];
    [DetailsButton setTitleColor:[UIColor colorWithRed:167 / 255.0 green:167 / 255.0 blue:167/ 255.0 alpha:1] forState:UIControlStateNormal];
   
    [DetailsButton setTitleColor:[UIColor colorWithRed:167 / 255.0 green:167 / 255.0 blue:167/ 255.0 alpha:1] forState:UIControlStateNormal];
    DetailsButton.layer.cornerRadius = 4;
    [DetailsButton setTitle:@"明细" forState:UIControlStateNormal];
    DetailsButton.layer.masksToBounds = YES;
    [DetailsButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    DetailsButton.backgroundColor =[UIColor clearColor];
    [DetailsButton addTarget:self action:@selector(fpDetails) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *DetailsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -30, 17.5, 10, 15)];
    [twoView addSubview:DetailsImageView];
    [DetailsImageView setImage:[UIImage imageNamed:@"xiayibu"]];
    
    
    
    UIButton *withdrawButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 140, SCREEN_WIDTH-40, 40)];
    [twoView addSubview:withdrawButton];
    withdrawButton.layer.cornerRadius = 4;
    [withdrawButton setTitle:@"领取" forState:UIControlStateNormal];
    withdrawButton.layer.masksToBounds = YES;
    withdrawButton.backgroundColor =[UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204/ 255.0 alpha:1];
    

        
       // Do any additional setup after loading the view.
}

- (void)getacount{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:@"userName"];
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:@"1521ac83521b8063e7a9a49dc22e79b0" forKey:@"access_token"];
    [sendDictionary setValue:@2 forKey:@"target_type"];
    [sendDictionary setValue:username forKey:@"target"];
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/splitdivide/api/account" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                [money setText:[NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"total_balance"]]];
                self.sting =[NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"total_balance"]];
               
            }
            
            return ;
            
            
            
        }else{
            [money setText:[NSString stringWithFormat:@"%@",@"0.00"]];
            self.sting = @"0.00";
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
    
}

-(void)fpDetails{
    
    MCAccountListViewController *listVC  = [[MCAccountListViewController alloc]init];
    
    listVC.money = money.text;
    [self.navigationController pushViewController:listVC animated:YES];
    
   

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
