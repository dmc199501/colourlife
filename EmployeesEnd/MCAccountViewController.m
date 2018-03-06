//
//  MCAccountViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/27.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCAccountViewController.h"
#import "MCAccountListViewController.h"
#import "MCJSFPListViewController.h"
#import "MCDgAccountViewController.h"
@interface MCAccountViewController ()

@end

@implementation MCAccountViewController
- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *fencheng  = [userDefaults objectForKey:@"fencheng"];
    
    [money setText:[NSString stringWithFormat:@"%.2f",[fencheng floatValue]]];

    [self getacount];
}
- (void)viewDidLoad {
    
    
   
        [super viewDidLoad];
        self.navigationItem.title = @"即时分配";
        
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
        label1.text = @"我的即时分配";
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
    //[twoView addSubview:DetailsButton];
    [DetailsButton setTitleColor:[UIColor colorWithRed:167 / 255.0 green:167 / 255.0 blue:167/ 255.0 alpha:1] forState:UIControlStateNormal];
   
    [DetailsButton setTitleColor:[UIColor colorWithRed:167 / 255.0 green:167 / 255.0 blue:167/ 255.0 alpha:1] forState:UIControlStateNormal];
    DetailsButton.layer.cornerRadius = 4;
    [DetailsButton setTitle:@"明细" forState:UIControlStateNormal];
    DetailsButton.layer.masksToBounds = YES;
    [DetailsButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    DetailsButton.backgroundColor =[UIColor clearColor];
    [DetailsButton addTarget:self action:@selector(fpDetails) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *DetailsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -30, 17.5, 10, 15)];
   // [twoView addSubview:DetailsImageView];
    [DetailsImageView setImage:[UIImage imageNamed:@"xiayibu"]];
    
    UIImageView *next = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -40, 90, 10, 15)];
    [next setImage:[UIImage imageNamed:@"xiayibu"]];
    [twoView addSubview:next];
    
    UIButton *Button = [[UIButton alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(line1), SCREEN_WIDTH, 80)];
    [twoView addSubview:Button];
       Button.backgroundColor = [UIColor clearColor];
    [Button addTarget:self action:@selector(goFPlistView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *withdrawButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 140, SCREEN_WIDTH-40, 40)];
    [twoView addSubview:withdrawButton];
    withdrawButton.layer.cornerRadius = 4;
    [withdrawButton setTitle:@"查看明细" forState:UIControlStateNormal];
    withdrawButton.layer.masksToBounds = YES;
    withdrawButton.backgroundColor = BLUK_COLOR_ZAN_MC;
    [withdrawButton addTarget:self action:@selector(goFPlistView) forControlEvents:UIControlEventTouchUpInside];
    
    //第3段
    UIView *threeView = [[UIView alloc]initWithFrame:CGRectMake(0,BOTTOM_Y(twoView)+10, SCREEN_WIDTH, 140)];
    threeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:threeView];
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH-100, 20)];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.text = @"我的对公账户";
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = [UIColor colorWithRed:46 / 255.0 green:54 / 255.0 blue:63/ 255.0 alpha:1];
    [threeView addSubview:label2];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0,50, SCREEN_WIDTH, 1)];
    line2.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240/ 255.0 alpha:1];
    [threeView addSubview:line2];
    
    UIImageView *next2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -40, 15, 10, 15)];
    [next2 setImage:[UIImage imageNamed:@"xiayibu"]];
    [threeView addSubview:next2];
    
    UIButton *withdrawButton2 = [[UIButton alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(line2)+30, SCREEN_WIDTH-40, 40)];
    [threeView addSubview:withdrawButton2];
    withdrawButton2.layer.cornerRadius = 4;
    [withdrawButton2 setTitle:@"查看明细" forState:UIControlStateNormal];
    withdrawButton2.layer.masksToBounds = YES;
    withdrawButton2.backgroundColor = BLUK_COLOR_ZAN_MC;
    [withdrawButton2 addTarget:self action:@selector(dgzhList) forControlEvents:UIControlEventTouchUpInside];


    
       // Do any additional setup after loading the view.
}
#pragma mark-对公账户
-(void)dgzhList{

    MCDgAccountViewController *dgController = [[MCDgAccountViewController alloc]init];
    dgController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:dgController animated:YES];

}
#pragma mark-即时分配按钮点击进入分配列表页面
-(void)goFPlistView{
    
    MCJSFPListViewController *jsfpVC = [[MCJSFPListViewController alloc]init];
    [self.navigationController pushViewController:jsfpVC animated:YES];

}
- (void)getacount{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *orgToken = [defaults objectForKey:@"orgToken"];
    
    
    NSString *username = [defaults objectForKey:@"userName"];
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:orgToken forKey:@"access_token"];
    [sendDictionary setValue:@2 forKey:@"split_type"];
    [sendDictionary setValue:username forKey:@"split_target"];
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/split/api/account" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                [money setText:[NSString stringWithFormat:@"%.2f",[dicDictionary[@"content"][@"total_balance"] floatValue]]];
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
