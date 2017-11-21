//
//  ApplyOpenEntranceGuardViewController.m
//  WeiTown
//
//  Created by 方燕娇 on 16/8/11.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "ApplyOpenEntranceGuardViewController.h"
#import "MCWebViewController.h"
#import "MCHttpManager.h"
#import "MCMacroDefinitionHeader.h"

@interface ApplyOpenEntranceGuardViewController ()<UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *applyOpenBtn;//申请开通 -按钮

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *labelOffsetY;

@end

@implementation ApplyOpenEntranceGuardViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"获取小区信息接口的数据：%@",_infomDic);
    
    [_appliedNum_Lab setText:[NSString stringWithFormat:@"已有 %d 位邻居申请开通",_appliedNum]];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (self.isapply == 0)
    {
        [self.applyOpenBtn setHidden:NO];
        
    } else {
        
        [self.applyOpenBtn setHidden:YES];
        
        [self.labelOffsetY setConstant:-95.0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  导航栏-返回按钮事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  申请开通 - 按钮
    
    关联接口：
        1.调用“当前用户是否已经申请了开通小区的电子门禁”接口；（检查是否已申请）---点击之前要完成
        2.调用“申请小区开通手机开门”接口
 
 *
 *  @param sender
 */
- (IBAction)applyOpenBtnAction:(id)sender
{
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    
    [param setObject:[self.communityInfoDict objectForKey:@"bid"] forKey:@"bid"];
    
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"module":@"wetown",
                               @"func":@"doorfixed/modify",
                               @"params":[weakSelf dictionaryToJson:param]
                               };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/BusinessAgentRequest" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            
            
            
            NSString * title = [NSString stringWithFormat:@"申请成功"];
            
            NSString * desc = [NSString stringWithFormat:@"邀请邻居一起来申请~"];
            
            UIAlertView * applySucAlert = [[UIAlertView alloc] initWithTitle:title message:desc delegate:self cancelButtonTitle:nil otherButtonTitles:@"邀请邻居", nil];
            
            [applySucAlert show];
        }else{
         [SVProgressHUD showWithStatus:dicDictionary[@"reason"]];
        
        }
        
    } failure:^(NSError *error) {
        
        
        
        
    }];

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"邀请邻居,这里需要处理邀请邻居逻辑，隐藏申请开通按钮，label上移");
        
        [self.applyOpenBtn setHidden:YES];
        
        [self.labelOffsetY setConstant:-95.0];
        
    }
}

/**
 *  帮助按钮 - 跳转到帮助页面
 *
 *  @param sender <#sender description#>
 */
- (IBAction)helpBtnAction:(id)sender {
    
    
    
    MCWebViewController *web = [[MCWebViewController alloc]initWithUrl:[NSURL  URLWithString:@"http://www.colourlife.com/Advertisement/Menjin"] titleString:@"使用帮助"];
    [self.navigationController pushViewController:web animated:YES];
    
}

#pragma mark - 字典转JSON格式
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

- (void)dealloc {
   
}
@end
