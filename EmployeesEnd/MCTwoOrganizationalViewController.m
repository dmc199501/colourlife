//
//  MCTwoOrganizationalViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/12/17.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCTwoOrganizationalViewController.h"
#import "MCAddressBookTableViewCell.h"
#import "MCContactViewController.h"
#import "MCOrganizationalViewController.h"
#import "MCMemberCenterTableViewCell.h"
@interface MCTwoOrganizationalViewController ()

@end

@implementation MCTwoOrganizationalViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        contactListMutableArray = [NSMutableArray array];
        listMutableArrayZZ = [NSMutableArray array];
        listMutableArrayRY = [NSMutableArray array];
        
        
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"组织架构";
    
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 50)];
    //[self.view addSubview:backView];
    backView1.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *iconImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 19, 4, 12)];
    [backView1 addSubview:iconImage1];
    [iconImage1 setImage:[UIImage imageNamed:@"biaoti"]];
    
    notice1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, SCREEN_WIDTH, 40)];
    notice1.numberOfLines = 2;
    notice1.text = [NSString stringWithFormat:@"%@>%@",self.titleString,self.nameString];
    notice1.textColor = [UIColor blackColor];
    notice1.textAlignment = NSTextAlignmentLeft;
    notice1.font = [UIFont systemFontOfSize:14];
    [backView1 addSubview:notice1];
    [self getcontactList];
    // Do any additional setup after loading the view.
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64 ) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    [listTableView setTableHeaderView:backView1];
    [self getOrganizational];
    

    
    
    
    
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
    
    if (contactListMutableArray.count == 0) {
        
        
        remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,listMutableArray.count*45 +150, SCREEN_WIDTH, 20)];
        remindLabel.text = @" ";
        remindLabel.textColor = [UIColor blackColor];
        remindLabel.textAlignment = NSTextAlignmentCenter;
        remindLabel.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:remindLabel];
        
    
    }
    
    
    
}
- (void)getcontactList{
    
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:self.phoneString forKey:@"property_coding"];
    [sendDictionary setValue:@"colourlife" forKey:@"appID"];
    
    [MCHttpManager GETWithIPString:BASEURL_FAMILY urlMethod:@"/administrator/select" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                contactListMutableArray = dicDictionary[@"content"][@"data"];
                
                [contactListTableView reloadData];
                
                // [listTableView.mj_header endRefreshing];
                
                NSLog(@"%@",contactListMutableArray);
                
                
            }
            

            
        }
            
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       
        
        
    }];
    
    
    
}

- (void)getOrganizational{
    
    NSDictionary *sendDict = @{
                               @"orgID":self.IDString,
                                                              };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/phonebook/childDatas" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
            {
                
                
                listMutableArray = dicDictionary[@"content"];
                for (int i = 0; i<listMutableArray.count; i++) {
                    if ([[[listMutableArray objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"org"]) {
                        [listMutableArrayZZ addObject:[listMutableArray objectAtIndex:i]];
                    }else{
                        
                        [listMutableArrayRY addObject:[listMutableArray objectAtIndex:i]];
                    }
                }

                [listTableView reloadData];
                // [listTableView.mj_header endRefreshing];
                
                
                
            }
            
        }else{
        
            

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
                        return 50;
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    return footView;
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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if ([tableView isEqual:listTableView]) {
        switch (section)
        {
            case 0:
            {
                return listMutableArrayZZ.count;
            }
                break;
                
            default:
            {
                return listMutableArrayRY.count;;
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
        MCMemberCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil)
        {
            cell = [[MCMemberCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            
                      
        }
        switch (indexPath.section) {
            case 0:
            {
                
                NSDictionary *dataDictionary =[listMutableArrayZZ  objectAtIndex:indexPath.row];
                cell.line2.hidden = YES;
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
        
       
        NSDictionary *dataDictionary =[contactListMutableArray  objectAtIndex:indexPath.row];
        
        
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
    if ([tableView isEqual:listTableView]) {
        
        
        NSDictionary *dataDictionary = [listMutableArrayZZ objectAtIndex:indexPath.row];
        
        NSString *type = [NSString stringWithFormat:@"%@",dataDictionary[@"type"]];
        switch (indexPath.section) {
            case 0:
            {
                MCOrganizationalViewController *twoVC =[[MCOrganizationalViewController alloc]init];
                twoVC.IDString = dataDictionary[@"id"];
                twoVC.phoneString = dataDictionary[@"id"];
                twoVC.nameString = dataDictionary[@"name"];
                twoVC.titleString = notice1.text;
                [self.navigationController pushViewController:twoVC animated:YES];
            }
                break;
            case 1:
            {
                NSDictionary *dataDictionary = [listMutableArrayRY objectAtIndex:indexPath.row];
                
                NSLog(@"%@",dataDictionary);
                MCContactViewController *contactVC = [[MCContactViewController alloc]init];
                contactVC.hidesBottomBarWhenPushed = YES;
                contactVC.dataDictionary = dataDictionary;
                contactVC.type = 3;
                [self.navigationController pushViewController:contactVC animated:YES];
                
                
            }
                break;
                
                
            default:
                break;
        }
        if ([type isEqualToString:@"org"]) {
            
            
        }else{
            
        }
        
        
        
        
        
        
        
    }else if ([tableView isEqual:contactListTableView]){
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO animated:YES];
        
        
        
        NSDictionary *dataDictionary = [contactListMutableArray objectAtIndex:indexPath.row];
        
        
        MCContactViewController *contactVC = [[MCContactViewController alloc]init];
        contactVC.hidesBottomBarWhenPushed = YES;
        contactVC.dataDictionary = dataDictionary;
        contactVC.type = 3;
        [self.navigationController pushViewController:contactVC animated:YES];
        
        
    }
    
    
    
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
