//
//  MCJTDetailsViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/8.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCJTDetailsViewController.h"
#import "MCJxViewController.h"
@interface MCJTDetailsViewController ()

@end

@implementation MCJTDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.navigationItem.title = @"奖金包详情";
    [self setData];
    // Do any additional setup after loading the view.
}

- (void)setUI{

    JTcoefficient = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-220,12.5 , 200, 20)];
    JTcoefficient.textAlignment = NSTextAlignmentRight;
    JTcoefficient.text = @"";
    JTcoefficient.font = [UIFont systemFontOfSize:15];
    JTcoefficient.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1];
    
    GRcoefficient = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-220,12.5 , 200, 20)];
    GRcoefficient.textAlignment = NSTextAlignmentRight;
    GRcoefficient.text = @"";
    GRcoefficient.font = [UIFont systemFontOfSize:15];
    GRcoefficient.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1];
    
    bouns = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-220,12.5 , 200, 20)];
    
    
    bouns.textAlignment = NSTextAlignmentRight;
    bouns.text = @"";
    bouns.font = [UIFont systemFontOfSize:15];
    bouns.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1];
    
    
    monthlyPerformance = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-220,12.5 , 200, 20)];
    
    
    monthlyPerformance.textAlignment = NSTextAlignmentRight;
    monthlyPerformance.text = @"查看详情";
    monthlyPerformance.font = [UIFont systemFontOfSize:15];
    monthlyPerformance.textColor = [UIColor colorWithRed:27 / 255.0 green:130 / 255.0 blue:210/ 255.0 alpha:1];
    
    monthlyBouns = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-220,12.5 , 200, 20)];
    
    
    monthlyBouns.textAlignment = NSTextAlignmentRight;
    monthlyBouns.text = @"";
    monthlyBouns.font = [UIFont systemFontOfSize:15];
    monthlyBouns.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1];
    
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];



}

- (void)setData{
//集体
    if ([self.type integerValue] == 0) {
        [bouns setText:[NSString stringWithFormat:@"%.2f",[self.jtDic[@"jthbfee"] floatValue]]];
        NSLog(@"%@",_jtDic);
        [monthlyBouns setText:[NSString stringWithFormat:@"%.2f",[self.jtDic[@"jthbfee"] floatValue]]];
    }else{
       [JTcoefficient setText:[NSString stringWithFormat:@"%.2f",[self.grDic[@"totaljjbbase"] floatValue]]];
    
        [GRcoefficient setText:[NSString stringWithFormat:@"%.2f",[self.grDic[@"jjbbase"] floatValue]]];
        [bouns setText:[NSString stringWithFormat:@"%.2f",[self.grDic[@"fee"] floatValue]]];
        [monthlyBouns setText:[NSString stringWithFormat:@"%.2f",[self.grDic[@"hbfee"] floatValue]]];
    }

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
            return 0.0001;
        }
            break;
            
        default:
        {
            return 0.0011;
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
            return 5;
        }
            break;
            
        default:
        {
            return 1 ;
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
       
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 44, SCREEN_WIDTH-32, 1)];
        line.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230/ 255.0 alpha:1];
        [cell addSubview:line];

        
        switch (indexPath.section)
        {
            case 0:
            {
                switch (indexPath.row)
                {
                    case 2:
                    {[cell.textLabel setText:@"个人奖金包"];
                        [cell addSubview:bouns];

                    }
                        break;
                        
                    case 1:
                    {
                       [cell.textLabel setText:@"个人系数"];
                        [cell addSubview:GRcoefficient];

                    }
                        break;
                        
                    case 0:
                    {
                        [cell.textLabel setText:@"集体系数之和"];
                        [cell addSubview:JTcoefficient];
                                            }
                        break;
                    case 3:
                    {
                        [cell.textLabel setText:@"本月绩效得分"];
                        [cell addSubview:monthlyPerformance];

                    }
                        break;
                    case 4:
                    {
                        [cell.textLabel setText:@"本月实获奖金"];
                        [cell addSubview:monthlyBouns];

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
                case 2:
                {
                    
                    
                }
                    break;
                case 3:
                {
                    MCJxViewController *JXvc = [[MCJxViewController alloc]init];
                    JXvc.type = self.type;
                    if ([self.type integerValue] == 0) {
                        JXvc.jtDic = self.jtDic;
                    }else{
                        JXvc.grDic = self.grDic;
                    }
                    [self.navigationController pushViewController:JXvc animated:YES];
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
