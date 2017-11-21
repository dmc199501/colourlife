//
//  MCCGViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/15.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCCGViewController.h"

@interface MCCGViewController ()

@end

@implementation MCCGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, 50, 60, 60)];
    [icon setImage:[UIImage imageNamed:@"chenggong"]];
    [self.view addSubview:icon];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(icon)+10, SCREEN_WIDTH, 20)];
    
    label.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:15]];
    label.text = @"提现申请已经提交";
    
    [self.view addSubview:label];
    
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(label)+10, self.view.frame.size.width, self.view.frame.size.height  - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    //    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
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
                        [cell.textLabel setText:@"储蓄卡"];
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-185, 12.5, 150, 20)];
                        label.textAlignment = NSTextAlignmentRight;
                        label.font = [UIFont systemFontOfSize:13];
                        [label setTextColor:GRAY_COLOR_ZZ];
                        [cell addSubview:label];
                        label.text = self.card;
                                            }
                        break;
                        
                    case 5:
                    {
                        //                        [cell.textLabel setText:@"意见反馈"];
                        //                        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 22, 17, 10, 10)];
                        //                        [arrowImageView setImage:[UIImage imageNamed:@"huise"]];
                        //                        [cell addSubview:arrowImageView];
                    }
                        break;
                        
                    case 1:
                    {
                        [cell.textLabel setText:@"提现金额"];
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-185, 12.5, 150, 20)];
                        label.textAlignment = NSTextAlignmentRight;
                        label.font = [UIFont systemFontOfSize:13];
                        [label setTextColor:GRAY_COLOR_ZZ];
                        [cell addSubview:label];
                        label.text = self.money;
                        
                    }
                        break;
                    case 2:
                    {
                        [cell.textLabel setText:@"到账金额"];
                        
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-185, 12.5, 150, 20)];
                        label.textAlignment = NSTextAlignmentRight;
                        label.font = [UIFont systemFontOfSize:13];
                        [label setTextColor:GRAY_COLOR_ZZ];
                        [cell addSubview:label];
                        label.text = self.money2;
                                            }
                        break;
                    case 3:
                    {
                        [cell.textLabel setText:@"版本检测"];
                        
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-185, 12.5, 150, 20)];
                        label.textAlignment = NSTextAlignmentRight;
                        label.font = [UIFont systemFontOfSize:13];
                        [label setTextColor:GRAY_COLOR_ZZ];
                        [cell addSubview:label];
                        label.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
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
