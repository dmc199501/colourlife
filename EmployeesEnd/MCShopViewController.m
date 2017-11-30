//
//  MCShopViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/16.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCShopViewController.h"
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

#import <AVFoundation/AVMediaFormat.h>
#import "MCShelvesViewController.h"
#import "MCManagementViewController.h"
#import "MCValidationViewController.h"
@interface MCShopViewController ()
@property(nonatomic,strong)NSString *IPString;
@end

@implementation MCShopViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        htmlMutableArray = [NSMutableArray array];
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self deviceIPAdress];
    if ([MCPublicDataSingleton sharePublicDataSingleton].isRequestVersion == 0) {
        [self VersionUpdate];
    }
    
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    
    
    
    [self loadUserData];
    [self loadHtmlString];
    [self getOfficeApplicationList];
    [self getManagementApplicationList];
    
    self.buttonMutableArray = [NSMutableArray array];
    [self.buttonMutableArray addObject:@{@"imageName":@"dingdan",@"title":@"订单管理"}];
    [self.buttonMutableArray addObject:@{@"imageName":@"shangping",@"title":@"商品管理"}];
    [self.buttonMutableArray addObject:@{@"imageName":@"shangjia",@"title":@"商品上架"}];
    [self.buttonMutableArray addObject:@{@"imageName":@"quanma",@"title":@"券码验证"}];
    
    
    
    
    self.navigationController.delegate = self;
    [self setUI];
    
    [self therRefresh];
    
    
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
- (void)setUI{
    
    backView = [[DDCoverView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 206 + 100)];
    backView.backgroundColor = [UIColor whiteColor];
    
    headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 206)];
    
    [headerView setImage:[UIImage imageNamed:@"beijing_home"]];
    [backView addSubview:headerView];
    headerView.userInteractionEnabled = YES;
    //headerView.backgroundColor = DARK_COLOER_ZZ;
    
    
    UIImageView *LOGO = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 20 *102/33, 20)];
    [LOGO setImage:[UIImage imageNamed:@"logo_home"]];
    [headerView addSubview:LOGO];
    
    UILabel *welcome = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 20)];
    welcome.text = @"欢迎您";
    welcome.textColor = [UIColor whiteColor];
    welcome.backgroundColor = [UIColor clearColor];
    welcome.textAlignment = NSTextAlignmentCenter;
    [welcome setFont:[UIFont systemFontOfSize:18]];
    [headerView addSubview:welcome];
    
    
    UIButton *scanButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, 32, 20, 20)];
    [headerView addSubview:scanButton];
    [scanButton setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
    scanButton.backgroundColor = [UIColor clearColor];
    [scanButton addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    //    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    [listTableView setTableHeaderView:backView];
    
    
    
    
    
}
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
- (void)clickButton:(UIButton *)senderButton
{
    
    
    switch (senderButton.tag)
    {
            //报修
        case 0:{
            
            
        }
            break;
        case 1://
        {
            
            MCManagementViewController *ManagementVC = [[MCManagementViewController alloc]init];
            ManagementVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ManagementVC animated:YES];
        }
            break;
        case 2://
        {
            
            MCShelvesViewController *ShelvesVC = [[MCShelvesViewController alloc]init];
            ShelvesVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ShelvesVC animated:YES];
        }
            break;
            
        case 3://
        {
            
            MCValidationViewController *ValidationVC = [[MCValidationViewController alloc]init];
            ValidationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ValidationVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
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
    bgView.backgroundColor = BACKGROUND_GRAY_COLOR_ZZ;
    return bgView;
    
}- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return listMutableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *indentifier = @"cell";
    MCHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCHomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    NSLog(@"%@",dataDictionary);
    [cell.titleLabel setText:[NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"weiappname"]]];
    
    [cell.contentLabel setText:[NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"content"]]];
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss "];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *data1 = [dateString substringFromIndex:10];
    NSString *data2 = [data1 stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *dateString1 = [dataDictionary objectForKey:@"homePushTime"];
    NSString *data3 = [dateString1 substringFromIndex:10];
    NSString *data4 = [dateString1 stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    if ([[dateString substringToIndex:10] isEqualToString:[[dataDictionary objectForKey:@"homePushTime"] substringToIndex:10]]) {
        if ([data2 integerValue] - [data4 integerValue] <20) {
            [cell.dateLabel setText:@"刚刚"];
        }else{
            [cell.dateLabel setText:data3];
            
        }
        
        
    }else{
        
        [cell.dateLabel setText:[dateString1 substringToIndex:10]];
    }
    
    
    NSString *urlString = [dataDictionary objectForKey:@"icon"];
    if ([urlString isKindOfClass:[NSString class]] && [urlString length] > 0)
    {
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"moren"]];
        
    }
    
    
    
    cell.noReadImageView.hidden = nil;
    if ([dataDictionary[@"notread"] integerValue] == 0) {
        cell.noReadImageView.hidden = YES;
        
        //
    }
    [cell.numberLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"notread"]]];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    NSLog(@"%@",dataDictionary);
    
    MCMessageVIiewControler *messageViewController = [[MCMessageVIiewControler alloc]init];
    messageViewController.codeString = dataDictionary[@"weiappcode"];
    messageViewController.titleString = dataDictionary[@"weiappname"];
    messageViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageViewController animated:YES];
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
    
    [self loadMassage];
}
- (void)loadUserData{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    
    
    
    NSDictionary *sendDict = @{
                               @"uid":uid,
                               @"appID":@"colourlife",
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_HOUSEKEEPER urlMethod:@"/administrator/getadministratorbusinessCard" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                NSDictionary *dic = dicDictionary[@"content"][@"data"][0];
                [MCPublicDataSingleton  sharePublicDataSingleton].userDictionary = dicDictionary[@"content"][@"data"][0];
                [self setUserData:dic];
                
                
            }
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       
        
        
    }];
    
    
}

- (void)setUserData:(NSDictionary *)dic{
    
    if ([dic[@"Icon"] length]>0) {
        [photoImageView sd_setImageWithURL:dic[@"Icon"] placeholderImage:[UIImage imageNamed:@"moren_geren"]];
    }
    
    [userNameLabel  setText:[NSString stringWithFormat:@"%@(%@)",dic[@"realname"],dic[@"username"]]];
    
    [workNumberLabel setText:[NSString stringWithFormat:@"%@/%@",dic[@"property_name"],dic[@"job_name"]]];
    
    
    
    
    
}


- (void)loadMassage{
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    
    
    NSDictionary *sendDict = @{
                               @"uid":uid,
                               @"page":@1,
                               @"pagesize":@10,
                               @"appID":@"colourlife",
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/homepush" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                [listMutableArray setArray:dicDictionary[@"content"][@"data"]];
                [listTableView reloadData];
                //[self setRedView];
                [listTableView.mj_header endRefreshing];
                
                
            }
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       
        
        
    }];
    
    
    
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
    [MCPublicDataSingleton sharePublicDataSingleton].isRequestVersion =YES;
    
    NSString *idUrlString = @"http://api.fir.im/apps/latest/?api_token=";
    NSURL *requestURL = [NSURL URLWithString:idUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [NSURLConnection sendAsynchronousRequest:request queue: [NSOperationQueue currentQueue]completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            //do something
            
        }else {
            NSError *jsonError = nil;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            NSString * version=result[@"build"];
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            
            NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
            ;
            NSLog(@"%d--%d",[currentVersion intValue],[version intValue]);
            NSLog(@"%@",result);
            if ([currentVersion intValue] < [version intValue] ) {
                
                
                NSString *titelStr = @"检查更新:";
                NSString *messageStr = @"发现新版本是否更新";
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titelStr message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更新", nil];
                alert.tag = 1001;
                [alert show];
                
                
            }else{
                
                
            }
            
            
            if (!jsonError && [result isKindOfClass:[NSDictionary class]]) {
                //do something
                
            }
        }
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag - 1000 == 1)
    {
        if (buttonIndex ==1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
        }
        
    }
    
    
}
- (void)getOfficeApplicationList{
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSString *uid = [MCPublicDataSingleton sharePublicDataSingleton].userDictionary[@"uid"];
    [sendDictionary setValue:@(10) forKey:@"pagesize"];
    [sendDictionary setValue:@(1) forKey:@"page"];
    [sendDictionary setValue:@(1) forKey:@"isHTML5url"];
    [sendDictionary setValue:uid forKey:@"uid"];
    [sendDictionary setValue:@1 forKey:@"categoryid"];
    [sendDictionary setValue:@"colourlife" forKey:@"appID"];
    
    [SVProgressHUD show];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/weiApplication" parameters:sendDictionary success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                [MCPublicDataSingleton sharePublicDataSingleton].arrayOne = dicDictionary[@"content"][@"data"];
                
                
            }
            
            return ;
            
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
}

- (void)getManagementApplicationList{
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSString *uid = [MCPublicDataSingleton sharePublicDataSingleton].userDictionary[@"uid"];
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
@end
