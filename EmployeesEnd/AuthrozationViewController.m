//
//  AuthrozationViewController.m
//  WeiTown
//
//  Created by 方燕娇 on 16/8/15.
//  Copyright © 2016年 Hairon. All rights reserved.
//
#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]


#import "AuthrozationViewController.h"
#import "CustomAlertView.h"
#import "AuthrozationListTableViewCell.h"//授权记录table cell
#import "MCHttpManager.h"
#import "MCMacroDefinitionHeader.h"
#import "SVProgressHUD.h"
#import "DetailAuthrozationViewController.h"//授权详情
#import "AgainAuthrozationViewController.h"//批复页面
#import "NSDateHelper.h"

@interface AuthrozationViewController ()<UITextViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

{
    CGFloat tv_height;//授权记录表格高度
}
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

@property (retain, nonatomic) IBOutlet UIScrollView *scrollview;


@property (retain, nonatomic) IBOutlet UIButton *confirmBtn;//确定授权

@property (retain, nonatomic) IBOutlet UITableView *tv;//授权记录 列表

@property (retain, nonatomic) IBOutlet UITextField *phoneTxt;//电话号码

@property (retain, nonatomic) IBOutlet UITextField *communityTxt;//授权小区

@property (strong, nonatomic) NSString * community_bid;

//填写备注
@property (retain, nonatomic) IBOutlet UILabel *memoLabel;

@property (retain, nonatomic) IBOutlet UITextView *memoTxt;

//授权时间
@property (copy, nonatomic) NSString *authTime;

//授权成功提示
@property (retain, nonatomic) IBOutlet UIView *tooltipBgView;

@property (retain, nonatomic) IBOutlet UIView *tooltipView;

@property (retain, nonatomic) IBOutlet UILabel *tooltipLabel;

@property (assign, nonatomic) int countDown;
@property (strong, nonatomic) NSTimer *timer;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;

@property (strong, nonatomic) NSMutableArray * myAuthroListmArray;//授权记录 列表 数据源

@property (strong, nonatomic) NSMutableArray * userCommunityListmArray;//用户小区列表 数据源

@property (strong, nonatomic) NSString * isReply;//判断是不是未批复   0：拒绝； 1：未批复； 2：已失效； 3：通过




@end

@implementation AuthrozationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tv setDelegate:self];
    
    [_tv setDataSource:self];
    
    [_tv setScrollEnabled:NO];
    
    [_tv setRowHeight:130.0f];
    
    [_tv setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.memoTxt setDelegate:self];
    
    [self get_userCommunityList];
    
    [self get_AuthorizationList];
    
    [self tooltipBgViewSetGesture];
    
    [self createTableView];
    
    //默认2小时（授权期限)
    self.authTime = @"0";
    
    [self.phoneTxt addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];//电话号码输入
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(get_AuthorizationList) name:@"UpdateAuthrozationList" object:nil];
        
}


-(void) textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] == 0) {
        
        [self.memoLabel setHidden:NO];
        
    }else{
        
        [self.memoLabel setHidden:YES];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  电话号码输入
 *
 *  @param textfield <#textfield description#>
 */
-(void)textChange:(UITextField *)textfield{
    
    
    NSString *pwd = textfield.text;
    
    NSUInteger length = pwd.length;
    
    if (length > 11 ){
        [self showAlertViewWithString:@"请输入11位电话号码" andDurationTime:2.0];
        
        self.phoneTxt.text = pwd;
        return;
    }
    
    if (textfield.text.length >= 11 && self.communityTxt.text != 0) {
        self.confirmBtn.backgroundColor = RGBACOLOR(49, 163, 237, 1.0);
    }else{
        self.confirmBtn.backgroundColor = RGBACOLOR(222, 222, 222, 1.0);
    }
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



#pragma mark - 创建小区弹出列表

- (void)createTableView{
    
    _typeTableView = [[SubViewController alloc] init];
    
    //headTitle子视图头标题；
    _typeTableView.headTitle = @"小区列表";
    
    _typeTableView.typeDelegate = self;
    
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

/**
 *  点击确定
 *
 *  @param sender <#sender description#>
 */
- (IBAction)confirmClick:(id)sender {
    
    NSString * autype = @"1";//默认限时
    
    NSString * granttype = @"0";//默认没有二次授权
    
//    NSString *starttime = [[NSDate date] toString:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * starttime = [[NSDate date] toStringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * stoptime = @"0000-00-00 00:00:00";//yyyy-MM-dd HH:mm:ss
    
    NSString * usertype = @"4";//默认2小时
    
    NSString * mobile = self.phoneTxt.text;
    
    NSString * memo = self.memoTxt.text;
    
    if (mobile.length == 0) {
        
        [self showAlertViewWithString:@"手机号码不能为空" andDurationTime:2.0];
        
        return;
        
    }
    else if (mobile.length != 11) {
        
        [self showAlertViewWithString:@"请输入正确的手机号" andDurationTime:2.0];
        
        return;
        
    }
    if (self.communityTxt.text.length == 0) {
        
        [self showAlertViewWithString:@"请选择小区" andDurationTime:2.0];
        
        return;
        
    }
    
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
    
    //......................................................................................................
    //调用接口...
    
   
    
    NSLog(@"bid is %@",_community_bid);
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"autype":autype,
                               @"granttype":granttype,
                               @"bid":weakSelf.community_bid,
                               @"usertype":usertype,
                               @"mobile":mobile,
                               @"starttime":starttime,
                               @"stoptime":stoptime,
                                @"memo":memo
                               };
    [SVProgressHUD showWithStatus:@"正在授权..."];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/AuthorizationAuthorize4mobile" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            weakSelf.countDown = 6;
            
            weakSelf.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            
        } else {
            NSString * errMsg = [dicDictionary objectForKey:@"reason"];
            
            [SVProgressHUD showErrorWithStatus:errMsg];
        }

        
        
    }
     
     
     failure:^(NSError *error) {
         
         
         
         
     }];

    
    
    //请求接口成功，跳出提示框
    
    
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



#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tv) {
        
        return [self.myAuthroListmArray count];
    }
    else {
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tv) {
        
        static NSString *cellId = @"AuthrozationListTableViewCell";
        
        AuthrozationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"AuthrozationListTableViewCell" owner:self options:nil].lastObject;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.phoneLab setText:[self.myAuthroListmArray[indexPath.row] objectForKey:@"toname"]];//??
        
        [cell.communityName setText:[self.myAuthroListmArray[indexPath.row] objectForKey:@"name"]];
        
        NSString * time = [CustomAlertView convertTimestampToString:[[self.myAuthroListmArray[indexPath.row] objectForKey:@"creationtime"] longLongValue]];
        
        [cell.timeLab setText:time];
        
        NSString * timetype;
        
        UIColor * timetypeColor;
        
        if ([[self.myAuthroListmArray[indexPath.row] objectForKey:@"type"] intValue] == 1) {
            
            if ([[self.myAuthroListmArray[indexPath.row] objectForKey:@"isdeleted"] intValue] == 1)
            {
                timetype = @"拒绝";
                
                timetypeColor = [UIColor blackColor];
                
                _isReply = @"0";
                
            }else{
                
                timetype = @"未批复";
                
                timetypeColor = [UIColor redColor];
                
                _isReply = @"0";
            }
            
        } else if ([[self.myAuthroListmArray[indexPath.row] objectForKey:@"type"] intValue] == 2)
        {
            
            if ([[self.myAuthroListmArray[indexPath.row] objectForKey:@"isdeleted"] intValue] == 1)
            {
                timetype = @"已失效";
                
                timetypeColor = [UIColor blackColor];
                
                _isReply = @"2";
                
            }else if([[self.myAuthroListmArray[indexPath.row] objectForKey:@"type"] intValue] == 2){
                
                timetype = @"通过";
                
                timetypeColor = [UIColor greenColor];
                
                _isReply = @"3";
            }
            
        }
        
        [cell.typeLab setText:timetype];
        
        [cell.typeLab setTextColor:timetypeColor];
        
        return cell;
    }
    else {
        return nil;
    }

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tv)
    {
        
        NSLog(@"权限记录 选中行的数据：%@",self.myAuthroListmArray[indexPath.row]);
        
        DetailAuthrozationViewController * detailAuthrozationVC = [DetailAuthrozationViewController new];
        
        NSString * timetype;
        
        if ([[self.myAuthroListmArray[indexPath.row] objectForKey:@"type"] intValue] == 1) {
            
            if ([[self.myAuthroListmArray[indexPath.row] objectForKey:@"isdeleted"] intValue] == 1)
            {
                timetype = @"拒绝";
                
            }else{
                
                timetype = @"未批复";
                
            }
            
            AgainAuthrozationViewController * againAuthrozationVC = [AgainAuthrozationViewController new];
            
            againAuthrozationVC.isPassAgain = @"1";
            
            againAuthrozationVC.infomDic = _infomDic;
            
            againAuthrozationVC.currentCommunityInfomDic = self.myAuthroListmArray[indexPath.row];
            
            againAuthrozationVC.userCommunityListmArray = self.userCommunityListmArray;
            
            [self.navigationController pushViewController:againAuthrozationVC animated:YES];
            
            
        } else if ([[self.myAuthroListmArray[indexPath.row] objectForKey:@"type"] intValue] == 2)
        {
            
            if ([[self.myAuthroListmArray[indexPath.row] objectForKey:@"isdeleted"] intValue] == 1)
            {
                timetype = @"已失效";
                
                detailAuthrozationVC.buttonTag = 11;
                
                
                
            }else if([[self.myAuthroListmArray[indexPath.row] objectForKey:@"type"] intValue] == 2){
                
                timetype = @"通过";
                
                detailAuthrozationVC.buttonTag = 12;
                
                
            }
            
            detailAuthrozationVC.autype_Str = timetype;
            
            detailAuthrozationVC.infomDic = _infomDic;
            
            detailAuthrozationVC.currentCommunityInfomDic = self.myAuthroListmArray[indexPath.row];
            
            detailAuthrozationVC.userCommunityListmArray = self.userCommunityListmArray;
            
            detailAuthrozationVC.authrozationViewController = self;
            
            [self.navigationController pushViewController:detailAuthrozationVC animated:YES];
            
        }
    }
    
}


/**
 *  获取用户小区列表数据
 */
-(void)get_userCommunityList
{
    
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                                                                    };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/UserCommunityList" parameters:sendDict success:^(id responseObject) {
       
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0){
            
            if ([(NSArray *)[dicDictionary objectForKey:@"communitylist"] count])
            {
                [self.userCommunityListmArray removeAllObjects];
                
                NSArray * array = [dicDictionary objectForKey:@"communitylist"];
                
                [self.userCommunityListmArray addObjectsFromArray:array];
                
                [_communityTxt setText:[_userCommunityListmArray[0] objectForKey:@"name"]];//默认取第一个
                
                _community_bid = [_userCommunityListmArray[0] objectForKey:@"bid"];
                
                NSLog(@"这时候的数据是：%@",_userCommunityListmArray);
                
                _typeTableView.dataArray = [NSMutableArray arrayWithArray:self.userCommunityListmArray];
                
                [_typeTableView.tableView reloadData];
            }
            
        }

        
        
    }
     
     
     
      failure:^(NSError *error) {
         
         
         
         
     }];

   }


/**
 *  获取授权记录列表
 */
-(void)get_AuthorizationList{
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                                                                    };
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/AuthorizationGetList4top" parameters:sendDict success:^(id responseObject) {
       
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            
            if ([(NSArray *)[dicDictionary objectForKey:@"list"] count] == 0)
            {
                [weakSelf.tv setHidden:YES];
                
                
            }else {
                
                [weakSelf.tv setHidden:NO];
                
            }
            
            
            [weakSelf.myAuthroListmArray removeAllObjects];
            
            NSArray * array = [dicDictionary objectForKey:@"list"];
            
            [weakSelf.myAuthroListmArray addObjectsFromArray:array];
            
            [weakSelf removeFromUserDefaults:@"myAuthroListmArray_Cache"];
            
            //将最新数据缓存到Plist中
            [weakSelf writeToUserDefaults:weakSelf.myAuthroListmArray withKey:@"myAuthroListmArray_Cache"];
            
            [weakSelf.tv reloadData];
            
            tv_height = weakSelf.myAuthroListmArray.count * 130.0;
            
            [weakSelf.tv setFrame:CGRectMake(weakSelf.tv.frame.origin.x, weakSelf.tv.frame.origin.y, SCREEN_WIDTH, tv_height)];
            
            [weakSelf.containerViewHeight setConstant:(345.0 + tv_height)];
            
            //设置偏移
            [weakSelf.scrollview setContentOffset:CGPointMake(0, 0)];
            
        }
        else
        {
            
        }

        
        
    }
     
     failure:^(NSError *error) {
         
         
         
         
     }];

    
   }




#pragma mark -
/**
 *  弹出自定义的提示框
 *
 *  @param alertString 提示文本
 *  @param duration    持续时间
 */
-(void)showAlertViewWithString:(NSString *)alertString andDurationTime:(NSTimeInterval)duration{
    
    CustomAlertView *alertView = [[CustomAlertView alloc]init];
    
    [alertView setAlertString:alertString];
    
    [alertView setTimerWithDuration:duration];//设置定时器关闭时间
    
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
    
}

-(NSMutableArray *)myAuthroListmArray
{
    if (!_myAuthroListmArray)
    {
        _myAuthroListmArray = [NSMutableArray new];
        
        //获取缓存数据
        NSArray *myAuthroListmArrayCache = [self readFromUserDefaults:@"myAuthroListmArray_Cache"];
        
        if (myAuthroListmArrayCache != nil) {
            
            [_myAuthroListmArray addObjectsFromArray:myAuthroListmArrayCache];
        }
        
    }
    return _myAuthroListmArray;
}

-(NSMutableArray *)userCommunityListmArray
{
    if (!_userCommunityListmArray)
    {
        _userCommunityListmArray = [NSMutableArray new];
    }
    return _userCommunityListmArray;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 通过UserDefaults读、写Plist方法

/**
 *  通过UserDefaults从Plist文件读取数据
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 */
-(id)readFromUserDefaults:(NSString *)key{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:key];
    
}



/**
 *  通过UserDefaults将数据写入Plist文件
 *
 *  @param obj <#obj description#>
 *  @param key <#key description#>
 */
-(void)writeToUserDefaults:(id)obj withKey:(NSString *)key{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:obj forKey:key];
    
    [userDefaults synchronize];
    
}

/**
 *  通过UserDefaults从Plist文件删除数据
 *
 *  @param key <#key description#>
 *
 */
-(void)removeFromUserDefaults:(NSString *)key{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:key];
    
    [userDefaults synchronize];
    
}


@end
