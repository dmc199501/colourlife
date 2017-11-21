//
//  MCShopMyViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/3/3.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCShopMyViewController.h"
#import "MCShopMyTableViewCell.h"
#import "MCSetUpViewController.h"
#import "MCUserInformationViewController.h"
@interface MCShopMyViewController ()

@end

@implementation MCShopMyViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        [listMutableArray addObject:@[@{@"icon": @"geren_my", @"title":@"个人信息"}]];
        [listMutableArray addObject:@[@{@"icon": @"tixian_shop", @"title":@"商家账户"}, @{@"icon": @"shnagjia_shop", @"title":@"提现记录"}, @{@"icon": @"tuandui_shop", @"title":@"团队管理"}]];
        [listMutableArray addObject:@[@{@"icon": @"shezhi_shop", @"title":@"更多设置"}]];
        //[listMutableArray addObject:@[@{@"icon": @"fenxiang_my", @"title":@"分享邀请"}]];
        // , @{@"icon": @"pinche_my", @"title":@"我的拼车"}
        
    }
    return  self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUserInformation];
    [self getUserInformation];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    userPhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9, 60, 60)];
    // [showUploadPhotoButton addSubview:userPhotoImageView];
    [userPhotoImageView.layer setCornerRadius:userPhotoImageView.frame.size.width / 2];
    [userPhotoImageView setClipsToBounds:YES];
    
    userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 30, self.view.frame.size.width - 20, 20)];
    // [tableHeaderView addSubview:userNameLabel];
    [userNameLabel setTextAlignment:NSTextAlignmentLeft];
    [userNameLabel setBackgroundColor:[UIColor clearColor]];
    [userNameLabel setTextColor:[UIColor grayColor]];
    [userNameLabel setFont:[UIFont systemFontOfSize:16]];
    [userNameLabel setText:@"阿根达斯"];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, 24)];
    [tableHeaderView addSubview:label];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setText:@"个人中心"];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 53, SCREEN_WIDTH-20, 1)];
    lineView.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
    lineView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 53, SCREEN_WIDTH-20, 1)];
    lineView2.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
    
    balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 40, 150, 20)];
    [balanceLabel setBackgroundColor:[UIColor clearColor]];
    [balanceLabel setTextColor:[UIColor whiteColor]];
    [balanceLabel setTextAlignment:NSTextAlignmentLeft];
    [balanceLabel setFont:[UIFont systemFontOfSize:13]];
    //    [balanceLabel setText:@"余额：130"];
    
    iconBadgeNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 60, 15, 18, 18)];
    [iconBadgeNumberLabel setBackgroundColor:RED_COLOR_ZZ];
    [iconBadgeNumberLabel setTextColor:[UIColor whiteColor]];
    [iconBadgeNumberLabel setFont:[UIFont systemFontOfSize:16]];
    [iconBadgeNumberLabel setTextAlignment:NSTextAlignmentCenter];
    [iconBadgeNumberLabel setText:@"1"];
    [iconBadgeNumberLabel.layer setCornerRadius:9];
    [iconBadgeNumberLabel setClipsToBounds:YES];
    [iconBadgeNumberLabel setHidden:YES];
    
    
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200  ) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    listTableView.scrollEnabled = NO;
    //[listTableView setTableHeaderView:tableHeaderView];
    // Do any additional setup after loading the view.
}
- (void)setUserInformation
{
    NSDictionary *userInfoDictionary = [MCPublicDataSingleton sharePublicDataSingleton].userDictionary;
    
    NSLog(@"%@",userInfoDictionary);
    if (userInfoDictionary)
    {
        NSString *urlString = [userInfoDictionary objectForKey:@"Icon"];
        if ([urlString isKindOfClass:[NSString class]] && [urlString length] > 0)
        {
            [showUploadPhotoButton setBackgroundImage:nil forState:UIControlStateNormal];//moren_xinxiguanli
            
            [userPhotoImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
        }
        else
        {
            [showUploadPhotoButton setBackgroundImage:[UIImage imageNamed:@"moren_"] forState:UIControlStateNormal];//moren_xinxiguanli
            [userPhotoImageView setImage:nil];
            
        }
        [userNameLabel setText:[userInfoDictionary objectForKey:@"username"]];
        [balanceLabel setText:[userInfoDictionary objectForKey:@"community"]];
        
        
        NSString *newmsg = [userInfoDictionary objectForKey:@"newmsg"];
        if ([newmsg isKindOfClass:[NSString class]] || [newmsg isKindOfClass:[NSNumber class]])
        {
            NSInteger msg = [newmsg integerValue];
            if (msg > 0 && msg < 10)
            {
                [iconBadgeNumberLabel setHidden:NO];
                [iconBadgeNumberLabel setFrame:CGRectMake(self.view.frame.size.width - 60, 15, 18, 18)];
                
            }
            else if (msg > 10)
            {
                [iconBadgeNumberLabel setHidden:NO];
                [iconBadgeNumberLabel setFrame:CGRectMake(self.view.frame.size.width - 60, 15, 25, 18)];
            }
            else
            {
                [iconBadgeNumberLabel setHidden:YES];
                
            }
        }
        
    }
    else
    {
        [showUploadPhotoButton setBackgroundImage:[UIImage imageNamed:@"moren_"] forState:UIControlStateNormal];//moren_xinxiguanli
        [userPhotoImageView setImage:nil];
        [iconBadgeNumberLabel setHidden:YES];
        
    }
    
    
}

- (void)getUserInformation
{
    
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:[[MCPublicDataSingleton sharePublicDataSingleton].userDictionary objectForKey:@"uid"] forKey:@"uid"];
    NSString *apiString = [NSString stringWithFormat:@"/administrator/%@",[[MCPublicDataSingleton sharePublicDataSingleton].userDictionary objectForKey:@"uid"]];
    
    
    [MCHttpManager GETWithIPString:BASEURL_FAMILY urlMethod:apiString parameters:sendDictionary success:^(id responseObject)
     {
         
         NSDictionary *dicDictionary = responseObject;
         NSLog(@"---%@",dicDictionary);
         
         if ([dicDictionary[@"code"] integerValue] == 0 )
         {
             if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]] )
             {
                 
                 [MCPublicDataSingleton sharePublicDataSingleton].userDictionary = dicDictionary[@"content"][0];
                 [self setUserInformation];
                 return;
                 
                 
             }
             
             
             
         }
                  
         
         
     } failure:^(NSError *error) {
         
         NSLog(@"****%@", error);
         
     }];
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    return 78;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    return 54;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    switch (section)
    {
        case 1:
        {
            return 10;
        }
            break;
        case 2:
        {
            return 10;
        }
            break;
            
        default:
        {
            return 0.000001;
        }
            break;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return listMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return ((NSArray *)([listMutableArray objectAtIndex:section])).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *indentifier = [NSString stringWithFormat:@"cell%@%@",@(indexPath.section), @(indexPath.row)];
    MCShopMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[MCShopMyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
        [cell.iconImageView setImage:[UIImage imageNamed:[[[listMutableArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"icon"]]];
        [cell.titleLabel setText:[[[listMutableArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"title"]];
              
        switch (indexPath.section)
        {
            case 0:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        
                        UILabel *ss = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-130, 29, 100, 20)];
                        [ss setTextAlignment:NSTextAlignmentRight];
                        
                        [ss setTextColor:[UIColor grayColor]];
                        [ss setFont:[UIFont systemFontOfSize:13]];
                        [ss setText:@"个人信息"];
                        
                        //cell.iconImageView.hidden = YES;
                        cell.titleLabel.hidden = YES;
                        cell.arrowImageView.frame = CGRectMake(SCREEN_WIDTH-20, 31.5, 10, 15) ;
                        [cell.arrowImageView setImage:[UIImage imageNamed:@"zhiyin_geren"]];
                        [cell addSubview:userPhotoImageView];
                        [cell addSubview:userNameLabel];
                        [cell addSubview:balanceLabel];
                        [cell addSubview:ss];
                        cell.ImageView.hidden = NO;
                    }
                        break;
                    case 1:
                    {
                        [cell addSubview:balanceLabel];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
            case 1:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        [cell addSubview:lineView];
                    }
                        break;
                    case 1:
                    {
                        [cell addSubview:lineView2];
                    }
                        break;
                    case 2:
                    {
                        
                    }
                        break;
                    case 3:
                    {
                        
                    }
                        break;
                        
                    default:
                        break;
                }
                
                
            }
                break;
                
            default:
                break;
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    MCShopMyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    if ([cell.titleLabel.text isEqualToString:@"个人信息"])
    {
        MCUserInformationViewController *userInformationViewController = [[MCUserInformationViewController alloc]init];
        userInformationViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:userInformationViewController animated:YES];
        

        
    }
    
    if ([cell.titleLabel.text isEqualToString:@"商家账户"])
    {
            }
    
    
    if ([cell.titleLabel.text isEqualToString:@"提现记录"])
    {
            }
    
    if ([cell.titleLabel.text isEqualToString:@"更多设置"])
    {
        MCSetUpViewController *SetViewController = [[MCSetUpViewController alloc]init];
        SetViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:SetViewController animated:YES];
    }
    

    
    
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
