//
//  MCGeneralHomeViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/7/21.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCGeneralHomeViewController.h"
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
#import "MCMessageListViewController.h"
#import "MCMycodeViewController.h"
@interface MCGeneralHomeViewController ()
@property(nonatomic,strong)NSString *IPString;
@property(nonatomic,strong)NSString *douwnUrl;

@end

@implementation MCGeneralHomeViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        htmlMutableArray = [NSMutableArray array];
        officeMutableArray = [NSMutableArray array];
        homeButtonMutableArray = [NSMutableArray array];
        
        
               
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
    if ([MCPublicDataSingleton sharePublicDataSingleton].isRequestVersion == 0) {
        [self VersionUpdate];
    }
    
    [listGDMutableArray addObject:@{@"imageName":@"通知公告",@"title":@"暂无新消息",@"comefrom":@"公告通知",@"owner_name":@"暂无",@"client_code":@"ggtz",@"modify_time":@"2000-06-10 17:57:11"}];
    [listGDMutableArray addObject:@{@"imageName":@"邮件",@"title":@"暂无新消息",@"comefrom":@"新邮件",@"owner_name":@"暂无",@"client_code":@"yj",@"modify_time":@"2000-06-10 17:57:11"}];
    [listGDMutableArray addObject:@{@"imageName":@"审批",@"title":@"暂无新消息",@"comefrom":@"蜜蜂协同",@"owner_name":@"暂无",@"client_code":@"case",@"modify_time":@"2000-06-10 17:57:11"}];
    [listGDMutableArray addObject:@{@"imageName":@"蜜蜂协同",@"title":@"暂无新消息",@"comefrom":@"审批",@"owner_name":@"暂无",@"client_code":@"sp",@"modify_time":@"2000-06-10 17:57:11"}];
    

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    
    
    
    
    //[self loadHtmlString];
    
    //[self getManagementApplicationList];
    
    self.buttonMutableArray = [NSMutableArray array];
    [self.buttonMutableArray addObject:@{@"imageName":@"新邮件t",@"title":@"邮件"}];
     [self.buttonMutableArray addObject:@{@"imageName":@"审批t",@"title":@"审批"}];
     [self.buttonMutableArray addObject:@{@"imageName":@"蜜蜂协同t",@"title":@"蜜蜂协同"}];
    [self.buttonMutableArray addObject:@{@"imageName":@"新e签到t",@"title":@"新e签到"}];
   
   
    
    
    
    
    
    self.navigationController.delegate = self;
    [self setUI];
    [self getOfficeApplicationList];
    [self therRefresh];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [defaults objectForKey:@"userInfo"];
    

    if (userDic) {
        [self setUserData];
    }else{
        
        [self loadUserData];
    }
    // Do any additional setup after loading the view.
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
        [SVProgressHUD dismiss];
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
    
    for (int i=0; i<officeMutableArray.count; i++) {
        NSString *title = [officeMutableArray objectAtIndex:i][@"name"];
        if ([title isEqualToString:@"邮件"]||[title isEqualToString:@"审批"]||[title isEqualToString:@"蜜蜂协同"]||[title isEqualToString:@"新e签到"]) {
            [homeButtonMutableArray addObject:[officeMutableArray objectAtIndex:i]];
        }
        if ([title isEqualToString:@"新邮件"]) {
            [MCPublicDataSingleton sharePublicDataSingleton].MailDictionary =[officeMutableArray objectAtIndex:i];
        }
    }
    
    
}

-(void)shaerCode{
    
    MCMycodeViewController *codevc = [[MCMycodeViewController alloc]init];
    codevc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:codevc animated:YES];
    //    MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:@"http://iceapi.colourlife.com:8081/v1/caiguanjia/qrcode"]  titleString:@"我的二维码"];
    //    webViewController.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:webViewController animated:YES];
    
}

- (void)setUI{
    
    backView = [[DDCoverView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 206 + 100)];
    backView.backgroundColor = [UIColor whiteColor];
    
    headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 206)];
    
    [headerView setImage:[UIImage imageNamed:@"beijing_home"]];
    [backView addSubview:headerView];
    headerView.userInteractionEnabled = YES;
    //headerView.backgroundColor = DARK_COLOER_ZZ;
    
    
    UIImageView *LOGO = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 20 *65/29, 20)];
    [LOGO setImage:[UIImage imageNamed:@"nav_icon_logo_normal"]];
    //[headerView addSubview:LOGO];
    
    UILabel *welcome = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 20)];
    welcome.text = @"欢迎您";
    welcome.textColor = [UIColor whiteColor];
    welcome.backgroundColor = [UIColor clearColor];
    welcome.textAlignment = NSTextAlignmentCenter;
    [welcome setFont:[UIFont systemFontOfSize:18]];
    [headerView addSubview:welcome];
    
    
    UIButton *scanButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 30, 20, 20)];
    [headerView addSubview:scanButton];
    [scanButton setImage:[UIImage imageNamed:@"code_home"] forState:UIControlStateNormal];
    scanButton.backgroundColor = [UIColor clearColor];
    [scanButton addTarget:self action:@selector(shaerCode) forControlEvents:UIControlEventTouchUpInside];
    
    
    photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70)/2, BOTTOM_Y(welcome)+20, 70, 70)];
    [headerView addSubview:photoImageView];
    
    
    //[photoImageView.layer setCornerRadius:5];
    [photoImageView setClipsToBounds:YES];
    [photoImageView.layer setCornerRadius:photoImageView.frame.size.width / 2];
    
    userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(photoImageView)+10, SCREEN_WIDTH, 20)];
    [headerView addSubview:userNameLabel];
    [userNameLabel setBackgroundColor:[UIColor clearColor]];
    [userNameLabel setTextColor:[UIColor whiteColor]];
    [userNameLabel setTextAlignment:NSTextAlignmentCenter];
    [userNameLabel setFont:[UIFont systemFontOfSize:16]];
    
    
    //    officeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(userNameLabel)+10, SCREEN_WIDTH, 20)];
    //    [headerView addSubview:officeLabel];
    //    [officeLabel setBackgroundColor:[UIColor clearColor]];
    //    officeLabel.textAlignment = NSTextAlignmentCenter;
    //    [officeLabel setTextColor:[UIColor whiteColor]];
    //    [officeLabel setFont:[UIFont systemFontOfSize:13]];
    
    workNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(userNameLabel)+5, SCREEN_WIDTH, 20)];
    [headerView addSubview:workNumberLabel];
    workNumberLabel.textAlignment = NSTextAlignmentCenter;
    [workNumberLabel setBackgroundColor:[UIColor clearColor]];
    [workNumberLabel setTextColor: GRAY_COLOR_BACK_ZZ];
    [workNumberLabel setFont:[UIFont systemFontOfSize:13]];
    
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(headerView), SCREEN_WIDTH, 100)];
    buttonView.backgroundColor = [UIColor clearColor];
    [backView addSubview:buttonView];
    
    
    
    for (int i = 0; i < self.buttonMutableArray.count; i++)
    {
        
        MCServeButton *serveButton = [[MCServeButton alloc]initWithFrame:CGRectMake((i % 4) * (buttonView.frame.size.width + 4) / 4 - 0.5 * (i % 4), 5,(buttonView.frame.size.width + 4) / 4, 80)];
        [buttonView addSubview:serveButton];
        [serveButton.iconImageView setImage:[UIImage imageNamed:[[self.buttonMutableArray objectAtIndex:i] objectForKey:@"imageName"]]];
        serveButton.backgroundColor = [UIColor clearColor];
        serveButton.iconImageView.frame = CGRectMake(((buttonView.frame.size.width + 4) / 4-45)/2, 10, 45, 45);
        [serveButton.titleNameLabel setText:[[self.buttonMutableArray objectAtIndex:i] objectForKey:@"title"]];
        [serveButton.titleNameLabel setFrame:CGRectMake(0, serveButton.frame.size.height - 15, serveButton.frame.size.width, 16)];
        
        [serveButton.titleNameLabel setFont:[UIFont systemFontOfSize:14]];
        [serveButton.titleNameLabel setTextAlignment:NSTextAlignmentCenter];
        [serveButton.titleNameLabel  setTextColor:[UIColor colorWithRed:66 / 255.0 green:90 / 255.0 blue:104 / 255.0 alpha:1]];
        [serveButton setTag:i];
        [serveButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor whiteColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    [listTableView setTableHeaderView:backView];
    
    //读取数据
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *homlist  = [userDefaults objectForKey:@"homelist"];
    if (homlist.count> 0) {
        [listMutableArray setArray:homlist];
        [self setListArray];
        [self therRefresh];
    }else{
        [self therRefresh];
    }

    
    
    
}
- (void)scan{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized)
        
    {
        
        NSLog(@"允许状态");
        
    }
    
    else if (authStatus == AVAuthorizationStatusDenied)
        
    {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请在iPhone的“设置-隐私-相机”选项中，允许格外生活访问你的相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
        
        
    }
    
    
    MCScanViewController *scanVC = [[MCScanViewController alloc]init];
    scanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scanVC animated:YES];
    
    
    
    
}

- (void)loadHtmlString{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    
    NSDictionary *sendDict = @{
                               @"uid":uid,
                               @"isHTML5url":@1,
                               @"page":@1,
                               @"pagesize":@10,
                               @"appID":@"colourlife",
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/weiApplication" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                [self setArray:dicDictionary[@"content"][@"data"]];
                
                
                
            }
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        //[SVProgressHUD showSuccessWithStatus:@"服务器无响应"];
        
        
    }];
    
    
    
    
}

- (void)setArray:(NSArray *)array{
    NSLog(@"%@",array);
    for(int i = 1 ;i<array.count;i++){
        
        if ([array[i][@"name"] isEqualToString:@"邮件管理"]||[array[i][@"name"] isEqualToString:@"任务工单"]) {
            
            [htmlMutableArray addObject:array[i]];
            
        }
        
        
    }
    NSLog(@"htm的数组%@",htmlMutableArray);
    [MCPublicDataSingleton sharePublicDataSingleton].mail =htmlMutableArray[0][@"HTML5url"];
    
}

- (void)loadMassage{
    
    [listOneMutableArray removeAllObjects];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];
    NSString *corpID = [defaults objectForKey:@"corpId"];
    
    NSDictionary *sendDict = @{
                               @"username":username,
                               @"page_num":@1,
                               @"page_size":@10,
                               @"corp_id":corpID
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/homelist" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
            {
                
                
                [listMutableArray setArray:dicDictionary[@"content"]];
                
                NSArray *array = dicDictionary[@"content"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                //存数据，不需要设置路劲，NSUserDefaults将数据保存在preferences目录下
                
                [userDefaults setObject:array forKey:@"homelist"];
                [userDefaults synchronize];
                
                [self setListArray];
                [listTableView reloadData];
                //[self setRedView];
                [listTableView.mj_header endRefreshing];
                
                
                
            }
            
        }else{
            
            [listOneMutableArray setArray:dicDictionary[@"content"]];
            [listTableView reloadData];
            //[self setRedView];
            [listTableView.mj_header endRefreshing];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        [listTableView.mj_header endRefreshing];
        NSLog(@"****%@", error);
        
        
        
        
    }];
    
    
    
    
}
- (void)setListArray{
    
    [listOneMutableArray removeAllObjects];
    [listMutableArray addObjectsFromArray:listGDMutableArray];
    NSLog(@"总共的数组%@",listMutableArray);
    
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
            
            if ([[self ConvertStrToTime:[[listOneMutableArray objectAtIndex:i]objectForKey:@"modify_time"] ] longLongValue]<[[self ConvertStrToTime:[[listOneMutableArray objectAtIndex:j]objectForKey:@"modify_time"] ] longLongValue]) {
                
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
    
    
    NSLog(@"处理好的数组%@",listOneMutableArray);
    

    
//    [ggtzMutableArray removeAllObjects];
//    [yjMutableArray removeAllObjects];
//    [mfMutableArray removeAllObjects];
//    [spMutableArray removeAllObjects];
//    [listOneMutableArray removeAllObjects];
//    [listMutableArray addObjectsFromArray:listGDMutableArray];
//    NSLog(@"总共的数组%@",listMutableArray);
//    NSDictionary *ggtzdic = [NSDictionary dictionary];
//    NSDictionary *yjdic = [NSDictionary dictionary];
//    NSDictionary *mfdic = [NSDictionary dictionary];
//    NSDictionary *spdic = [NSDictionary dictionary];
//    for (int i = 0; i <listMutableArray.count; i++) {
//        if ([listMutableArray[i][@"client_code"] isEqualToString:@"ggtz"]) {
//            
//            ggtzdic = listMutableArray[i];
//            [ggtzMutableArray addObject:ggtzdic];
//        }
//        if ([listMutableArray[i][@"client_code"] isEqualToString:@"yj"]) {
//            
//            yjdic = listMutableArray[i];
//            [yjMutableArray addObject:yjdic];
//        }
//        if ([listMutableArray[i][@"client_code"] isEqualToString:@"case"]) {
//            
//            mfdic = listMutableArray[i];
//            [mfMutableArray addObject:mfdic];
//        }
//        if ([listMutableArray[i][@"client_code"] isEqualToString:@"sp"]) {
//            
//            spdic = listMutableArray[i];
//            [spMutableArray addObject:spdic];
//        }
//        
//        
//        
//        
//        
//    }
//    
//    
//    if ([ggtzMutableArray[0][@"client_code"] length]>0) {
//        
//        [listOneMutableArray addObject:ggtzMutableArray];
//    }
//    if ([yjMutableArray[0][@"client_code"] length]>0) {
//        
//        [listOneMutableArray addObject:yjMutableArray];
//    }
//    if ([mfMutableArray[0][@"client_code"] length]>0) {
//        
//        [listOneMutableArray addObject:mfMutableArray];
//    }
//    if ([spMutableArray[0][@"client_code"] length]>0) {
//        
//        [listOneMutableArray addObject:spMutableArray];
//    }
//    
//    
//    for (int i=0; i<listOneMutableArray.count-1; i++)
//        
//    {
//        
//        for (int j=i+1; j<listOneMutableArray.count; j++) {
//            
//            if ([[self ConvertStrToTime:[[listOneMutableArray objectAtIndex:i][0]objectForKey:@"modify_time"] ] longLongValue]<[[self ConvertStrToTime:[[listOneMutableArray objectAtIndex:j][0]objectForKey:@"modify_time"] ] longLongValue]) {
//                
//                NSMutableDictionary *TempDic=[[listOneMutableArray objectAtIndex:i]copy];
//                
//                listOneMutableArray[i]=[[listOneMutableArray objectAtIndex:j]copy];
//                
//                listOneMutableArray[j]=TempDic;
//                
//            }
//            
//        }
//        
//    }
//    
//    
//    NSLog(@"处理好的数组%@",listOneMutableArray);
    
    
    
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

- (void)clickButton:(UIButton *)senderButton
{
    NSDictionary *YJDic = [[NSDictionary alloc]init];
    NSDictionary *spDic = [[NSDictionary alloc]init];
    NSDictionary *mfDic = [[NSDictionary alloc]init];
    NSDictionary *QDDic = [[NSDictionary alloc]init];
    NSLog(@"%@",homeButtonMutableArray);
//    for (int i=0; i<homeButtonMutableArray.count; i++) {
//        NSString *title = [homeButtonMutableArray objectAtIndex:i][@"name"];
//        if ([title isEqualToString:@"邮件"]) {
//            YJDic =[homeButtonMutableArray objectAtIndex:i];
//            
//        }
//        if ([title isEqualToString:@"审批"]) {
//            spDic =[homeButtonMutableArray objectAtIndex:i];
//        }
//        if ([title isEqualToString:@"蜜蜂协同"]) {
//            
//            mfDic =[homeButtonMutableArray objectAtIndex:i];
//        }
//        if ([title isEqualToString:@"新e签到"]) {
//            
//            QDDic =[homeButtonMutableArray objectAtIndex:i];
//            
//        }
//    }
    
    switch (senderButton.tag)
    {
            
        case 0:{
             YJDic = @{@"name":@"新邮件",@"oauthType":@"1",@"url":@"http://mail.oa.colourlife.com:40060/login",@"app_code":@"xyj"};
            [self pushH5:YJDic];
            
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
            mfDic = @{@"name":@"蜜蜂协同",@"oauthType":@"1",@"url":@"http://iceapi.colourlife.com:4600/home",@"app_code":@"case"};
           
            [self pushH5:mfDic];
            
            
        }
            break;
            
        case 3://
        {
            QDDic = @{@"name":@"签到",@"oauthType":@"1",@"url":@"http://eqd.oa.colourlife.com/cailife/sign/main",@"app_code":@"qiandao"};
            [self pushH5:QDDic];
            
            
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
                
                
                
                
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring]  titleString:name];
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
                
                
                
            }
            
            return ;
            
            
            
        }else{
         [SVProgressHUD showErrorWithStatus:@"应用授权失败"];
        
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
                
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring]  titleString:name];
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
                
                
            }
            
            return ;
            
            
            
        }else{
        
         [SVProgressHUD showErrorWithStatus:@"应用授权失败"];
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
}

- (void)getToken:(NSString *)urlString andTitle:(NSString *)title{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *password = [defaults objectForKey:@"passWord"];
    //根据键值取出
    
    NSString *token  = [defaults objectForKey:@"access_token"];
    NSString *token_p = [NSString stringWithFormat:@"%@",[MCPublicDataSingleton sharePublicDataSingleton].token];
    if (token_p.length>0) {
        token = [NSString stringWithFormat:@"%@",token_p];
    }
    NSString * URLString = urlString;
    NSString *URLstring = @"";
    if ([URLString rangeOfString:@"?"].location != NSNotFound) {
        URLstring = [NSString stringWithFormat:@"%@&username=%@&access_token=%@",URLString,username,token];
    }else{
        URLstring = [NSString stringWithFormat:@"%@?username=%@&access_token=%@",URLString,username,token];
        
    }
    
    
    
    NSLog(@"%@",URLstring);
    MCWebViewController *wbViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring] titleString:title];
    wbViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wbViewController animated:YES];
    
    //            }
    //
    //        }
    //
    //
    //
    //
    //    } failure:^(NSError *error) {
    //
    //
    //
    //    }];
    //
    
    
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
        
        
        //首先创建格式化对象
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //然后创建日期对象
        
        NSDate *date1 = [dateFormatter dateFromString:[dataDictionary objectForKey:@"modify_time"]];
        
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
            
            NSString *dateString2 = [dataDictionary objectForKey:@"modify_time"];
            
            [cell.dateLabel setText:[dateString2 substringFromIndex:10]];
            
            
        }else {
            NSLog(@"%d",days);
            if (days<-2000) {
                [cell.dateLabel setText:@""];
            }else{
                NSString *dateString1 = [dataDictionary objectForKey:@"modify_time"];
                
                [cell.dateLabel setText:[dateString1 substringToIndex:10]];
                
            }
            
            
            
        }
        
        
        
        
        //[cell.dateLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"modify_time"]]];
        
        
        
        
        //    NSString *urlString = [dataDictionary objectForKey:@"app_icon_ios"];
        //    if ([urlString isKindOfClass:[NSString class]] && [urlString length] > 0)
        //    {
        //        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"moren"]];
        //
        //    }
        if ([dataDictionary[@"client_code"] isEqualToString:@"ggtz"]) {
            [cell.iconImageView setImage:[UIImage imageNamed:@"通知公告"]];
        }else
            if ([dataDictionary[@"client_code"] isEqualToString:@"yj"]) {
                [cell.iconImageView setImage:[UIImage imageNamed:@"邮件"]];
            }
            else
                if ([dataDictionary[@"comefrom"] isEqualToString:@"审批"]) {
                    [cell.iconImageView setImage:[UIImage imageNamed:@"审批"]];
                }
                else
                    if ([dataDictionary[@"client_code"] isEqualToString:@"case"]) {
                        [cell.iconImageView setImage:[UIImage imageNamed:@"蜜蜂协同"]];
                    }
                    else{
                        
                        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataDictionary[@"app_icon_ios"]] placeholderImage:[UIImage imageNamed:@"moren"]];
                    }
        
        
        
        
        cell.noReadImageView.hidden = nil;
        if ([dataDictionary[@"notread"] integerValue] == 0) {
            cell.noReadImageView.hidden = YES;
            
            //
        }
        [cell.numberLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"notread"]]];
        
        
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
        
        
        
    }
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self getTokens];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    NSString *isClean  = [defaults objectForKey:@"isClean"];
    
    if ([isClean isEqualToString:@"yes"]) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isClean"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self loadMassage];
    }

    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@avatar?uid=%@", USER_ICON_URL,username]];
    UIImage *defaultImage = [UIImage imageNamed:@"default.png"];
    
    [photoImageView sd_setImageWithURL:url placeholderImage:defaultImage options:SDWebImageRefreshCached];
    [self getKeyData];
   
}
- (void)loadUserData{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    NSString *username = [defaults objectForKey:@"userName"];
    
    
    
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    [sendDict setObject:uid forKey:@"uid"];
    [sendDict setObject:username forKey:@"username"];
    NSLog(@"%@",sendDict);
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/account" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                NSDictionary *dic = dicDictionary[@"content"];
                [MCPublicDataSingleton  sharePublicDataSingleton].userDictionary = dicDictionary[@"content"];
                [defaults setObject:dicDictionary[@"content"] forKey:@"userInfo"];
                [defaults synchronize];
                [self setUserData];
                
                
            }
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       // [SVProgressHUD showSuccessWithStatus:@"服务器无响应"];
        
        
    }];
    
    
}

- (void)setUserData{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"userInfo"];
    NSLog(@"%@",dic);
    NSString *username = [defaults objectForKey:@"userName"];
    //    if ([dic[@"Icon"] length]>0) {
//    [photoImageView sd_setImageWithURL:dic[@"Icon"] placeholderImage:[UIImage imageNamed:@"moren_geren"]];
//    //}
    
    [userNameLabel  setText:[NSString stringWithFormat:@"%@(%@)",dic[@"realname"],username]];
    
    [workNumberLabel setText:[NSString stringWithFormat:@"%@/%@",dic[@"familyName"],dic[@"jobName"]]];
    
    
    
    
    
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
             _douwnUrl = @"itms-services://?action=download-manifest&url=https://cd.colourlife.com/cgj.plist";
             
             
             NSString *string = @"";
             
             
             
             if ([result integerValue] ==1) {
                 
                 
                 
                 
             }
             if ([result integerValue] ==-1) {
                 NSArray *array = dicDictionary[@"content"][@"info"][0][@"func"];
                 if (array.count>1) {
                     string = [array componentsJoinedByString:@","];
                 }
                 
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"检查更新:彩管家" message:string delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:nil, nil];
                 alert.tag = 1002;
                 [alert show];
                 
                 
             }
             if ([result integerValue] ==0 ) {
                 NSArray *array = dicDictionary[@"content"][@"info"][0][@"func"];
                 if (array.count>1) {
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

- (void)getManagementApplicationList{
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    [sendDictionary setValue:@(10) forKey:@"pagesize"];
    [sendDictionary setValue:@(1) forKey:@"page"];
    [sendDictionary setValue:@(1) forKey:@"isHTML5url"];
    [sendDictionary setValue:uid forKey:@"uid"];
    [sendDictionary setValue:@2 forKey:@"categoryid"];
    [sendDictionary setValue:@"colourlife" forKey:@"appID"];
    
    [SVProgressHUD show];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/weiApplication" parameters:sendDictionary success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                [MCPublicDataSingleton sharePublicDataSingleton].arrayTwo = dicDictionary[@"content"][@"data"];
                
                
            }
            
            return ;
            
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
}

-(void)getKeyData{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];
    NSString *password = [defaults objectForKey:@"passWordMI"];
    
    
    NSDictionary *sendDict = @{
                               @"username":username,
                               @"password":password
                               };
    
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
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%@",@"wu"] forKey:@"fpquanxian"];
            [defaults setObject:[NSString stringWithFormat:@"%@",@"0.00"] forKey:@"fanpiao"];
            [defaults setObject:[NSString stringWithFormat:@"%@",@"0.00"] forKey:@"hongbao"];
            [defaults synchronize];
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
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                
                [MCPublicDataSingleton sharePublicDataSingleton].fanpiao =dicDictionary[@"content"][@"balance"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                [userDefaults setObject:[NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"balance"]] forKey:@"fanpiao"];
                [userDefaults synchronize];
                
                
                
            }
            
        }else{
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
