//
//  MCMycodeViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/28.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCMycodeViewController.h"

@interface MCMycodeViewController ()

@end

@implementation MCMycodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-250*SCREEN_WIDTH/375)/2, 30, 250*SCREEN_WIDTH/375, 250*SCREEN_WIDTH/375)];
    [self.view addSubview:image];
    [image setImage:[UIImage imageNamed:@"erweima"]];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(image)+20, SCREEN_WIDTH, 30)];
    [self.view addSubview:label];
    [label setBackgroundColor:[UIColor clearColor]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[UIColor colorWithRed:13 / 255.0 green:40 / 255.0 blue:53 / 255.0 alpha:1] ];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setText:@"彩管家APP"];
    
    
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(label)+10, SCREEN_WIDTH, 20)];
    [self.view addSubview:label2];
    [label2 setBackgroundColor:[UIColor clearColor]];
    label2.textAlignment = NSTextAlignmentCenter;
    [label2 setTextColor:[UIColor colorWithRed:13 / 255.0 green:40 / 255.0 blue:53 / 255.0 alpha:1] ];
    [label2 setFont:[UIFont systemFontOfSize:15]];
    [self VersionUpdate];
    
    
    // Do any additional setup after loading the view.
}
- (void)VersionUpdate{
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSString *Version = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [sendDictionary setValue:@"ios" forKey:@"type"];
    [sendDictionary setValue:Version forKey:@"version"];
    
    NSLog(@"%@",sendDictionary);
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/czywg/version" parameters:sendDictionary success:^(id responseObject)
     {
         
         NSDictionary *dicDictionary = responseObject;
         NSLog(@"---%@",dicDictionary);
         
         if ([dicDictionary[@"code"] integerValue] == 0 )
         {
             
             NSString *result = dicDictionary[@"content"][@"info"][0][@"version"];
             if (result.length == 0) {
                 [label2 setText:[NSString stringWithFormat:@"安卓:v%@/ios:v%@",Version,Version]];
             }else{
             [label2 setText:[NSString stringWithFormat:@"安卓:v%@/ios:v%@",result,result]];
             }
             
         }
         
         
         
     } failure:^(NSError *error) {
         
         NSLog(@"****%@", error);
         
     }];
    
    
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
