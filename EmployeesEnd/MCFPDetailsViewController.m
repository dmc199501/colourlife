//
//  MCFPDetailsViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/9.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCFPDetailsViewController.h"
#import "MCFPTableViewCell.h"
@interface MCFPDetailsViewController ()
@property (nonatomic, assign) int page;  //请求页码

@property (nonatomic, strong) UIButton *selectedButton; //接收被选中的按钮
@property (nonatomic ,strong)  UIView *indicateView ;
@property (nonatomic, strong)NSMutableArray *buttonMutableArray;//键： title

@property(nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, assign) int classId;//记录点击某个分类按钮；

@end

@implementation MCFPDetailsViewController
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
    _page = 1;

    self.navigationItem.title = @"饭票收支明细";
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    backView.backgroundColor = [UIColor colorWithWhite:242 / 255.0 alpha:1];
    
    srlabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, SCREEN_WIDTH-40, 20)];
    srlabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:srlabel];
    [srlabel setBackgroundColor:[UIColor clearColor]];
    [srlabel setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
    [srlabel setFont:[UIFont systemFontOfSize:13]];
   
    
    
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-64-50) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    //    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    [listTableView setTableHeaderView:backView];
    [self getData];
    [self therRefresh];
    [self setButton];
    
    
    // Do any additional setup after loading the view.
}

- (void)therRefresh{
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    
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

- (void)setButton{
    
    
    NSArray *stateArray = @[@"收入",@"支出"];
    
    for (int i = 0; i < stateArray.count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        float buttonW =  self.view.frame.size.width/(stateArray.count*1.0);
        button.frame = CGRectMake(i*buttonW, 0, buttonW, 50);
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
        
        [self.view addSubview:button];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0+5, 1, 30)];
        line.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:line];
        
        //        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 64+5, 1, 30)];
        //        line2.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        //        [self.view addSubview:line2];
        
    }
    
    
    
    //滑动条
    if (_indicateView == nil){
        _indicateView = [[UIView alloc]initWithFrame:CGRectMake(0,0+ 48, SCREEN_WIDTH/2, 2)];
        _indicateView.backgroundColor = [UIColor colorWithRed:41 / 255.0 green:161 / 255.0 blue:247 / 255.0 alpha:1];
        [self.view addSubview:_indicateView];
    }
    
    
}

- (void)buttonClicked:(UIButton *)button
{
    
    _selectedButton.selected = NO; //先取消上一个按钮的选择状态
    button.selected = YES;
    _selectedButton = button;
    
    
    
    _classId = (int)button.tag - 1000 ;
    [UIView animateWithDuration:0.5 animations:^{
        _indicateView.frame = CGRectMake(button.frame.origin.x+0, 0 +48, button.frame.size.width, 2);
    }];
    
    
    [self getData];
    
}
- (void)loadMoreData{
    
    if (_classId ==1) {
        _page += 1;
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *key = [defaults objectForKey:@"key"];
        NSString *secret = [defaults objectForKey:@"secret"];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setValue:@(_page) forKey:@"page"];
        [dic setValue:@10 forKey:@"pagesize"];
        [dic setValue:key forKey:@"key"];
        [dic setValue:secret forKey:@"secret"];
        
        [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/redPacketExpend" parameters:dic success:^(id responseObject) {
            
            NSDictionary *dicDictionary = responseObject;
            NSLog(@"%@",dicDictionary);
            if ([dicDictionary[@"code"] integerValue] == 0 )
            {
                if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
                {
                    [listMutableArray addObjectsFromArray:dicDictionary[@"content"][@"expend"]];
                    [listTableView reloadData];
                    [listTableView.mj_footer endRefreshing];
                    
                }
                
            }else{
               
                [listTableView.mj_footer endRefreshing];
            }
            
            
            
            
        } failure:^(NSError *error) {
            
            
            NSLog(@"****%@", error);
           
            
            
        }];

        
    }else{
        
        _page += 1;
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *key = [defaults objectForKey:@"key"];
        NSString *secret = [defaults objectForKey:@"secret"];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@(_page) forKey:@"page"];
        [dic setValue:@10 forKey:@"pagesize"];
        [dic setValue:key forKey:@"key"];
        [dic setValue:secret forKey:@"secret"];

        
        [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/redPacketReceive" parameters:dic success:^(id responseObject) {
            
            NSDictionary *dicDictionary = responseObject;
            NSLog(@"%@",dicDictionary);
            if ([dicDictionary[@"code"] integerValue] == 0 )
            {
                if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
                {
                    [listMutableArray addObjectsFromArray:dicDictionary[@"content"][@"receive"]];
                    
                    
                    [listTableView reloadData];
                    [listTableView.mj_footer endRefreshing];
                    
                }
                
            }else{
                
                [listTableView.mj_footer endRefreshing];
            }
            
            
            
            
        } failure:^(NSError *error) {
            
            
            NSLog(@"****%@", error);
            
            
            
        }];

    
        

    
    }
    
    
}
- (void)getData{
    if (_classId == 0) {
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *key = [defaults objectForKey:@"key"];
        NSString *secret = [defaults objectForKey:@"secret"];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@1 forKey:@"page"];
        [dic setValue:@10 forKey:@"pagesize"];
        [dic setValue:key forKey:@"key"];
        [dic setValue:secret forKey:@"secret"];

                [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/redPacketReceive" parameters:dic success:^(id responseObject) {
            
            NSDictionary *dicDictionary = responseObject;
            NSLog(@"%@",dicDictionary);
            if ([dicDictionary[@"code"] integerValue] == 0 )
            {
                if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
                {
                    
                    [listMutableArray setArray:dicDictionary[@"content"][@"receive"]];
                    [listTableView reloadData];
                    //[self setRedView];
                    [listTableView.mj_header endRefreshing];
                    
                }
                
            }else{
//
                [listTableView.mj_header endRefreshing];
                
            }
            
            
            
            
        } failure:^(NSError *error) {
            
            
            NSLog(@"****%@", error);
            
            
            
        }];
        

        
    }else{
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *key = [defaults objectForKey:@"key"];
        NSString *secret = [defaults objectForKey:@"secret"];
        
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@1 forKey:@"page"];
        [dic setValue:@10 forKey:@"pagesize"];
        [dic setValue:key forKey:@"key"];
        [dic setValue:secret forKey:@"secret"];
        [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/redPacketExpend" parameters:dic success:^(id responseObject) {
            
            NSDictionary *dicDictionary = responseObject;
            NSLog(@"%@",dicDictionary);
            if ([dicDictionary[@"code"] integerValue] == 0 )
            {
                if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
                {
                    
                    [listMutableArray setArray:dicDictionary[@"content"][@"expend"]];
                    if (listMutableArray.count>0) {
                        srlabel.text =[NSString stringWithFormat:@"支出:%@",dicDictionary[@"content"][@"expend"][0][@"total"]] ;
                    }else{
                     srlabel.text =[NSString stringWithFormat:@"支出:%@",@"0"] ;
                    
                    }
                    [listTableView reloadData];
                    //[self setRedView];
                    [listTableView.mj_header endRefreshing];
                    
                }
                
            }else{
                
                [listTableView.mj_header endRefreshing];
                
            }
            
            
            
            
        } failure:^(NSError *error) {
            
            
            NSLog(@"****%@", error);
            
            
            
        }];

    
       
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 140;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    return footView;
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
    
          return listMutableArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    static NSString *indentifier = @"cell";
    MCFPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCFPTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    if (listMutableArray.count >0) {
        NSDictionary *dic = [listMutableArray objectAtIndex:indexPath.row];
        
        if(_classId == 0){
            
            srlabel.text =[NSString stringWithFormat:@"收入:%@",dic[@"total"]] ;
        }else{
            
            srlabel.text =[NSString stringWithFormat:@"支出:%@",dic[@"total"]] ;
            
        }
        [cell.moneyLabel setText:[NSString stringWithFormat:@"%.2f",[dic[@"sum"] floatValue]]];
        [cell.titleLabel setText:[NSString stringWithFormat:@"%@",dic[@"typeName"]]];
        [cell.contentLabel setText:[NSString stringWithFormat:@"%@",dic[@"note"]]];
        [cell.contentLabel2 setText:[NSString stringWithFormat:@"%@",dic[@"remark"]]];
        NSString  *overTimeStr =  [self ConvertStrToTime:dic[@"create_time"]];
        [cell.dateLabel setText:[NSString stringWithFormat:@"%@",overTimeStr]];
        
        if (_classId == 1) {
            cell.moneyLabel.textColor = [UIColor colorWithRed:241 / 255.0 green:115 / 255.0 blue:94/ 255.0 alpha:1];
            [cell.moneyLabel setText:[NSString stringWithFormat:@"-%.2f",[dic[@"sum"] floatValue]]];
        }else{
            [cell.moneyLabel setTextColor:[UIColor colorWithRed:233 / 255.0 green:176 / 255.0 blue:38/ 255.0 alpha:1]];
            [cell.moneyLabel setText:[NSString stringWithFormat:@"+%.2f",[dic[@"sum"] floatValue]]];
        }

    }
    
       return cell;
    
}
-(NSString *)ConvertStrToTime:(NSString *)timeStr
//timeStr毫秒字段
{
    
    NSString *date             = timeStr; //时间戳
    NSDate *confromTimesp      = [NSDate dateWithTimeIntervalSince1970:[date longLongValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateOutput       = [formatter stringFromDate:confromTimesp];

    
    return dateOutput;
    
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
