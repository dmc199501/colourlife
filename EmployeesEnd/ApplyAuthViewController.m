//
//  ApplyAuthViewController.m
//  WeiTown
//
//  Created by 方燕娇 on 16/8/12.
//  Copyright © 2016年 Hairon. All rights reserved.
//
#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]


#import "ApplyAuthViewController.h"
#import "MyApplyTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
#import "MCHttpManager.h"
#import "SVProgressHUD.h"
#import "CustomAlertView.h"
#import "DetailApplyAuthViewController.h"//申请详情页面


@interface ApplyAuthViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

{
    CGFloat tv_height;//我的申请记录表格高度
}
@property (retain, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (retain, nonatomic) IBOutlet UIView *containerView;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;


@property (retain, nonatomic) IBOutlet UITextField *phoneTxt;//请输入申请人手机号码

@property (retain, nonatomic) IBOutlet UITextView *remarkTxt;//请填写备注信息

@property (retain, nonatomic) IBOutlet UILabel *remarkLabel;

@property (retain, nonatomic) IBOutlet UIButton *submitBtn;//确定 按钮

@property (retain, nonatomic) IBOutlet UITableView *tv;

@property (strong, nonatomic) NSMutableArray * myApplyListmArray;//我的申请 列表 数据源

@end

@implementation ApplyAuthViewController
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
    
    [_bgScrollView setScrollEnabled:YES];
    
    [_tv setDelegate:self];
    
    [_tv setDataSource:self];
    
    [_tv setScrollEnabled:NO];
    
    [_tv setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_tv setRowHeight:100.f];
    
    [self.remarkTxt setDelegate:self];
    
    [_phoneTxt addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self get_applyAuthorizationList];
    
}


-(void) textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] == 0) {
        
        [self.remarkLabel setHidden:NO];
        
    }else{
        
        [self.remarkLabel setHidden:YES];
        
    }
}


-(void)textChange:(UITextField *)txt{
    
    NSString *pwd = txt.text;
    
    NSUInteger length = pwd.length;
    
    if (length > 11 ){
        
        [self showAlertViewWithString:@"请输入11位电话号码" andDurationTime:2.0];
        
       
        
        self.phoneTxt.text = pwd;
        
        return;
    }
    if (txt.text.length>=11) {
        
        [self.submitBtn setEnabled:YES];
        
        self.submitBtn.backgroundColor = RGBACOLOR(49, 163, 237, 1.0);
        
    }else {
        
        [self.submitBtn setEnabled:NO];
        
        self.submitBtn.backgroundColor = RGBACOLOR(222, 222, 222, 1.0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//门禁申请权限确定事件
- (IBAction)submitBtnAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    
    [SVProgressHUD showWithStatus:@"正在申请"];
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"account":weakSelf.phoneTxt.text,
                               @"memo":weakSelf.remarkTxt.text};
    [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/ApplyApply4mobile" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"申请成功，等待审核！"];
            //申请成功，刷新纪录
            [weakSelf get_applyAuthorizationList];
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dicDictionary[@"reason"]];
            
        }
        
        
        
        
        
        
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
    }];
    
    }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.myApplyListmArray count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"funcCell";
    
    MyApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyApplyTableViewCell" owner:self options:nil].lastObject;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.fromname setText:[self.myApplyListmArray[indexPath.row] objectForKey:@"fromname"]];//fromname
    
    NSString * time = [CustomAlertView convertTimestampToString:[[self.myApplyListmArray[indexPath.row] objectForKey:@"creationtime"] longLongValue]];
    
    [cell.creationtime setText:time];//申请时间
    
    [cell.name setText:[self.myApplyListmArray[indexPath.row] objectForKey:@"name"]];//申请小区
    
    NSString * timetype;
    
    UIColor * timetypeColor;
    
    if ([[self.myApplyListmArray[indexPath.row] objectForKey:@"type"] intValue] == 1) {
        
        if ([[self.myApplyListmArray[indexPath.row] objectForKey:@"isdeleted"] intValue] == 1)
        {
            timetype = @"拒绝";
            
            timetypeColor = [UIColor blackColor];
            
        }else{
            
            timetype = @"未批复";
            
            timetypeColor = [UIColor redColor];
        }
        
    } else if ([[self.myApplyListmArray[indexPath.row] objectForKey:@"type"] intValue] == 2)
    {
        
        if ([[self.myApplyListmArray[indexPath.row] objectForKey:@"isdeleted"] intValue] == 1)
        {
            timetype = @"已失效";
            
            timetypeColor = [UIColor blackColor];
            
        }else if([[self.myApplyListmArray[indexPath.row] objectForKey:@"type"] intValue] == 2){
            
            
            
            int usertype = [[self.myApplyListmArray[indexPath.row] objectForKey:@"usertype"] intValue];
            
            if (usertype == 1) {
                timetype = @"永久";
            }
            else if (usertype == 2)
            {
                timetype = @"7天";
            }
            else if (usertype == 3)
            {
                timetype = @"1天";
            }
            else if (usertype == 4)
            {
                timetype = @"2小时";
            }
            else if (usertype == 5)
            {
                timetype = @"1年";
            }
            
            timetypeColor = [UIColor greenColor];
        }
        
    }
    
    [cell.timetype setText:timetype];
    
    [cell.timetype setTextColor:timetypeColor];
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailApplyAuthViewController * detailApplyAuthVC = [DetailApplyAuthViewController new];
    
    detailApplyAuthVC.infomDic = _infomDic;
    
    detailApplyAuthVC.currentApplyInfomDic = self.myApplyListmArray[indexPath.row];
    
    detailApplyAuthVC.phone = [self.myApplyListmArray[indexPath.row] objectForKey:@"mobile"];
    
    detailApplyAuthVC.remark = [self.myApplyListmArray[indexPath.row] objectForKey:@"memo"];
    
    NSString * timetype;
    
    if ([[self.myApplyListmArray[indexPath.row] objectForKey:@"type"] intValue] == 1) {
        
        if ([[self.myApplyListmArray[indexPath.row] objectForKey:@"isdeleted"] intValue] == 1)
        {
            timetype = @"拒绝";
            
            detailApplyAuthVC.ishidden = NO;
            
        }else{
            
            timetype = @"未批复";
            
            detailApplyAuthVC.ishidden = YES;
        }
        
    } else if ([[self.myApplyListmArray[indexPath.row] objectForKey:@"type"] intValue] == 2)
    {
        
        if ([[self.myApplyListmArray[indexPath.row] objectForKey:@"isdeleted"] intValue] == 1)
        {
            timetype = @"已失效";
            
            detailApplyAuthVC.ishidden = NO;
            
        }else if([[self.myApplyListmArray[indexPath.row] objectForKey:@"type"] intValue] == 2){
            
            int usertype = [[self.myApplyListmArray[indexPath.row] objectForKey:@"usertype"] intValue];
            
            if (usertype == 1) {
                timetype = @"永久";
            }
            else if (usertype == 2)
            {
                timetype = @"7天";
            }
            else if (usertype == 3)
            {
                timetype = @"1天";
            }
            else if (usertype == 4)
            {
                timetype = @"2小时";
            }
            else if (usertype == 5)
            {
                timetype = @"1年";
            }
            
            detailApplyAuthVC.ishidden = YES;
        }
        
    }
    
    detailApplyAuthVC.type = timetype;
    
    
    [self.navigationController pushViewController:detailApplyAuthVC animated:YES];

}

/**
 *  获取我的申请列表
 */
-(void)get_applyAuthorizationList{
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"]
                               };
    //[SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/AuthorizationGetList4topByToID" parameters:sendDict success:^(id responseObject) {
        //[SVProgressHUD dismiss];
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
            
            [weakSelf.myApplyListmArray removeAllObjects];
            
            NSArray * array = [dicDictionary objectForKey:@"list"];
            
            [weakSelf.myApplyListmArray addObjectsFromArray:array];
            
            [weakSelf removeFromUserDefaults:@"myApplyListmArray_Cache"];
            
            //将最新数据缓存到Plist中
            [weakSelf writeToUserDefaults:weakSelf.myApplyListmArray withKey:@"myApplyListmArray_Cache"];
            
            
            [weakSelf.tv reloadData];
            
            tv_height = weakSelf.myApplyListmArray.count * 100.0;
            
            [weakSelf.tv setFrame:CGRectMake(weakSelf.tv.frame.origin.x, weakSelf.tv.frame.origin.y, SCREEN_WIDTH, tv_height)];
            
            [weakSelf.containerViewHeight setConstant:(255.0 + tv_height)];
            
            
        }
        else
        {
            [SVProgressHUD showWithStatus:dicDictionary[@"reason"]];
        }
        
        
        
        
        
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
    }];

    }

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

-(NSMutableArray *)myApplyListmArray
{
    if (!_myApplyListmArray)
    {
        _myApplyListmArray = [NSMutableArray new];
        
        //获取缓存数据
        NSArray *myApplyListmArrayCache = [self readFromUserDefaults:@"myApplyListmArray_Cache"];
        
        if (myApplyListmArrayCache != nil) {
            
            [_myApplyListmArray addObjectsFromArray:myApplyListmArrayCache];
        }
    }
    return _myApplyListmArray;
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
