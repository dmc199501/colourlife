//
//  MCTemporarypasswordViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/8.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCTemporarypasswordViewController.h"

@interface MCTemporarypasswordViewController ()
@property(nonatomic,strong)NSString *passStr;
@end

@implementation MCTemporarypasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"获取临时密码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_refresh_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(getload)];
    
    labelTempPass = [[UILabel alloc] init];
    labelTempPass.frame = CGRectMake(0, 200*SCREEN_WIDTH/375 , SCREEN_WIDTH, 30);
    labelTempPass.font = [UIFont systemFontOfSize:30];
    labelTempPass.textAlignment = NSTextAlignmentCenter;
    labelTempPass.tag = 100;
    [self.view addSubview:labelTempPass];
    [self getload];
    
   
}

- (void)getload{

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *pass = [defaults objectForKey:@"passWordMI"];
    NSString *username = [defaults objectForKey:@"userName"];
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:username forKey:@"username"];
    [sendDictionary setValue:pass forKey:@"password"];
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/account/temp" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                self.passStr = [NSString stringWithFormat:@"%@",dicDictionary[@"content"][@"password"]];
                [labelTempPass setText:[NSString stringWithFormat:@"%@",self.passStr]];
                
            }
            
            return ;
            
            
            
        }else{
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    



}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 100;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *normalCell = @"passCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *labelTempPass = [[UILabel alloc] init];
        labelTempPass.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + 100, cell.frame.size.width, cell.frame.size.height);
        labelTempPass.font = [UIFont systemFontOfSize:30];
        labelTempPass.textAlignment = NSTextAlignmentCenter;
        labelTempPass.tag = 100;
        [cell.contentView addSubview:labelTempPass];
    }
    
    UILabel *label = [cell.contentView viewWithTag:100];
    if (label) {
        label.text = self.passStr;
    }
    
    return cell;
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
