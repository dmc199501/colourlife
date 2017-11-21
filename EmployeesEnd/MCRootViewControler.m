//
//  MCRootViewControler.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCRootViewControler ()

@end

@implementation MCRootViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithWhite:242 / 255.0 alpha:1]];
    
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
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
