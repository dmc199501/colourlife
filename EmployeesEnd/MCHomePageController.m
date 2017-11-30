//
//  MCHomePageController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define GT_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7

#import "MCHomePageController.h"
#import "MCServeButton.h"
#import "MCHomePageTableViewCell.h"
#import "MCMessageVIiewControler.h"
#import "MCWebViewController.h"
#import "MCScanViewController.h"
#import "MCUploadReportRepairViewController.h"
#import "MCSendComplaintAndSuggestViewControler.h"
#import "MyMD5.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <ColourlifeAuth/ColourlifeAuth.h>
#import <AVFoundation/AVMediaFormat.h>
#import "MCsousuoViewController.h"
#import "MapViewController.h"
#import "MCFanPiaoViewController.h"
#import "MCDataKBViewController.h"
#import "MCMessageListViewController.h"
#import "MCAccountViewController.h"
#import "MCMycodeViewController.h"
#import "HCScanQRViewController.h"
#import "NSArray+deleteNill.h"
#import "JPUSHService.h"
#import "UITabBar+MCTabBar.h"
@interface MCHomePageController () <XWXAuthDelegate>
@property(nonatomic,strong)NSString *IPString;
@property(nonatomic,assign)int isOpen;
@property (nonatomic, assign) int page;  //请求页码
@property(nonatomic,strong)NSString *douwnUrl;

@end

@implementation MCHomePageController

- (id)init
{
    self = [super init];
    if (self)
    {
       
        listMutableArray = [NSMutableArray array];
        htmlMutableArray = [NSMutableArray array];
        officeMutableArray = [NSMutableArray array];
        redIDMutableArray = [NSMutableArray array];
        
         listOneMutableArray = [NSMutableArray array];
        ggtzMutableArray = [NSMutableArray array];
         yjMutableArray = [NSMutableArray array];
         mfMutableArray = [NSMutableArray array];
         spMutableArray = [NSMutableArray array];
        listGDMutableArray = [NSMutableArray array];
        

        homeButtonMutableArray = [NSMutableArray array];
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self deviceIPAdress];
    [self setAlias];
    if ([MCPublicDataSingleton sharePublicDataSingleton].isRequestVersion == 0) {
        [self VersionUpdate];
    }
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti1) name:@"pushList" object:nil];
//    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
//    
//    [notiCenter addObserver:self selector:@selector(receiveNotification:) name:@"首页列表推送" object:nil];
   
    [listGDMutableArray addObject:@{@"imageName":@"通知公告",@"title":@"暂无新消息",@"comefrom":@"公告通知",@"owner_name":@"暂无",@"client_code":@"ggtz",@"homePushTime":@"2000-06-10 17:57:11",@"notread":@"0"}];
     [listGDMutableArray addObject:@{@"imageName":@"邮件",@"title":@"暂无新消息",@"comefrom":@"新邮件",@"owner_name":@"暂无",@"client_code":@"yj",@"homePushTime":@"2000-06-10 17:57:11",@"notread":@"0"}];
    [listGDMutableArray addObject:@{@"imageName":@"审批",@"title":@"暂无新消息",@"comefrom":@"蜜蜂协同",@"owner_name":@"暂无",@"client_code":@"case",@"homePushTime":@"2000-06-10 17:57:11",@"notread":@"0"}];
    [listGDMutableArray addObject:@{@"imageName":@"蜜蜂协同",@"title":@"暂无新消息",@"comefrom":@"审批",@"owner_name":@"暂无",@"client_code":@"sp",@"homePushTime":@"2000-06-10 17:57:11",@"notread":@"0"}];
    
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://cd.colourlife.com/cgj.plist"]];
    [self getAPPs];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [defaults objectForKey:@"userInfo"];
    
    
    //[self loadMassage];
    


    
    _page = 1;

   
    self.navigationController.delegate = self;
    [self setUI];
    [self getOfficeApplicationList];
    NSLog(@"%@",userDic);
    if (userDic) {
        [self setUserHome];
    }else{
        
        [self loadUserData];
    }
    
   [self getKeyData];
    

    
    
    


    // Do any additional setup after loading the view.
}
-(void)noti1

{
    //前台收到通知
    [self loadMassage];
    
    
}
- (void)dealloc
{
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}
-(void)setAlias{
     NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"userName"];
    NSString *corpId = [defaults objectForKey:@"corpId"];
    
    if (name.length>0 && corpId.length>0) {
        //标签
        __autoreleasing NSMutableSet *tags = [NSMutableSet set];
        [self setTags:&tags addTag:corpId];
        [self setTags:&tags addTag:@"cgj"];
        //别名
        __autoreleasing NSString *alias ;
        alias = [NSString stringWithFormat:@"cgj_%@",name];
        NSLog(@"%@",alias);
        [self analyseInput:&alias tags:&tags];
        
        [JPUSHService setTags:tags alias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
   


}
#pragma mark--设置推送的标签及别名
- (void)setTags:(NSMutableSet **)tags addTag:(NSString *)tag {
    
    [*tags addObject:tag];
}
- (void)analyseInput:(NSString **)alias tags:(NSSet **)tags {
    // alias analyse
    if (![*alias length]) {
        // ignore alias
        *alias = nil;
    }
    // tags analyse
    if (![*tags count]) {
        *tags = nil;
    } else {
        __block int emptyStringCount = 0;
        [*tags enumerateObjectsUsingBlock:^(NSString *tag, BOOL *stop) {
            if ([tag isEqualToString:@""]) {
                emptyStringCount++;
            } else {
                emptyStringCount = 0;
                *stop = YES;
            }
        }];
        if (emptyStringCount == [*tags count]) {
            *tags = nil;
        }
    }
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}
- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *fanpiao  = [userDefaults objectForKey:@"fanpiao"];
        NSString *fencheng  = [userDefaults objectForKey:@"fencheng"];
        NSString *isClean  = [userDefaults objectForKey:@"isClean"];
   
    if ([isClean isEqualToString:@"yes"]) {
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isClean"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self loadMassage];
    }
    
    if (fanpiao.length>0) {
    
       NSLog(@"%@",fanpiao);
        [myMealLaber setText:[NSString stringWithFormat:@"%.2f",[fanpiao floatValue]]];
          }
    if (fencheng.length>0) {
        
        
        [accountLaber setText:[NSString stringWithFormat:@"%.2f",[fencheng floatValue]]];
    }
    
    
    [self getacount];//分账
    
    //[self getHongbao];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)gtstock{

    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:@"彩生活" forKey:@"stock"];
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/stock" parameters:sendDictionary success:^(id responseObject) {
        [Activitystock stopAnimating]; // 结束旋转
        [Activitystock setHidesWhenStopped:YES]; //当旋转结束时隐藏
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                [userDefaults setObject:[NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"currentPrice"]] forKey:@"gupiao"];
                [userDefaults synchronize];

                
                [stockLaber setText:[NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"currentPrice"]]];
                
            }
            
            return ;
            
            
            
        }else{
        
         [stockLaber setText:[NSString stringWithFormat:@"%@",@"4.55"]];
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    


}
//分账
- (void)getacount{
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:@"userName"];
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:@"1521ac83521b8063e7a9a49dc22e79b0" forKey:@"access_token"];
    [sendDictionary setValue:@2 forKey:@"target_type"];
    [sendDictionary setValue:username forKey:@"target"];
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/splitdivide/api/account" parameters:sendDictionary success:^(id responseObject) {
        [ActivityFZ stopAnimating]; // 结束旋转
        [ActivityFZ setHidesWhenStopped:YES]; //当旋转结束时隐藏
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                [accountLaber setText:[NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"total_balance"]]];
                self.fzstring = dicDictionary[@"content"][@"total_balance"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                [userDefaults setObject:[NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"total_balance"]] forKey:@"fencheng"];
                [userDefaults synchronize];

                
            }
            
            return ;
            
            
            
        }else{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[NSString stringWithFormat:@"%@",@"0.00"] forKey:@"fencheng"];
            [accountLaber setText:[NSString stringWithFormat:@"%@",@"0.00"]];
           
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    

    
}
- (void)gtsscore{
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    NSString *year = [NSString stringWithFormat:@"%ld",comp.year];
    NSString *month = [NSString stringWithFormat:@"%ld",comp.month];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:username forKey:@"oauser"];
    [sendDictionary setValue:year forKey:@"year"];
    [sendDictionary setValue:month forKey:@"month"];
    

    
    NSLog(@"%@",sendDictionary);
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/oa/jxfen" parameters:sendDictionary success:^(id responseObject) {
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        [Activityscore stopAnimating]; // 结束旋转
        [Activityscore setHidesWhenStopped:YES]; //当旋转结束时隐藏
        
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                NSString *meal = [NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"fee"]];
                float meal1 = [meal floatValue];
                
                NSString *score = [NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"percent"]];
                float score1 = [score floatValue];

                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                
                 [userDefaults setObject:[NSString stringWithFormat:@"%f",score1] forKey:@"jixiao"];
                [userDefaults synchronize];
                
                //[myMealLaber setText:[NSString stringWithFormat:@"%.2f",meal1]];
                
                [scoreLaber setText:[NSString stringWithFormat:@"%.2f",score1]];
                
            }
            
            return ;
            
            
            
        }else{
        
        
            
            
            [scoreLaber setText:[NSString stringWithFormat:@"%@",@"0.00"]];
        
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
    
}


- (void)gtsArea{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *orgToken = [defaults objectForKey:@"orgToken"];
    NSString *corpID = [defaults objectForKey:@"corpId"];
NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:@"9959f117-df60-4d1b-a354-776c20ffb8c7" forKey:@"orgUuid"];
    [sendDictionary setValue:orgToken forKey:@"token"];
     [sendDictionary setValue:corpID forKey:@"corpId"];

    
    
    
    
    NSLog(@"%@",sendDictionary);
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/resourcems/community/statistics" parameters:sendDictionary success:^(id responseObject) {
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        [Activityarea stopAnimating]; // 结束旋转
        [Activityarea setHidesWhenStopped:YES]; //当旋转结束时隐藏
        
        [Activitydistrict stopAnimating]; // 结束旋转
        [Activitydistrict setHidesWhenStopped:YES]; //当旋转结束时隐藏
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                NSString *area = [NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"area"]];
                
                self.areaDic = dicDictionary[@"content"];
                
                NSString *district = [NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"count"]];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                [userDefaults setObject:[NSString stringWithFormat:@"%@",area] forKey:@"xiaoqu"];
                [userDefaults setObject:[NSString stringWithFormat:@"%@",district] forKey:@"mianji"];
                [userDefaults synchronize];
                
                [districtlLaber setText:[NSString stringWithFormat:@"%@",district]];
               
                
                [areaLaber setText:[NSString stringWithFormat:@"%.2f",[area floatValue] /10000]];
                
            }
            
            return ;
            
            
            
        }else{
            
            
            [districtlLaber setText:[NSString stringWithFormat:@"%@",@"0"]];
            
            [areaLaber setText:[NSString stringWithFormat:@"%@",@"0"]];
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
    
}
- (void)therRefresh{

    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMassage)];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松手立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"努力刷新中" forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置刷新控件
    listTableView.mj_header = header;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//    listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        //[weakSelf loadMoreData];
//    }];



}
- (void)getAPPs{
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
            
           
            NSArray *array = dicDictionary[@"content"][@"app_list"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            //存数据，不需要设置路劲，NSUserDefaults将数据保存在preferences目录下
            
            [userDefaults setObject:array forKey:@"searchAPPs"];
            [userDefaults synchronize];
            // [self getHomeButton];
            
            
            
            
            
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
    
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newoa/rights/list" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                NSArray *array = dicDictionary[@"content"][@"app_list"];
                if ([array count]>0) {
                    [officeMutableArray setArray:dicDictionary[@"content"][@"app_list"][0][@"list"]];
                    [self getHomeButton];
                }

                
                
                
            }
            
            return ;
            
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
}
- (void)getHomeButton{
    NSLog(@"%@",officeMutableArray);
    for (int i=0; i<officeMutableArray.count; i++) {
        NSString *title = [officeMutableArray objectAtIndex:i][@"name"];
        if ([title isEqualToString:@"邮件"]||[title isEqualToString:@"审批"]||[title isEqualToString:@"新e签到"]) {
            [htmlMutableArray addObject:[officeMutableArray objectAtIndex:i]];
            if ([title isEqualToString:@"新邮件"]) {
                [MCPublicDataSingleton sharePublicDataSingleton].MailDictionary = [officeMutableArray objectAtIndex:i];
            }
            
            
        }
        
        
    }
    NSLog(@"%@",htmlMutableArray);
   
    
    
}
- (void)clickTWOButton:(UIButton *)senderButton
{
    
    NSDictionary *YJDic = [[NSDictionary alloc]init];
    NSDictionary *spDic = [[NSDictionary alloc]init];
    NSDictionary *QDDic = [[NSDictionary alloc]init];
//    NSLog(@"%@",htmlMutableArray);
//        for (int i=0; i<htmlMutableArray.count; i++) {
//        NSString *title = [htmlMutableArray objectAtIndex:i][@"name"];
//        
//        if ([title isEqualToString:@"审批"]) {
//            spDic =[htmlMutableArray objectAtIndex:i];
//        }
//        if ([title isEqualToString:@"新e签到"]) {
//            
//            QDDic =[htmlMutableArray objectAtIndex:i];
//        }
//        if ([title isEqualToString:@"邮件"]) {
//            
//            YJDic =[htmlMutableArray objectAtIndex:i];
//            
//        }
//}
    
    switch (senderButton.tag)
    {
            
        case 1000:{
            YJDic = @{@"name":@"新邮件",@"oauthType":@"1",@"url":@"http://mail.oa.colourlife.com:40060/login",@"app_code":@"yj"};
            [self pushH5:YJDic];
            
            
        }
            break;
        case 1001://
        {
            spDic = @{@"name":@"审批",@"oauthType":@"0",@"url":@"http://spsso.colourlife.net/login.aspx",@"app_code":@"sp"};
            [self pushH5:spDic];
            
            
        }
            break;
        case 1002://
        {
            QDDic = @{@"name":@"签到",@"oauthType":@"1",@"url":@"http://eqd.oa.colourlife.com/cailife/sign/main",@"app_code":@"qiandao"};
            [self pushH5:QDDic];
            
            
        }
            break;
            
        case 1003://
        {
            [self cancelOpendoor];
            [self scan];
            
        }
                    break;
            
        default:
            break;
    }
    
    
}
- (void)pushH5:(NSDictionary *)dic{
    NSLog(@"%@",dic);
    NSString *oauthType = [NSString stringWithFormat:@"%@",dic[@"oauthType"]];
    if ([oauthType integerValue] == 0) {
        
        NSString *clientCode = [NSString stringWithFormat:@"%@",dic[@"app_code"]];
        NSString *urloauth1 = [NSString stringWithFormat:@"%@",dic[@"url"]];
        [self getoauth1:urloauth1 andTitle:dic[@"name"]andClientCode:clientCode];
        
    }else{
        NSLog(@"%@",dic);
        NSString *developerCode = [NSString stringWithFormat:@"%@",dic[@"app_code"]];
        NSString *urloauth2 = @"";
        
            urloauth2 = [NSString stringWithFormat:@"%@",dic[@"url"]];
        [self getoauth2:urloauth2 andTitle:dic[@"name"]anddeveloperCode:developerCode];
        
    }
    
    
}

- (void)setUI{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    //首页6个缓存
    
    
    NSString *jixiao  = [userDefaults objectForKey:@"jixiao"];
    NSString *gupiao  = [userDefaults objectForKey:@"gupiao"];
    NSString *mianji  = [userDefaults objectForKey:@"mianji"];
    NSString *xiaoqu  = [userDefaults objectForKey:@"xiaoqu"];
    NSString *fanpiao  = [userDefaults objectForKey:@"fanpiao"];
     NSString *fencheng  = [userDefaults objectForKey:@"fencheng"];

    
    
    
    
    self.view.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245/ 255.0 alpha:1];
    backView = [[DDCoverView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    backView.backgroundColor = [UIColor colorWithRed:44 / 255.0 green:54 / 255.0 blue:64/ 255.0 alpha:1];
    [self.view addSubview:backView];
    
    UIImageView *LOGO = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-(22*132/46))/2, 30, 22*132/46, 22)];
    [LOGO setImage:[UIImage imageNamed:@"logo_cgj"]];
    //[backView addSubview:LOGO];
    
   
    
    
    UIButton *scanButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 25, 25)];
    [backView addSubview:scanButton];
    [scanButton setImage:[UIImage imageNamed:@"code_home"] forState:UIControlStateNormal];
    scanButton.backgroundColor = [UIColor clearColor];
    [scanButton addTarget:self action:@selector(shaerCode) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -35, 30, 25, 25)];
    [backView addSubview:addButton];
    [addButton setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor clearColor];
    [addButton addTarget:self action:@selector(addFeatures) forControlEvents:UIControlEventTouchUpInside];
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(backView), self.view.frame.size.width, 228-50)];
    headerView.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:headerView];
    
    UIButton * barButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -70, 30, 25, 25)];
    [barButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(sousuo) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:barButton];
    
    UIImageView *homeBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, 180)];
    
    [homeBack setImage:[UIImage imageNamed:@"bg_lanse"]];
    [headerView addSubview:homeBack];
    homeBack.userInteractionEnabled = YES;
    
    labelHome = [[UILabel alloc]initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, 20)];
    labelHome.textAlignment = NSTextAlignmentCenter;
    labelHome.font = [UIFont systemFontOfSize:15];
    [labelHome setTextColor:[UIColor whiteColor]];
    [backView addSubview:labelHome];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 1, 1, 176)];
    line.backgroundColor = GRAY_LIGHTS_COLOR_BLAK;
    [homeBack addSubview:line];

    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 1, 1, 176)];
    line1.backgroundColor = GRAY_LIGHTS_COLOR_BLAK;
    [homeBack addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 1)];
    line2.backgroundColor = GRAY_LIGHTS_COLOR_BLAK;
    [homeBack addSubview:line2];
    
//在管面积
    UILabel *area = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH/3, 20)];
    area.text = @"上线面积";
    area.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:1];
    area.backgroundColor = [UIColor clearColor];
    area.textAlignment = NSTextAlignmentLeft;
    [area setFont:[UIFont systemFontOfSize:15]];
    [homeBack addSubview:area];
    
    UILabel *areaUnit = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH/3, 20)];
    areaUnit.text = @"总计:(万m2)";
    areaUnit.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:0.5];
    areaUnit.backgroundColor = [UIColor clearColor];
    areaUnit.textAlignment = NSTextAlignmentLeft;
    [areaUnit setFont:[UIFont systemFontOfSize:11]];
    [homeBack addSubview:areaUnit];
    
    areaLaber = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH/3 -20, 20)];
    
    areaLaber.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:0.7];
    areaLaber.backgroundColor = [UIColor clearColor];
    areaLaber.textAlignment = NSTextAlignmentLeft;
    [areaLaber setFont:[UIFont systemFontOfSize:18]];
    [homeBack addSubview:areaLaber];
    
    Activityarea = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    Activityarea.center = CGPointMake(40, 70);//只能设置中心，不
        if (mianji.length>0) {
        
        
    }else{
        [homeBack addSubview:Activityarea];
    }
    Activityarea.color = [UIColor blackColor]; // 改变圈圈的颜色为红色； iOS5引入
    [Activityarea startAnimating]; // 开始旋转

    
    
    
//集团股票
    UILabel *stock = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 +20, 15, SCREEN_WIDTH/3, 20)];
    stock.text = @"集团股票";
    stock.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:1];
    stock.backgroundColor = [UIColor clearColor];
    stock.textAlignment = NSTextAlignmentLeft;
    [stock setFont:[UIFont systemFontOfSize:15]];
    [homeBack addSubview:stock];
    
    UILabel *stockUnit = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 +20, 40, SCREEN_WIDTH/3, 20)];
    stockUnit.text = @"今日报价";
    stockUnit.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:0.5];
    stockUnit.backgroundColor = [UIColor clearColor];
    stockUnit.textAlignment = NSTextAlignmentLeft;
    [stockUnit setFont:[UIFont systemFontOfSize:11]];
    [homeBack addSubview:stockUnit];
    
    stockLaber = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 +20, 60, SCREEN_WIDTH/3 -20, 20)];
    stockLaber.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:0.7];
    stockLaber.backgroundColor = [UIColor clearColor];
    stockLaber.textAlignment = NSTextAlignmentLeft;
    [stockLaber setFont:[UIFont systemFontOfSize:18]];
    [homeBack addSubview:stockLaber];
    
    Activitystock = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    Activitystock.center = CGPointMake(SCREEN_WIDTH/3 +40, 70);//只能设置中心，不
    
    if (gupiao.length>0) {
        
        
    }else{
       [homeBack addSubview:Activitystock];
    }

    Activitystock.color = [UIColor blackColor]; // 改变圈圈的颜色为红色； iOS5引入
    [Activitystock startAnimating]; // 开始旋转
//我的饭票
    UILabel *myMeal = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2 +20, 15, SCREEN_WIDTH/3, 20)];
    myMeal.text = @"我的饭票";
    myMeal.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:1];
    myMeal.backgroundColor = [UIColor clearColor];
    myMeal.textAlignment = NSTextAlignmentLeft;
    [myMeal setFont:[UIFont systemFontOfSize:15]];
    [homeBack addSubview:myMeal];
    
    UILabel *myMealUnit = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2 +20, 40, SCREEN_WIDTH/3, 20)];
    myMealUnit.text = @"当前余额";
    myMealUnit.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:0.5];
    myMealUnit.backgroundColor = [UIColor clearColor];
    myMealUnit.textAlignment = NSTextAlignmentLeft;
    [myMealUnit setFont:[UIFont systemFontOfSize:11]];
    [homeBack addSubview:myMealUnit];
    
    myMealLaber = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2 +20, 60, SCREEN_WIDTH/3 -20, 20)];
    
    myMealLaber.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:0.7];
    myMealLaber.backgroundColor = [UIColor clearColor];
    myMealLaber.textAlignment = NSTextAlignmentLeft;
    [myMealLaber setFont:[UIFont systemFontOfSize:18]];
    [homeBack addSubview:myMealLaber];
    
    Activitymeal = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    Activitymeal.center = CGPointMake(SCREEN_WIDTH/3*2 +40, 70);//只能设置中心，不
    
       // [homeBack addSubview:Activitymeal];
    
    if (fanpiao.length>0) {
        
        
    }else{
        [homeBack addSubview:Activitymeal];
    }
    
    
    Activitymeal.color = [UIColor blackColor]; // 改变圈圈的颜色为红色； iOS5引入
    [Activitymeal startAnimating]; // 开始旋转
    
//在管小区
    UILabel *district = [[UILabel alloc]initWithFrame:CGRectMake(20, 105, SCREEN_WIDTH/3 -20, 20)];
    district.text = @"上线小区";
    district.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:1];
    district.backgroundColor = [UIColor clearColor];
    district.textAlignment = NSTextAlignmentLeft;
    [district setFont:[UIFont systemFontOfSize:15]];
    [homeBack addSubview:district];
    
    UILabel *districtUnit = [[UILabel alloc]initWithFrame:CGRectMake(20, 130, SCREEN_WIDTH/3, 20)];
    districtUnit.text = @"小区数量";
    districtUnit.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:0.5];
    districtUnit.backgroundColor = [UIColor clearColor];
    districtUnit.textAlignment = NSTextAlignmentLeft;
    [districtUnit setFont:[UIFont systemFontOfSize:11]];
    [homeBack addSubview:districtUnit];
    
    districtlLaber = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, SCREEN_WIDTH/3, 20)];
    
    districtlLaber.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:0.7];
    districtlLaber.backgroundColor = [UIColor clearColor];
    districtlLaber.textAlignment = NSTextAlignmentLeft;
    [districtlLaber setFont:[UIFont systemFontOfSize:18]];
    [homeBack addSubview:districtlLaber];
    
    
    Activitydistrict = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    Activitydistrict.center = CGPointMake(40, 160);//只能设置中心，不
    
    if (xiaoqu.length>0) {
        
        
    }else{
        [homeBack addSubview:Activitydistrict];
    }

    Activitydistrict.color = [UIColor blackColor]; // 改变圈圈的颜色为红色； iOS5引入
    [Activitydistrict startAnimating]; // 开始旋转
    
//绩效评分
    UILabel *score = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 +20, 105, SCREEN_WIDTH/3 -20, 20)];
    score.text = @"绩效评分";
    score.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:1];
    score.backgroundColor = [UIColor clearColor];
    score.textAlignment = NSTextAlignmentLeft;
    [score setFont:[UIFont systemFontOfSize:15]];
    [homeBack addSubview:score];
    
    UILabel *scoreUnit = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 +20, 130, SCREEN_WIDTH/3, 20)];
    scoreUnit.text = @"我的评分";
    scoreUnit.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:0.5];
    scoreUnit.backgroundColor = [UIColor clearColor];
    scoreUnit.textAlignment = NSTextAlignmentLeft;
    [scoreUnit setFont:[UIFont systemFontOfSize:11]];
    [homeBack addSubview:scoreUnit];
    
    scoreLaber = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 +20, 150, SCREEN_WIDTH/3, 20)];
    
    scoreLaber.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:0.7];
    scoreLaber.backgroundColor = [UIColor clearColor];
    scoreLaber.textAlignment = NSTextAlignmentLeft;
    [scoreLaber setFont:[UIFont systemFontOfSize:18]];
    [homeBack addSubview:scoreLaber];
    
    Activityscore = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    Activityscore.center = CGPointMake(SCREEN_WIDTH/3 +40, 160);//只能设置中心，不
    if (jixiao.length>0) {
         Activityscore.color = [UIColor clearColor];
        
    }else{
        [homeBack addSubview:Activityscore];
         Activityscore.color = [UIColor blackColor]; // 改变圈圈的颜色为红色；
    }
    
  
    [Activityscore startAnimating]; // 开始旋转

    
//即时分账
    UILabel *account = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2 +20, 105, SCREEN_WIDTH/3 -20, 20)];
    account.text = @"即时分成";
    account.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:1];
    account.backgroundColor = [UIColor clearColor];
    account.textAlignment = NSTextAlignmentLeft;
    [account setFont:[UIFont systemFontOfSize:15]];
    [homeBack addSubview:account];
    
    UILabel *accountUnit = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2 +20, 130, SCREEN_WIDTH/3, 20)];
    accountUnit.text = @"分成金额";
    accountUnit.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:0.5];
    accountUnit.backgroundColor = [UIColor clearColor];
    accountUnit.textAlignment = NSTextAlignmentLeft;
    [accountUnit setFont:[UIFont systemFontOfSize:11]];
    [homeBack addSubview:accountUnit];
    
    accountLaber = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2 +20, 150, SCREEN_WIDTH/3, 20)];
    //accountLaber.text = @"0.00";
    accountLaber.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:0.7];
    accountLaber.backgroundColor = [UIColor clearColor];
    accountLaber.textAlignment = NSTextAlignmentLeft;
    [accountLaber setFont:[UIFont systemFontOfSize:18]];
    [homeBack addSubview:accountLaber];
    
    ActivityFZ = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    ActivityFZ.center = CGPointMake(SCREEN_WIDTH/3*2 +40, 160);//只能设置中心，不
    if (fencheng.length>0) {
         ActivityFZ.color = [UIColor clearColor]; // 改变圈圈的颜色为红色； iOS5引入
        
    }else{
        [homeBack addSubview:ActivityFZ];
         ActivityFZ.color = [UIColor blackColor]; // 改变圈圈的颜色为红色； iOS5引入
    }

    
   
    [ActivityFZ startAnimating]; // 开始旋转
    








    
    
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    buttonView.backgroundColor = [UIColor clearColor];
    [homeBack addSubview:buttonView];
    
    
    
    for (int i = 0; i < 6; i++)
    {
        
        MCServeButton *serveButton = [[MCServeButton alloc]initWithFrame:CGRectMake((i % 3) * (buttonView.frame.size.width + 3) / 3 - 0.5 * (i % 3), (i / 3) * 90,(buttonView.frame.size.width + 3) / 3, 90)];
        [buttonView addSubview:serveButton];
                [serveButton setTag:i];
        [serveButton addTarget:self action:@selector(clicHomekButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }

    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height-50-64) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor whiteColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    [listTableView setTableHeaderView:headerView];
    
    
    
    //读取数据
    
    NSArray *homlist  = [userDefaults objectForKey:@"homelist"];
    if (homlist.count> 0) {
        [listMutableArray setArray:homlist];
        [self setListArray];
        [self therRefresh];
    }else{
     [self therRefresh];
    }
   
    
    
    if (gupiao.length>0) {
        
        [stockLaber setText:[NSString stringWithFormat:@"%@",gupiao]];
         [self gtstock];//股票
    }else{
        [self gtstock];//股票
    }
    
    if (xiaoqu.length>0 &&mianji.length>0) {
        [districtlLaber setText:[NSString stringWithFormat:@"%@",mianji]];
       
        [areaLaber setText:[NSString stringWithFormat:@"%.2f",[xiaoqu floatValue]/10000]];
        [self getAuthApp];
       //面积和小区
    }else{
        
        [self getAuthApp];//面积和小区
    }
    
    if (jixiao.length>0) {
        //[myMealLaber setText:[NSString stringWithFormat:@"%.2f",[jixiao floatValue]]];
        
        [scoreLaber setText:[NSString stringWithFormat:@"%.2f",[jixiao floatValue]]];
        [self gtsscore];//绩效和饭票
    }else{
        
        [self gtsscore];//绩效和饭票
    }
    




}
#pragma mark -获取资源2.0授权
- (void)getAuthApp{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *corp = [defaults objectForKey:@"corpId"];
    NSString *ts = [defaults objectForKey:@"ts"];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:@"33f09c7ca5e6491fbcdfd363cf58851e" forKey:@"app_uuid"];//app分配id
    [dic setValue:corp forKey:@"corp_uuid"];//租户ID
    
    NSString *singe = [NSString stringWithFormat:@"%@%@%@",@"33f09c7ca5e6491fbcdfd363cf58851e",ts,@"48a8c06966fb40e3b1c55c95692be1d8"];
    
    NSString *  signature = [MyMD5 md5:singe];//签名=( APPID +ts +appSecret)md5
    [dic setValue:signature forKey:@"signature"];
    [dic setValue:ts forKey:@"timestamp"];//时间戳
    NSLog(@"%@",dic);
    
       
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/authms/auth/app" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 &&[dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
        {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dicDictionary[@"content"] objectForKey:@"accessToken"] forKey:@"orgToken"];
            
            [defaults synchronize];
             [self gtsArea];//获取资源数据
            [self getOrgidType];//获取当前人的组织架构类型
            
            
            
            
        }else{
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    
    
    
}
#pragma mark-获取组织架构详情类型
-(void)getOrgidType{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *orgToken = [defaults objectForKey:@"orgToken"];
    NSString *corpID = [defaults objectForKey:@"corpId"];
    NSString *oid =  [[MCPublicDataSingleton sharePublicDataSingleton].userDictionary objectForKey:@"orgId"];
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:oid forKey:@"orgUuid"];
    [sendDictionary setValue:orgToken forKey:@"token"];
    [sendDictionary setValue:corpID forKey:@"corpId"];
    
    
    
    
    
    NSLog(@"%@",sendDictionary);
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/orgms/org" parameters:sendDictionary success:^(id responseObject) {
        NSDictionary *dicDictionary = responseObject;
       
       
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            id orgType =[[dicDictionary objectForKey:@"content"] objectForKey:@"orgType"] ;
           
            NSString *type = @"";
          
            if ([orgType isEqual:[NSNull null]]) {
                type = [NSString stringWithFormat:@"小区"];
               
            }else{
            
                 type = [NSString stringWithFormat:@"%@",[[dicDictionary objectForKey:@"content"] objectForKey:@"orgType"]];
            }
           
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:type forKey:@"orgtype"];
            
            [defaults synchronize];

            
            
        }else{
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    


}
- (void)setListArray{
    [listOneMutableArray removeAllObjects];
    [listMutableArray addObjectsFromArray:listGDMutableArray];
    
    
    NSMutableArray *dateKeys = [NSMutableArray array];
    for (NSDictionary *dic in listMutableArray) {
        NSString *dateKey = dic[@"client_code"];
        if (![dateKeys containsObject:dateKey]) {
            [dateKeys addObject:dateKey];
        }
    }
    
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < dateKeys.count; i++) {
        
        NSMutableArray *values = [NSMutableArray array];
        NSString *key = (NSString *)dateKeys[i];
        for (NSDictionary *dic in listMutableArray) {
            
            if ([dic[@"client_code"] isEqualToString: key]) {
                [values addObject:dic];
            }
        }
        
        [mutableDic setValue:[values objectAtIndex:0] forKey:key];
    }
    
    listOneMutableArray = [NSMutableArray arrayWithArray:mutableDic.allValues];
    for (int i=0; i<listOneMutableArray.count-1; i++){
        
        for (int j=i+1; j<listOneMutableArray.count; j++) {
            
            if ([[self ConvertStrToTime:[[listOneMutableArray objectAtIndex:i]objectForKey:@"homePushTime"] ] longLongValue]<[[self ConvertStrToTime:[[listOneMutableArray objectAtIndex:j]objectForKey:@"homePushTime"] ] longLongValue]) {
                
                NSLog(@"%@",[listOneMutableArray class]);
                NSMutableDictionary *TempDic=[listOneMutableArray objectAtIndex:i];
                NSLog(@"%@",TempDic);
                NSLog(@"%@",listOneMutableArray[j]);
                //[listOneMutableArray replaceObjectAtIndex:i withObject:TempDic];
                listOneMutableArray[i]=[listOneMutableArray objectAtIndex:j];
                //
                listOneMutableArray[j] = TempDic;
                
            }
            
        }
        
    }
    
    
   
    
    
    [listTableView reloadData];
    //[self setRedView];
    [listTableView.mj_header endRefreshing];


}
- (void)clicHomekButton:(UIButton *)button{

    switch (button.tag) {
        case 0:
             {
                 
                 MCDataKBViewController *dataVC = [[MCDataKBViewController alloc]init];
                 dataVC.dic = self.areaDic;
                 dataVC.name = self.flamname;
                 dataVC.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:dataVC animated:YES];
             
             }
            break;
        case 1:
        {
            NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
            
            [nsdf2 setDateStyle:NSDateFormatterShortStyle];
            
            [nsdf2 setDateFormat:@"yyyyMMddHHmmssSSSS"];
            
            NSString *t2=[nsdf2 stringFromDate:[NSDate date]];
            
            ;nsdf2=nil;
            
            int timestamp = arc4random() % 100000;
            
            NSString *rand=[NSString stringWithFormat:@"%@%d",t2,timestamp];

        NSString *url = [NSString stringWithFormat:@"http://image.sinajs.cn/newchart/hk_stock/min/01778.gif?%@",rand];
        MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:url]  titleString:@"股票"];
            webViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
            
        }
            break;
        case 2:
        {
            MCFanPiaoViewController *fpVC = [[MCFanPiaoViewController alloc]init];
            fpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fpVC animated:YES];
        }
            break;
        case 3:
        {
            MCDataKBViewController *dataVC = [[MCDataKBViewController alloc]init];
            dataVC.dic = self.areaDic;
            dataVC.name = self.flamname;
            dataVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dataVC animated:YES];
        }
            break;
        case 4:
        {
              MCFanPiaoViewController *fpVC = [[MCFanPiaoViewController alloc]init];
            fpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fpVC animated:YES];
        }
            break;
        case 5:
        {
            MCAccountViewController *fzVC = [[MCAccountViewController alloc]init];
        
            fzVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fzVC animated:YES];
        
        
        }
            break;
            
        default:
            break;
    }



}
//搜索

-(void)sousuo{

    MCsousuoViewController *ssVC = [[MCsousuoViewController alloc]init];
    ssVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ssVC animated:YES];




}
-(void)shaerCode{
    
    MCMycodeViewController *codevc = [[MCMycodeViewController alloc]init];
    codevc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:codevc animated:YES];
//    MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:@"http://iceapi.colourlife.com:8081/v1/caiguanjia/qrcode"]  titleString:@"我的二维码"];
//    webViewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:webViewController animated:YES];

}
//弹框弹出功能
-(void)addFeatures{
    
    if (_isOpen == 0) {
        _isOpen = 1;
        shopButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        shopButton.backgroundColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:0.3];
        [self.tabBarController.view addSubview:shopButton];
        [shopButton addTarget:self action:@selector(removeButton) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *backView1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2 -5, 5, SCREEN_WIDTH/3, SCREEN_WIDTH/3 *363/261)];
        //backView.backgroundColor = [UIColor whiteColor];
        [backView1 setImage:[UIImage imageNamed:@"tanchu1"]];
        [shopButton addSubview:backView1];
        backView1.userInteractionEnabled = YES;
        
//        if (self.isShowRed == 1) {
//            UIImageView *redView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3-30, (backView.frame.size.height/2  - 8)/2 +backView.frame.size.height/2, 8, 8)];
//            [redView setImage:[UIImage imageNamed:@"yuan"]];
//            [backView addSubview:redView];
//            
//        }
        
        
        UIButton *mailButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, backView1.frame.size.width, backView1.frame.size.height/4)];
        mailButton.tag = 1000;
        mailButton.backgroundColor = [UIColor clearColor];
        [backView1 addSubview:mailButton];
        
        [mailButton addTarget:self action:@selector(clickTWOButton:)  forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *ApprovalButton = [[UIButton alloc]initWithFrame:CGRectMake(0, backView1.frame.size.height/4, backView1.frame.size.height, backView1.frame.size.height/4)];
        [backView1 addSubview:ApprovalButton];
        ApprovalButton.tag = 1001;
        [ApprovalButton addTarget:self action:@selector(clickTWOButton:)  forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *CheckButton = [[UIButton alloc]initWithFrame:CGRectMake(0, backView1.frame.size.height/4*2, backView1.frame.size.width, backView1.frame.size.height/4)];
        [backView1 addSubview:CheckButton];
        CheckButton.tag = 1002;
        [CheckButton addTarget:self action:@selector(clickTWOButton:)  forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *scanInlButton = [[UIButton alloc]initWithFrame:CGRectMake(0, backView1.frame.size.height/4*3, backView1.frame.size.width, backView1.frame.size.height/2)];
        [backView1 addSubview:scanInlButton];
        scanInlButton.tag = 1003;
        [scanInlButton addTarget:self action:@selector(clickTWOButton:)  forControlEvents:UIControlEventTouchUpInside];
        
        
    }else{
        
        [self cancelOpendoor];
        
    }

    
    
    
}

- (void)cancelOpendoor{
    
    
    self.isOpen = 0;
    [shopButton removeFromSuperview];
    
    
}
-(void)removeButton{
    self.isOpen = 0;
    [shopButton removeFromSuperview];
    
}

//扫一扫功能
- (void)scan{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized)
        
    {
        
        NSLog(@"允许状态");
        
    }
    
    else if (authStatus == AVAuthorizationStatusDenied)
        
    {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请在iPhone的“设置-隐私-相机”选项中，允许彩管家访问你的相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
        
        
    }
//    if ([self checkIfCameraAvailable]) {
        HCScanQRViewController *scanner = [[HCScanQRViewController alloc] init];
        //scanner.delegate = self.delegate;
    
    [scanner successfulGetQRCodeInfo:^(NSString *QRCodeInfo) {
    
        NSLog(@"二维码扫到的结果：%@",QRCodeInfo);
        if ([QRCodeInfo containsString:@"m.colourlife.tw/Meet"] ||[QRCodeInfo containsString:@"m.colourlife.com/Meet"]) {
            
            NSDictionary *sendDict = @{
                                       @"app":@"cgj",
                                                                              };
            
            [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/code/app" parameters:sendDict success:^(id responseObject) {
                
                NSDictionary *dicDictionary = responseObject;
                NSLog(@"%@",dicDictionary);
                if ([dicDictionary[@"code"] integerValue] == 0 )
                {
                    NSString *apptype = (NSString *)[dicDictionary objectForKey:@"content"];
                    
                    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                    NSString *username = [defaults objectForKey:@"userName"];
                    
                    NSString *mobile = (NSString*)[[MCPublicDataSingleton  sharePublicDataSingleton].userDictionary objectForKey:@"mobile"];
                    
                    
                    NSString *requestStr = @"";
                    if (mobile == nil) {
                        mobile = @"";
                    }
                    if ([QRCodeInfo containsString:@"?"]) {
                        requestStr=[NSString stringWithFormat:@"%@&from_type=%@&mobile=%@&oa_username=%@",QRCodeInfo,apptype, mobile, username];
                    }
                    else{
                        requestStr=[NSString stringWithFormat:@"%@?from_type=%@&mobile=%@&oa_username=%@",QRCodeInfo,apptype, mobile, username];
                    }
                    
                    MCWebViewController *weVC = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:requestStr] titleString:@"签到"];
                    [self.navigationController pushViewController:weVC animated:YES];

                }
                
                
                
                
            } failure:^(NSError *error) {
                
                
                
                
            }];
            
            

        }else if([QRCodeInfo containsString:@"http://dr.ices.io"]){
            NSString*code = [QRCodeInfo stringByReplacingOccurrencesOfString:@"http://dr.ices.io/"withString:@""];
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [defaults objectForKey:@"userInfo"];
            NSString *uuid = [dic objectForKey:@"uuid"];
            NSString *url = [NSString stringWithFormat:@"http://www-czytest.colourlife.com/qrcode/active?access_token=%@&code=%@",uuid,code];
            
            MCWebViewController *weVC = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:url] titleString:@""];
            [self.navigationController pushViewController:weVC animated:YES];
            
            
        
        }else{
        
            MCWebViewController *weVC = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:QRCodeInfo] titleString:@"扫一扫"];
            [self.navigationController pushViewController:weVC animated:YES];
        }
    
    }];
         scanner.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scanner animated:NO];
        //            [self presentViewController:scanner animated:NO completion:nil];//动画设置NO
        
   // }


//    MCScanViewController *scanVC = [[MCScanViewController alloc]init];
//    scanVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:scanVC animated:YES];




}

/**
 *  检查是否打开相机权限
 *
 *  @return 是否打开
 */
-(BOOL)checkIfCameraAvailable{
    
    if (GT_IOS7) {
        
        NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
      
        // This status is normally not visible—the AVCaptureDevice class methods for discovering devices do not return devices the user is restricted from accessing.
        if(authStatus ==AVAuthorizationStatusRestricted){
            NSLog(@"Restricted");
        }else if(authStatus == AVAuthorizationStatusDenied){
            // The user has explicitly denied permission for media capture.
            NSLog(@"Denied");     //应该是这个，如果不允许的话
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请在设备的 设置-隐私-相机 中允许访问相机。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            return NO;
        }
        else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问
            // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
            NSLog(@"Authorized");
            
            return YES;
            
        }else if(authStatus == AVAuthorizationStatusNotDetermined){
            // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if(granted){//点击允许访问时调用
                    //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                    NSLog(@"Granted access to %@", mediaType);
                }
                else {
                    NSLog(@"Not granted access to %@", mediaType);
                }
                
            }];
            
            return YES;
            
            
        }else {
            NSLog(@"Unknown authorization status");
        }
        
    }
    
    return NO;
    
}



- (void)getoauth1:(NSString *)url andTitle:(NSString *)name andClientCode:(NSString *)clientCode{
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *passWord = [defaults objectForKey:@"passWordMI"];//根据键值取出name
    
    [sendDictionary setValue:username forKey:@"username"];
    [sendDictionary setValue:passWord forKey:@"password"];
    [sendDictionary setValue:clientCode forKey:@"clientCode"];
    
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
                NSString *URLstring = @"";
                NSDictionary *dic = dicDictionary[@"content"];
                if ([url rangeOfString:@"?"].location != NSNotFound) {
                    URLstring = [NSString stringWithFormat:@"%@&openID=%@&accessToken=%@",url,dic[@"openID"],dic[@"accessToken"]];
                }else{
                    
                    URLstring = [NSString stringWithFormat:@"%@?openID=%@&accessToken=%@",url,dic[@"openID"],dic[@"accessToken"]];
                    
                }

               
                self.isOpen = 0;
                [shopButton removeFromSuperview];
                
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring]  titleString:name];
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
                
                
                
            }
            
            return ;
            
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"验证失败"];
        
        }
       
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
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
    [sendDictionary setValue:developerCode forKey:@"developerCode"];
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
                 NSString *URLstring = @"";
                 NSDictionary *dic = dicDictionary[@"content"];
                if ([url rangeOfString:@"?"].location != NSNotFound) {
                    URLstring = [NSString stringWithFormat:@"%@&username=%@&access_token=%@",url,username,dic[@"access_token"]];
                    NSLog(@"%@",URLstring);
                }else{
                    
                    URLstring = [NSString stringWithFormat:@"%@?username=%@&access_token=%@",url,username,dic[@"access_token"]];
                    
                }
                
               
                NSLog(@"%@",name);
                self.isOpen = 0;
                [shopButton removeFromSuperview];
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring]  titleString:name];
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
                
                
            }
            
            return ;
            
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
}

#pragma mark - XWXAuthDelegate
- (void)authWithOAuthStatus:(XWXOAuthStatus)status result:(XWXAuthResult *)result {
    
    //status 不为 XWXOAuthStatusSuccess ，则 result 等于 nil
    NSLog(@"%lu,%@", (unsigned long)status,result);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    bgView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245/ 255.0 alpha:1];
    return bgView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UILabel *bgView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    bgView.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    bgView.textAlignment = NSTextAlignmentCenter;
    bgView.font = [UIFont systemFontOfSize:14];
    bgView.text = @"--把社区服务做到家--";
    
    return bgView;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
   
    return listOneMutableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *indentifier = @"cell";
    MCHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCHomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
       if (listOneMutableArray.count>0) {
        NSDictionary *dataDictionary = [listOneMutableArray objectAtIndex:indexPath.row];
        
        NSLog(@"%@",dataDictionary);
        [cell.titleLabel setText:[NSString stringWithFormat:@"%@(%@)", [dataDictionary objectForKey:@"comefrom"],dataDictionary[@"owner_name"]]];
        
        [cell.contentLabel setText:[NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"title"]]];
        cell.noReadImageView.hidden = nil;
        NSString *notread = [NSString stringWithFormat:@"%@",dataDictionary[@"notread"]];
        if ([notread integerValue] > 0 && notread != NULL) {
            NSLog(@"%@",dataDictionary);
            cell.noReadImageView.hidden = NO;
            
            //
        }else{
        
            cell.noReadImageView.hidden = YES;

        }
           int sum = 0;
           for (int i= 0; i<listOneMutableArray.count; i++) {
               
               sum += [[[listOneMutableArray objectAtIndex:i] objectForKey:@"notread"] intValue];
           }
           
           if (sum>0) {
               [self.tabBarController.tabBar showBadgeOnItmIndex:0];
           }else{
               [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
           }

        cell.numberLabel.hidden = YES;
        //首先创建格式化对象
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //然后创建日期对象
        
        NSDate *date1 = [dateFormatter dateFromString:[dataDictionary objectForKey:@"homePushTime"]];
        
        NSDate *date = [NSDate date];
        
        //计算时间间隔（单位是秒）
        
        NSTimeInterval time = [date1 timeIntervalSinceDate:date];
        
        //计算天数、时、分、秒
        
        int days = ((int)time)/(3600*24);
        
        int hours = ((int)time)%(3600*24)/3600;
        
        int minutes = ((int)time)%(3600*24)%3600/60;
        
        int seconds = ((int)time)%(3600*24)%3600%60;
        
        NSString *dateContent = [[NSString alloc] initWithFormat:@"仅剩%i天%i小时%i分%i秒",days,hours,minutes,seconds];
        NSLog(@"%@",dateContent);
        
        if (days == 0 && hours == 0 && minutes <=10) {
            
            [cell.dateLabel setText:@"刚刚"];
            
            
            
            
        }else if (days == 0  ){
            
            NSString *dateString2 = [dataDictionary objectForKey:@"homePushTime"];
            
            [cell.dateLabel setText:[dateString2 substringFromIndex:10]];
            
            
        }else {
            NSLog(@"%d",days);
            if (days<-2000) {
                [cell.dateLabel setText:@""];
            }else{
                NSString *dateString1 = [dataDictionary objectForKey:@"homePushTime"];
                
                [cell.dateLabel setText:[dateString1 substringToIndex:10]];
                
            }
            
            
            
        }
        
        
        
        
        if ([dataDictionary[@"client_code"] isEqualToString:@"ggtz"]) {
            [cell.iconImageView setImage:[UIImage imageNamed:@"通知公告"]];
        }else
        if ([dataDictionary[@"client_code"] isEqualToString:@"yj"]) {
                [cell.iconImageView setImage:[UIImage imageNamed:@"邮件"]];
            }
        else
        if ([dataDictionary[@"client_code"] isEqualToString:@"sp"]) {
                    [cell.iconImageView setImage:[UIImage imageNamed:@"审批"]];
                }
        else
            if ([dataDictionary[@"client_code"] isEqualToString:@"case"]) {
                        [cell.iconImageView setImage:[UIImage imageNamed:@"蜜蜂协同"]];
                    }
                    else{
                        
                        //[cell.iconImageView setImage:[UIImage imageNamed:@"通知公告"]];
                        
                        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataDictionary[@"ICON"]] placeholderImage:[UIImage imageNamed:@"moren"]];
                    }
        
        
        
       
//        [cell.numberLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"notread"]]];
        

    }
    
     
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if (listOneMutableArray.count>0) {
        NSDictionary *dataDictionary = [listOneMutableArray objectAtIndex:indexPath.row];
        NSLog(@"%@",dataDictionary);
        
        
        
        NSString *code = [NSString stringWithFormat:@"%@",dataDictionary[@"client_code"]];
        
        MCMessageListViewController *listVC = [[MCMessageListViewController alloc]init];
        listVC.code = code;
        listVC.title = dataDictionary[@"comefrom"];
        listVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listVC animated:YES];
       
        [self changgeRedNumber:code andRow:indexPath.row];
        

    }
    
    
   


}
- (void)changgeRedNumber:(NSString *)code andRow:(NSInteger)row{
    
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary:[listOneMutableArray objectAtIndex:row]] ;
    
    [dic setValue:@"0" forKey:@"notread"];
    
    [listOneMutableArray replaceObjectAtIndex:row withObject:dic];
    [listTableView reloadData];
    int sum = 0;
    for (int i= 0; i<listOneMutableArray.count; i++) {
        
        sum += [[[listOneMutableArray objectAtIndex:i] objectForKey:@"notread"] intValue];
    }
    
    if (sum>0) {
        [self.tabBarController.tabBar showBadgeOnItmIndex:0];
    }else{
        [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
    }

     
    
    

}
- (void)loadUserData{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    NSString *username = [defaults objectForKey:@"userName"];
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    [sendDict setObject:uid forKey:@"uid"];
    //[sendDict setObject:username forKey:@"username"];
    NSLog(@"%@",sendDict);
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/account" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                [MCPublicDataSingleton  sharePublicDataSingleton].userDictionary = dicDictionary[@"content"];
                [defaults setObject:dicDictionary[@"content"] forKey:@"userInfo"];
                [defaults synchronize];
                [self setUserHome];
              
                
               
                
            }
            
        }
        
       
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
        
    }];


}

- (void)setUserHome{
   
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSDictionary *dics = [defaults objectForKey:@"userInfo"];
    NSLog(@"%@",dics);
     self.flamname = dics[@"familyName"];
    
    labelHome.text = [NSString stringWithFormat:@"%@",dics[@"familyName"]];
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
    CGSize size=[labelHome.text sizeWithAttributes:attrs];
    
    imageHome = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2 -size.width/2) -20, 36, 15, 15)];
    [imageHome setImage:[UIImage imageNamed:@"coordinates_fillmap"]];
    [backView addSubview:imageHome];

  


}
-(void)getKeyData{

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];
    NSString *password = [defaults objectForKey:@"passWordMI"];
    
    NSLog(@"%@",username);
    NSDictionary *sendDict = @{
                               @"username":username,
                               @"password":password
                               };
    NSLog(@"%@",sendDict);
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/czywg/employee/login" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = dicDictionary[@"content"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:dic[@"key"] forKey:@"key"];
                [defaults setObject:dic[@"secret"] forKey:@"secret"];
                [self getBalance];
                [self getHongbao];
            }
            
        }else{
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
        
    }];



}


- (void)getBalance{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    NSDictionary *sendDict = @{
                               
                               @"key":key,
                               @"secret":secret
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/getBalance" parameters:sendDict success:^(id responseObject) {
        [Activitymeal stopAnimating]; // 结束旋转
        [Activitymeal setHidesWhenStopped:YES]; //当旋转结束时隐藏
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
              
                
            [myMealLaber setText:[NSString stringWithFormat:@"%.2f",[dicDictionary[@"content"][@"balance"] floatValue]]];
                [MCPublicDataSingleton sharePublicDataSingleton].fanpiao =myMealLaber.text;
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                [userDefaults setObject:[NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"balance"]] forKey:@"fanpiao"];
                [userDefaults synchronize];
                

                
            }
            
        }else{
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        NSString *str = [NSString stringWithFormat:@"%@",error];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更新", nil];
        alert.tag = 1001;
        [alert show];

        
        
    }];
    
    
    
    
}

- (void)getHongbao{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    NSDictionary *sendDict = @{
                               
                               @"key":key,
                               @"secret":secret
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/getHBUserList" parameters:sendDict success:^(id responseObject) {
       
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                NSString *string = [NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"fee"]];
                [MCPublicDataSingleton sharePublicDataSingleton].honbao = string;
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                [userDefaults setObject:[NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"fee"]] forKey:@"hongbao"];
                [userDefaults synchronize];
                
                
            }
            
        }else{
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    
}



- (void)loadMassage{
    
    //[listOneMutableArray removeAllObjects];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];
     NSString *corpID = [defaults objectForKey:@"corpId"];
    
    NSDictionary *sendDict = @{
                               @"username":username,
                               @"corp_id":corpID
                               };
    NSLog(@"%@",sendDict);
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/push2/homepush/gethomePushBybox" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                    
                [listMutableArray setArray:dicDictionary[@"content"][@"data"]];
                
                NSArray *array = dicDictionary[@"content"][@"data"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                //存数据，不需要设置路劲，NSUserDefaults将数据保存在preferences目录下
                NSArray *array1 = [NSArray removeNullFromArray:array];
                [userDefaults setObject:array1 forKey:@"homelist"];
                [userDefaults synchronize];
                
                    [self setListArray];
                    [listTableView reloadData];
                    //[self setRedView];
                    [listTableView.mj_header endRefreshing];
                    
                
                
                          }
            
        }else{
            
            [listMutableArray removeAllObjects];
            
            [self setListArray];
            
        
        }
        
        
        
        
    } failure:^(NSError *error) {
        
         [listTableView.mj_header endRefreshing];
        NSLog(@"****%@", error);
        
        
        
        
    }];



    
}
-(NSString *)ConvertStrToTime:(NSString *)timeStr
//timeStr毫秒字段
{
    
    //首先创建格式化对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //然后创建日期对象
    
    NSDate *date1 = [dateFormatter dateFromString:timeStr];
    
    NSDate *date = [NSDate date];
    
    //计算时间间隔（单位是秒）
    
    NSTimeInterval time = [date1 timeIntervalSinceDate:date];
    
    //计算天数、时、分、秒
    
    int days = ((int)time)/(3600*24);
    
    int hours = ((int)time)%(3600*24)/3600;
    
    int minutes = ((int)time)%(3600*24)%3600/60;
    
   
    int num = +(days)*60*60 + +(hours)*60 + minutes;
    
    NSString *dateContent = [[NSString alloc] initWithFormat:@"%d",num];
    NSLog(@"%@",dateContent);
    
    return dateContent;
    
}


- (void)setRedView{

    if (listMutableArray.count>0)
    {
        NSMutableArray *readArray = [NSMutableArray array];
        for (int i = 0; i<listMutableArray.count; i++)
        {
            
            
            if ([[listMutableArray objectAtIndex:i][@"notread"] integerValue] >0)
            {
                
                [readArray addObject:[listMutableArray objectAtIndex:i]];
                
                
            
            }
            
            if (readArray.count>0) {
                UIImageView *dotImage = [[UIImageView alloc]init];
                
                [dotImage setBackgroundColor:[UIColor redColor]];
                
                
                CGRect tabFrame =self.navigationController.tabBarController.tabBar.frame;
                
                CGFloat x =ceilf(0.15 * tabFrame.size.width);
                
                CGFloat y =ceilf(0.1 * tabFrame.size.height);
                
                dotImage.frame =CGRectMake(x, y, 6,6);
                [dotImage setClipsToBounds:YES];
                [dotImage.layer setCornerRadius:dotImage.frame.size.width/2];
                
                [self.navigationController.tabBarController.tabBar addSubview:dotImage];
                

            }else{
            
                UIView *dotImage = [[UIView alloc]init];
                
                [dotImage setBackgroundColor:[UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1]  ];
                
                
                CGRect tabFrame =self.navigationController.tabBarController.tabBar.frame;
                
                CGFloat x =ceilf(0 * tabFrame.size.width);
                
                CGFloat y =ceilf(0 * tabFrame.size.height);
                
                dotImage.frame =CGRectMake(x, y, 6,6);
                [dotImage.layer setCornerRadius:dotImage.frame.size.width/2];
                [dotImage.layer setMasksToBounds:YES];
                [self.navigationController.tabBarController.tabBar addSubview:dotImage];
            
            }
        }
    }
    


}
- (void)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    NSLog(@"手机的IP是：%@", address);
    _IPString = address;
    
    
}
- (void)VersionUpdate{
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSString *Version = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [sendDictionary setValue:@"ios" forKey:@"type"];
    [sendDictionary setValue:Version forKey:@"version"];
    
    NSLog(@"%@",sendDictionary);
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/czywg/version" parameters:sendDictionary success:^(id responseObject)
     {
         
         NSDictionary *dicDictionary = responseObject;
         NSLog(@"---%@",dicDictionary);
         
         if ([dicDictionary[@"code"] integerValue] == 0 )
         {
             
             NSString *result = dicDictionary[@"content"][@"result"];
             _douwnUrl = dicDictionary[@"content"][@"info"][0][@"download_url"];
             
           
             NSString *string = @"";
             
             
             
             if ([result integerValue] ==1) {
                 
                 
                 

             }
             if ([result integerValue] ==-1) {
                  NSArray *array = dicDictionary[@"content"][@"info"][0][@"func"];
                 if (array.count>=1) {
                     string = [array componentsJoinedByString:@","];
                 }

                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"检查更新:彩管家" message:string delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:nil, nil];
                 alert.tag = 1002;
                 [alert show];

                 
             }
             if ([result integerValue] ==0 ) {
                 NSArray *array = dicDictionary[@"content"][@"info"][0][@"func"];
                 if (array.count>=1) {
                     string = [array componentsJoinedByString:@","];
                 }
                 NSString *titelStr = @"检查更新:彩管家";
                 NSString *messageStr = @"发现新版本是否更新";
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titelStr message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更新", nil];
                 alert.tag = 1001;
                 [alert show];
                 
             }

             
             
         }
         
         
         
     } failure:^(NSError *error) {
         
         NSLog(@"****%@", error);
         
     }];

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag - 1000 == 1)
    {
        if (buttonIndex ==1)
        {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_douwnUrl]];
        }
        
    }
    if (alertView.tag - 1000 == 2)
    {
       
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_douwnUrl]];
        
    }

    
    
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
