//
//  MCsuccessfulViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/24.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCsuccessfulViewController.h"

@interface MCsuccessfulViewController ()

@end

@implementation MCsuccessfulViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"验证成功";
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    [self.view addSubview:backView];
    backView.backgroundColor = BLUK_COLOR;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-106)/2,20 , 106, 91)
                        ];
    [button setBackgroundImage:[UIImage imageNamed:@"chenggon"] forState:UIControlStateNormal];
    //[button addTarget:self action:@selector(saoma) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 20)];
    label.text = @"验证成功!";
    [backView addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    
    
    UIView *informationView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 150)];
    informationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:informationView];
    
    
   UILabel* wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, self.view.frame.size.width- 100, 20)];
    [informationView addSubview:wordLabel];
    wordLabel.textAlignment = NSTextAlignmentLeft;
    [wordLabel setBackgroundColor:[UIColor clearColor]];
    [wordLabel setTextColor:[UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:1] ];
    [wordLabel setFont:[UIFont systemFontOfSize:14]];
    [wordLabel setText:@"券码密码:12345667"];
    
    
    
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH-20, 1)];
    line.backgroundColor = [UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:0.1];
    [informationView addSubview:line];
    
    
   UILabel* priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH-100, 20)];
    [informationView addSubview:priceLabel];
    [priceLabel setBackgroundColor:[UIColor clearColor]];
    [priceLabel setTextColor:[UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:1]];
    [priceLabel setFont:[UIFont systemFontOfSize:13]];
    [priceLabel setText:@"商品名称:麦当娜哦超值鸡腿"];
    
   UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, SCREEN_WIDTH-100, 20)];
    [informationView addSubview:nameLabel];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextColor:[UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:1]];
    [nameLabel setFont:[UIFont systemFontOfSize:13]];
    [nameLabel setText:@"商品价格:50.00"];
    
   UILabel * userLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-100, 20)];
    [informationView addSubview:userLabel];
    [userLabel setBackgroundColor:[UIColor clearColor]];
    [userLabel setTextColor:[UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:1]];
    [userLabel setFont:[UIFont systemFontOfSize:13]];
    [userLabel setText:@"购买用户:123131313"];
    
   UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, SCREEN_WIDTH-100, 20)];
    [informationView addSubview:timeLabel];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setTextColor:[UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:1]];
    [timeLabel setFont:[UIFont systemFontOfSize:13]];
    [timeLabel setText:@"验证时间:120020200"];
    
    

    UIButton *promoteButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 320, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:promoteButton];
    [promoteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[promoteButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    promoteButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [promoteButton.layer setCornerRadius:5];
    
    promoteButton.backgroundColor = BLUK_COLOR;
    
    [promoteButton setTitle:@"确认消费" forState:UIControlStateNormal];
    


    // Do any additional setup after loading the view.
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
