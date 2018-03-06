//
//  MCDataChanggeViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/7/12.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCDataChanggeViewController.h"
#import "MCAddressBookTableViewCell.h"
#import "MCContactViewController.h"
#import "MCTwoOrganizationalViewController.h"
#import "MCDatachanggeTableViewCell.h"
#import "MCDataKBViewController.h"
#import "MyMD5.h"
@interface MCDataChanggeViewController ()<MCMembersTableViewCellDelegate>

@end

@implementation MCDataChanggeViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        listMutableArrayZZ = [NSMutableArray array];
        listMutableArrayRY = [NSMutableArray array];
        contactListMutableArray = [NSMutableArray array];
        
        
        
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type ==12) {
        self.navigationItem.title = @"我的部门";
    }else{
        self.navigationItem.title = @"组织架构";}
    
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 50)];
    //[self.view addSubview:backView];
    backView1.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *iconImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 19, 4, 12)];
    [backView1 addSubview:iconImage1];
    [iconImage1 setImage:[UIImage imageNamed:@"biaoti"]];
    
    notice1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, SCREEN_WIDTH, 40)];
    notice1.numberOfLines = 2;
    if (self.type == 11 || self.type ==12) {
        notice1.text = [NSString stringWithFormat:@"%@",self.titleString];
    }else {
        notice1.text = [NSString stringWithFormat:@"%@>%@",self.titleString,self.nameString];
        
    }
    notice1.textColor = [UIColor blackColor];
    notice1.textAlignment = NSTextAlignmentLeft;
    notice1.font = [UIFont systemFontOfSize:14];
    [backView1 addSubview:notice1];
   
    // Do any additional setup after loading the view.
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-50) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    [listTableView setTableHeaderView:backView1];
   
    [self getAuthApp];
    
    
    
}

#pragma mark -获取资源2.0授权
- (void)getAuthApp{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *corp = [defaults objectForKey:@"corpId"];
    NSString *ts = [defaults objectForKey:@"ts"];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:@"33f09c7ca5e6491fbcdfd363cf58851e" forKey:@"app_uuid"];//app分配id
    [dic setValue:corp forKey:@"corp_uuid"];//租户ID
    
    NSString *singe = [NSString stringWithFormat:@"%@%@%@",@"33f09c7ca5e6491fbcdfd363cf58851e",ts,@"48a8c06966fb40e3b1c55c95692be1d8"];
    
    NSString *  signature = [MyMD5 md5:singe];//签名=( APPID +ts +appSecret)md5
    [dic setValue:signature forKey:@"signature"];
    [dic setValue:ts forKey:@"timestamp"];//时间戳
    NSLog(@"%@",dic);
    
    
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/authms/auth/app" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 &&[dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
        {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dicDictionary[@"content"] objectForKey:@"accessToken"] forKey:@"orgToken"];
            
            [defaults synchronize];
            
             [self getOrganizational];
            
            
        }else{
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    
    
    
}

- (void)setUI{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 50)];
    //[self.view addSubview:backView];
    backView.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 19, 4, 12)];
    [backView addSubview:iconImage];
    [iconImage setImage:[UIImage imageNamed:@"biaoti"]];
    
    UILabel *notice = [[UILabel alloc]initWithFrame:CGRectMake(15, 19, 100, 12)];
    notice.text = @"主要联系人";
    notice.textColor = [UIColor blackColor];
    notice.textAlignment = NSTextAlignmentLeft;
    notice.font = [UIFont systemFontOfSize:15];
    [backView addSubview:notice];
    
    
    
    
    contactListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, listMutableArray.count*45 +60, self.view.frame.size.width, self.view.frame.size.height -(listMutableArray.count*45 +60 )) style:UITableViewStyleGrouped];
    [self.view addSubview:contactListTableView];
    
    [contactListTableView setBackgroundColor:[UIColor clearColor]];
    [contactListTableView setBackgroundView:nil];
    [contactListTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [contactListTableView setDelegate:self];
    [contactListTableView setDataSource:self];
    [contactListTableView setTableHeaderView:backView];
    
    
    
    
    
    
}

- (void)getOrganizational{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *orgToken = [defaults objectForKey:@"orgToken"];
    NSString *corpID = [defaults objectForKey:@"corpId"];

    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
   
    [sendDictionary setValue:orgToken forKey:@"token"];
    [sendDictionary setValue:corpID forKey:@"corpId"];
    [sendDictionary setValue:@0 forKey:@"status"];
     [sendDictionary setValue:self.orgType forKey:@"orgType"];
     [sendDictionary setValue:@0 forKey:@"familyTypeId"];
     [sendDictionary setValue:self.IDString forKey:@"parentId"];
    
    
    //     [sendDictionary setValue:@"colourlife" forKey:@"appID"];
    //     [sendDictionary setValue:@"asc" forKey:@"orderDirection"];
    NSLog(@"%@",sendDictionary);
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/orgms/org/batchList" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
            {
                
                
                listMutableArray = dicDictionary[@"content"];
                                [listTableView reloadData];
                // [listTableView.mj_header endRefreshing];
                
                
                
            }else{
            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"message"]];
            
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"message"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([tableView isEqual:listTableView]) {
        switch (indexPath.section)
        {
            case 0:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        return 45;
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
        return 50;
        
    }else if ([tableView isEqual:contactListTableView]){
        
        return 70;
        
        
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    switch (section)
    {
        case 0:
        {
            return 1;
        }
            break;
            
        default:
        {
            return 1;
        }
            break;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    return footView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if ([tableView isEqual:listTableView]) {
        switch (section)
        {
            case 0:
            {
                return listMutableArray.count;
            }
                break;
                
            
        }
        
    }else if ([tableView isEqual:contactListTableView]){
        
        return contactListMutableArray.count;
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([tableView isEqual:listTableView]) {
        NSString *indentifier = [NSString stringWithFormat:@"cell%@%@",@(indexPath.section), @(indexPath.row)];
        MCDatachanggeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil)
        {
            cell = [[MCDatachanggeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            cell.delegate = self;
            
            
        }
        
        switch (indexPath.section) {
            case 0:
            {
                
                NSDictionary *dataDictionary =[listMutableArray  objectAtIndex:indexPath.row];
                cell.dataDic = dataDictionary;
                
               
                [cell.titleLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"name"]]];
                
                
                NSString *type = [NSString stringWithFormat:@"%@",dataDictionary[@"type"]];
                cell.iconImageView.hidden = YES;
                
                cell.titleLabel.frame = CGRectMake(10, 15, SCREEN_WIDTH-100, 20);
                if ([type isEqualToString:@"org"]) {
                    [cell.iconImageView setImage:[UIImage imageNamed:@"guishu"]];
                    
                }else{
                    
                    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataDictionary[@"avatar"]] placeholderImage:[UIImage imageNamed:@"guishu"]];
                    
                }
            }
                break;
            case 1:{
                NSDictionary *dataDictionary =[listMutableArrayRY  objectAtIndex:indexPath.row];
                
                [cell.titleLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"name"]]];
                                
                NSString *type = [NSString stringWithFormat:@"%@",dataDictionary[@"type"]];
                
                cell.iconImageView.frame = CGRectMake(10, 5, 40, 40);
                [cell.iconImageView setClipsToBounds:YES];
                [cell.iconImageView.layer setCornerRadius:20];
                cell.titleLabel.frame = CGRectMake(60, 15, SCREEN_WIDTH-100, 20);
                if ([type isEqualToString:@"org"]) {
                    [cell.iconImageView setImage:[UIImage imageNamed:@"guishu"]];
                    
                }else{
                    
                    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataDictionary[@"avatar"]] placeholderImage:[UIImage imageNamed:@"guishu"]];
                    
                }
                
            }
                break;
            default:
                break;
        }
        
        
        return cell;
        
        
    }else if([tableView isEqual:contactListTableView]){
        
        static NSString *indentifier = @"cell2";
        MCAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil)
        {
            cell = [[MCAddressBookTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            
        }
        
        NSLog(@"%@",contactListMutableArray);
        NSDictionary *dataDictionary =[contactListMutableArray  objectAtIndex:indexPath.row];
        NSLog(@"%@",dataDictionary);
        
        [cell.titleLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"realname"]]];
        cell.titleLabel.frame = CGRectMake(60, 25, [[UIScreen mainScreen] bounds].size.width - 130, 20);
        if ([ dataDictionary[@"Icon"] isKindOfClass:[NSString class]] &&[dataDictionary[@"Icon"] length]>0) {
            [cell.iconImageView sd_setImageWithURL:dataDictionary[@"Icon"]];
        }else{
            
            [cell.iconImageView setImage:[UIImage imageNamed:@"moren_geren"]];
        }
        cell.jobLabel.hidden = YES;
        return cell;
        
        
        
        
    }
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
   
        
        
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    NSArray *vcArray = self.navigationController.viewControllers;
    
    
    //if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:didPushVlaueWithAddress:)]) {
        [self.delegate viewController:self didPushVlaueWithAddress:dataDictionary];
        
    //}
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc postNotificationName:@"架构传值" object:dataDictionary userInfo:nil];
    
    
    for(UIViewController *vc in vcArray)
    {
        if ([vc isKindOfClass:[MCDataKBViewController class]])
        {
            
            [self.navigationController popToViewController:vc animated:YES];
        }
    }

    
//        NSString *type = [NSString stringWithFormat:@"%@",dataDictionary[@"type"]];
//
//                MCDataChanggeViewController *twoVC =[[MCDataChanggeViewController alloc]init];
//                twoVC.IDString = dataDictionary[@"id"];
//                twoVC.phoneString = dataDictionary[@"id"];
//                twoVC.nameString = dataDictionary[@"name"];
//                twoVC.titleString = notice1.text;
//                [self.navigationController pushViewController:twoVC animated:YES];
    
    
}
- (void)MCDatachanggeTableViewCell:(MCDatachanggeTableViewCell *)MCDatachanggeTableViewCell deleteMembers:(UIButton *)Button{
    
    NSIndexPath *indexPath = [listTableView indexPathForCell:MCDatachanggeTableViewCell];
     NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    NSLog(@"%@",dataDictionary);
    MCDataChanggeViewController *twoVC =[[MCDataChanggeViewController alloc]init];
    twoVC.IDString = dataDictionary[@"orgUuid"];
    twoVC.phoneString = dataDictionary[@"id"];
    twoVC.nameString = dataDictionary[@"name"];
     twoVC.titleString = notice1.text;
    NSString *type = [NSString stringWithFormat:@"%@",[dataDictionary objectForKey:@"orgType"]];
    if ([type isEqualToString:@"彩生活集团"]) {
        twoVC.orgType = @"大区";
          [self.navigationController pushViewController:twoVC animated:YES];
            }
    if ([type isEqualToString:@"大区"]) {
        twoVC.orgType = @"事业部";
          [self.navigationController pushViewController:twoVC animated:YES];
    }
    if ([type isEqualToString:@"事业部"]) {
        twoVC.orgType = @"小区";
          [self.navigationController pushViewController:twoVC animated:YES];
    }if ([type isEqualToString:@"小区"]) {
        [SVProgressHUD showErrorWithStatus:@"小区已经是最后一级,无法进入下一级"];
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
