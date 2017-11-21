//
//  OpenDoorViewController.m
//  WeiTown
//
//  Created by 方燕娇 on 16/8/16.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "OpenDoorViewController.h"
#import "UIView+Helper.h"
#import "MCMacroDefinitionHeader.h"
#import "MCHttpManager.h"
#import "SVProgressHUD.h"
@interface OpenDoorViewController ()<UITextFieldDelegate>



@end

@implementation OpenDoorViewController
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
    self.navigationItem.title = @"门禁";
    if ([_openSuccess isEqualToString:@"0"])
    {
        [_imageView setImage:[UIImage imageNamed:@"img_open_successes"]];
        
        [_label setText:@"开门成功"];
    }
    else if ([_openSuccess isEqualToString:@"1"])
    {
        [_imageView setImage:[UIImage imageNamed:@"img_open_fail"]];
        
        [_label setText:@"开门失败"];
    }
    
    if ([_isfrom isEqualToString:@"commonUse"])
    {
        [_editName_Txt setHidden:YES];
        
        [_addCommonUse_Btn setHidden:YES];
        
        CGFloat ori_y = _backBtn.frame.origin.y;
        
        [_backBtn setFrameOriginY:ori_y - 100.00f];
        
        
    } else if ([_isfrom isEqualToString:@"uncommonUse"]){
        
        [_editName_Txt setHidden:NO];
        
        [_addCommonUse_Btn setHidden:NO];
    }
    
    NSLog(@"存储当前操作的这个门的信息  %@",_currenDoorInfomDic);
    
    [_editName_Txt setClearButtonMode:UITextFieldViewModeAlways];
    
    [_editName_Txt setPlaceholder:@"常用门禁名称"];
    
    [_editName_Txt setText:[_currenDoorInfomDic objectForKey:@"name"]];
    
    //来自扫描的成功/失败
    if ([_isSucceed_FromScan isEqualToString:@"1"])
    {
        [_editName_Txt setHidden:YES];
        
        [_addCommonUse_Btn setHidden:NO];
        
        [_addCommonUse_Btn setTitle:@"重新扫描" forState:UIControlStateNormal];
    }
    else
    {
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnAction:(id)sender {
    
    
    if (_entranceGuardViewController)
    {
        
        [self.navigationController popToViewController:_entranceGuardViewController animated:YES];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
    
    
}

//添加常用门禁
- (IBAction)addCommonUse_BtnAction:(id)sender {
    
    if ([self.isSucceed_FromScan isEqualToString:@"1"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if ([self.isSucceed_FromScan isEqualToString:@"0"])
    {
        {
            NSLog(@"常用名称 %@",_editName_Txt.text);
            
            NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
            
            [params setObject:self.editName_Txt.text forKey:@"name"];
            
            [params setObject:[self.currenDoorInfomDic objectForKey:@"id"] forKey:@"doorid"];
            
            __weak typeof(self) weakSelf = self;
            
            NSDictionary *sendDict = @{
                                    @"customer_id":self.infomDic[@"id"],
                                       @"module":@"wetown",
                                       @"func":@"doorfixed/add",
                                       @"params":[weakSelf dictionaryToJson:params]
                                       };
            
            [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/BusinessAgentRequest" parameters:sendDict success:^(id responseObject) {
                
                NSDictionary *dicDictionary = responseObject;
                NSLog(@"%@",dicDictionary);
                if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
                {
                    //添加成功
                    //返回到前一个页面
                    
                    if (weakSelf.reloadData) {
                        
                        weakSelf.reloadData();
                    }
                    
                    //                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    [weakSelf.navigationController popToViewController:weakSelf.entranceGuardViewController animated:YES];
                    
                    
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:dicDictionary[@"reason"]];
                    
                }
                
                
                
                
            } failure:^(NSError *error) {
                
                
                
                
            }];

            
            
        }
    }
    else
    {
        NSLog(@"常用名称 %@",_editName_Txt.text);
        
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        
        [params setObject:_editName_Txt.text forKey:@"name"];
        
        [params setObject:[_currenDoorInfomDic objectForKey:@"doorid"] forKey:@"doorid"];
        
        __weak typeof(self) weakSelf = self;
        
        NSDictionary *sendDict = @{
                                   @"customer_id":self.infomDic[@"id"],
                                   @"module":@"wetown",
                                   @"func":@"doorfixed/add",
                                   @"params":[weakSelf dictionaryToJson:params]
                                   };
        
        [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/BusinessAgentRequest" parameters:sendDict success:^(id responseObject) {
            
            NSDictionary *dicDictionary = responseObject;
            NSLog(@"%@",dicDictionary);
            if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
            {
                //添加成功
                //返回到前一个页面
                
                if (self.reloadData) {
                    
                    self.reloadData();
                }
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                
                [SVProgressHUD showErrorWithStatus:dicDictionary[@"reason"]];
            }
            
            
            
            
        } failure:^(NSError *error) {
            
            
            
            
        }];
    }
}


/**
 *  字典转JSON格式
 */
-(NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError * parseError = nil;
    
    //options=0 转换成不带格式的字符串
    //options=NSJSONWritingPrettyPrinted 格式化输出
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
@end
