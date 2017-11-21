//
//  MCAboutAPPViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/12/15.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCAboutAPPViewController.h"

@interface MCAboutAPPViewController ()

@end

@implementation MCAboutAPPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    
    UIImageView *aboutImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 50, 80, 80)];
    [aboutImage setImage:[UIImage imageNamed:@"58x58"]];
    [self.view addSubview:aboutImage];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(aboutImage)+10, SCREEN_WIDTH, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    [label setTextColor:GRAY_COLOR_ZZ];
    [self.view addSubview:label];
    label.text = [NSString stringWithFormat:@"最新版本%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0,  BOTTOM_Y(label)+30,SCREEN_WIDTH, SCREEN_WIDTH*1262/1125)];
    [image setImage:[UIImage imageNamed:@"jieshao"]];
   // [self.view addSubview:image];
     
    
    
    
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
