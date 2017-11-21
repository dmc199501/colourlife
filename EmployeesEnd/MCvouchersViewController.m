//
//  MCvouchersViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/23.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCvouchersViewController.h"
#import "MCvouchersTableViewCell.h"
@interface MCvouchersViewController ()
@property(nonatomic,assign)NSInteger type;
@property (nonatomic, assign) int page;  //请求页码
@end

@implementation MCvouchersViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        total = 0;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"验证记录";
    _page = 1;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    [self.view addSubview:backView];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *startLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, 100, 20)];
    startLabel.text = @"开始日期";
    startLabel.font = [UIFont systemFontOfSize:14];
    startLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:startLabel];
    
    UILabel *endLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 75, 100, 20)];
    endLabel.text = @"结束日期";
    endLabel.font = [UIFont systemFontOfSize:14];
    endLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:endLabel];
    
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(130, 22,150, 35)];
    [backView addSubview:startButton];
    [startButton setBackgroundImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
    startButton.tag = 1001;
    
    [startButton addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *endButton = [[UIButton alloc]initWithFrame:CGRectMake(130, 70, 150, 35)];
    [backView addSubview:endButton];
    [endButton setBackgroundImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
    endButton.tag = 1002;
    
    [endButton addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    beginDateTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 100, 35)];
    [beginDateTextField setPlaceholder:@"请选择"];
    [beginDateTextField setTextAlignment:NSTextAlignmentLeft];
    [beginDateTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [beginDateTextField setBackgroundColor:[UIColor clearColor]];
    [beginDateTextField setFont:[UIFont systemFontOfSize:14]];
    [beginDateTextField setDelegate:self];
    [beginDateTextField setUserInteractionEnabled:NO];
    [beginDateTextField setTextColor:BLACK_COLOR_ZZ];
    [startButton addSubview:beginDateTextField];
    
    
    endDateTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 100, 35)];
    [endDateTextField setPlaceholder:@"请选择"];
    [endDateTextField setTextAlignment:NSTextAlignmentLeft];
    [endDateTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [endDateTextField setBackgroundColor:[UIColor clearColor]];
    [endDateTextField setFont:[UIFont systemFontOfSize:14]];
    [endDateTextField setDelegate:self];
    [endDateTextField setUserInteractionEnabled:NO];
    [endDateTextField setTextColor:BLACK_COLOR_ZZ];
    [endButton addSubview:endDateTextField];

    
    
    UIButton *promoteButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 120, SCREEN_WIDTH-40, 40)];
    [backView addSubview:promoteButton];
    [promoteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [promoteButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    promoteButton.titleLabel.font = [UIFont systemFontOfSize:13];
    //[promoteButton.layer setBorderWidth:1];
    [promoteButton.layer setCornerRadius:5];
    
    promoteButton.backgroundColor = BLUK_COLOR;
    
    [promoteButton setTitle:@"点击查询" forState:UIControlStateNormal];
    
    
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setTableHeaderView:backView];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    listTableView.scrollEnabled = YES;
    
    [self loadNewData];
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
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

    
    // Do any additional setup after loading the view.
}
- (void)submit{
    if ([beginDateTextField.text length] == 0 )
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请选择开始日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([endDateTextField.text length] == 0 )
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请选择结束日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    NSDictionary *sendDict = @{
                               @"isPlatform":@1,
                               @"page":@1,
                               @"btime":beginDateTextField.text,
                               @"etime":endDateTextField.text,
                               @"pagesize":@10,
                               @"appID":@"colourlife",
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_SHOP urlMethod:@"/orders/getcommoditycodeByInfo" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                [listMutableArray setArray:dicDictionary[@"content"][@"data"]];
                [listTableView reloadData];
                //[self setRedView];
                [listTableView.mj_header endRefreshing];
                
                
            }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       }else{
                
                
                [listMutableArray setArray:dicDictionary[@"content"][@"data"]];
                NSLog(@"%@",listMutableArray);
                
                [listTableView reloadData];
                [listTableView.mj_header endRefreshing];
                
            }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    


}
- (void)loadNewData{

    NSDictionary *sendDict = @{
                               @"isPlatform":@1,
                               @"page":@1,
                               @"pagesize":@10,
                               @"appID":@"colourlife",
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_SHOP urlMethod:@"/orders/getcommoditycodeByInfo" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                [listMutableArray setArray:dicDictionary[@"content"][@"data"]];
                [listTableView reloadData];
                //[self setRedView];
                [listTableView.mj_header endRefreshing];
                
                
            }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       }else{
                
                
                [listMutableArray setArray:dicDictionary[@"content"][@"data"]];
                NSLog(@"%@",listMutableArray);
                
                [listTableView reloadData];
                [listTableView.mj_header endRefreshing];
                
            }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
               
        
    }];
    
    


}

- (void)loadMoreData{
    _page += 1;
    
    NSDictionary *sendDict = @{
                               @"isPlatform":@1,
                               @"page":@(_page),
                               @"pagesize":@10,
                               @"appID":@"colourlife",
                               };
    
    
    
    [MCHttpManager GETWithIPString:BASEURL_SHOP urlMethod:@"/orders/getcommoditycodeByInfo" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])                                                                                                                                                                                     {
                
                [listMutableArray addObjectsFromArray:dicDictionary[@"content"][@"data"]] ;
                NSLog(@"%@",listMutableArray);
                [listTableView reloadData];
                [listTableView.mj_footer endRefreshing];
                
                total = (int)[[responseObject objectForKey:@"total"] integerValue];
                
            }
            
        }else{
            
            ;
            
            [listTableView reloadData];
            [listTableView.mj_footer endRefreshing];
            
        }
        
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    


}
- (void)chooseDate:(UIButton *)button{
    self.type = button.tag;
    ZZDatePickerView *pickerView = [[ZZDatePickerView alloc]initWithFrame:self.view.bounds];
    pickerView.delegate = self;
    [pickerView showInView:self.view animation:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)datePickerView:(ZZDatePickerView *)datePickerView  finishFirstComponentRow:(NSInteger)row;
{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLog(@"%@",formatter);
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:[datePickerView.choosePickerView date]];
    NSLog(@"%ld",self.currentSelectIndexPath.row);
    if (self.type == 1001) {
        [beginDateTextField setText:dateString];
    }else{
    [endDateTextField setText:dateString];
    }
        [datePickerView dismissAnimation:YES];
    
}
- (void)datePickerView:(ZZDatePickerView *)datePickerView  cancelFirstComponentRow:(NSInteger)row;
{
    [datePickerView dismissAnimation:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 170;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 100;
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
    MCvouchersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCvouchersTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    [cell.wordLabel setText:[NSString stringWithFormat:@"券码密码: %@",dataDictionary[@"useCede"]]];
    [cell.nameLabel setText:[NSString stringWithFormat:@"商品名称: %@",dataDictionary[@"cName"]]];
    [cell.priceLabel setText:[NSString stringWithFormat:@"商品价格: %@元",dataDictionary[@"cPrice"]]];
    [cell.timeLabel setText:[NSString stringWithFormat:@"验证时间: %@",dataDictionary[@"useTime"]]];
    [cell.userLabel setText:[NSString stringWithFormat:@"购买用户: %@",dataDictionary[@"uname"]]];
    
    if ([dataDictionary[@"state"] integerValue] == 0) {
        cell.stateLabel.text = @"已消费";
        cell.stateLabel.textColor = ORANGE_COLOR_ZZ;
    }else{
    
        cell.stateLabel.text = @"已验证";
        cell.stateLabel.textColor = BLUK_COLOR;
    }
    
    return cell;
    
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
