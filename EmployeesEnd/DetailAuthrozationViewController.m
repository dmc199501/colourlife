//
//  DetailAuthrozationViewController.m
//  WeiTown
//
//  Created by 方燕娇 on 16/8/24.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "DetailAuthrozationViewController.h"

#import "AgainAuthrozationViewController.h"//再次授权页面
#import "CustomAlertView.h"
#import "MCMacroDefinitionHeader.h"
#import "MCHttpManager.h"
#import "SVProgressHUD.h"
@interface DetailAuthrozationViewController ()

@end

@implementation DetailAuthrozationViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [_autype setText:_autype_Str];
    
    if ([_autype_Str isEqualToString:@"通过"]) {
        [_autype setTextColor:[UIColor greenColor]];
    }
    else if ([_autype_Str isEqualToString:@"未批复"])
    {
        [_autype setTextColor:[UIColor redColor]];
    }
    else
    {
        [_autype setTextColor:[UIColor blackColor]];
    }
    
    NSString * usertype;
    
    switch ([[_currentCommunityInfomDic objectForKey:@"usertype"] intValue]) {
        case 1:
            
            usertype = @"永久";
            
            break;
            
        case 2:
            
            usertype = @"7天";
            
            break;
            
        case 3:
            
            usertype = @"1天";
            
            break;
            
        case 4:
            
            usertype = @"2小时";
            
            break;
            
        case 5:
            
            usertype = @"一年";
            
            break;
            
        default:
            break;
    }
    
    [_usertype setText:usertype];
    
    [_starttime setText:[CustomAlertView convertTimestampToString:[[_currentCommunityInfomDic objectForKey:@"starttime"] longLongValue]]];
    
    [_memo setText:[_currentCommunityInfomDic objectForKey:@"memo"]];
    
    if (_buttonTag == 11){
        
        _button.tag = 11;
        
        [_button setTitle:@"再次授权" forState:UIControlStateNormal];
        
    } else if(_buttonTag == 12){
        
        _button.tag = 12;
        
        [_button setTitle:@"取消授权" forState:UIControlStateNormal];
    }
    
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 11) {
        
        NSLog(@"再次授权");
        
        AgainAuthrozationViewController * againAuthrozationVC = [AgainAuthrozationViewController new];
        
        againAuthrozationVC.isPassAgain = @"0";
        
        againAuthrozationVC.infomDic = _infomDic;
        
        againAuthrozationVC.currentCommunityInfomDic = _currentCommunityInfomDic;
        
        againAuthrozationVC.userCommunityListmArray = _userCommunityListmArray;
        
        againAuthrozationVC.authrozationViewController = _authrozationViewController;
        
        [self.navigationController pushViewController:againAuthrozationVC animated:YES];
        
    }else if (sender.tag == 12){
        
        NSLog(@"取消授权");
        
        [self postAuthorizationUnAuthorize];
        
    }
}

//取消授权
-(void)postAuthorizationUnAuthorize{
    
    NSDictionary *sendDict = @{
                               @"customer_id":[_infomDic objectForKey:@"id"],
                               @"aid":[_currentCommunityInfomDic objectForKey:@"id"]                                       };
    [SVProgressHUD showWithStatus:@"正在取消授权..."];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/AuthorizationUnAuthorize" parameters:sendDict success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"取消授权成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            //发出通知，更新授权记录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAuthrozationList" object:nil];
        }
        else{
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"reason"]];
           
        }

        
        
    }
     
     
     
     
     
     
      failure:^(NSError *error) {
         
         
         
         
     }];

   
    
}

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
