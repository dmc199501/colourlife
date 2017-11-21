//
//  MCValidationViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/24.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCValidationViewController.h"
#import "MCScanViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import "MCsuccessfulViewController.h"
#import <AVFoundation/AVMediaFormat.h>
@interface MCValidationViewController ()

@end

@implementation MCValidationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"券码验证";
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    [self.view addSubview:backView];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2,20 , 80, 80)
                        ];
    [button setBackgroundImage:[UIImage imageNamed:@"saoma_"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saoma) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 20)];
    label.text = @"点击进行扫码验券";
    [backView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    
    
    UIView *fileView = [[UIView alloc]initWithFrame:CGRectMake(100/2, 200, SCREEN_WIDTH-100, 40)];
    [self.view addSubview:fileView];
    fileView.backgroundColor = [UIColor clearColor];
    
    UITextField *wordField =[[UITextField alloc] initWithFrame:CGRectMake(0, 0, ((SCREEN_WIDTH-100)*3/4), 40)];
    wordField.backgroundColor = [UIColor whiteColor];
    wordField.placeholder = @"请输入验证密码";
    [self.view addSubview:wordField];
    [wordField.layer setCornerRadius:5];

    wordField.font = [UIFont systemFontOfSize:14];
    [fileView addSubview:wordField];
    
    
    UIButton *promoteButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)*3/4, 0, (SCREEN_WIDTH-100)*1/4, 40)];
    [fileView addSubview:promoteButton];
    [promoteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [promoteButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    promoteButton.titleLabel.font = [UIFont systemFontOfSize:13];
    //[promoteButton.layer setBorderWidth:1];
    [promoteButton.layer setCornerRadius:5];
    
    promoteButton.backgroundColor = BLUK_COLOR;
    
    [promoteButton setTitle:@"验证" forState:UIControlStateNormal];
    

    
    // Do any additional setup after loading the view.
}

- (void)submit{

    MCsuccessfulViewController *successVC = [[MCsuccessfulViewController alloc]init];
    [self.navigationController pushViewController:successVC animated:YES];


}
- (void)saoma{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized)
        
    {
        
        NSLog(@"允许状态");
        
    }
    
    else if (authStatus == AVAuthorizationStatusDenied)
        
    {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请在iPhone的“设置-隐私-相机”选项中，允许彩管家访问你的相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
        
        
    }
    
    
    MCScanViewController *scanVC = [[MCScanViewController alloc]init];
    scanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scanVC animated:YES];
    
    
    
    

    
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
