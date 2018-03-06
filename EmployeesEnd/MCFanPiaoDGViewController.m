//
//  MCFanPiaoDGViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2018/2/7.
//  Copyright © 2018年 邓梦超. All rights reserved.
//

#import "MCFanPiaoDGViewController.h"
#import "MyMD5.h"
#import "MCdgmxTableViewCell.h"
@interface MCFanPiaoDGViewController ()
@property(nonatomic,assign)int isOpen;
@property (nonatomic, assign) int page;  //请求页码

@property (nonatomic, strong) UILabel *accountName;
@property (nonatomic, strong) UILabel *carNumber;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@end

@implementation MCFanPiaoDGViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        nameMutableArray = [NSMutableArray array];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    
    self.navigationItem.title = @"饭票交易明细";
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(certain)];
    _type = @"0";
    [self setListView];
    [self therRefresh];
    
    // Do any additional setup after loading the view.
}
- (void)therRefresh{
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAuthApp1)];
    
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
    listTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    
    
}

-(void)certain{
    if (_isOpen == 0) {
        _isOpen = 1;
        shopButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        shopButton.backgroundColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:0.3];
        [self.tabBarController.view addSubview:shopButton];
        [shopButton addTarget:self action:@selector(cancelOpendoor) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *backView1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -SCREEN_WIDTH/4 -5, 5, SCREEN_WIDTH/4, SCREEN_WIDTH/4 *286/211)];
        //backView.backgroundColor = [UIColor whiteColor];
        [backView1 setImage:[UIImage imageNamed:@"shaixuan"]];
        [shopButton addSubview:backView1];
        backView1.userInteractionEnabled = YES;
        
        
        
        UIButton *mailButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, backView1.frame.size.width, backView1.frame.size.height/3)];
        mailButton.tag = 1000;
        mailButton.backgroundColor = [UIColor clearColor];
        [backView1 addSubview:mailButton];
        
        [mailButton addTarget:self action:@selector(clickButton:)  forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *ApprovalButton = [[UIButton alloc]initWithFrame:CGRectMake(0, backView1.frame.size.height/3, backView1.frame.size.height, backView1.frame.size.height/3)];
        [backView1 addSubview:ApprovalButton];
        ApprovalButton.tag = 1001;
        [ApprovalButton addTarget:self action:@selector(clickButton:)  forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *CheckButton = [[UIButton alloc]initWithFrame:CGRectMake(0, backView1.frame.size.height/3*2, backView1.frame.size.width, backView1.frame.size.height/3)];
        [backView1 addSubview:CheckButton];
        CheckButton.tag = 1002;
        [CheckButton addTarget:self action:@selector(clickButton:)  forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
    }else{
        
        [self cancelOpendoor];
        
    }
    
    
    
}
-(void)clickButton:(UIButton *)button{
    [self cancelOpendoor];
    switch (button.tag) {
        case 1000:
        {
            _type = @"0";
            [self getAuthApp1];
            
        }
            break;
        case 1001:
        {
            _type = @"2";
            [self getAuthApp1];
        }
            break;
        case 1002:
        {
            _type = @"1";
            [self getAuthApp1];
            
        }
            break;
            
        default:
            break;
    }
    
}
- (void)cancelOpendoor{
    
    
    self.isOpen = 0;
    [shopButton removeFromSuperview];
    
    
}

-(void)setListView{
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    backView.backgroundColor = [UIColor whiteColor];
    
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 60, 20)];
    label1.textAlignment = NSTextAlignmentLeft;
    //[self addSubview:label1];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
    [label1 setFont:[UIFont systemFontOfSize:13]];
    [label1 setText:@"账户名:"];
    [backView addSubview:label1];
    
    _accountName = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, SCREEN_WIDTH-16, 20)];
    _accountName.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:_accountName];
    [_accountName setBackgroundColor:[UIColor clearColor]];
    [_accountName setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
    [_accountName setFont:[UIFont systemFontOfSize:13]];
    [_accountName setText:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"name"]]];
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(16, 40, 60, 20)];
    label2.textAlignment = NSTextAlignmentLeft;
    //[self addSubview:label2];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
    [label2 setFont:[UIFont systemFontOfSize:13]];
    [label2 setText:@"账号:"];
    [backView addSubview:label2];
    
    _carNumber = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, SCREEN_WIDTH-16, 20)];
    _carNumber.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:_carNumber];
    [_carNumber setBackgroundColor:[UIColor clearColor]];
    [_carNumber setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
    [_carNumber setFont:[UIFont systemFontOfSize:13]];
    [_carNumber setText:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"ano"]]];
    
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(16, 70, 60, 20)];
    label3.textAlignment = NSTextAlignmentLeft;
    //[self addSubview:label2];
    [label3 setBackgroundColor:[UIColor clearColor]];
    [label3 setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
    [label3 setFont:[UIFont systemFontOfSize:13]];
    [label3 setText:@"来源:"];
    [backView addSubview:label3];
    
    
    _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 70, 250, 20)];
    _typeLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:_typeLabel];
    [_typeLabel setBackgroundColor:[UIColor clearColor]];
    [_typeLabel setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
    [_typeLabel setFont:[UIFont systemFontOfSize:13]];
    
    NSString *sourceName = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"sourceName"]];
    if ([sourceName isEqualToString:@"(null)"]) {
        
        [_typeLabel setText:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"pid"]]];
    }else{
        [_typeLabel setText:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"sourceName"]]];
        
    }
    
    
    
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    
    
}

- (void)getAuthApp1{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *ts = [defaults objectForKey:@"ts"];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:@"01a2b3c4d5e6f7a8b9c0" forKey:@"appkey"];//app分配id
    //[dic setValue:corp forKey:@"corp_uuid"];//租户ID
    
    NSString *singe = [NSString stringWithFormat:@"%@%@%@",@"01a2b3c4d5e6f7a8b9c0",ts,@"1a2b3c4d5e6f7a8b9c0d1a2b3c4d5e6f"];
    
    NSString *  signature = [MyMD5 md5:singe];//签名=( APPID +ts +appSecret)md5
    [dic setValue:signature forKey:@"signature"];
    [dic setValue:ts forKey:@"timestamp"];//时间戳
    NSLog(@"%@",dic);
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/jqfw/app/auth" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 &&[dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
        {
            
            
            _taken = [NSString stringWithFormat:@"%@",[dicDictionary[@"content"] objectForKey:@"access_token"]];
            
            [self getdata];
            
        }else{
            
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    
    
    
}

- (void)getdata{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"userInfo"];
    //    NSLog(@"%@",dic);
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:@3 forKey:@"utype"];
    
    [sendDictionary setValue:_taken forKey:@"access_token"];
    //[sendDictionary setValue:_type forKey:@"ispay"];
    [sendDictionary setValue:@0 forKey:@"transtype"];
    [sendDictionary setValue:@0 forKey:@"starttime"];
    [sendDictionary setValue:_dic[@"cno"] forKey:@"uno"];
    [sendDictionary setValue:@"6" forKey:@"atid"];
    [sendDictionary setValue:_dic[@"cano"] forKey:@"ano"];
    [sendDictionary setValue:_dic[@"pano"] forKey:@"pano"];
    [sendDictionary setValue:@0 forKey:@"skip"];
    [sendDictionary setValue:@20 forKey:@"limit"];
    
    
    
    NSLog(@"%@",sendDictionary);
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/jrpt/transaction/list" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                [listMutableArray setArray:[dicDictionary[@"content"] objectForKey:@"list"]];
                
                [listTableView reloadData];
                
            }
            
        }else{
            
            [self setErrorUI];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    [listTableView.mj_header endRefreshing];
}

- (void)loadMoreData{
    
    
    _page += 20;
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"userInfo"];
    //    NSLog(@"%@",dic);
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:@2 forKey:@"utype"];
    [sendDictionary setValue:@3 forKey:@"utype"];
    
    [sendDictionary setValue:_taken forKey:@"access_token"];
    //[sendDictionary setValue:_type forKey:@"ispay"];
    [sendDictionary setValue:@0 forKey:@"transtype"];
    [sendDictionary setValue:@0 forKey:@"starttime"];
    [sendDictionary setValue:_dic[@"cno"] forKey:@"uno"];
    [sendDictionary setValue:@"6" forKey:@"atid"];
    [sendDictionary setValue:_dic[@"cano"] forKey:@"ano"];
    [sendDictionary setValue:_dic[@"pano"] forKey:@"pano"];
    [sendDictionary setValue:@(_page) forKey:@"skip"];
    [sendDictionary setValue:@20 forKey:@"limit"];
    
    
    
    NSLog(@"%@",sendDictionary);
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/jrpt/transaction/list" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                [listMutableArray addObjectsFromArray:dicDictionary[@"content"][@"list"]];
                
                
                [listTableView reloadData];
                [listTableView.mj_footer endRefreshing];
                
            }
            
        }else{
            
            [self setErrorUI];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    
    
    [listTableView.mj_footer endRefreshing];
    
}

- (void)setErrorUI{
    
    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 150, 150, 150)];
//    [self.view addSubview:imageView];
//    //imageView.backgroundColor = [UIColor yellowColor];
//    [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",@"kong"]]];
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    return footView;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
//{
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    UILabel *bgView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
//    bgView.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
//    bgView.textAlignment = NSTextAlignmentCenter;
//    bgView.font = [UIFont systemFontOfSize:14];
//    bgView.text = @"--把社区服务做到家--";
//    return bgView;
//
//}
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
    MCdgmxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCdgmxTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    NSDictionary *dataDic = [listMutableArray objectAtIndex:indexPath.row];
    
    [cell.dateLabel setText:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"creationtime"]]];
    if ([[dataDic objectForKey:@"content"] length] == 0) {
        [cell.bzLabel setText:[NSString stringWithFormat:@"备注:兑换"]];
    }else{
        
            
        [cell.bzLabel setText:[NSString stringWithFormat:@"备注:%@",[dataDic objectForKey:@"content"]]];
        
        
        
    }
    
    if ([_dic[@"cano"] isEqualToString:dataDic[@"destcccount"]]) {
        if ([[dataDic objectForKey:@"orgclient"] length]>0) {
            
        [cell.contentLabel setText:[NSString stringWithFormat:@"收到[%@][%@]转入%.2f,交易流水号:%@",[dataDic objectForKey:@"orgplatform"],[dataDic objectForKey:@"orgclient"],[[dataDic objectForKey:@"doubleValue"] floatValue],[dataDic objectForKey:@"tno"]]];
        }else{
        
            if ([[dataDic objectForKey:@"orgbiz"] length]>0){
            
                [cell.contentLabel setText:[NSString stringWithFormat:@"收到[%@][%@]转入%.2f,交易流水号:%@",[dataDic objectForKey:@"orgplatform"],[dataDic objectForKey:@"orgbiz"],[[dataDic objectForKey:@"destmoney"] doubleValue],[dataDic objectForKey:@"tno"]]];
            }else{
                [cell.contentLabel setText:[NSString stringWithFormat:@"收到[%@][%@]转入%.2f,交易流水号:%@",[dataDic objectForKey:@"orgplatform"],@"系统",[[dataDic objectForKey:@"destmoney"] doubleValue],[dataDic objectForKey:@"tno"]]];
            }
        
        }
        
        [cell.moneyLabel setText:[NSString stringWithFormat:@"+%.2f",[[dataDic objectForKey:@"destmoney"] floatValue]]];
        [cell.moneyLabel setTextColor:[UIColor colorWithRed:255 / 255.0 green:101 / 255.0 blue:76/ 255.0 alpha:1]];
    }else{
        
        [cell.contentLabel setText:[NSString stringWithFormat:@"向[%@][%@]转出%.2f,交易流水号:%@",[dataDic objectForKey:@"destplatform"],[dataDic objectForKey:@"destclient"],[[dataDic objectForKey:@"destmoney"] doubleValue],[dataDic objectForKey:@"tno"]]];
        [cell.moneyLabel setText:[NSString stringWithFormat:@"-%.2f",[[dataDic objectForKey:@"destmoney"] doubleValue]]];
        [cell.moneyLabel setTextColor:[UIColor colorWithRed:0/ 255.0 green:124 / 255.0 blue:0/ 255.0 alpha:1]];
        
    }
    
    
    
    
    
    
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self cancelOpendoor];
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
