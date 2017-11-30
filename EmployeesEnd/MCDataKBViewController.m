//
//  MCDataKBViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/20.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCDataKBViewController.h"
#import "MCDataChanggeViewController.h"
#import "MyMD5.h"
@interface MCDataKBViewController ()<MCDataChanggeViewControllerDeleGete>
@property (nonatomic, assign) int page;  //请求页码

@property (nonatomic, strong) UIButton *selectedButton; //接收被选中的按钮
@property (nonatomic ,strong)  UIView *indicateView ;
@property (nonatomic, strong)NSMutableArray *buttonMutableArray;//键： title

@property(nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, assign) int classId;//记录点击某个分类按钮；


@end

@implementation MCDataKBViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"数据看板";
    bacskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    [self.view addSubview:backView];
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    
    // 注册一个监听事件。第三个参数的事件名， 系统用这个参数来区别不同事件。
    [notiCenter addObserver:self selector:@selector(receiveNotification:) name:@"架构传值" object:nil];
    
    
    
    [self getAuthApp];
    
    
    
    
    areView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [bacskView addSubview:areView];
    
    JGlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 20)];
    JGlabel.textAlignment = NSTextAlignmentCenter;
    JGlabel.font = [UIFont systemFontOfSize:15];
    [JGlabel setTextColor:GRAY_COLOR_ZZ];
    [areView addSubview:JGlabel];
    JGlabel.text = [NSString stringWithFormat:@"%@",self.name];
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
    CGSize size=[JGlabel.text sizeWithAttributes:attrs];
    
     image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -size.width/2 -20, 17.5, 15, 15)];
    [image setImage:[UIImage imageNamed:@"coordinates_fill-black"]];
    [areView addSubview:image];
    
    UIButton *changgeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [areView addSubview:changgeButton];
    [changgeButton addTarget:self action:@selector(changgeData) forControlEvents:UIControlEventTouchUpInside];
    
    areView.backgroundColor = [UIColor whiteColor];

     [self setButton];
    
    // Do any additional setup after loading the view.
}
- (void)receiveNotification:(NSNotification *)noti
{
    
    // NSNotification 有三个属性，name, object, userInfo，其中最关键的object就是从第三个界面传来的数据。name就是通知事件的名字， userInfo一般是事件的信息。
    NSLog(@"%@ === %@ === %@", noti.object, noti.userInfo, noti.name);
    
    JGlabel.text = [noti.object objectForKey:@"name"];
    [self gtsArea:[noti.object objectForKey:@"id"]];
    
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
    CGSize size=[JGlabel.text sizeWithAttributes:attrs];
    
    image.frame = CGRectMake(SCREEN_WIDTH/2 -size.width/2 -20, 17.5, 15, 15);
   }

- (void)dealloc
{
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
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
            
            NSString *oid =  [[MCPublicDataSingleton sharePublicDataSingleton].userDictionary objectForKey:@"orgId"];
            [self gtsArea:oid];
            
            
        }else{
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    
    
    
}

- (void)setUI{

    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-50) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    //    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    [listTableView setTableHeaderView:bacskView];
   


}
- (void)gtsArea:(NSString *)oid{
    [listTableView removeFromSuperview];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *orgToken = [defaults objectForKey:@"orgToken"];
    NSString *corpID = [defaults objectForKey:@"corpId"];
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:oid forKey:@"orgUuid"];
    [sendDictionary setValue:orgToken forKey:@"token"];
    [sendDictionary setValue:corpID forKey:@"corpId"];
    
    
    
    
    
    NSLog(@"%@",sendDictionary);
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/resourcems/community/statistics" parameters:sendDictionary success:^(id responseObject) {
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
       
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                self.datadic = dicDictionary[@"content"];
               
                
                [self gtsAreaOne:oid];

                
            }
            
            
            
            
        }else{
            
            
                   }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
    
   
    
    
}


- (void)gtsAreaOne:(NSString *)oid{
    [listTableView removeFromSuperview];
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *orgtype = [defaults objectForKey:@"orgtype"];//组织架构类型
    NSInteger level = 0;
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    if ([orgtype isEqualToString:@"彩生活集团"]) {
        level = 1;
    }
    if ([orgtype isEqualToString:@"大区"]) {
        level = 2;
        [sendDictionary setValue:oid forKey:@"regiongroupUuid"];
    }
    if ([orgtype isEqualToString:@"事业部"]) {
        level = 3;
        [sendDictionary setValue:oid forKey:@"districtUuid"];
    }
    if ([orgtype isEqualToString:@"小区"]) {
        level = 4;
        [sendDictionary setValue:oid forKey:@"regionUuid"];
    }
    
    
    
    [sendDictionary setValue:@"9959f117-df60-4d1b-a354-776c20ffb8c7" forKey:@"groupUuid"];
    [sendDictionary setValue:@(level) forKey:@"level"];
    //[sendDictionary setValue:corpID forKey:@"corpId"];
   
    NSLog(@"%@-%@",sendDictionary,orgtype);
    
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/xsfxt/report/charge_receipt" parameters:sendDictionary success:^(id responseObject) {
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                
                self.datadicTwo = dicDictionary[@"content"];
              
                [self setUI];
                [listTableView reloadData];
                
                
                
                
            }
            
            return ;
            
            
            
        }else{
            
             [self setUI];
            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"message"]];
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
    
    
}

- (void)changgeData{

    MCDataChanggeViewController *OrganizationalVC = [[MCDataChanggeViewController alloc]init];
    OrganizationalVC.delegate = self;
    OrganizationalVC.titleString = self.name;
    OrganizationalVC.type = 12;
    
//    OrganizationalVC.IDString = [[MCPublicDataSingleton sharePublicDataSingleton].userDictionary objectForKey:@"orgId"];
    OrganizationalVC.IDString = @"9959f117-df60-4d1b-a354-776c20ffb8c7";

    
    OrganizationalVC.phoneString =  [[MCPublicDataSingleton sharePublicDataSingleton].userDictionary objectForKey:@"familyId"];
   
    
    [self.navigationController pushViewController:OrganizationalVC animated:YES];


}
-(void)viewController:(MCDataChanggeViewController*)ViewController didPushVlaueWithAddress:(id)address{

   
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setButton{
    
    
    NSArray *stateArray = @[@"管理类",@"经营类"];
    
    for (int i = 0; i < stateArray.count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        float buttonW =  self.view.frame.size.width/(stateArray.count*1.0);
        button.frame = CGRectMake(i*buttonW, 60, buttonW, 50);
        // NSDictionary * dict = (NSDictionary *)[array objectAtIndex:i] ;
        
        
        
        
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:[stateArray objectAtIndex:i]  forState:    UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1]  forState:UIControlStateNormal];
        button.titleLabel.font  = [UIFont systemFontOfSize: 16.0];
        [button setTitleColor:[UIColor colorWithRed:27 / 255.0 green:130 / 255.0 blue:210 / 255.0 alpha:1] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000+i;
        if (i == 0)
        {
            button.selected = YES;
            _selectedButton = button;
        }
        
        [bacskView addSubview:button];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 60+5, 1, 30)];
        line.backgroundColor = [UIColor whiteColor];
        [bacskView addSubview:line];
        
        //        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 64+5, 1, 30)];
        //        line2.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        //        [self.view addSubview:line2];
        
    }
    
    
    
    //滑动条
    if (_indicateView == nil){
        _indicateView = [[UIView alloc]initWithFrame:CGRectMake(0,60+ 48, SCREEN_WIDTH/2, 2)];
        _indicateView.backgroundColor = [UIColor colorWithRed:41 / 255.0 green:161 / 255.0 blue:247 / 255.0 alpha:1];
        [bacskView addSubview:_indicateView];
    }
    
    
}

- (void)buttonClicked:(UIButton *)button
{
    
    _selectedButton.selected = NO; //先取消上一个按钮的选择状态
    button.selected = YES;
    _selectedButton = button;
    
    
    
    _classId = (int)button.tag - 1000 ;
    [UIView animateWithDuration:0.5 animations:^{
        _indicateView.frame = CGRectMake(button.frame.origin.x+0, 60 +48, button.frame.size.width, 2);
    }];
   
    
    [listTableView reloadData];
   
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    return 45;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    switch (section)
    {
        case 0:
        {
            return 1;
        }
            break;
            
        default:
        {
            return 1;
        }
            break;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    switch (section)
    {
        case 0:
        {
            if (_classId ==0) {
                 return 5;
            }else{
             return 5;
            
            }
           
        }
            break;
            
        default:
        {
            return 1;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (_classId==1) {
        NSString *indentifier = [NSString stringWithFormat:@"cell%@%@",@(indexPath.section), @(indexPath.row)];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            [cell.textLabel setTextColor:BLACK_COLOR_ZZ];
            [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
            
            switch (indexPath.section)
            {
                case 0:
                {
                    switch (indexPath.row)
                    {
                        case 0:
                        {
                            [cell.textLabel setText:@"当前查询费用日期"];
                            
                            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, 12.5, 150, 20)];
                            label.textAlignment = NSTextAlignmentRight;
                            label.font = [UIFont systemFontOfSize:13];
                            [label setTextColor:GRAY_COLOR_ZZ];
                            [cell addSubview:label];
                            label.text = [NSString stringWithFormat:@"%@",self.datadicTwo[@"dateTime"]];
                            
                            
                            
                        }
                            break;

                        case 1:
                        {
                            [cell.textLabel setText:@"应收"];
                            
                            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, 12.5, 150, 20)];
                            label.textAlignment = NSTextAlignmentRight;
                            label.font = [UIFont systemFontOfSize:13];
                            [label setTextColor:GRAY_COLOR_ZZ];
                            [cell addSubview:label];
                            label.text = [NSString stringWithFormat:@"%@",self.datadicTwo[@"receivableValue"]];
                            
                            
                            
                        }
                            break;
                            
                            
                        case 2:
                        {
                            [cell.textLabel setText:@"实收"];
                            
                            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, 12.5, 150, 20)];
                            label.textAlignment = NSTextAlignmentRight;
                            label.font = [UIFont systemFontOfSize:13];
                            [label setTextColor:GRAY_COLOR_ZZ];
                            [cell addSubview:label];
                            label.text = [NSString stringWithFormat:@"%@",self.datadicTwo[@"chargeValue"]];
                            
                        }
                            break;
                        case 3:
                        {
                            [cell.textLabel setText:@"收费率"];
                            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, 12.5, 150, 20)];
                            label.textAlignment = NSTextAlignmentRight;
                            label.font = [UIFont systemFontOfSize:13];
                            [label setTextColor:GRAY_COLOR_ZZ];
                            [cell addSubview:label];
                            label.text = [NSString stringWithFormat:@"%@",@"0"];
                            
                            
                        }
                            break;
                            
                        case 4:
                        {
                            [cell.textLabel setText:@"业主投诉数"];
                            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, 12.5, 150, 20)];
                            label.textAlignment = NSTextAlignmentRight;
                            label.font = [UIFont systemFontOfSize:13];
                            [label setTextColor:GRAY_COLOR_ZZ];
                            [cell addSubview:label];
                            label.text = [NSString stringWithFormat:@"%@",@"0"];
                        }
                            break;

                        default:
                            break;
                    }
                    
                    
                }
                    break;
                    
                    
                default:
                {
                    //                [cell.textLabel setText:@"退出登录"];
                    //                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                    
                }
                    break;
            }
        }
        
        
        
        return cell;
    }else{
    
        NSString *indentifier = [NSString stringWithFormat:@"cell1%@%@",@(indexPath.section), @(indexPath.row)];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            [cell.textLabel setTextColor:BLACK_COLOR_ZZ];
            [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
           
            switch (indexPath.section)
            {
                case 0:
                {
                    switch (indexPath.row)
                    {
                        case 0:
                        {
                            [cell.textLabel setText:@"小区面积(m2)"];
                            
                            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, 12.5, 150, 20)];
                            label.textAlignment = NSTextAlignmentRight;
                            label.font = [UIFont systemFontOfSize:13];
                            [label setTextColor:GRAY_COLOR_ZZ];
                            [cell addSubview:label];
                           
                            label.text = [NSString stringWithFormat:@"%@",self.datadic[@"area"]];
                            
                            
                            
                        }
                            break;
                            
                            
                        case 1:
                        {
                            [cell.textLabel setText:@"小区数"];
                            
                            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, 12.5, 150, 20)];
                            label.textAlignment = NSTextAlignmentRight;
                            label.font = [UIFont systemFontOfSize:13];
                            [label setTextColor:GRAY_COLOR_ZZ];
                            [cell addSubview:label];
                            label.text = [NSString stringWithFormat:@"%@",self.datadic[@"count"]];
                            
                        }
                            break;
                        case 2:
                        {
                            [cell.textLabel setText:@"车位数量"];
                            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, 12.5, 150, 20)];
                            label.textAlignment = NSTextAlignmentRight;
                            label.font = [UIFont systemFontOfSize:13];
                            [label setTextColor:GRAY_COLOR_ZZ];
                            [cell addSubview:label];
                            label.text = [NSString stringWithFormat:@"%@",self.datadic[@"upParkingSpace"]];
                            
                            
                        }
                            break;
                        case 3:
                        {
                            [cell.textLabel setText:@"APP安装数量"];
                            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, 12.5, 150, 20)];
                            label.textAlignment = NSTextAlignmentRight;
                            label.font = [UIFont systemFontOfSize:13];
                            [label setTextColor:GRAY_COLOR_ZZ];
                            [cell addSubview:label];
                            label.text = [NSString stringWithFormat:@"%@",@"0"];
                        }
                            break;
                        case 4:
                        {
                            [cell.textLabel setText:@"上线小区"];
                            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170, 12.5, 150, 20)];
                            label.textAlignment = NSTextAlignmentRight;
                            label.font = [UIFont systemFontOfSize:13];
                            [label setTextColor:GRAY_COLOR_ZZ];
                            [cell addSubview:label];
                            label.text = [NSString stringWithFormat:@"%@",self.datadic[@"count"]];
                        }
                            break;
                            
                            
                            
                        default:
                            break;
                    }
                    
                    
                }
                    break;
                    
                    
                default:
                {
                    //                [cell.textLabel setText:@"退出登录"];
                    //                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                    
                }
                    break;
            }
        }
        
        
        
        return cell;
    
    }
    return nil;
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
