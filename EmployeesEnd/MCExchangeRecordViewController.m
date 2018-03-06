//
//  MCExchangeRecordViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/15.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCExchangeRecordViewController.h"
#import "MCExchangeTableViewCell.h"

@interface MCExchangeRecordViewController ()
@property(nonatomic, strong) NSArray *typeButtonArray;

@end

@implementation MCExchangeRecordViewController

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
    self.navigationItem.title = @"兑换记录";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(screening)];
    self.navigationItem.rightBarButtonItem.tag = 0;
    
    totle = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300, 30)];
    totle.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:totle];
    [totle setBackgroundColor:[UIColor clearColor]];
    [totle setTextColor:GRAY_COLOR_ZZ];
    [totle setFont:[UIFont systemFontOfSize:13]];
    
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-64-30) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    //[listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    [self getlistData:@"0"];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *orgToken = [defaults objectForKey:@"orgToken"];
    NSString *username = [defaults objectForKey:@"userName"];
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    
    [sendDictionary setValue:orgToken forKey:@"access_token"];
    
    
    
    
    
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/split/api/appdetail" parameters:sendDictionary success:^(id responseObject) {
        NSDictionary *dicDictionary = responseObject;
        
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
               
                self.typeButtonArray = dicDictionary[@"content"][@"result"];
                
                
                
            }
            
            
            
            
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"message"]];
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    

}
-(void)screening{
   
    if ( self.navigationItem.rightBarButtonItem.tag == 0) {
        
        
        self.navigationItem.rightBarButtonItem.tag = 1;
       
        if (self.typeButtonArray.count>0) {
            [self setSxUI];
        }else{
            [SVProgressHUD showErrorWithStatus:@"暂无商户类目"];
            
        }

      
        
    }else{
         self.navigationItem.rightBarButtonItem.tag = 0;
        [backView removeFromSuperview];
        [oderView removeFromSuperview];
    
    }

    

}

-(void)setSxUI{
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor =[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0/ 255.0 alpha:0.1];
    [self.view addSubview:backView];
    
    
    
    
    NSUInteger i = self.typeButtonArray.count;
    oderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (i-1)/3 *70*SCREEN_WIDTH/375 +70*SCREEN_WIDTH/375+40)];
    oderView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:oderView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH, 20)];
    label.text = @"选择应用";
    label.textColor = GRAY_COLOR_ZZ;
    label.font = [UIFont systemFontOfSize:14];
    [oderView addSubview:label];
    
    [self setOderType];

}
-(void)setOderType{
    
    for (int i = 0; i < self.typeButtonArray.count; i++)
    {
        
        UIButton *TtypeButton = [[UIButton alloc]initWithFrame:CGRectMake((i % 3) * (20+ (SCREEN_WIDTH-20*4)/3)+20,(i / 3)*(60) +40,(SCREEN_WIDTH-20*4)/3, 40*SCREEN_WIDTH/375)];
        [oderView addSubview:TtypeButton];
        TtypeButton.backgroundColor =[UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
        
        [TtypeButton setTitle:[[self.typeButtonArray objectAtIndex:i] objectForKey:@"general_name"]  forState:UIControlStateNormal];
        [TtypeButton setTitleColor: [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1]  forState:UIControlStateNormal];
        [TtypeButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [TtypeButton setTitleColor:BLUK_COLOR_ZAN_MC forState:UIControlStateSelected];
        
        
        [TtypeButton setTag:i];
        [TtypeButton addTarget:self action:@selector(clickTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
   
    
}
-(void)clickTypeButton:(UIButton *)button{
    
self.navigationItem.rightBarButtonItem.tag = 0;
    [backView removeFromSuperview];
    [oderView removeFromSuperview];
   
    NSString *general_uuid = [[self.typeButtonArray objectAtIndex:button.tag] objectForKey:@"general_uuid"];
    [self getlistData:general_uuid];

}
#pragma mark- 兑换列表数据获取
-(void)getlistData:(NSString *)general_uuid{
    
    [labelw removeFromSuperview];
    [imagew removeFromSuperview];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *orgToken = [defaults objectForKey:@"orgToken"];
    NSString *username = [defaults objectForKey:@"userName"];
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:general_uuid forKey:@"general_uuid"];
    [sendDictionary setValue:username forKey:@"split_target"];//账号
    [sendDictionary setValue:orgToken forKey:@"access_token"];
    [sendDictionary setValue:@2 forKey:@"split_type"];
    [sendDictionary setValue:@1 forKey:@"page"];
    [sendDictionary setValue:@99999 forKey:@"page_size"];
    NSLog(@"%@",sendDictionary);
    
    
    
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/split/api/account/withdrawals" parameters:sendDictionary success:^(id responseObject) {
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            
            if ([dicDictionary[@"content"][@"result"][@"data"] isKindOfClass:[NSArray class]])
            {
                
                [listMutableArray setArray:dicDictionary[@"content"][@"result"][@"data"]];
                [listTableView reloadData];
                if (listMutableArray.count == 0) {
                    imagew = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70)/2, 100, 70, 70)];
                    [imagew setImage:[UIImage imageNamed:@"sp_wugg"]];
                    [self.view addSubview:imagew];
                    
                    labelw = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(imagew)+10, SCREEN_WIDTH, 20)];
                    labelw.text = @"当前暂无数据";
                    labelw.textAlignment = NSTextAlignmentCenter;
                    labelw.textColor = GRAY_COLOR_BACK_ZZ;
                    [self.view addSubview:labelw];
                    
                }else{
                    [listTableView reloadData];
                    [totle setText:[NSString stringWithFormat:@"支出:%.2f",[dicDictionary[@"content"][@"result"][@"withdraw_money"] floatValue]]];
                }

                
                
            }
            
            
            
            
        }else{
            
            
            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"message"]];
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UILabel *bgView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    //    bgView.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    //    bgView.textAlignment = NSTextAlignmentCenter;
    //    bgView.font = [UIFont systemFontOfSize:14];
    //    bgView.text = @"--把社区服务做到家--";
    
    return bgView;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
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
    MCExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCExchangeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    NSDictionary *dataDic = [listMutableArray objectAtIndex:indexPath.row];
    [cell.nameLabel setText:[NSString stringWithFormat:@"%@",dataDic[@"general_name"]]];
    [cell.dateLabel setText:[NSString stringWithFormat:@"%@",dataDic[@"create_at"]]];
     [cell.moneyLabel setText:[NSString stringWithFormat:@"%.2f",[dataDic[@"amount"] floatValue]]];
    NSString *state = [NSString stringWithFormat:@"%@",dataDic[@"state"]];
    switch ([state integerValue]) {
        case 1:
        {
        cell.stateLabel.text = @"状态:未处理";
         cell.stateLabel.textColor=   [UIColor colorWithRed:227 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1];
        
        }
            break;
        case 2:
        {
            cell.stateLabel.text = @"状态:成功";
            cell.stateLabel.textColor =[UIColor colorWithRed:0 / 255.0 green:149 / 255.0 blue:91 / 255.0 alpha:1];
            
        }
            break;
        case 3:
        {
            cell.stateLabel.text = @"状态:失败";
             cell.stateLabel.textColor=[UIColor colorWithRed:227 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1];
        }
            break;
            
        default:
            break;
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
