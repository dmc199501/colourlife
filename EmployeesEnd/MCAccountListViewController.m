//
//  MCAccountListViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/27.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCAccountListViewController.h"
#import "MCFPTableViewCell.h"
@interface MCAccountListViewController ()
@property (nonatomic, assign) int page;  //请求页码

@property (nonatomic, strong) UIButton *selectedButton; //接收被选中的按钮
@property (nonatomic ,strong)  UIView *indicateView ;
@property (nonatomic, strong)NSMutableArray *buttonMutableArray;//键： title

@property(nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, assign) int classId;//记录点击某个分类按钮；
@end

@implementation MCAccountListViewController
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
    
    self.navigationItem.title = @"即时分成明细";
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    backView.backgroundColor = [UIColor colorWithWhite:242 / 255.0 alpha:1];
    
    srlabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, SCREEN_WIDTH-40, 20)];
    srlabel.textAlignment = NSTextAlignmentLeft;
    
    [srlabel setBackgroundColor:[UIColor clearColor]];
    [srlabel setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
    [srlabel setFont:[UIFont systemFontOfSize:13]];
    srlabel.text =[NSString stringWithFormat:@"总收入:%@",self.money] ;
    [backView addSubview:srlabel];
    
    
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-64-50) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    //    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    [listTableView setTableHeaderView:backView];
    
    image = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 100, 100, 100)];
    [image setImage:[UIImage imageNamed:@"暂未开放"]];
    
    image2 = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 100, 100, 100)];
    [image2 setImage:[UIImage imageNamed:@"暂未获得收入"]];
    [self.view addSubview:image2];
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
    
    
    NSArray *stateArray = @[@"分成收入",@"领取记录"];
    
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
    
    
    if(_classId == 0){
        
        srlabel.hidden = NO;
        
    }else{
        
         srlabel.hidden = YES;
        
    }

    [self getData];
    
}
- (void)loadMoreData{
    
    if (_classId ==1) {
        
        [listTableView reloadData];
        //[listTableView setHidden:YES];
        image.hidden = NO;
        
        [self.view addSubview:image];
        [listTableView.mj_footer endRefreshing];

    }else{
        
        _page += 1;
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        
        NSString *username = [defaults objectForKey:@"userName"];

        NSDictionary *sendDict = @{
                                   @"page":@(_page),
                                   @"pagesize":@10,
                                @"access_token":@"1521ac83521b8063e7a9a49dc22e79b0",
                                   @"target_type":@2,
                                   @"target":username
                                   };
        
        [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/splitdivide/api/bill" parameters:sendDict success:^(id responseObject) {
            
            NSDictionary *dicDictionary = responseObject;
            NSLog(@"%@",dicDictionary);
            if ([dicDictionary[@"code"] integerValue] == 0 )
            {
                if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
                {
                    [listMutableArray addObjectsFromArray:dicDictionary[@"content"]];
                    
                    
                    [listTableView reloadData];
                    [listTableView.mj_footer endRefreshing];
                    
                }
                
            }else{
                [listMutableArray addObjectsFromArray:dicDictionary[@"content"][@"receive"]];
                
                
                [listTableView reloadData];
                [listTableView.mj_footer endRefreshing];
            }
            
            
            
            
        } failure:^(NSError *error) {
            
            
            NSLog(@"****%@", error);
                        
            
        }];
        
        
        
        
        
    }
    
    
}
- (void)getData{
     image.hidden = YES;
    image2.hidden = YES;
    
    if (_classId == 0) {
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        
        NSString *username = [defaults objectForKey:@"userName"];

        NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
        
        [sendDictionary setValue:@"1521ac83521b8063e7a9a49dc22e79b0" forKey:@"access_token"];
        [sendDictionary setValue:@1 forKey:@"page"];
        [sendDictionary setValue:@10 forKey:@"pagesize"];
        [sendDictionary setValue:username forKey:@"target"];
         [sendDictionary setValue:@2 forKey:@"target_type"];
        
        NSLog(@"%@",sendDictionary);
        [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/splitdivide/api/bill" parameters:sendDictionary success:^(id responseObject) {
           
            NSDictionary *dicDictionary = responseObject;
            NSLog(@"%@",dicDictionary);
            if ([dicDictionary[@"code"] integerValue] == 0 )
            {
                if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
                   
                
                {
                     NSArray *array = dicDictionary[@"content"];
                    
                    
                    if (array.count>0) {
                        [listMutableArray setArray:dicDictionary[@"content"]];
                        [listTableView reloadData];
                        //[self setRedView];
                        [listTableView.mj_header endRefreshing];

                    }else{
                    
                        [listMutableArray setArray:dicDictionary[@"content"]];
                        [listTableView reloadData];
                        //[self setRedView];
                        [listTableView.mj_header endRefreshing];
                       
                        image2.hidden = NO;
                        
                        
                    
                    }
                    
                   
                    
                }
                
                return ;
                
                
                
            }else{
//                [listMutableArray setArray:dicDictionary[@"content"]];
//                [listTableView reloadData];
                //[self setRedView];
                [listTableView.mj_header endRefreshing];

                
            }
            
            
            NSLog(@"----%@",responseObject);
            
        } failure:^(NSError *error) {
            
            NSLog(@"****%@", error);
            
        }];

        
        
    }else{
        
        [listTableView reloadData];
        //[listTableView setHidden:YES];
        image.hidden = NO;
        
        [self.view addSubview:image];
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (_classId == 0) {
        return listMutableArray.count;
    }else{
    
        return 0;
    }
    
    
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
                       [cell.moneyLabel setText:[NSString stringWithFormat:@"%.2f",[dic[@"money"] floatValue]]];
            [cell.titleLabel setText:[NSString stringWithFormat:@"%@",dic[@"station_name"]]];
            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
            CGSize size=[cell.titleLabel.text sizeWithAttributes:attrs];
            
            cell.LYlabel.hidden = NO;
            cell.LYlabel.frame =CGRectMake(16 + size.width +20,42 , SCREEN_WIDTH-40, 20);
            
            [cell.LYlabel setText:[NSString stringWithFormat:@"%@",dic[@"tag_name"]]];
            
            [cell.contentLabel setText:[NSString stringWithFormat:@"订单号:%@",dic[@"pay"]]];
            [cell.contentLabel2 setText:[NSString stringWithFormat:@"应用:%@",dic[@"app_name"]]];
            //NSString  *overTimeStr =  [self ConvertStrToTime:dic[@"time_at"]];
            [cell.dateLabel setText:[NSString stringWithFormat:@"%@",dic[@"time_at"]]];
            
            if (_classId == 0) {
                cell.moneyLabel.textColor = [UIColor colorWithRed:241 / 255.0 green:115 / 255.0 blue:94/ 255.0 alpha:1];
                [cell.moneyLabel setText:[NSString stringWithFormat:@"%.2f",[dic[@"money"] floatValue]]];
                cell.moneyLabel.frame = CGRectMake(SCREEN_WIDTH-230, 40, 200, 20);
            }else{
                //[cell.moneyLabel setTextColor:[UIColor colorWithRed:233 / 255.0 green:176 / 255.0 blue:38/ 255.0 alpha:1]];
                [cell.moneyLabel setText:[NSString stringWithFormat:@"%.2f",[dic[@"money"] floatValue]]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
