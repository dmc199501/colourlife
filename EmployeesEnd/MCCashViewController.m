//
//  MCCashViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/24.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCCashViewController.h"

@interface MCCashViewController ()

@end

@implementation MCCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现申请";
    
    _priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 220, 0, 195, 45)];
    [_priceTextField setPlaceholder:@"请输入提现金额"];
    [_priceTextField setTextAlignment:NSTextAlignmentRight];
    [_priceTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_priceTextField setBackgroundColor:[UIColor clearColor]];
    [_priceTextField setFont:[UIFont systemFontOfSize:14]];
    [_priceTextField setUserInteractionEnabled:YES];

    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -34, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    //[listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    listTableView.scrollEnabled = NO;
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 180, SCREEN_WIDTH, 20)];
    [label setText:@"温馨提示:"];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 200, SCREEN_WIDTH, 20)];
    [label2 setText:@"1.平台结算日为每月15日,结算日后商家可对上月金额进行提现"];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    label2.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 220, SCREEN_WIDTH, 20)];
    [label3 setText:@"2.每月每个商家账号提现次数为1次"];
    label3.textAlignment = NSTextAlignmentLeft;
    label3.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    label3.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(15, 240, SCREEN_WIDTH, 20)];
    [label4 setText:@"3.提现金额必须为整数，且大于100"];
    label4.textAlignment = NSTextAlignmentLeft;
    label4.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    label4.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label4];
    
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(15, 260, SCREEN_WIDTH, 20)];
    [label5 setText:@"4.提现银行卡默认为绑定银行卡"];
    label5.textAlignment = NSTextAlignmentLeft;
    label5.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    label5.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label5];
    
    
    
    UIButton *promoteButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 290, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:promoteButton];
    [promoteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [promoteButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    promoteButton.titleLabel.font = [UIFont systemFontOfSize:13];
    //[promoteButton.layer setBorderWidth:1];
    [promoteButton.layer setCornerRadius:5];
    
    promoteButton.backgroundColor = BLUK_COLOR;
    
    [promoteButton setTitle:@"提交申请" forState:UIControlStateNormal];

    
    
    // Do any additional setup after loading the view.
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
                    return 80;
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
            return 3;
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
    NSString *indentifier = [NSString stringWithFormat:@"cell%@%@",@(indexPath.section), @(indexPath.row)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        [cell.textLabel setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
        
        switch (indexPath.section)
        {
            case 0:
            {
                switch (indexPath.row)
                {
                        
                    case 0:
                    {
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH, 20)];
                        [label setText:@"可用余额"];
                        label.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        
                        
                        
                        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-220, 40, 200, 40)];
                        [label2 setText:@"100.00"];
                        label2.textAlignment = NSTextAlignmentRight;
                        label2.textColor = BLUK_COLOR;
                        label2.font = [UIFont systemFontOfSize:30];
                        [cell addSubview:label2];
                    }
                        break;
                    case 1:
                    {
                        
                        
                        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 22, 17, 8, 10)];
                        [arrowImageView setImage:[UIImage imageNamed:@"huise"]];
                        [cell addSubview:arrowImageView];
                         [cell.textLabel setText:@"选择银行卡"];
                       
                        
                    }
                        break;
                        
                    case 2:
                    {
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH, 20)];
                        [label setText:@"提现金额"];
                        label.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
                        label.font = [UIFont systemFontOfSize:13];
                        [cell addSubview:label];
                        [cell addSubview:_priceTextField];
                        
                        
                        
                    }
                        break;
                        
                    case 3:
                    {
                        
                        
                    }
                        break;
                        
                    case 4:
                    {
                                           }
                        break;
                    case 5:
                    {
                        
                                           }
                        break;
                    case 6:
                    {
                        
                       
                        
                    }
                        break;
                        
                    default:
                        break;
                }
                
                
            }
                break;
                
            case 1:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                       
                    }
                        break;
                        
                    case 1:
                    {
                    }
                        break;
                        
                    case 2:
                    {
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
            default:
            {
                
            }
                break;
        }
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
//    _currentSelectIndexPath = indexPath;
    
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                }
                    break;
                case 1:
                {
                    
                    
                }
                    break;
                case 3:
                {
                    
                    
                }
                    break;
                case 4:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        case 1:
        {
            switch (indexPath.row)
            {
                case 0://地址
                {
                    
                }
                    
                    break;
                case 2://修改密码
                {
                    
                    
                    
                }
                    break;
                    
            }
            break;
            
        default:
            {
                
            }
            break;
        }
    }
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
