//
//  MCAddressBookController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCAddressBookController.h"
#import "MCMemberCenterTableViewCell.h"
#import "MCPhoneViewController.h"
#import <ContactsUI/ContactsUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MCAddressBookTableViewCell.h"
#import "MCContactViewController.h"
#import "MCOrganizationalViewController.h"
#import "MCsousuoViewController.h"
#import "MyMD5.h"
@interface MCAddressBookController ()<CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate>

@end

@implementation MCAddressBookController
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        [listMutableArray addObject:@[@{@"icon": @"彩之云logo", @"title":@"彩生活服务集团"}]];
        [listMutableArray addObject:@[@{@"icon": @"部门", @"title":@"我的部门"}]];
        [listMutableArray addObject:@[@{@"icon": @"通讯录", @"title":@"手机通讯录"}]];
        
        contactListMutableArray = [NSMutableArray array];
       
        
        
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.title = @"通讯录";
   
   
   
    [self setUI];
    
     [self getAuthApp];
    
    // Do any additional setup after loading the view.
}

- (void)setUI{
    organizationLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 220, 0, 185, 50)];
    organizationLabel.text = @"组织架构";
    organizationLabel.textColor = GRAY_COLOR_ZZ;
    organizationLabel.textAlignment = NSTextAlignmentRight;
    [organizationLabel setFont:[UIFont systemFontOfSize:14]];
    
    
    jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 220, 0, 185, 50)];
    jobLabel.text =  [[MCPublicDataSingleton sharePublicDataSingleton].userDictionary objectForKey:@"familyName"];
    NSLog(@"%@",[MCPublicDataSingleton sharePublicDataSingleton].userDictionary);
    jobLabel.textColor = GRAY_COLOR_ZZ;
    jobLabel.textAlignment = NSTextAlignmentRight;
    [jobLabel setFont:[UIFont systemFontOfSize:14]];
    UIView *oneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*63/521 +150 +60)];
    
    [self.view addSubview:oneView];
    
    UIButton * barButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*63/521)];
    [barButton setBackgroundImage:[UIImage imageNamed:@"sousuoK"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(sousuo) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:barButton];
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  SCREEN_WIDTH*63/521 +150 +60   ) style:UITableViewStyleGrouped];
    [oneView addSubview:listTableView];
    
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    [listTableView setTableHeaderView:barButton];
    listTableView.scrollEnabled = NO;
    
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 210, SCREEN_WIDTH, 50)];
    [oneView addSubview:backView];
    backView.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 19, 4, 12)];
    [backView addSubview:iconImage];
    [iconImage setImage:[UIImage imageNamed:@"biaoti"]];
    
    UILabel *notice = [[UILabel alloc]initWithFrame:CGRectMake(15, 19, 100, 12)];
    notice.text = @"收藏联系人";
    notice.textColor = [UIColor blackColor];
    notice.textAlignment = NSTextAlignmentLeft;
    notice.font = [UIFont systemFontOfSize:15];
    [backView addSubview:notice];
   // [self.view addSubview:listTableView];
    
    
    contactListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT-64-50 ) style:UITableViewStyleGrouped];
    [self.view addSubview:contactListTableView];
    
    [contactListTableView setBackgroundColor:[UIColor clearColor]];
    [contactListTableView setBackgroundView:nil];
    [contactListTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [contactListTableView setDelegate:self];
    [contactListTableView setDataSource:self];
    [contactListTableView setTableHeaderView:oneView];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSMutableArray *contactArray = [defaults objectForKey:@"contactList"];
    NSLog(@"%@",contactArray);
    if (contactArray.count>0) {
        
    contactListMutableArray = contactArray;
        [self getContactData];
    }else{
        [self getContactData];
    }
//    __unsafe_unretained __typeof(self) weakSelf = self;
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getContactData)];
//    
//    // 设置文字
//    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//    [header setTitle:@"松手立即刷新" forState:MJRefreshStatePulling];
//    [header setTitle:@"努力刷新中" forState:MJRefreshStateRefreshing];
//    
//    // 设置字体
//    header.stateLabel.font = [UIFont systemFontOfSize:15];
//    
//    header.lastUpdatedTimeLabel.hidden = YES;
//    // 设置颜色
//    header.stateLabel.textColor = [UIColor grayColor];
//    // 马上进入刷新状态
//    [header beginRefreshing];
//    
//    // 设置刷新控件
//    contactListTableView.mj_header = header;
    


}
-(void)sousuo{
    
    MCsousuoViewController *ssVC = [[MCsousuoViewController alloc]init];
    ssVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:ssVC animated:YES];
    
    
    
    
}
- (void)getContactData{

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];
    NSDictionary *sendDict = @{
                               @"uid":username
                               
                               };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/phonebook/frequentContacts" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
            {
                
                
                contactListMutableArray = dicDictionary[@"content"];
                
                [contactListTableView reloadData];
                
                NSArray *array = dicDictionary[@"content"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                
                [userDefaults setObject:array forKey:@"contactList"];
                [userDefaults synchronize];

                [contactListTableView.mj_header endRefreshing];
                NSLog(@"%@",contactListMutableArray);
                
                
            }
            
        }else{
            contactListMutableArray = dicDictionary[@"content"];
            
            [contactListTableView reloadData];
        [contactListTableView.mj_header endRefreshing];
            remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH, 20)];
            remindLabel.text = @" ";
            remindLabel.textColor = [UIColor blackColor];
            remindLabel.textAlignment = NSTextAlignmentCenter;
            remindLabel.font = [UIFont systemFontOfSize:16];
            [self.view addSubview:remindLabel];
           
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    




}

- (void)getOrgms{
   
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *orgToken = [defaults objectForKey:@"orgToken"];
     NSString *corp = [defaults objectForKey:@"corpId"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
     [dic setValue:orgToken forKey:@"token"];
     [dic setValue:@"0" forKey:@"parentId"];
    [dic setValue:@"0" forKey:@"familyTypeId"];
    [dic setValue:@"0" forKey:@"type"];
    [dic setValue:@"0" forKey:@"status"];
    [dic setValue:corp forKey:@"corpId"];
    NSLog(@"%@",dic);
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/orgms/org/batch" parameters:dic success:^(id responseObject) {
       
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            
            if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
            {
                
                
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                
                NSString *corpType = [defaults objectForKey:@"corpType"];
                if ([corpType isEqualToString:@"101"]) {
                    self.orgName = @"彩生活集团";
                    self.orgid = @"9959f117-df60-4d1b-a354-776c20ffb8c7";
                    
                }else{
                
                    self.orgName = [NSString stringWithFormat:@"%@",[[dicDictionary[@"content"] objectAtIndex:0] objectForKey:@"name"]];
                    self.orgid = [NSString stringWithFormat:@"%@",[[dicDictionary[@"content"] objectAtIndex:0] objectForKey:@"orgUuid"]];
                
                }
              
                
                [defaults setObject:self.orgName forKey:@"isOrgName"];
                
                
                [defaults synchronize];
                for (UIView *view in self.view.subviews) {
                    
                    if ([view isKindOfClass:[UITableView class] ]) {
                        
                        [view removeFromSuperview];
                    }
                }
                [self setUI];
            }
            
        }else{
            //[self setUI];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([tableView isEqual:listTableView]) {
        
        return 50;
        
    }
    
    else if ([tableView isEqual:contactListTableView])
        
    {
        
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
    
    if ([tableView isEqual:listTableView]) {
        
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

        
    }
    
    else if ([tableView isEqual:contactListTableView])
        
    {
        
        return 1;;
        
    }
    
    return 0;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    if ([tableView isEqual:listTableView]) {
        
        return listMutableArray.count;;
        
    }
    
    else if ([tableView isEqual:contactListTableView])
        
    {
        
        return 1;
        
    }
    
    return 0;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if ([tableView isEqual:listTableView]) {
        
        return ((NSArray *)([listMutableArray objectAtIndex:section])).count;
        
    }
    
    else if ([tableView isEqual:contactListTableView])
        
    {
       
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
            cell.iconImageView.frame = CGRectMake(10,10 , 30, 30);
            [cell.iconImageView setImage:[UIImage imageNamed:[[[listMutableArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"icon"]]];
            if (indexPath.section == 0) {
                if (self.orgName.length ==0) {
                     [cell.titleLabel setText:[NSString stringWithFormat:@"%@",@"服务集团"]];
                }else{
                    [cell.titleLabel setText:[NSString stringWithFormat:@"%@",self.orgName]];}
            }else{
                [cell.titleLabel setText:[[[listMutableArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"title"]];
        }
            
            switch (indexPath.section)
            {
                case 0:
                {
                    [cell addSubview:organizationLabel];
                }
                    break;
                case 1:
                {
                    cell.titleLabel.font = [UIFont systemFontOfSize:15];
                    [cell.titleLabel setTextColor:GRAY_COLOR_ZZ];
                    [cell addSubview:jobLabel];
                }
                    break;
                case 2:
                {
                    
                }
                    break;
                    
                default:
                {
                    
                }
                    break;
            }
            
            
        }
        
        return cell;
        
 } else{
     
     
     static NSString *indentifier = @"cell2";
     MCAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
     if (cell == nil)
     {
         cell = [[MCAddressBookTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
         
     }
     
     NSDictionary *dataDictionary =[contactListMutableArray  objectAtIndex:indexPath.row];
     NSLog(@"%@",dataDictionary);
     
     [cell.titleLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"realname"]]];
     if ([ dataDictionary[@"avatar"] isKindOfClass:[NSString class]] &&[dataDictionary[@"avatar"] length]>0) {
         
         [cell.iconImageView sd_setImageWithURL:dataDictionary[@"avatar"] placeholderImage:[UIImage imageNamed:@"moren_geren"]];
     }else{
         
          [cell.iconImageView setImage:[UIImage imageNamed:@"moren_geren"]];
     }
      [cell.jobLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"jobName"]]];
     return cell;
     
 }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([tableView isEqual:listTableView]){
        MCMemberCenterTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO animated:YES];
        switch (indexPath.section)
        {
            case 0:
            {
                if (self.orgid.length>0) {
                    MCOrganizationalViewController *OrganizationalVC = [[MCOrganizationalViewController alloc]init];
                    OrganizationalVC.titleString = self.orgName;
                    OrganizationalVC.type = 11;
                    OrganizationalVC.orgString = self.orgid;
                    [self.navigationController pushViewController:OrganizationalVC animated:YES];

                }else{
                
                
                }
                           }
                break;
            case 1:
            {
                
                MCOrganizationalViewController *OrganizationalVC = [[MCOrganizationalViewController alloc]init];
                OrganizationalVC.titleString = jobLabel.text;
                OrganizationalVC.type = 12;
                NSLog(@"%@",[MCPublicDataSingleton sharePublicDataSingleton].userDictionary);
                OrganizationalVC.IDString = [[MCPublicDataSingleton sharePublicDataSingleton].userDictionary objectForKey:@"orgId"];
                OrganizationalVC.phoneString =  [[MCPublicDataSingleton sharePublicDataSingleton].userDictionary objectForKey:@"familyId"];
                [self.navigationController pushViewController:OrganizationalVC animated:YES];
            }
                break;
            case 2:
            {
                if ([[[UIDevice currentDevice] systemVersion] floatValue]>8.0 && [[[UIDevice currentDevice] systemVersion] floatValue]<9.0) {
                    [self checkStatus];
                    
                }else{
                    
                    [self touchesBegan];
                    
                }
            }
                break;
                
            default:
            {
                
            }
                break;
        }

    }else if ([tableView isEqual:contactListTableView]){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO animated:YES];
        
        NSDictionary *dataDictionary = [contactListMutableArray objectAtIndex:indexPath.row];
        
        
        MCContactViewController *contactVC = [[MCContactViewController alloc]init];
            contactVC.hidesBottomBarWhenPushed = YES;
        contactVC.dataDictionary = dataDictionary;
        [self.navigationController pushViewController:contactVC animated:YES];
   
    }
    

}

    // Do any additional setup after loading the view.


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan
{
    // 1.创建选择联系人的控制器
    CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
    
    // 2.设置代理
    contactVc.delegate = self;
    
    // 3.弹出控制器
    [self presentViewController:contactVc animated:YES completion:nil];
}
- (void)touchesBegan2
{
    // 1.创建选择联系人的控制器
    ABPeoplePickerNavigationController *ppnc = [[ABPeoplePickerNavigationController alloc] init];
    
    ppnc.peoplePickerDelegate = self;
    
    [self presentViewController:ppnc animated:YES completion:nil];
}


- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    // 1.获取联系人的姓名
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
    NSLog(@"%@ %@", lastname, firstname);
    
    // 2.获取联系人的电话号码
    NSArray *phoneNums = contact.phoneNumbers;
    for (CNLabeledValue *labeledValue in phoneNums) {
        // 2.1.获取电话号码的KEY
        NSString *phoneLabel = labeledValue.label;
        
        // 2.2.获取电话号码
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        
        NSLog(@"%@ -------  %@", phoneLabel, phoneValue);
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneValue]]];
    }
}
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    NSLog(@"点击取消后的代码");
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    // 1.获取选中联系人的姓名
    CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    NSString *lastname = (__bridge_transfer NSString *)(lastName);
    NSString *firstname = (__bridge_transfer NSString *)(firstName);
    
    NSLog(@"%@ %@", lastname, firstname);
    
    // 2.获取选中联系人的电话号码
    // 2.1.获取所有的电话号码
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex phoneCount = ABMultiValueGetCount(phones);
    
    // 2.2.遍历拿到每一个电话号码
    for (int i = 0; i < phoneCount; i++) {
        // 2.2.1.获取电话对应的key
        NSString *phoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
        
        // 2.2.2.获取电话号码
        NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
        
        NSLog(@"%@ %@", phoneLabel, phoneValue);
        
       
       [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneValue]]];
    }
    
    // 注意:管理内存
    CFRelease(phones);
}

// 当用户选中某一个联系人的某一个属性时会执行该方法,并且选中属性后会退出控制器
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSLog(@"%s", __func__);
    NSLog(@"%@--%d---%d", person,property,identifier);
}

- (void)checkStatus
{
    // 1.获取授权状态
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (status == kABAuthorizationStatusNotDetermined) {
        NSLog(@"还没问呢");
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            if(granted){
                NSLog(@"选择了同意");
            }else{
                NSLog(@"拒绝了");
            }
        });
    }else if (status == kABAuthorizationStatusAuthorized){
        NSLog(@"已经授权");
        [self touchesBegan2];
        [self loadPerson];
    }else {
        NSLog(@"没有授权");
        // 弹窗提示去获取权限
    }
    
    
}

- (void)loadPerson
{
    // 3.创建通信录对象
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    // 4.获取所有的联系人
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex peopleCount = CFArrayGetCount(peopleArray);
    
    // 5.遍历所有的联系人
    for (int i = 0; i < peopleCount; i++) {
        // 5.1.获取某一个联系人
        ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
        // 5.2.获取联系人的姓名
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSLog(@"%@ %@", lastName, firstName);
        
        // 5.3.获取电话号码
        // 5.3.1.获取所有的电话号码
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        
        // 5.3.2.遍历拿到每一个电话号码
        for (int i = 0; i < phoneCount; i++) {
            // 1.获取电话对应的key
            NSString *phoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
            
            // 2.获取电话号码
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            
            NSLog(@"%@ %@", phoneLabel, phoneValue);
        }
        
        CFRelease(phones);
    }
    
    CFRelease(addressBook);
    CFRelease(peopleArray);
}
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
    
    NSString *OrgName = [defaults objectForKey:@"isOrgName"];
   
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/authms/auth/app" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if ([dicDictionary[@"code"] integerValue] == 0 &&[dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
        {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[dicDictionary[@"content"] objectForKey:@"accessToken"] forKey:@"orgToken"];
            
            [defaults synchronize];
            self.orgName = [defaults objectForKey:@"isOrgName"];
//            if (self.orgName.length>0) {
//                
//                [self setUI];
//            }else{
                [self getOrgms];
                
           // }

           
            
            
        }else{
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    
    




}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //2.0应用鉴w
    

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
