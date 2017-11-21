//
//  MCManagementViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/20.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCManagementViewController.h"
#import "MCManagentTableViewCell.h"
#import "MCGoodsDetailsViewController.h"
@interface MCManagementViewController ()
@property (nonatomic, assign) int page;  //请求页码

@property (nonatomic, strong) UIButton *selectedButton; //接收被选中的按钮
@property (nonatomic ,strong)  UIView *indicateView ;
@property (nonatomic, strong)NSMutableArray *buttonMutableArray;//键： title

@property(nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, assign) int classId;//记录点击某个分类按钮；

@end

@implementation MCManagementViewController
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
    self.navigationItem.title = @"商品管理";
    _btnArray = [NSMutableArray array];
    _page = 1;
    _classId = 0;
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    //    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    
    [self setButton];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadNewData];
}
- (void)setButton{
    
    
    NSArray *stateArray = @[@"实物",@"虚拟",@"服务"];
    
    for (int i = 0; i < stateArray.count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        float buttonW =  self.view.frame.size.width/(stateArray.count*1.0);
        button.frame = CGRectMake(i*buttonW, 0, buttonW, 40);
        // NSDictionary * dict = (NSDictionary *)[array objectAtIndex:i] ;
        
        
        
        
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:[stateArray objectAtIndex:i]  forState:    UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:180 / 255.0 green:180 / 255.0 blue:180 / 255.0 alpha:1]  forState:UIControlStateNormal];
        button.titleLabel.font  = [UIFont systemFontOfSize: 14.0];
        [button setTitleColor:BLUK_COLOR forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000+i;
        if (i == 0)
        {
            button.selected = YES;
            _selectedButton = button;
        }
        
        [self.view addSubview:button];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0+10, 1, 20)];
        line.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        [self.view addSubview:line];
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0+10, 1, 20)];
        line2.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        [self.view addSubview:line2];
        
        //        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 64+5, 1, 30)];
        //        line2.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        //        [self.view addSubview:line2];
        
    }
    
    
    
    //滑动条
    if (_indicateView == nil){
        _indicateView = [[UIView alloc]initWithFrame:CGRectMake(0,0+ 38, SCREEN_WIDTH/3, 2)];
        _indicateView.backgroundColor = BLUK_COLOR;
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
        _indicateView.frame = CGRectMake(button.frame.origin.x, 0 +38, SCREEN_WIDTH/3, 2);
    }];
    
    [self loadNewData];
    
    
}
- (void)loadNewData{

    [SVProgressHUD show];
    
    
    
    NSDictionary *sendDict = @{
                               @"isPlatform":@1,
                               @"page":@1,
                               @"type":@(self.classId),
                               @"pagesize":@10,
                               @"appID":@"colourlife",
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_SHOP urlMethod:@"/commodity" parameters:sendDict success:^(id responseObject) {
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
                               @"type":@(self.classId),
                               @"pagesize":@10,
                               @"appID":@"colourlife",
                               };

    
    
    [MCHttpManager GETWithIPString:BASEURL_SHOP urlMethod:@"/commodity" parameters:sendDict success:^(id responseObject) {
        
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 100;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 1;
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
    MCManagentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCManagentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    [cell.titleLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"name"]]];
    
    CGFloat price = [dataDictionary[@"price"] floatValue];
    CGFloat originalPrice = [dataDictionary[@"originalPrice"] floatValue];
    
    [cell.priceLabel setText:[NSString stringWithFormat:@"供货价: %.2f  建议售价: %.2f",price,originalPrice]];
    
    [cell.salesLabel setText:[NSString stringWithFormat:@"库存: %@  销量: %@",dataDictionary[@"amount"],dataDictionary[@"amount"]]];
    
    if ([dataDictionary[@"state"] integerValue] == 0) {
        [cell.stateButton setBackgroundImage:[UIImage imageNamed:@"shangjia_"] forState:UIControlStateNormal];
    }else{
        
        [cell.stateButton setBackgroundImage:[UIImage imageNamed:@"xiajia"] forState:UIControlStateNormal];
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    NSLog(@"%@",dataDictionary);
    
    MCGoodsDetailsViewController *goodsDetailsViewController = [[MCGoodsDetailsViewController alloc]init];
    goodsDetailsViewController.dataDic = dataDictionary;
        goodsDetailsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailsViewController animated:YES];

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
