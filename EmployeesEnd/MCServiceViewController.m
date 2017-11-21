//
//  MCServiceViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/18.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCServiceViewController.h"
#import "MCServeButton.h"
#import "MCManagementViewController.h"
#import "MCShelvesViewController.h"
#import "MCvouchersViewController.h"
#import "MCCashViewController.h"
#import "MCSalesViewController.h"
@interface MCServiceViewController ()

@end

@implementation MCServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"微服务";
    self.buttonMutableArray = [NSMutableArray array];
    [self.buttonMutableArray addObject:@{@"imageName":@"dingdan_w", @"title":@"订单管理"}];
    [self.buttonMutableArray addObject:@{@"imageName":@"shangpin_w", @"title":@"商品管理"}];
    [self.buttonMutableArray addObject:@{@"imageName":@"shangjia_w", @"title":@"商品上架"}];
    [self.buttonMutableArray addObject:@{@"imageName":@"xiaofeima_w", @"title":@"消费码管理"}];
    [self.buttonMutableArray addObject:@{@"imageName":@"tixian_w", @"title":@"提现申请"}];
    [self.buttonMutableArray addObject:@{@"imageName":@"shouhou_w", @"title":@"售后管理"}];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
    [self.view addSubview:backView];
    backView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < self.buttonMutableArray.count; i++)
    {
        
        
        float heightB = 90;
        MCServeButton *serveButton = [[MCServeButton alloc]initWithFrame:CGRectMake((i % 3) * (self.view.frame.size.width + 3) / 3 - 0.5 * (i % 3),  (i / 3) * (heightB+30) +10,(self.view.frame.size.width + 3) / 3,heightB-20 )];
        [backView addSubview:serveButton];
        
//        NSURL *imageUrl = [NSURL URLWithString:[[self.buttonMutableArray objectAtIndex:i] objectForKey:@"imageName"]];
        
        [serveButton.iconImageView setImage:[UIImage imageNamed:[[self.buttonMutableArray objectAtIndex:i] objectForKey:@"imageName"]]];
        serveButton.iconImageView.frame = CGRectMake((serveButton.frame.size.width - 40) / 2, 20, 40, 40);
        [serveButton.titleNameLabel setFrame:CGRectMake(0, serveButton.frame.size.height , serveButton.frame.size.width, 16)];
        
        [serveButton.titleNameLabel setFont:[UIFont systemFontOfSize:14]];
        serveButton.titleNameLabel.textColor = GRAY_COLOR_ZZ;
        [serveButton.titleNameLabel setText:[[self.buttonMutableArray objectAtIndex:i] objectForKey:@"title"]];
        [serveButton setTag:i];
        
        
        
        
        [serveButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, 1, 240)];
    [backView addSubview:line];
    line.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/3)*2 , 0, 1, 240)];
    [backView addSubview:line2];
    line2.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0 , 120, SCREEN_WIDTH, 1)];
    [backView addSubview:line3];
    line3.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
    

    
    
   
    // Do any additional setup after loading the view.
}
- (void)clickButton:(UIButton *)button{
switch (button.tag)
{
        //
    case 0:{
        
       
                
        
    }
        break;
    case 1://商品管理
    {
        MCManagementViewController *managentVC = [[MCManagementViewController alloc]init];
        managentVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:managentVC animated:YES];
    }
        break;
    case 2://
    {
        
        MCShelvesViewController *ShelvesVC = [[MCShelvesViewController alloc]init];
        ShelvesVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ShelvesVC animated:YES];
           }
        break;
        
    case 3://
    {
        MCvouchersViewController *vouchersVC = [[MCvouchersViewController alloc]init];
        vouchersVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vouchersVC animated:YES];
        
           }
        break;
    case 4://
    {
        MCCashViewController *cashVC = [[MCCashViewController alloc]init];
        cashVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cashVC animated:YES];
        
    }
        break;
    case 5://
    {
        MCSalesViewController *SalesVC = [[MCSalesViewController alloc]init];
        SalesVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:SalesVC animated:YES];
        
    }
        break;
        
    default:
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
