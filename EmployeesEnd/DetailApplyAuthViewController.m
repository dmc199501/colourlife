//
//  DetailApplyAuthViewController.m
//  WeiTown
//
//  Created by 方燕娇 on 16/8/23.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "DetailApplyAuthViewController.h"
#import "MCHttpManager.h"
#import "MCMacroDefinitionHeader.h"
#import "SVProgressHUD.h"

@interface DetailApplyAuthViewController ()

@end

@implementation DetailApplyAuthViewController
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
    
    [_phoneLab setText:_phone];
    
    [_remarkLab setText:_remark];
    
    [_timetype setText:_type];
    
    if ([_type isEqualToString:@"通过"])
    {
        [_timetype setTextColor:[UIColor greenColor]];
    }
    else if ([_type isEqualToString:@"未批复"])
    {
        [_timetype setTextColor:[UIColor redColor]];
    }
    else
    {
        [_timetype setTextColor:[UIColor blackColor]];
    }
    
    if (_ishidden == YES)
    {
        [_applyAgainBtn setHidden:YES];
    }
    else
    {
        [_applyAgainBtn setHidden:NO];
    }
    
    NSLog(@"当前选中行的申请记录的信息 %@",_currentApplyInfomDic);
    
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
- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//再次申请
- (IBAction)applyAgainBtnAction:(id)sender {
    
    
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"cid":[weakSelf.currentApplyInfomDic objectForKey:@"cid"],
                               @"memo":[weakSelf.currentApplyInfomDic objectForKey:@"memo"]};
    [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/ApplyApply1" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"reason"]];
            
        }

    
     
     
     
    
     
     
     
     
     } failure:^(NSError *error) {
         
         
         
         
     }];

    
    }

@end
