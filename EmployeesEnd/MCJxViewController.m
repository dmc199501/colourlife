//
//  MCJxViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/8.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCJxViewController.h"
#import "MCJXMTableViewCell.h"
@interface MCJxViewController ()

@end

@implementation MCJxViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        JXlistMutableArray = [NSMutableArray array];
        JFlistMutableArray = [NSMutableArray array];
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    if ([self.type integerValue]==0) {
        JXlistMutableArray = [self.jtDic objectForKey:@"hbdata"];
        JFlistMutableArray = [self.jtDic objectForKey:@"kkdata"];
    }else{
    
        JXlistMutableArray = [self.grDic objectForKey:@"hbdata"];
        JFlistMutableArray = [self.grDic objectForKey:@"kkdata"];
    }
    
    [self setUI];

    

    // Do any additional setup after loading the view.
}

- (void)setUI{
  
    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    back.backgroundColor = [UIColor colorWithWhite:242 / 255.0 alpha:1];
    UILabel * month =  [[UILabel alloc]initWithFrame:CGRectMake(16, 10, SCREEN_WIDTH, 20)];
    month.textColor = [UIColor colorWithRed:86 / 255.0 green:86 / 255.0 blue:86/ 255.0 alpha:1];
    month.backgroundColor = [UIColor clearColor];
    month.textAlignment = NSTextAlignmentLeft;
    [month setFont:[UIFont systemFontOfSize:15]];
    NSLog(@"%@",self.type);
    if ([self.type integerValue] == 0) {
        NSLog(@"%@----",self.jtDic);
        [month setText:[NSString stringWithFormat:@"%@年-%@月",self.jtDic[@"year"],self.jtDic[@"month"]]];
    }else{
        
        [month setText:[NSString stringWithFormat:@"%@年-%@月",self.grDic[@"year"],self.grDic[@"month"]]];
    }

   
    [back addSubview:month];
    
    
    JXlistTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, JXlistMutableArray.count*60+100) style:UITableViewStyleGrouped];
    [self.view addSubview:JXlistTableView];
    [JXlistTableView setBackgroundColor:[UIColor clearColor]];
    [JXlistTableView setBackgroundView:nil];
    [JXlistTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [JXlistTableView setDelegate:self];
    [JXlistTableView setDataSource:self];
    [JXlistTableView setTableHeaderView:back];
    
    JFlistTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:JFlistTableView];
    [JFlistTableView setBackgroundColor:[UIColor clearColor]];
    [JFlistTableView setBackgroundView:nil];
    [JFlistTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [JFlistTableView setDelegate:self];
    [JFlistTableView setDataSource:self];
    [JFlistTableView setTableHeaderView:JXlistTableView];
    


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([tableView isEqual:JXlistTableView]) {
        
        return 60;
        
    }
    
    else if ([tableView isEqual:JFlistTableView])
        
    {
        
        return 60;
        
    }
    
    return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if ([tableView isEqual:JXlistTableView]) {
        
        return 50;
        
    }
    
    else if ([tableView isEqual:JFlistTableView])
        
    {
        
        return 50;
        
    }
    
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([tableView isEqual:JXlistTableView]) {
        
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        back.backgroundColor = [UIColor whiteColor];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(16, 15, 15*28/22, 15)];
        [image setImage:[UIImage imageNamed: @"JXdefen"]];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16+14+16,12.5 , 200, 20)];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"绩效得分";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithRed:46 / 255.0 green:54 / 255.0 blue:63/ 255.0 alpha:1];
        [back addSubview:label];
        [back addSubview:image];
        return back;
        
    }
    
    else if ([tableView isEqual:JFlistTableView])
        
    {
        
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        back.backgroundColor = [UIColor whiteColor];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(16, 15, 15*21/26, 15)];
        [image setImage:[UIImage imageNamed: @"JFlist"]];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(44,12.5 , 200, 20)];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"奖罚列表";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithRed:46 / 255.0 green:54 / 255.0 blue:63/ 255.0 alpha:1];
        [back addSubview:label];
        [back addSubview:image];
        return back;

        
    }
    
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    if ([tableView isEqual:JXlistTableView]) {
        
        return 10;
        
    }
    
    else if ([tableView isEqual:JFlistTableView])
        
    {
        
        return 40;
        
    }
    
    return 0;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UILabel *bgView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    bgView.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    
    
    return bgView;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    if ([tableView isEqual:JXlistTableView]) {
        
        return 1;
        
    }
    
    else if ([tableView isEqual:JFlistTableView])
        
    {
        
        return 1;
        
    }
    
    return 0;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if ([tableView isEqual:JXlistTableView]) {
        
        return JXlistMutableArray.count;
        
    }
    
    else if ([tableView isEqual:JFlistTableView])
        
    {
        
        return JFlistMutableArray.count;
        
    }
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([tableView isEqual:JXlistTableView]) {
        
        static NSString *indentifier = @"cell";
        MCJXMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil)
        {
            cell = [[MCJXMTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            
        }
        NSDictionary *dic = [JXlistMutableArray objectAtIndex:indexPath.row];
        [cell.titleLabel setText:[NSString stringWithFormat:@"%@",dic[@"title"]]];
        [cell.pinfenLabel setText:[NSString stringWithFormat:@"%@",dic[@"pinfen"]]];
        [cell.moenyLabel setText:[NSString stringWithFormat:@"%.2f",[dic[@"money"] floatValue]]];
        return cell;
        
    }
    
    else if ([tableView isEqual:JFlistTableView])
        
    {
        
        static NSString *indentifier = @"cell2";
        MCJXMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil)
        {
            cell = [[MCJXMTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            
        }
        cell.label2.hidden = YES;
        cell.pinfenLabel.hidden = YES;
         NSDictionary *dic = [JFlistMutableArray objectAtIndex:indexPath.row];
        [cell.titleLabel setText:[NSString stringWithFormat:@"%@",dic[@"title"]]];
        [cell.dateLabel setText:[NSString stringWithFormat:@"%@",dic[@"time"]]];
        [cell.moenyLabel setText:[NSString stringWithFormat:@"%.2f",[dic[@"money"] floatValue]]];

        return cell;
        
    }
    
    

    
    //NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    
    
    
    
    return nil;
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
