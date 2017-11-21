//
//  MCFeedbackViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/12/15.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCFeedbackViewController.h"

@interface MCFeedbackViewController ()

@end

@implementation MCFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];self.navigationItem.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    backgroundScrollView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:backgroundScrollView];
    
    
    contentTextView = [[MCTextsView alloc]initWithFrame:CGRectMake(10, 10+20, backgroundScrollView.frame.size.width - 20, 160)];
    [backgroundScrollView addSubview:contentTextView];
    
    [contentTextView setPlaceholder:@"请填写反馈的内容..."];
    
    [contentTextView setFont:[UIFont systemFontOfSize:15]];
    [contentTextView.layer setBorderColor:LINE_GRAY_COLOR_ZZ.CGColor];
    [contentTextView.layer setBorderWidth:1];
    [contentTextView.layer setCornerRadius:5];
    
    

    // Do any additional setup after loading the view.
}
- (void)submit
{
    
    
    
    if ([contentTextView.text length] == 0 ||[contentTextView.text length]<5)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入五个字以上内容再进行提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    
    
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    
    
    
    [sendDictionary setValue:[[MCPublicDataSingleton sharePublicDataSingleton].userDictionary objectForKey:@"realname"] forKey:@"founder"];
    [sendDictionary setValue:contentTextView.text forKey:@"content"];
    [sendDictionary setValue:@"colourlife" forKey:@"appID"];
    
    
    [MCHttpManager PostWithIPString:BASEURL_TASK urlMethod:@"/feedback" parameters:sendDictionary success:^(id responseObject)
     {
         
         NSDictionary *dicDictionary = responseObject;
         NSLog(@"---%@",dicDictionary);
         
         if ([dicDictionary[@"code"] integerValue] == 0 )
         {
             if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
             {
                 
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"感谢您的意见" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                 [alertView show];
                 
                 [self.navigationController popViewControllerAnimated:YES];
                 return;
                 
                 
             }
             
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"提交失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alertView show];
             
             
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
