//
//  AgainAuthrozationViewController.m
//  WeiTown
//
//  Created by 方燕娇 on 16/8/25.
//  Copyright © 2016年 Hairon. All rights reserved.
//
#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]


#import "AgainAuthrozationViewController.h"
#import "MCMacroDefinitionHeader.h"
#import "MCHttpManager.h"
#import "SVProgressHUD.h"
#import "CustomAlertView.h"
#import "NSDateHelper.h"

@interface AgainAuthrozationViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (retain, nonatomic) IBOutlet UIButton *hoursBtn;//一小时
@property (retain, nonatomic) IBOutlet UIButton *oneDayBtn;//一天
@property (retain, nonatomic) IBOutlet UIButton *sevenDayBtn;//七天
@property (retain, nonatomic) IBOutlet UIButton *oneYearBtn;//一年
@property (retain, nonatomic) IBOutlet UIButton *permanentBtn;//永久
@property (retain, nonatomic) IBOutlet UIImageView *twoHourImg;
@property (retain, nonatomic) IBOutlet UIImageView *oneDayImg;
@property (retain, nonatomic) IBOutlet UIImageView *sevDayImg;
@property (retain, nonatomic) IBOutlet UIImageView *oneYearImg;
@property (retain, nonatomic) IBOutlet UIImageView *everImg;

//授权成功提示
@property (retain, nonatomic) IBOutlet UIView *tooltipBgView;
@property (retain, nonatomic) IBOutlet UIView *tooltipView;
@property (retain, nonatomic) IBOutlet UILabel *tooltipLabel;

@property (assign, nonatomic) int countDown;
@property (strong, nonatomic) NSTimer *timer;


@property (retain, nonatomic) IBOutlet UILabel *applyTime;//申请时间

@property (retain, nonatomic) IBOutlet UILabel *remark;//备注

@property (retain, nonatomic) IBOutlet UITextField *communityTxt;

@property (retain, nonatomic) IBOutlet UIButton *passBtn;//未批复-通过

@property (retain, nonatomic) IBOutlet UIButton *refuseBtn;//未批复-拒绝

@property (retain, nonatomic) IBOutlet UIButton *againPassBtn;//再次授权-通过

//授权时间
@property (copy, nonatomic) NSString *authTime;

@end

@implementation AgainAuthrozationViewController
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
    
//    [self.communityTxt setDelegate:self];
    
    NSLog(@"\n再次授权的小区信息：%@  \n 移动OA获取的彩之云账号信息：%@, \n 小区列表 %@",_currentCommunityInfomDic,_infomDic,_userCommunityListmArray);
    //默认2小时（授权期限)
    self.authTime = @"0";
    
    [self setBtns];
    
    [self setDefaultInfo];
    
    [self createTableView];
    
    [self tooltipBgViewSetGesture];
    
}

//按钮布局情况
-(void)setBtns
{
    if ([_isPassAgain isEqualToString:@"1"])//未批复的
    {
        [_passBtn setHidden:NO];
        
        [_refuseBtn setHidden:NO];
        
        [_againPassBtn setHidden:YES];
        
    } else if([_isPassAgain isEqualToString:@"0"])//再次授权
    {
        
        [_passBtn setHidden:YES];
        
        [_refuseBtn setHidden:YES];
        
        [_againPassBtn setHidden:NO];
        
    }
}

//设置默认的信息
-(void)setDefaultInfo
{
    [_applyTime setText:[CustomAlertView convertTimestampToString:[[_currentCommunityInfomDic objectForKey:@"creationtime"] longLongValue]]];
    
    [_remark setText:[_currentCommunityInfomDic objectForKey:@"memo"]];
    
    if ([_currentCommunityInfomDic objectForKey:@"bid"] == nil)
    {
        _community_bid = [_userCommunityListmArray[0] objectForKey:@"bid"];
        
        [_communityTxt setText:[_userCommunityListmArray[0] objectForKey:@"name"]];
        
    } else {
        
        _community_bid = [_currentCommunityInfomDic objectForKey:@"bid"];
        
        [_communityTxt setText:[_currentCommunityInfomDic objectForKey:@"name"]];
    }
    
}

#pragma mark - 创建小区弹出列表

- (void)createTableView{
    
    _typeTableView = [[SubViewController alloc] init];
    
    //headTitle子视图头标题；
    _typeTableView.headTitle = @"小区列表";
    
    _typeTableView.typeDelegate = self;
    
    _typeTableView.dataArray = [NSMutableArray arrayWithArray:_userCommunityListmArray];
    
    [_typeTableView.tableView reloadData];
    
}
#pragma mark typeDelegate

- (void)typeviewControllerDidCancel:(SubViewController *)type{
    [_typeTableView hideView];
}

- (void)typeViewdidClick:(SubViewController *)type AtIndex:(NSInteger)index{
    
    [_typeTableView hideView];
    
    [_communityTxt setText:[NSString stringWithFormat:@"%@",[type.dataArray[index] objectForKey:@"name"]]];
    
    NSLog(@"1111111111  is  %@",type.dataArray[index]);
    
    _community_bid = [type.dataArray[index] objectForKey:@"bid"];
    
    
}

#pragma mark -

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.communityTxt) {
        
        [_typeTableView.tableView reloadData];
        
        [_typeTableView showViw:self.view];
        
        _typeTableView.checkMark = _communityTxt.text;
        
        return NO;
    }
    
    return YES;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)hoursBtnAction:(id)sender {
    
    self.twoHourImg.hidden=NO;
    self.oneDayImg.hidden=YES;
    self.sevDayImg.hidden=YES;
    self.oneYearImg.hidden=YES;
    self.everImg.hidden=YES;
    
    self.authTime = @"0";
    
}

- (IBAction)oneDayBtnAction:(id)sender {
    
    self.twoHourImg.hidden=YES;
    self.oneDayImg.hidden=NO;
    self.sevDayImg.hidden=YES;
    self.oneYearImg.hidden=YES;
    self.everImg.hidden=YES;
    
    self.authTime = @"1";
}

- (IBAction)sevenDayBtnAction:(id)sender {
    
    self.twoHourImg.hidden=YES;
    self.oneDayImg.hidden=YES;
    self.sevDayImg.hidden=NO;
    self.oneYearImg.hidden=YES;
    self.everImg.hidden=YES;
    
    self.authTime = @"2";
}

- (IBAction)oneYearBtnAction:(id)sender {
    
    self.twoHourImg.hidden=YES;
    self.oneDayImg.hidden=YES;
    self.sevDayImg.hidden=YES;
    self.oneYearImg.hidden=NO;
    self.everImg.hidden=YES;
    
    self.authTime = @"3";
}

- (IBAction)permanentBtnAction:(id)sender {
    
    self.twoHourImg.hidden=YES;
    self.oneDayImg.hidden=YES;
    self.sevDayImg.hidden=YES;
    self.oneYearImg.hidden=YES;
    self.everImg.hidden=NO;
    
    self.authTime = @"4";
}



#pragma mark - 通过
- (IBAction)passBtnAction:(id)sender {
    
    NSString * autype = @"1";//默认限时
    
    NSString * granttype = @"0";//默认没有二次授权
    
    NSString * starttime = [[NSDate date] toStringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * stoptime = @"0000-00-00 00:00:00";//yyyy-MM-dd HH:mm:ss
    
    NSString * usertype = @"4";//默认2小时
    
    NSString * memo = self.remark.text;
    
    switch ([self.authTime intValue]) {
        case 0: //2小时
            usertype = @"4";
            
            stoptime = [NSDate stringFromDate:[NSDate dateWithHoursFromNow:2] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;
        case 1: //一天
            usertype = @"3";
            
            stoptime = [NSDate stringFromDate:[NSDate dateWithDaysFromNow:1] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;
        case 2: //7天
            usertype = @"2";
            
            stoptime = [NSDate stringFromDate:[NSDate dateWithDaysFromNow:7] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;
        case 3: //一年
            usertype = @"5";
            
            stoptime = [NSDate stringFromDate:[NSDate dateWithDaysFromNow:365] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;
        case 4: //永久
            usertype = @"1";
            granttype = @"1";
            autype = @"2";
            
            starttime = @"0000-00-00 00:00:00";
            
            break;
            
        default:
            break;
    }
    //TODO:代码块内，需要弱引用self
   
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *sendDict = @{
                               @"customer_id":[weakSelf.infomDic objectForKey:@"id"],
                               @"applyid":[weakSelf.currentCommunityInfomDic objectForKey:@"id"],
                                @"memo":memo,
                                   @"autype":autype,
                                   @"granttype":granttype,
                                   @"starttime":starttime,
                                   @"stoptime":stoptime,
                                   @"bid":weakSelf.community_bid,
                                   @"usertype":usertype,
                               
                                   @"approve":@"1"
                                   
                                   
                                   
                                   };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/ApplyApprove" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            //发出通知，更新授权记录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAuthrozationList" object:nil];
            
        } else {
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"reason"]];
           
            
        }

        
        
    }
     
     
    failure:^(NSError *error) {
         
         
         
         
     }];

       
}

#pragma mark - 拒绝
- (IBAction)refuseBtnAction:(id)sender {
    
    NSString * autype = @"1";//默认限时
    
    NSString * granttype = @"0";//默认没有二次授权
    
    NSString * starttime = [[NSDate date] toStringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * stoptime = @"0000-00-00 00:00:00";//yyyy-MM-dd HH:mm:ss
    
    NSString * usertype = @"4";//默认2小时
    
    NSString * memo = self.remark.text;
    
    switch ([self.authTime intValue]) {
        case 0: //2小时
            usertype = @"4";
            
            stoptime = [NSDate stringFromDate:[NSDate dateWithHoursFromNow:2] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;
        case 1: //一天
            usertype = @"3";
            
            stoptime = [NSDate stringFromDate:[NSDate dateWithDaysFromNow:1] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;
        case 2: //7天
            usertype = @"2";
            
            stoptime = [NSDate stringFromDate:[NSDate dateWithDaysFromNow:7] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;
        case 3: //一年
            usertype = @"5";
            
            stoptime = [NSDate stringFromDate:[NSDate dateWithDaysFromNow:365] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;
        case 4: //永久
            usertype = @"1";
            granttype = @"1";
            autype = @"2";
            
            starttime = @"0000-00-00 00:00:00";
            
            break;
            
        default:
            break;
    }
    
   
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *sendDict = @{
                               @"customer_id":[weakSelf.infomDic objectForKey:@"id"],
                               @"applyid":[weakSelf.currentCommunityInfomDic objectForKey:@"id"],
                               @"memo":memo,
                               @"autype":autype,
                               @"granttype":granttype,
                               @"starttime":starttime,
                               @"stoptime":stoptime,
                               @"bid":weakSelf.community_bid,
                               @"usertype":usertype,
                               
                               @"approve":@"2"
                               
                               
                               
                               };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/ApplyApprove" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"已拒绝批复"];
            //发出通知，更新授权记录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAuthrozationList" object:nil];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        } else {
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"reason"]];
            
            
        }
        
        
        
    }
     
     
        failure:^(NSError *error) {
                                
                                
                                
                                
    }];
    

    
}

#pragma mark - 再次授权-通过
- (IBAction)againPassBtnAction:(id)sender {
    
    
    NSString * autype = @"1";//默认限时
    
    NSString * granttype = @"0";//默认没有二次授权
    
    NSString * starttime = [[NSDate date] toStringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * stoptime = @"0000-00-00 00:00:00";//yyyy-MM-dd HH:mm:ss
    
    NSString * usertype = @"4";//默认2小时
    
    NSString * memo = self.remark.text;
    
    switch ([self.authTime intValue]) {
        case 0: //2小时
            usertype = @"4";
            
            stoptime = [NSDate stringFromDate:[NSDate dateWithHoursFromNow:2] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;
        case 1: //一天
            usertype = @"3";
            
            stoptime = [NSDate stringFromDate:[NSDate dateWithDaysFromNow:1] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;
        case 2: //7天
            usertype = @"2";
            
            stoptime = [NSDate stringFromDate:[NSDate dateWithDaysFromNow:7] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;
        case 3: //一年
            usertype = @"5";
            
            stoptime = [NSDate stringFromDate:[NSDate dateWithDaysFromNow:365] withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            break;
        case 4: //永久
            usertype = @"1";
            granttype = @"1";
            autype = @"2";
            
            starttime = @"0000-00-00 00:00:00";
            
            break;
            
        default:
            break;
    }
    
    
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *sendDict = @{
                               @"customer_id":[weakSelf.infomDic objectForKey:@"id"],
                               @"autype":autype,
                               @"granttype":granttype,
                               @"starttime":starttime,
                               @"stoptime":stoptime,
                               @"bid":weakSelf.community_bid,
                               @"usertype":usertype,
                               @"memo":memo,
                               @"toid":[weakSelf.currentCommunityInfomDic objectForKey:@"toid"]
                               
                             
                               
                               
                               
                               };
    [SVProgressHUD showWithStatus:@"正在授权"];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/AuthorizationAuthorize" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            weakSelf.countDown = 6;
            
            weakSelf.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            //发出通知，更新授权记录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAuthrozationList" object:nil];
            
        } else {
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"reason"]];
            
            
        }
        [weakSelf.navigationController popToViewController:_authrozationViewController animated:YES];
        
        
    }
     
     
                            failure:^(NSError *error) {
                                
                                
                                
                                
                            }];
    

    
    
}


#pragma mark - 授权成功提示

/**
 *  tooltipBgView 添加手势
 */
-(void)tooltipBgViewSetGesture
{
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tooltipBgViewClick:)];
    
    [_tooltipBgView addGestureRecognizer:recognizer];
}

-(void)tooltipBgViewClick:(id)sender
{
    if (self.tooltipView.hidden == NO) {
        
        if (_timer) {
            
            [_timer invalidate];
            
        }
        
        self.tooltipBgView.hidden = YES;
        
        self.tooltipView.hidden = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//计算时间差，每一秒进行刷新
-(void)timerFireMethod:(NSTimer *)timer{
    
    _countDown--;
    
    if (_countDown==0) {
        
        self.tooltipBgView.hidden = YES;
        
        self.tooltipView.hidden = YES;
        
        [timer invalidate];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    self.tooltipLabel.text = [NSString stringWithFormat:@"(提示：此页面将在%d秒内自动关闭，并返回到门禁首页)",self.countDown];
    
    [self fuwenbenLabel:self.tooltipLabel FontNumber:[UIFont systemFontOfSize:14] AndRange:NSMakeRange(9, 1) AndColor:RGBACOLOR(253, 61, 65, 1.0)];
    
    self.tooltipBgView.hidden = NO;
    
    self.tooltipView.hidden=NO;
    
}

//改变倒计时字体的颜色
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    labell.attributedText = str;
}


#pragma mark - 


@end
