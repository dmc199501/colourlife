//
//  MCMicroServiceControl.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCMicroServiceControl.h"
#import "MCServeButton.h"
#import "MCWebViewController.h"
#import "MCUploadReportRepairViewController.h"
#import "MCSendComplaintAndSuggestViewControler.h"
#import "MyMD5.h"
#import "EntranceGuardViewController.h"
#import "AFNetworking.h"
#import "VierticalScrollView.h"
#import "MCDgAccountViewController.h"
@interface MCMicroServiceControl ()<UIScrollViewDelegate,VierticalScrollViewDelegate>

@end

@implementation MCMicroServiceControl
- (id)init
{
    self = [super init];
    if (self)
    {
        officeMutableArray = [NSMutableArray array];
        managementMutableArray = [NSMutableArray array];
        oneButtonMutableArray = [NSMutableArray array];
        twoButtonMutableArray = [NSMutableArray array];
        twoMutableArray = [NSMutableArray array];
        oneMutableArray = [NSMutableArray array];
       activityMutableArray = [NSMutableArray array];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //[self getTs];
    
        //读取数据
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"ad.plist" ];
    NSMutableArray *result = [NSMutableArray arrayWithContentsOfFile:fileName];//如果存储的是其他类型数据，使用相应类型
       // [self getADdata];
    [oneButtonMutableArray addObject:@{@"imageName":@"tz",@"title":@"未读邮件"}];
    [oneButtonMutableArray addObject:@{@"imageName":@"sp",@"title":@"待我审批"}];
    [oneButtonMutableArray addObject:@{@"imageName":@"mf",@"title":@"请假"}];
    [oneButtonMutableArray addObject:@{@"imageName":@"QD2",@"title":@"签到"}];
    
    
    [twoButtonMutableArray addObject:@{@"imageName":@"YJ_fuwu@3x",@"title":@"邮件"}];
    [twoButtonMutableArray addObject:@{@"imageName":@"SP_fuwu",@"title":@"审批"}];
    [twoButtonMutableArray addObject:@{@"imageName":@"QD_fuwu",@"title":@"新e签到"}];
    [twoButtonMutableArray addObject:@{@"imageName":@"case",@"title":@"蜜蜂协同"}];
     [twoButtonMutableArray addObject:@{@"imageName":@"door_fuwu",@"title":@"扫码开门"}];
     [twoButtonMutableArray addObject:@{@"imageName":@"TZ_fuwu",@"title":@"通知公告"}];

    
    
    
    
    ButtonView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40)];
    [self.view addSubview:ButtonView];
    
    

    
    self.navigationItem.title = @"工作";
   [self setViewUI];
    [activityMutableArray removeAllObjects];
    if (result.count>0) {
        
        activityMutableArray = result;
        [self setADUI];
        [self getADdata];
    }else{
        [self getADdata];
    }

    // Do any additional setup after loading the view.
}
-(void)setViewUI{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    

    NSArray *listone  = [userDefaults objectForKey:@"applistone"];
    NSArray *listtwo  = [userDefaults objectForKey:@"applisttwo"];
    
    [twoMutableArray removeAllObjects];
    [officeMutableArray removeAllObjects];
    //广告图
    _adScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 160*SCREEN_WIDTH/375)];
    _adScrollView.pagingEnabled = YES;
    _adScrollView.backgroundColor = [UIColor whiteColor];
    
    _adScrollView.showsHorizontalScrollIndicator = NO;
    
    //创建书页控件
    _adPageControl  = [[UIPageControl alloc]init];
    _adPageControl.frame = CGRectMake( (SCREEN_WIDTH-120)/2, (160*SCREEN_WIDTH/375)-20 , 120, 20);
    _adPageControl.currentPage = 0;
    _adPageControl.tag = 100;
    [ButtonView addSubview:_adScrollView];
    [ButtonView addSubview:_adPageControl];
    
    //设置scrollView的代理为当前类对象
    _adScrollView.delegate = self;
    [self setUpTime];
    //    UIImageView *workImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160*SCREEN_WIDTH/375)];
    //    [ButtonView addSubview:workImageView];
    //    [workImageView setImage:[UIImage imageNamed:@"彩管家_工作_banner图"]];
    //
    //
    //    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160*SCREEN_WIDTH/375)];
    //    [ButtonView addSubview:button];
    //    [button addTarget:self action:@selector(pushweb) forControlEvents:UIControlEventTouchUpInside];
    
    
    oneButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 160*SCREEN_WIDTH/375, SCREEN_WIDTH, 90)];
    oneButtonView.backgroundColor = [UIColor whiteColor];
    [ButtonView addSubview:oneButtonView];
    
    for (int i = 0; i < oneButtonMutableArray.count; i++)
    {
        
        
        float heightB = 90;
        MCServeButton *serveButton = [[MCServeButton alloc]initWithFrame:CGRectMake((i % 4) * (oneButtonView.frame.size.width + 4) / 4 - 0.5 * (i % 4), 0,(oneButtonView.frame.size.width + 4) / 4,heightB-20 )];
        [oneButtonView addSubview:serveButton];
        
        
        
        [serveButton.iconImageView setImage:[UIImage imageNamed:@"BACK_fuwu"]];
        serveButton.iconImageView.frame = CGRectMake((serveButton.frame.size.width - 45) / 2, 10, 45, 45);
        [serveButton.titleNameLabel setFrame:CGRectMake(0, serveButton.frame.size.height - 10, serveButton.frame.size.width, 16)];
        
        [serveButton.titleNameLabel setFont:[UIFont systemFontOfSize:14]];
        serveButton.tag = i;
        [serveButton.titleNameLabel setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
        [serveButton.titleNameLabel setText:[[oneButtonMutableArray objectAtIndex:i] objectForKey:@"title"]];
        [serveButton setTag:i];
        
        switch (i) {
            case 0:
            {
                label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
                label.text = @"0";
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:25];
                label.backgroundColor = [UIColor clearColor];
                [serveButton.iconImageView addSubview:label];
            }
                break;
            case 1:
            {
                label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
                label2.text = [NSString stringWithFormat:@"%@",@"0"];
                label2.textAlignment = NSTextAlignmentCenter;
                label2.font = [UIFont systemFontOfSize:25];
                label2.backgroundColor = [UIColor clearColor];
                [serveButton.iconImageView addSubview:label2];
                
            }
                break;
            case 2:
            {
                UIImageView *QJImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25,25)];
                [serveButton.iconImageView addSubview:QJImageView];
                [serveButton.iconImageView setImage:[UIImage imageNamed:@"QJ_fuwu"]];
                
            }
                break;
            case 3:
            {
                UIImageView *QDImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25,25)];
                [serveButton.iconImageView setImage:[UIImage imageNamed:@"QD2"]];
                [serveButton.iconImageView addSubview:QDImageView];
                ;
            }
                break;
                
            default:
                break;
        }
        
        [serveButton addTarget:self action:@selector(clickoneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, 1, 90)];
    line.backgroundColor =  [UIColor colorWithWhite:242/ 255.0 alpha:1] ;
    [oneButtonView addSubview:line];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 1, 90)];
    line1.backgroundColor =  [UIColor colorWithWhite:242/ 255.0 alpha:1] ;
    [oneButtonView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 0, 1, 90)];
    line2.backgroundColor =  [UIColor colorWithWhite:242/ 255.0 alpha:1] ;
    [oneButtonView addSubview:line2];
    
    
    if (listone.count>0) {
        [twoMutableArray setArray:listone];
        [self setUI];
        [self getOfficeApplicationList];
        
    }else{
        
        [self getOfficeApplicationList];
    }
    
    if (listtwo.count>0) {
        [officeMutableArray setArray:listtwo];
        [self setOfficeArray:listtwo];
    }
    
    [self NetworkReachability];

}
- (void)getADdata{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *corpID = [defaults objectForKey:@"corpId"];
    
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    
    
    
    [sendDict setValue:corpID forKey:@"corp_id"];
    [sendDict setValue:@"100301" forKey:@"plate_code"];
   
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newoa/banner/list" parameters:sendDict success:^(id responseObject) {
                NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 &&[dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
        {
            
            if([[[dicDictionary objectForKey:@"content"] objectForKey:@"list"] count]>0){
                activityMutableArray = [[[dicDictionary objectForKey:@"content"] objectForKey:@"list"] objectForKey:@"100301"];
                NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
                NSString *fileName = [path stringByAppendingPathComponent:@"ad.plist"];
                
                [activityMutableArray writeToFile:fileName atomically:YES];
                
                
                
                [self setADUI];
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    





}
- (void)setUpTime{
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(changgeTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    double page = scrollView.contentOffset.x/scrollView.bounds.size.width;
    self.adPageControl.currentPage = page;
}

- (void)changgeTime{
    if (activityMutableArray.count>0) {
        
        int page = (int)(self.adPageControl.currentPage + 1)%activityMutableArray.count;
        self.adPageControl.currentPage =page;
        
        [self pageChangge:self.adPageControl];
        
    }else{
        
        int page = (int)(self.adPageControl.currentPage + 1)%2;
        self.adPageControl.currentPage =page;
        [self pageChangge:self.adPageControl];
        
    }
    
}

- (void)pageChangge:(UIPageControl *)pagecontrol{
    CGFloat x = (pagecontrol.currentPage)*self.adScrollView.bounds.size.width;
    [self.adScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)setADUI{
    NSLog(@"%@",activityMutableArray);
    
    for (int i = 0; i <activityMutableArray.count; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, _adScrollView.frame.size.width, _adScrollView.frame.size.height)];
        
        UIButton *imgButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, _adScrollView.frame.size.width, _adScrollView.frame.size.height)];
        imgButton.tag = i +1000;
                NSString *urlStr = activityMutableArray[i][@"img_path"];
        [imgView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        [_adScrollView addSubview: imgView];
        [_adScrollView addSubview: imgButton];
        [imgButton addTarget:self action:@selector(pushAdView:) forControlEvents:UIControlEventTouchUpInside];
        _adScrollView.contentSize = CGSizeMake(activityMutableArray.count*SCREEN_WIDTH, 0);
        
    }
    if (activityMutableArray.count>1) {
        _adPageControl.numberOfPages = activityMutableArray.count;
    }else{
     _adPageControl.numberOfPages = 0;
    }
    
    
}
- (void)pushAdView:(UIButton *)button{
    NSLog(@"%@",activityMutableArray);
    NSString *urlString = [NSString stringWithFormat:@"%@",activityMutableArray[button.tag-1000][@"url"]];
    [self getoauth2:urlString andTitle:@"" anddeveloperCode:@"case"];
    
    
}

- (void)NetworkReachability{

    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == 0) {
            [SVProgressHUD showErrorWithStatus:@"网络无连接"];
        }else{
            [self getOfficeApplicationList];

        }
//        switch (status) {
//            case 0:{
//                NSLog(@"网络不通：%@",@(status) );
//                break;
//            }
//            case AFNetworkReachabilityStatusReachableViaWiFi:{
//                NSLog(@"网络通过WIFI连接：%@",@(status));
//                
//                   [self getOfficeApplicationList];
//                
//                break;
//            }
//                
//            case AFNetworkReachabilityStatusReachableViaWWAN:{
//                NSLog(@"网络通过无线连接：%@",@(status) );
//                [self getOfficeApplicationList];
//                break;
//            }
//            default:
//                break;
//        }
        
        
    }];
     [afNetworkReachabilityManager startMonitoring];
}
- (void)pushweb{
    
        
        NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
        NSString *passWord = [defaults objectForKey:@"passWordMI"];//根据键值取出name
        
        [sendDictionary setValue:username forKey:@"username"];
        [sendDictionary setValue:passWord forKey:@"password"];
        [sendDictionary setValue:@"case" forKey:@"developerCode"];
        [sendDictionary setValue:@"cgj" forKey:@"accountType"];
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak  MBProgressHUD *weakHub = hub;
        hub.opacity = 1.0;
        [hub setDetailsLabelText:@"正在获取授权..."];
        
        [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/auth2" parameters:sendDictionary success:^(id responseObject) {
            [weakHub hide:YES];
            NSDictionary *dicDictionary = responseObject;
            NSLog(@"%@",dicDictionary);
            if ([dicDictionary[@"code"] integerValue] == 0 )
            {
                if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
                {
                    
                    NSString *url = @"http://iceapi.colourlife.com:4600/detail";
                    NSString *userName = username;
                    NSString *token = dicDictionary[@"content"][@"access_token"];
                    NSString *caseId = @"27d905d3-89e7-4ba0-ad8e-3c3f68e07a11";
                    
                    NSString *URLstring = [NSString stringWithFormat:@"%@?username=%@&access_token=%@&caseId=%@",url,userName,token,caseId];
                    MCWebViewController *web = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring] titleString:@"蜜蜂协同"];
                    web.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:web animated:YES];
                    
                    
                    
                }
                
                return ;
                
                
                
            }
            
            
            NSLog(@"----%@",responseObject);
            
        } failure:^(NSError *error) {
            
            NSLog(@"****%@", error);
            
        }];
        
        
    
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getamailNum];
    [self getexamineNum];

}
- (void)getamailNum{
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    
    
    [sendDictionary setValue:username forKey:@"uid"];
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/newmail/mail/getmailsumbyuid" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"][@"data"] isKindOfClass:[NSDictionary class]])
            {
                
               
                label.text = [NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"data"][@"recipientsum"]];
                
                
            }
            
            return ;
            
            
            
        }else{
        
         label.text = [NSString stringWithFormat:@"%@",@"0"];
        
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];




}

- (void)getexamineNum{
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    
    
    [sendDictionary setValue:username forKey:@"username"];
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/oa/examineNum" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                label2.text = [NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"number"]];
                
                
            }
            
            return ;
            
            
            
        }else{
        
        label2.text = [NSString stringWithFormat:@"%@",@"0"];
        
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
    
    
}

- (void)getOfficeApplicationList{
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *passWord = [defaults objectForKey:@"passWord"];//根据键值取出name
    
    [sendDictionary setValue:username forKey:@"user_name"];
    [sendDictionary setValue:passWord forKey:@"password"];
    [sendDictionary setValue:@"app" forKey:@"resource"];
    [sendDictionary setValue:@0 forKey:@"cate_id"];

    //[sendDictionary setValue:@"0" forKey:@"clientCode"];
    NSLog(@"%@",sendDictionary);
   
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newoa/rights/list" parameters:sendDictionary success:^(id responseObject) {
       
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            _tol = 1;
            if ([dicDictionary[@"content"][@"app_list"] count]>0) {
                
                [twoMutableArray setArray:dicDictionary[@"content"][@"app_list"][0][@"list"]];
                NSArray *array1 = dicDictionary[@"content"][@"app_list"][0][@"list"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
               
                
                [userDefaults setObject:array1 forKey:@"applistone"];
                [userDefaults synchronize];
                
                [self setUI];
                // [self getHomeButton];
                if ([dicDictionary[@"content"][@"app_list"] count]>1) {
                    officeMutableArray = dicDictionary[@"content"][@"app_list"][1][@"list"];
                    // [self getHomeButton];
                    
                    NSArray *array2 = dicDictionary[@"content"][@"app_list"][1][@"list"];
                    
                    
                    
                    
                    [userDefaults setObject:array2 forKey:@"applisttwo"];
                    [userDefaults synchronize];
                    
                    
                    
                    [self setOfficeArray:dicDictionary[@"content"][@"app_list"][1][@"list"]];
                }
                
                
              
                
                
                

                
            }
            
                
                
            }
            
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
}

- (void)getOfficeApplicationList2{
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *passWord = [defaults objectForKey:@"passWord"];//根据键值取出name
    
    [sendDictionary setValue:username forKey:@"user_name"];
    [sendDictionary setValue:passWord forKey:@"password"];
    [sendDictionary setValue:@"app" forKey:@"resource"];
    [sendDictionary setValue:@2 forKey:@"cate_id"];
    
    //[sendDictionary setValue:@"0" forKey:@"clientCode"];
    NSLog(@"%@",sendDictionary);
    
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newoa/rights/list" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"][@"app_list"] count]>0) {
            
            officeMutableArray = dicDictionary[@"content"][@"app_list"][0][@"list"];
            // [self getHomeButton];
            
            NSArray *array = dicDictionary[@"content"][@"app_list"][0][@"list"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            //存数据，不需要设置路劲，NSUserDefaults将数据保存在preferences目录下
            
            [userDefaults setObject:array forKey:@"applisttwo"];
            [userDefaults synchronize];

            
           
            }
            
            
            
            
            
            
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
}


- (void)setOfficeArray:(NSArray *)array{
    
   
    [officeButtonView removeFromSuperview];
    officeButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(twoButtonView)+10, SCREEN_WIDTH, ((array.count-1)/4 * 90)+130)];
    officeButtonView.tag = 1202;
   
    ButtonView.contentSize = CGSizeMake(SCREEN_WIDTH,officeButtonView.frame.size.height +560*SCREEN_WIDTH/375);
    officeButtonView.backgroundColor = [UIColor whiteColor];
    [ButtonView addSubview:officeButtonView];
    
    UILabel *label11 = [[UILabel alloc]initWithFrame:CGRectMake(20,0, SCREEN_WIDTH, 40)];
    label11.text = @"其他应用";
    
    label11.font = [UIFont systemFontOfSize:14];
    label11.backgroundColor = [UIColor whiteColor];
    [officeButtonView addSubview:label11];
    
    UILabel *label12 = [[UILabel alloc]initWithFrame:CGRectMake(0,BOTTOM_Y(officeButtonView)+10, SCREEN_WIDTH, 20)];
    label12.text = @"--把社区服务做到家--";
    label12.textAlignment = NSTextAlignmentCenter;
    label12.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    label12.font = [UIFont systemFontOfSize:14];
    label12.backgroundColor = [UIColor clearColor];
    [ButtonView addSubview:label12];


    
   for (int i = 0; i < array.count; i++)
   {
   
      
        float heightB = 90;
        MCServeButton *serveButton = [[MCServeButton alloc]initWithFrame:CGRectMake((i % 4) * (officeButtonView.frame.size.width + 4) / 4 - 0.5 * (i % 4),  (i / 4) * (heightB)+40,(officeButtonView.frame.size.width + 4) / 4,heightB-20 )];
        [officeButtonView addSubview:serveButton];
        
        NSURL *imageUrl = [NSURL URLWithString:[[array objectAtIndex:i] objectForKey:@"icon"][@"ios"]];
      
       NSString *imageUrl2 = [NSString stringWithFormat:@"%@",imageUrl];
       if ([imageUrl2 containsString:@"-100-100.jpg"]) {
           NSString *str3 = [imageUrl2 stringByReplacingOccurrencesOfString:@"-100-100.jpg" withString:@""];
           [serveButton.iconImageView sd_setImageWithURL:[NSURL URLWithString:str3] placeholderImage:[UIImage imageNamed:@"moren"]];
       }else{
           [serveButton.iconImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"moren"]];
       }

       
       
        serveButton.iconImageView.frame = CGRectMake((serveButton.frame.size.width - 45) / 2, 10, 45, 45);
        [serveButton.titleNameLabel setFrame:CGRectMake(0, serveButton.frame.size.height-10 , serveButton.frame.size.width, 16)];
        
        [serveButton.titleNameLabel setFont:[UIFont systemFontOfSize:14]];
        serveButton.tag = i;
        [serveButton.titleNameLabel setText:[[array objectAtIndex:i] objectForKey:@"name"]];
        [serveButton setTag:i];
        
       UIView *line6 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
       line6.backgroundColor = [UIColor colorWithWhite:242/ 255.0 alpha:1];
       [officeButtonView addSubview:line6];
       
       
       UIView *line8 = [[UIView alloc]initWithFrame:CGRectMake(0, (i/4)*(heightB) +heightB+40, SCREEN_WIDTH, 1)];
       if (i == 20) {
           NSLog(@"%f",line8.frame.origin.y);
       }
       line8.backgroundColor = [UIColor colorWithWhite:242/ 255.0 alpha:1];
       [officeButtonView addSubview:line8];
       
       UIView *line9 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/4)*(i%4+1), 40, 1,((array.count-1)/4 * 100)+130)];
       line9.backgroundColor = [UIColor colorWithWhite:242/ 255.0 alpha:1];
       [officeButtonView addSubview:line9];

       [serveButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
   }
    
   

   
}

- (void)setUI{

    //第一行按钮
    
    //第二行常用应用
    [twoButtonView  removeFromSuperview];
    twoButtonView = [[UIView alloc]init];
    twoButtonView.backgroundColor = [UIColor whiteColor];
    twoButtonView.tag = 1201;
    [ButtonView addSubview:twoButtonView];
    twoButtonView.frame = CGRectMake(0,  BOTTOM_Y(oneButtonView)+10, SCREEN_WIDTH, ((twoMutableArray.count-1)/4 * 90)+130);
    
    officeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(oneButtonView)+10, SCREEN_WIDTH, 40)];
    officeLabel.text = @"常用应用";
    officeLabel.font = [UIFont systemFontOfSize:14];
    officeLabel.backgroundColor = [UIColor whiteColor];
    [ButtonView addSubview:officeLabel];
    
    for (int i = 0; i < twoMutableArray.count; i++)
    {
        
        
        float heightB = 90;
        MCServeButton *serveButton = [[MCServeButton alloc]initWithFrame:CGRectMake((i % 4) * (oneButtonView.frame.size.width + 4) / 4 - 0.5 * (i % 4),  (i / 4) * (heightB)+40,(oneButtonView.frame.size.width + 4) / 4,heightB-20 )];
        [twoButtonView addSubview:serveButton];
        
        
        
        NSURL *imageUrl = [NSURL URLWithString:[[twoMutableArray objectAtIndex:i] objectForKey:@"icon"][@"ios"]];
        NSString *imageUrl2 = [NSString stringWithFormat:@"%@",imageUrl];
        if ([imageUrl2 containsString:@"-100-100.jpg"]) {
        NSString *str3 = [imageUrl2 stringByReplacingOccurrencesOfString:@"-100-100.jpg" withString:@""];
             [serveButton.iconImageView sd_setImageWithURL:[NSURL URLWithString:str3] placeholderImage:[UIImage imageNamed:@"moren"]];
        }else{
        [serveButton.iconImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"moren"]];
        }
        
       
        serveButton.iconImageView.frame = CGRectMake((serveButton.frame.size.width - 45) / 2, 10, 45, 45);
        [serveButton.titleNameLabel setFrame:CGRectMake(0, serveButton.frame.size.height - 10, serveButton.frame.size.width, 16)];
        
        [serveButton.titleNameLabel setFont:[UIFont systemFontOfSize:14]];
        serveButton.tag = i;
        [serveButton.titleNameLabel setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
        [serveButton.titleNameLabel setText:[[twoMutableArray objectAtIndex:i] objectForKey:@"name"]];
        [serveButton setTag:i];
        
        UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
        line5.backgroundColor = [UIColor colorWithWhite:242/ 255.0 alpha:1];
        [twoButtonView addSubview:line5];
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, (i % 4)*(heightB+40) +heightB+40, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithWhite:242/ 255.0 alpha:1];
        [twoButtonView addSubview:line];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/4)*(i%4+1), 0, 1,4*(serveButton.frame.size.height+40))];
        line2.backgroundColor = [UIColor colorWithWhite:242/ 255.0 alpha:1];
        [twoButtonView addSubview:line2];
        
        
        [serveButton addTarget:self action:@selector(clickTWOButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    



}

- (void)clickTWOButton:(UIButton *)senderButton
{
    NSLog(@"%@",twoMutableArray);
    
        [self pushH5:[twoMutableArray objectAtIndex:senderButton.tag]];
    
    
        
    
}

-(void)getInfoByOa{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];
    
    
    NSDictionary *sendDict = @{
                               @"oa":username,
                               
                               
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/newczy/customer/infoByOa" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 1 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
            {
                
                
                EntranceGuardViewController * entranceGuardViewController = [EntranceGuardViewController new];
                
                entranceGuardViewController.infomDic = [dicDictionary objectForKey:@"content"][0];
                
                entranceGuardViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:entranceGuardViewController animated:YES];
                
            }
            
        }else{
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       
        
        
    }];
    
    




}
- (void)clickoneButton:(UIButton *)senderButton
{
   
    NSDictionary *spDic = [[NSDictionary alloc]init];//工作审批
   
    NSDictionary *yjDic = [[NSDictionary alloc]init];//邮件
    NSDictionary *qdDic = [[NSDictionary alloc]init];//新E
   
    
//    for (int i=0; i<twoMutableArray.count; i++) {
//        NSString *title = [twoMutableArray objectAtIndex:i][@"name"];
//        
//        if ([title isEqualToString:@"审批"]) {
//            spDic =[twoMutableArray objectAtIndex:i];
//        }
//        
//        if ([title isEqualToString:@"新邮件"]) {
//            
//            yjDic =[twoMutableArray objectAtIndex:i];
//            
//        }
//        if ([title isEqualToString:@"签到"]) {
//            qdDic =[twoMutableArray objectAtIndex:i];
//            NSLog(@"%@",yjDic);
//            
//            
//        }
//        
//    }
    
    switch (senderButton.tag)
    {
            
        case 0:{
            NSLog(@"%@",yjDic);
            yjDic = @{@"name":@"新邮件",@"oauthType":@"1",@"url":@"http://mail.oa.colourlife.com:40060/login",@"app_code":@"xyj"};
            [self pushH5:yjDic];
            
            
        }
            break;
        case 1://
        {
            spDic = @{@"name":@"审批",@"oauthType":@"0",@"url":@"http://spsso.colourlife.net/login.aspx",@"app_code":@"sp"};
            [self pushH5:spDic];
            
            
        }
            break;
        case 2://
        {
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
            NSString *qj = @"http://eqd.backyard.colourlife.com/cailife/leave/index?username=";

            NSString *url = [NSString stringWithFormat:@"%@%@",qj,username];
            
            MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:url]  titleString:@"请假"];
            webViewController.iosURL = url;
            webViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
            
            
        }
            break;
            
        case 3://
        {
            qdDic = @{@"name":@"签到",@"oauthType":@"1",@"url":@"http://eqd.oa.colourlife.com/cailife/sign/main",@"app_code":@"qiandao"};
            
           [self pushH5:qdDic];
            
            
        }
            break;
            
       
            
        default:
            break;
    }
    
    
}


- (void)pushH5:(NSDictionary *)dic{
    NSLog(@"%@",dic);
    if ([dic[@"app_code"] isEqualToString:@"smkm"])
    {
        [self getInfoByOa];
        
        
    }else if ([dic[@"app_code"] isEqualToString:@"dgzh"]){
        
        MCDgAccountViewController *dgController = [[MCDgAccountViewController alloc]init];
        dgController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:dgController animated:YES];
        
        
    }else
    {

    NSString *oauthType = [NSString stringWithFormat:@"%@",dic[@"oauthType"]];
    if ([oauthType integerValue] == 0) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        //读取数据
        
       
        NSString *clientCode = [NSString stringWithFormat:@"%@",dic[@"app_code"]];
        NSString *urloauth1 = [NSString stringWithFormat:@"%@",dic[@"url"]];
        
        [self getoauth1:urloauth1 andTitle:dic[@"name"]andClientCode:clientCode];
// }
        
        
    }else{
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        //读取数据
        
        NSString *token  = [userDefaults objectForKey:@"token2.0"];
        NSString *username = [userDefaults objectForKey:@"userName"];//根据键值取出name
         NSString *time  = [userDefaults objectForKey:@"oauth2time"];
        NSString *yxTime  = [userDefaults objectForKey:@"expires"];
        NSLog(@"%@",yxTime);
        NSString *developerCode = [NSString stringWithFormat:@"%@",dic[@"app_code"]];
        NSString *urloauth2 = @"";
        
         urloauth2 = [NSString stringWithFormat:@"%@",dic[@"url"]];
        
       
        if (token.length>0) {
            if ([[self timechangge:time] integerValue]>[yxTime integerValue]) {
                [self getoauth2:urloauth2 andTitle:dic[@"name"]anddeveloperCode:developerCode];
            }else{
            NSString *urlString = [NSString stringWithFormat:@"%@?username=%@&access_token=%@",urloauth2,username,token];
            
            MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:urlString]  titleString:dic[@"name"]];
                webViewController.iosURL = urlString;
            webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];}
            
        }else{
   
            [self getoauth2:urloauth2 andTitle:dic[@"name"]anddeveloperCode:developerCode];
        }
        
    
    
    }
    }
}


- (void)clickButton:(UIButton *)senderButton{
   
   NSDictionary *dics = [NSDictionary dictionary];
    dics = [officeMutableArray objectAtIndex:senderButton.tag];
    
    if ([dics[@"app_code"] isEqualToString:@"smkm"])
    {
        [self getInfoByOa];
        
    }else if ([dics[@"app_code"] isEqualToString:@"dgzh"]){
        
        MCDgAccountViewController *dgController = [[MCDgAccountViewController alloc]init];
        dgController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:dgController animated:YES];
        
        
    }else
    {

    NSString *oauthType = [NSString stringWithFormat:@"%@",dics[@"oauthType"]];
    if ([oauthType integerValue] == 0) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        //读取数据
        
      
        
        NSString *clientCode = [NSString stringWithFormat:@"%@",dics[@"app_code"]];
        NSString *urloauth1 = [NSString stringWithFormat:@"%@",dics[@"url"]];
        
    [self getoauth1:urloauth1 andTitle:dics[@"name"]andClientCode:clientCode];
      
        
            }else{
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                //读取数据
                
                NSString *token  = [userDefaults objectForKey:@"token2.0"];
                NSString *username = [userDefaults objectForKey:@"userName"];//根据键值取出name
                NSString *time  = [userDefaults objectForKey:@"oauth2time"];
                NSString *yxTime  = [userDefaults objectForKey:@"expires"];
                
                NSLog(@"%@",yxTime);
                NSString *developerCode = [NSString stringWithFormat:@"%@",dics[@"app_code"]];
                NSString *urloauth2 = @"";
                
                urloauth2 = [NSString stringWithFormat:@"%@",dics[@"url"]];
                if (token.length>0) {
                    if ([[self timechangge:time] integerValue]>[yxTime integerValue]) {
                        [self getoauth2:urloauth2 andTitle:dics[@"name"]anddeveloperCode:developerCode];
                    }else{
                        NSString *urlString = [NSString stringWithFormat:@"%@?username=%@&access_token=%@",urloauth2,username,token];
                        
                        MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:urlString]  titleString:dics[@"name"]];
                         webViewController.iosURL = urlString;
                        webViewController.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:webViewController animated:YES];}
                    
                }else{
                    
                    [self getoauth2:urloauth2 andTitle:dics[@"name"]anddeveloperCode:developerCode];
                }

    
    }
   

    }
    
}

- (NSString *)timechangge:(NSString *)oauthTime{
    //首先创建格式化对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //然后创建日期对象
    
    NSDate *date1 = [dateFormatter dateFromString:oauthTime];
    
    NSDate *date = [NSDate date];
  
    //计算时间间隔（单位是秒）
    
    NSTimeInterval time = [date timeIntervalSinceDate:date1];
    
    //计算天数、时、分、秒
    
    int days = ((int)time)/(3600*24);
    
    int hours = ((int)time)%(3600*24)/3600;
    
     int minutes = ((int)time)%(3600*24)%3600/60;
    
    
   
    int num = days*(-24) + hours*(-1);
   
    NSString *numString = [NSString stringWithFormat:@"%ld",(NSInteger)time];
     NSLog(@"%d---%@---%@",(int)time,oauthTime,numString);
    
    return numString;

}
- (void)getoauth1:(NSString *)url andTitle:(NSString *)name andClientCode:(NSString *)clientCode{

    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *passWord = [defaults objectForKey:@"passWordMI"];//根据键值取出name
    
    [sendDictionary setValue:username forKey:@"username"];
    [sendDictionary setValue:passWord forKey:@"password"];
    [sendDictionary setValue:@"case" forKey:@"clientCode"];
    
    NSLog(@"%@",sendDictionary);
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak  MBProgressHUD *weakHub = hub;
    hub.opacity = 1.0;
    [hub setDetailsLabelText:@"正在获取授权..."];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/auth" parameters:sendDictionary success:^(id responseObject) {
        [weakHub hide:YES];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = dicDictionary[@"content"];
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString = [dateFormatter stringFromDate:currentDate];

                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                //存数据，不需要设置路劲，NSUserDefaults将数据保存在preferences目录下
                [userDefaults setObject:dateString forKey:@"oauth1time"];
                [userDefaults setObject:dic[@"accessToken"] forKey:@"token1.0"];
                [userDefaults setObject:dic[@"openID"] forKey:@"openID1.0"];
                [userDefaults synchronize];

                NSString *urlString = [NSString stringWithFormat:@"%@?openID=%@&accessToken=%@",url,dic[@"openID"],dic[@"accessToken"]];
                NSLog(@"URL----%@",urlString);
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:urlString]  titleString:name];
                 webViewController.iosURL = urlString;
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];

                
                
                
            }
            
            return ;
            
            
            
        }else{
        
            [SVProgressHUD showErrorWithStatus:@"应用授权失败"];
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        [weakHub hide:YES];
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        NSLog(@"****%@", error);
        
    }];



}
- (void)getoauth2:(NSString *)url andTitle:(NSString *)name anddeveloperCode:(NSString *)developerCode{

    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *passWord = [defaults objectForKey:@"passWordMI"];//根据键值取出name
    
    [sendDictionary setValue:username forKey:@"username"];
    [sendDictionary setValue:passWord forKey:@"password"];
    [sendDictionary setValue:@"case" forKey:@"developerCode"];
    [sendDictionary setValue:@"cgj" forKey:@"accountType"];
    [sendDictionary setValue:@"1" forKey:@"getExpire"];
    NSLog(@"%@",sendDictionary);
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak  MBProgressHUD *weakHub = hub;
    hub.opacity = 1.0;
    [hub setDetailsLabelText:@"正在获取授权..."];
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/auth2" parameters:sendDictionary success:^(id responseObject) {
        [weakHub hide:YES];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString = [dateFormatter stringFromDate:currentDate];

                NSDictionary *dic = dicDictionary[@"content"];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                //存数据，不需要设置路劲，NSUserDefaults将数据保存在preferences目录下
                
                [userDefaults setObject:dic[@"access_token"] forKey:@"token2.0"];
                [userDefaults setObject:dic[@"expires_in"] forKey:@"expires"];
                [userDefaults setObject:dateString forKey:@"oauth2time"];
                [userDefaults synchronize];

                NSString *urlString = [NSString stringWithFormat:@"%@?username=%@&access_token=%@",url,username,dic[@"access_token"]];
                
               
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:urlString]  titleString:name];
                webViewController.iosURL = urlString;
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
                
                
            }
            
            return ;
            
            
            
        }else{
        
             [SVProgressHUD showErrorWithStatus:@"应用授权失败"];
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        [weakHub hide:YES];
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
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
