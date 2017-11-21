//
//  MCRedEnvelopesViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/9.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRedEnvelopesViewController.h"
#import "MCredBaoTableViewCell.h"
#import "MCGivingFPViewController.h"
#import <ContactsUI/ContactsUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MCAddressBookTableViewCell.h"
@interface MCRedEnvelopesViewController ()<CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate>

@end

@implementation MCRedEnvelopesViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        listMutableArray = [NSMutableArray array];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"转账给同事";
    [self getlistdata];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 187.5)];
    [self.view addSubview:backView];
    
    
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65.5)];
    [backView addSubview:backView1];
    backView1.backgroundColor = [UIColor whiteColor];
    _moneyTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 22, SCREEN_WIDTH-120, 20)];
    [_moneyTextField setPlaceholder:@"同事OA或者手机号码"];
    [_moneyTextField setTextAlignment:NSTextAlignmentLeft];
    [_moneyTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_moneyTextField setBackgroundColor:[UIColor clearColor]];
    [_moneyTextField setFont:[UIFont systemFontOfSize:15]];
    [backView1 addSubview:_moneyTextField];
    
    UIButton *image = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 15, 35, 35)];
    [image setImage:[UIImage imageNamed:@"addressbook_fill"] forState:UIControlStateNormal];
    [image addTarget:self action:@selector(addbook) forControlEvents:UIControlEventTouchUpInside];
    [backView1 addSubview:image];
    
    
    UIButton *leaveButton = [[UIButton alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(backView1)+16, SCREEN_WIDTH-40, 40)];
    [leaveButton setBackgroundColor:[UIColor colorWithRed:0 / 255.0 green:157 / 255.0 blue:255/ 255.0 alpha:1]];
    [leaveButton setTitle:@"下一步" forState:UIControlStateNormal];
    //[leaveButton setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [leaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leaveButton.titleLabel.font = [UIFont systemFontOfSize:16];   [leaveButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:leaveButton];
    [leaveButton.layer setCornerRadius:4];
    
    UIView *soo = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(leaveButton)+16, SCREEN_WIDTH, 50)];
    soo.backgroundColor = [UIColor whiteColor];
    [backView addSubview:soo];
    
    UIImageView *imageS = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 20, 20)];
    [imageS setImage:[UIImage imageNamed: @"soo"]];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(44,15 , 200, 20)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"历史搜索";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:46 / 255.0 green:54 / 255.0 blue:63/ 255.0 alpha:1];
    [soo addSubview:label];
    [soo addSubview:imageS];
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  ) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [listTableView setTableHeaderView:backView];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    listTableView.scrollEnabled = YES;
    
    
    // Do any additional setup after loading the view.
}
- (void)getlistdata{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    NSDictionary *sendDict = @{
                               @"page":@1,
                               @"pagesize":@999,
                               @"key":key,
                               @"secret":secret
                               };
    [SVProgressHUD show];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/carryList" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                [listMutableArray setArray:dicDictionary[@"content"][@"CarryJsonList"]];
                [listTableView reloadData];
                //[self setRedView];
                [listTableView.mj_header endRefreshing];
                
            }
            
        }else{
            [listMutableArray setArray:dicDictionary[@"content"][@"CarryJsonList"]];
            [listTableView reloadData];
            //[self setRedView];
            [listTableView.mj_header endRefreshing];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       [SVProgressHUD dismiss];
        
        
    }];
    



}
- (void)addbook{

    if ([[[UIDevice currentDevice] systemVersion] floatValue]>8.0 && [[[UIDevice currentDevice] systemVersion] floatValue]<9.0) {
        [self checkStatus];
        
    }else{
        
        [self touchesBegan];
        
    }


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
        _moneyTextField.text = phoneValue;
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneValue]]];
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
        _moneyTextField.text = phoneValue;
        
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneValue]]];
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

- (void)next{
    if (_moneyTextField.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请填写OA账号或手机号码再进行提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    
    NSDictionary *sendDict = @{
                               @"username":_moneyTextField.text,
                               @"key":key,
                               @"secret":secret
                               };
    [SVProgressHUD showWithStatus:@"查询中"];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/hongbao/getEmployeeInfo" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                MCGivingFPViewController *ZZvc = [[MCGivingFPViewController alloc]init];
                ZZvc.type =@"1";
                ZZvc.balance = self.balance;
                ZZvc.dataDic = dicDictionary[@"content"][@"employeeInfo"];
                [self.navigationController pushViewController:ZZvc animated:YES];
                

                
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
       
        
        
    }];

    

    }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UILabel *bgView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    //    bgView.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    //    bgView.textAlignment = NSTextAlignmentCenter;
    //    bgView.font = [UIFont systemFontOfSize:14];
    //    bgView.text = @"--把社区服务做到家--";
    
    return bgView;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return listMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
        static NSString *indentifier = @"cell";
        MCredBaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil)
        {
            cell = [[MCredBaoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            
        }
        
    
    
    
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    cell.titleLabel.text  = [NSString stringWithFormat:@"%@",dataDictionary[@"receiverName"]];
    [cell.moenyLabel setText:[NSString stringWithFormat:@"OA:%@",dataDictionary[@"receiverOA"]]];
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSDictionary *dataDictionary = [listMutableArray objectAtIndex:indexPath.row];
    
    MCGivingFPViewController *ZZvc = [[MCGivingFPViewController alloc]init];
    ZZvc.dataDic = dataDictionary;
    ZZvc.type = @"2";
    ZZvc.balance = self.balance;
    [self.navigationController pushViewController:ZZvc animated:YES];

    
    
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
