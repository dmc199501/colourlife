//
//  EntranceGuardViewController.m
//  WeiTown
//
//  Created by 方燕娇 on 16/8/10.
//  Copyright © 2016年 Hairon. All rights reserved.
//
#define UIColorFromRGB(rgbValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]
#import "EntranceGuardViewController.h"
#import "MCHttpManager.h"
#import "MCMacroDefinitionHeader.h"
#import "SVProgressHUD.h"
#import "ApplyOpenEntranceGuardViewController.h"//申请开通门禁
#import "CFPopView.h"//弹框视图
#import "CFFuncModel.h"//弹框视图的数据
#import "MCWebViewController.h"//门禁说明
#import "ApplyAuthViewController.h"//申请权限
#import "AuthrozationViewController.h"//权限授权
#import "CLEntranceGuardEditVCViewController.h"//编辑门禁
//#import "PMApps.h"//“扫码开门”功能相关的接口
#import "HCScanQRViewController.h"

#import "OpenDoorViewController.h"
#import "OpenDoorRecordTableViewCell.h"//开门记录的cell

#import "CustomAlertView.h"
#import "CommonEntranceGuardCollectionViewCell.h"//常用门禁CollectionViewCell



@interface EntranceGuardViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *stepFourImgV;//四步骤 -图片

@property (retain, nonatomic) IBOutlet UIButton *scanBtn;//扫一扫 -按钮

@property (retain, nonatomic) IBOutlet UIButton *clickApplyBtn;//点击申请 -按钮

@property (strong, nonatomic) UIView * popBgView;//弹框视图的背景视图

@property (strong, nonatomic) CFPopView * popView;//弹框视图

@property (retain, nonatomic) IBOutlet UIView *firstView;//带开门记录列表的视图

@property (retain, nonatomic) IBOutlet UITableView *doorOpenlogTableView;//开门记录表

@property (strong, nonatomic) NSMutableArray * doorOpenlogMArry;//存储开门记录接口的数据

@property (retain, nonatomic) IBOutlet UIView *secondView;//带扫码开门步骤图片的视图

@property (retain, nonatomic) IBOutlet UICollectionView *commonUseColleV;//常用的门禁列表

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *commonColleVHeight;

@property (strong, nonatomic) NSMutableArray * commonUseColleVmArry;//存储常用的门禁列表的数据

@property (strong, nonatomic) NSMutableDictionary * communityInfoDict;//当前用户所在的小区信息

@property (retain, nonatomic) IBOutlet UIView *doorEmptyView;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *doorEmptyViewTopConstraint;


@property (retain, nonatomic) IBOutlet UIButton *clearAllBtn;


@end

@implementation EntranceGuardViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"门禁";
//    [_firstView setHidden:YES];
    
    //==================================================================================
    //设置表格数据源代理及行高
    
    [_doorOpenlogTableView setDelegate:self];
    
    [_doorOpenlogTableView setDataSource:self];
    
    [_doorOpenlogTableView setScrollEnabled:YES];
    
    [_doorOpenlogTableView setRowHeight:70.0f];
    
    [_doorOpenlogTableView setTableFooterView:[UIView new]];
    
//    [_doorOpenlogTableView setBackgroundColor:[UIColor clearColor]];
    
    //==================================================================================
    
    [self createCommonUseCollectionView];//创建常用门禁列表collectionView表格
    
//    [self postBusinessAgentRequest_doorfixedGetlist];//调用“获取常用门禁列表”接口，获取collectionView数据源
    
    //==================================================================================
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_nav_more.png"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnAction:)];
    
    
    [self communityGetByColorIDInfo];//获取当前登录的用户所在的小区信息
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [_stepFourImgV setImage:[UIImage imageNamed:@"img_no_doorlog"]];//设置“四步骤”图片
    
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"door_scan"] forState:UIControlStateNormal];//设置“扫一扫”按钮背景图片
    
    [self clickApplyBtn_SetAtrribute];//设置“点击申请”title颜色和下划线
    
    [self.view addSubview:self.popView];//添加 弹框视图的背景视图 到父视图
//    
    [self.popView setAlpha:0];
    
    //TODO:扫码开门
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //[[AppPlusAppDelegate sharedAppDelegate] hideLoading];
    
    [self postBusinessAgentRequest_doorfixedGetlist];//获取常用门禁，重新刷新数据源
    
    //获取缓存数据
    NSArray *commonUseColleVmArryCache = [self readFromUserDefaults:@"CommonListmArray_Cache"];
    
    
    if ([commonUseColleVmArryCache count] >= 3)
    {
        [self.commonColleVHeight setConstant:240.0];
        
        [self.doorEmptyViewTopConstraint setConstant:10.0];
        
    }
    else if ([commonUseColleVmArryCache count] == 0)
    {
        [_secondView setHidden:NO];
        
        [_firstView setHidden:YES];
    }
    else {
        
        [self.commonColleVHeight setConstant:120.0];
        
    }
    
    NSArray *doorOpenlogMArryCache = [self readFromUserDefaults:@"doorOpenlogMArry_Cache"];
    
    if ([doorOpenlogMArryCache count] == 0)
    {
        
        [self.doorOpenlogTableView setHidden:YES];
        
        [self.doorEmptyView setHidden:NO];
        
        [self.clearAllBtn setHidden:YES];
        
    } else {
        
        [self.doorOpenlogTableView setHidden:NO];
        
        [self.doorEmptyView setHidden:YES];
        
        [self.clearAllBtn setHidden:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.popView dismissFromKeyWindow];
}

/**
 *  获取小区信息
 */
-(void)communityGetByColorIDInfo
{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               
                               @"community_id":[weakSelf.infomDic objectForKey:@"community_id"]
                               };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/CommunityGetByColorID" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            [weakSelf.communityInfoDict removeAllObjects];
            
            id community = [dicDictionary objectForKey:@"community"];
            
            if ([community isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dict = (NSDictionary *)community;
                [weakSelf.communityInfoDict addEntriesFromDictionary:dict];
                
                if (![weakSelf.commonUseColleVmArry count])
                {
                    [weakSelf checkOpen];
                }
            }
        } else
        {
            [SVProgressHUD showWithStatus:dicDictionary[@"reason"]];
        }
        
        
        
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
    }];
    

    }

/**
 *  获取常用门禁列表
 *
 *  ***  Module:@"wetown"
 *  ***  Func:@"doorfixed/getlist"
 *
 *  @return <#return value description#>
 */
-(void)postBusinessAgentRequest_doorfixedGetlist{
    
    __weak typeof(self) weakSelf = self;

    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"module":@"wetown",
                               @"func":@"doorfixed/getlist",
                               @"params":@""
                               };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/BusinessAgentRequest" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"result"] integerValue] == 0 )
        {
            if ([(NSArray *)[dicDictionary objectForKey:@"list"] count] == 0)
            {
                //常用门禁列表数据为空／走获取小区信息接口
                
                //                [_firstView setHidden:YES];
                //
                [_secondView setHidden:NO];
                
                //                [self checkOpen];//检查是否已经申请开通手机开门
                
            } else {
                
                [_secondView setHidden:YES];
                
                [_firstView setHidden:NO];
                
                //常用门禁列表数据存在，继续调用“获取开门记录”接口
                [weakSelf postBusinessAgentRequest_doorOpenlog];
            }
            
            [weakSelf.commonUseColleVmArry removeAllObjects];
            
            NSArray * array = [dicDictionary objectForKey:@"list"];
            
            [weakSelf.commonUseColleVmArry addObjectsFromArray:array];
            
            [weakSelf removeFromUserDefaults:@"CommonListmArray_Cache"];
            
            //将最新数据缓存到Plist中
            [weakSelf writeToUserDefaults:weakSelf.commonUseColleVmArry withKey:@"CommonListmArray_Cache"];
            
            NSLog(@"此时常用门径的数据:%@",weakSelf.commonUseColleVmArry);
            
            [weakSelf.commonUseColleV reloadData];
            
            if ([weakSelf.commonUseColleVmArry count] >= 3)
            {
                [weakSelf.commonColleVHeight setConstant:240.0];
                
            }
            else if ([weakSelf.commonUseColleVmArry count] == 0)
            {
                [weakSelf.secondView setHidden:NO];
                
                [weakSelf.firstView setHidden:YES];
            }
            else {
                
                [weakSelf.commonColleVHeight setConstant:120.0];
                
            }

            
        }else{
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
    }];

}


/**
 *  获取开门记录
 *
 *  ***  Module:@"wetown"
 *  ***  Func:@"door/openlog"
 *
 *  @return <#return value description#>
 */
-(void)postBusinessAgentRequest_doorOpenlog{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"module":@"wetown",
                               @"func":@"door/openlog",
                               @"params":@""
                               };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/BusinessAgentRequest" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"result"] integerValue] == 0 )
        {
            NSLog(@"获取开门记录----------");
            [weakSelf.doorOpenlogMArry removeAllObjects];
            
            NSArray * array = [dicDictionary objectForKey:@"list"];
            
            [weakSelf.doorOpenlogMArry addObjectsFromArray:array];
            
            [weakSelf removeFromUserDefaults:@"doorOpenlogMArry_Cache"];
            
            //将最新数据缓存到Plist中
            [weakSelf writeToUserDefaults:weakSelf.doorOpenlogMArry withKey:@"doorOpenlogMArry_Cache"];
            
            [weakSelf.doorOpenlogTableView reloadData];
            
            if ([(NSArray *)[dicDictionary objectForKey:@"list"] count] == 0)
            {
                [weakSelf.doorOpenlogTableView setHidden:YES];
                
                [weakSelf.doorEmptyView setHidden:NO];
                
                [weakSelf.clearAllBtn setHidden:YES];
            }
            else
            {
                [weakSelf.doorOpenlogTableView setHidden:NO];
                
                [weakSelf.doorEmptyView setHidden:YES];
                
                [weakSelf.clearAllBtn setHidden:NO];
                
            }
        }else{
            
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
    }];

    
}

/**
 *  创建常用门禁列表
 */
-(void)createCommonUseCollectionView{
    
    //先创建一个九宫格布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    //设置单元格的各个参数
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 20 - 2)/3 , 120 - 2);
    
    layout.minimumInteritemSpacing = 0.5;
    
    layout.minimumLineSpacing = 0.5;
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [_commonUseColleV setCollectionViewLayout:layout];
    
    [_commonUseColleV setScrollEnabled:YES];//关闭滚动
    
    //初始化九宫格
    _commonUseColleV.pagingEnabled = YES;
    
    _commonUseColleV.dataSource = self;
    
    _commonUseColleV.delegate = self;
    
#pragma mark -- <注册单元格>
    [_commonUseColleV registerClass:[CommonEntranceGuardCollectionViewCell class] forCellWithReuseIdentifier:@"CommonEntranceGuardCollectionViewCell"];
    
    _commonUseColleV.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
}

#pragma mark - collectionView 代理


//九宫格单元格数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if ([self.commonUseColleVmArry count] >= 3) {
        
        return 6;
        
    }
    else{
        return 3;
    }
}


//九宫格实际内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{

#pragma mark --- <获取CommonEntranceGuardCollectionViewCell已注册的单元格>
    static NSString * CommonEntranceGuardCollectionViewCellIdentifier2 = @"CommonEntranceGuardCollectionViewCell";
        
    UINib *nib = [UINib nibWithNibName:@"CommonEntranceGuardCollectionViewCell" bundle: [NSBundle mainBundle]];
        
    [collectionView registerNib:nib forCellWithReuseIdentifier:CommonEntranceGuardCollectionViewCellIdentifier2];
        
    CommonEntranceGuardCollectionViewCell * cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommonEntranceGuardCollectionViewCell" forIndexPath:indexPath];
        
    [cell1.editingView setHidden:YES];
    
    cell1.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.item == (int)[self.commonUseColleVmArry count]) {
        
        [cell1.commonDoorName setHidden:YES];
        
        [cell1.commonDoorImageV setHidden:YES];
        
        [cell1.addDoorBtn setHidden:NO];//加号显示
        
        [cell1.addDoorBtn addTarget:self action:@selector(addDoorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else if (indexPath.item > (int)[self.commonUseColleVmArry count]) {
        
        [cell1.commonDoorName setHidden:YES];
        
        [cell1.commonDoorImageV setHidden:YES];
        
        [cell1.addDoorBtn setHidden:YES];//全空白
        
        
    }else
    {
        
        [cell1.commonDoorName setHidden:NO];
        
        [cell1.commonDoorImageV setHidden:NO];
        
        [cell1.addDoorBtn setHidden:YES];//加好隐藏
        
        [cell1.commonDoorName setText:[self.commonUseColleVmArry[indexPath.item] objectForKey:@"name"]];
        
        if ([[self.commonUseColleVmArry[indexPath.item] objectForKey:@"type"] intValue] == 2) {
            
            [cell1.commonDoorImageV setImage:[UIImage imageNamed:@"icon_bussine"]];//大楼
            
        }
         else{
            
            [cell1.commonDoorImageV setImage:[UIImage imageNamed:@"icon_home"]];//房子
            
        }
    }
    
    return cell1;
}


-(void)addDoorBtnAction:(UIButton *)button
{
    CLEntranceGuardEditVCViewController * cLEntranceGuardEditVC = [CLEntranceGuardEditVCViewController new];
    
    cLEntranceGuardEditVC.infomDic = self.infomDic;
    
    cLEntranceGuardEditVC.reloadCommonEntrData = ^(){
        
        [self postBusinessAgentRequest_doorfixedGetlist];
        
    };
    
    [self.navigationController pushViewController:cLEntranceGuardEditVC animated:YES];
}



//选中单元格执行跳转页面
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //有加号的项
    if (indexPath.item == (int)[self.commonUseColleVmArry count]) {
        
        CLEntranceGuardEditVCViewController * cLEntranceGuardEditVC = [CLEntranceGuardEditVCViewController new];
        
        cLEntranceGuardEditVC.infomDic = self.infomDic;
        
        cLEntranceGuardEditVC.reloadCommonEntrData = ^(){
            
            [self postBusinessAgentRequest_doorfixedGetlist];
            
        };
        
        [self.navigationController pushViewController:cLEntranceGuardEditVC animated:YES];
        
    }
    else if (indexPath.item < (int)[self.commonUseColleVmArry count]) {
        
        
        __weak typeof(self) weakSelf = self;
        NSLog(@"%@",[weakSelf.commonUseColleVmArry[indexPath.item]objectForKey:@"qrcode"]);
        NSDictionary *sendDict = @{
                                   @"customer_id":self.infomDic[@"id"],
                                   @"qrcode":[weakSelf.commonUseColleVmArry[indexPath.item]objectForKey:@"qrcode"],
                                   
                                   };
        
        [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
        [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/DoorOpen" parameters:sendDict success:^(id responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *dicDictionary = responseObject;
            NSLog(@"%@",dicDictionary);
            OpenDoorViewController * openDoorViewController = [OpenDoorViewController new];
            
            openDoorViewController.isfrom = @"commonUse";
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
                {
                    //开门成功
                    openDoorViewController.openSuccess = @"0";
                    
                    [weakSelf.navigationController pushViewController:openDoorViewController animated:YES];
                    
                } else {
                    
                    //开门失败
                    openDoorViewController.openSuccess = @"1";
                    
                    [weakSelf.navigationController pushViewController:openDoorViewController animated:YES];
                    
                }
                
                
            
            
            
            
            
        } failure:^(NSError *error) {
            
            
            
            
        }];
        
    }
}


#pragma mark - tableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.doorOpenlogMArry count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"OpenDoorRecordTableViewCell";
    OpenDoorRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OpenDoorRecordTableViewCell" owner:self options:nil].lastObject;
    }
    
    NSLog(@"当前的doorid是：%@",self.doorOpenlogMArry[indexPath.row][@"doorid"]);
    
    
    [cell.doorName setText:[self.doorOpenlogMArry[indexPath.row] objectForKey:@"name"]];
    
    [cell.lastTime setText:[CustomAlertView convertTimestampToString:[[self.doorOpenlogMArry[indexPath.row] objectForKey:@"creationtime"] longLongValue]]];
    
    [cell.openDoorBtn setTag:indexPath.row +100];
    
    [cell.openDoorBtn addTarget:self action:@selector(openDoorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - 点击开门事件

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"qrcode":[weakSelf.doorOpenlogMArry[indexPath.row] objectForKey:@"qrcode"],
                               
                               };
    [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/DoorOpen" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"result"] integerValue] == 0 )
        {
            OpenDoorViewController * openDoorViewController = [OpenDoorViewController new];
            
            openDoorViewController.currenDoorInfomDic = weakSelf.doorOpenlogMArry[indexPath.row];
            
            openDoorViewController.infomDic = self.infomDic;
            
            openDoorViewController.isfrom = @"uncommonUse";//默认是非常用的
            
            //        NSLog(@"当前的doorid是：%@",self.doorOpenlogMArry[indexPath.row][@"doorid"]);
            //        NSLog(@"已添加的门有：%@",self.commonUseColleVmArry);
            
            for (NSDictionary * dic in weakSelf.commonUseColleVmArry)
            {
                if ( [[dic objectForKey:@"doorid"] integerValue] == [[weakSelf.doorOpenlogMArry[indexPath.row] objectForKey:@"doorid"] integerValue])
                {
                    openDoorViewController.isfrom = @"commonUse";//uncommonUse
                    break;
                }
            }
            
            //        for (NSDictionary * dic in weakSelf.doorOpenlogMArry)
            //        {
            //            if ( [dic objectForKey:@"doorid"] == [weakSelf.commonUseColleVmArry[indexPath.row] objectForKey:@"doorid"])
            //            {
            //                openDoorViewController.isfrom = @"commonUse";//uncommonUse
            //            }
            //        }
            
            if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
            {
                //开门成功
                openDoorViewController.openSuccess = @"0";
                
                [weakSelf.navigationController pushViewController:openDoorViewController animated:YES];
                
            } else {
                
                //开门失败
                openDoorViewController.openSuccess = @"1";
                
                [weakSelf.navigationController pushViewController:openDoorViewController animated:YES];
                
            }

            
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"reason"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
    }];

    
}

-(void)openDoorBtnClick:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"qrcode":[weakSelf.doorOpenlogMArry[button.tag - 100] objectForKey:@"qrcode"],
                               
                               };
    [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/DoorOpen" parameters:sendDict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        OpenDoorViewController * openDoorViewController = [OpenDoorViewController new];
        
        openDoorViewController.isfrom = @"commonUse";
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            //开门成功
            openDoorViewController.openSuccess = @"0";
            
            [weakSelf.navigationController pushViewController:openDoorViewController animated:YES];
            
        } else {
            
            //开门失败
            openDoorViewController.openSuccess = @"1";
            
            [weakSelf.navigationController pushViewController:openDoorViewController animated:YES];
            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"reason"]];
            
        }
        
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
    }];

       
}


#pragma mark - 控件响应事件

/**
 *  导航栏-返回按钮事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)backBtnAction:(id)sender {
    
    [self.popView dismissFromKeyWindow];
    
    [self.popView dismissFromKeyWindow];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  //清除开门记录
 *
 *  @param sender <#sender description#>
 */
- (IBAction)clearBtnAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认清空开门记录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert setTag:101];
    
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        switch (buttonIndex) {
            case 0:
                NSLog(@"cancel");
                break;
            
            case 1:
            {
                __weak typeof(self) weakSelf = self;
                
                NSDictionary *sendDict = @{
                                           @"customer_id":self.infomDic[@"id"],
                                           @"module":@"wetown",
                                           @"func":@"door/clearlog",
                                           @"params":@""
                                           };
                
                [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/BusinessAgentRequest" parameters:sendDict success:^(id responseObject) {
                    
                    NSDictionary *dicDictionary = responseObject;
                    NSLog(@"%@",dicDictionary);
                    if ([dicDictionary[@"result"] integerValue] == 0 )
                    {
                        [weakSelf postBusinessAgentRequest_doorOpenlog];
                    
                    }else{
                        
                        [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"reason"]];
                    }
                    
                    
                    
                    
                } failure:^(NSError *error) {
                    
                    
                    
                    
                }];
 
            }
                break;
                
            default:
                break;
        }
    }
}

/**
 *  扫一扫按钮响应方法
 *
 *  @param sender <#sender description#>
 */
- (IBAction)scanBtnAction:(id)sender {
    
    
    {
        HCScanQRViewController *scan = [[HCScanQRViewController alloc]init];
        //调用此方法来获取二维码信息
        [scan successfulGetQRCodeInfo:^(NSString *QRCodeInfo) {
            
            NSRange range1 = [QRCodeInfo rangeOfString:@"/" options:NSBackwardsSearch];
            
            NSString * qrcode = [QRCodeInfo substringFromIndex:range1.location +1];
            
           
            
            __weak typeof(self) weakSelf = self;
            
            NSDictionary *sendDict = @{
                                    @"customer_id":self.infomDic[@"id"],
                                       @"qrcode":qrcode                                       };
            [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
            [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/DoorOpen" parameters:sendDict success:^(id responseObject) {
                [SVProgressHUD dismiss];
                NSDictionary *dicDictionary = responseObject;
                NSLog(@"%@",dicDictionary);
                OpenDoorViewController * openDoorViewController = [OpenDoorViewController new];
                
                openDoorViewController.isfrom = @"uncommonUse";//默认是非常用的
                
                openDoorViewController.entranceGuardViewController = weakSelf;
                if ([dicDictionary[@"result"] integerValue] == 0 )
                {
                    
                    
                    NSDictionary *sendDict = @{
                                               @"customer_id":self.infomDic[@"id"],
                                               @"qrcode":qrcode                                       };
                    [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
                    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/wetown/DoorGet" parameters:sendDict success:^(id responseObject) {
                        [SVProgressHUD dismiss];
                        
                        NSDictionary *sendDict = @{
                                                   @"customer_id":self.infomDic[@"id"],
                                                   @"qrcode":qrcode                                       };
                        [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
                        [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/wetown/DoorGet" parameters:sendDict success:^(id responseObject) {
                            [SVProgressHUD dismiss];
                            NSDictionary *dicDictionary2 = responseObject;
                            if (dicDictionary2 && [[dicDictionary2 objectForKey:@"result"] intValue] == 0)
                            {
                                for (NSDictionary * dic in weakSelf.commonUseColleVmArry)
                                {
                                    if ([[[dicDictionary2 objectForKey:@"door"] objectForKey:@"id"] intValue] == [[dic objectForKey:@"doorid"] intValue])
                                    {
                                        openDoorViewController.isfrom = @"commonUse";//commonUse 常用门禁里面已经存在
                                    }
                                }
                                
                                //开门成功
                                openDoorViewController.openSuccess = @"0";
                                
                                openDoorViewController.isSucceed_FromScan = @"0";
                                
                                openDoorViewController.infomDic = weakSelf.infomDic;
                                
                                openDoorViewController.currenDoorInfomDic = [dicDictionary2 objectForKey:@"door"];
                                
                                [weakSelf.navigationController pushViewController:openDoorViewController animated:YES];
                            }
                            else {
                                
                                [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
                               
                            }

                            
                            
                            
                            
                        } failure:^(NSError *error) {
                            
                            
                            
                            
                        }];

                    
                        
                        
                    } failure:^(NSError *error) {
                        
                        
                        
                        
                    }];

                    
                    
                }else{
                    openDoorViewController.openSuccess = @"1";
                    
                    openDoorViewController.isSucceed_FromScan = @"1";
                    
                    [weakSelf.navigationController pushViewController:openDoorViewController animated:YES];
                    
                    [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"reason"]];
                }
                
                
                
                
            } failure:^(NSError *error) {
                
                
                
                
            }];

            scan.scanFaileBlock = ^(){
                
                NSLog(@"scan faile");
            };
            
            //[self.navigationController pushViewController:scan animated:YES];
            //调用“扫码开门”接口。成功/失败 跳到相应的提示页面
            
            
            
        }];
        //扫描失败
        scan.scanFaileBlock = ^(){
            
            NSLog(@"scan faile");
        };
        
        [self.navigationController pushViewController:scan animated:YES];
    }
    
}

/**
 *  点击申请 -按钮title部分颜色和下划线设置
 */
-(void)clickApplyBtn_SetAtrribute{
    
    NSMutableAttributedString * title = [[NSMutableAttributedString alloc] initWithString:self.clickApplyBtn.titleLabel.text];
    NSRange titleRange = {8,[title length]-8};
    
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    
    [title addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFD7A4C) range:titleRange];
    [self.clickApplyBtn setAttributedTitle:title
                                      forState:UIControlStateNormal];
}

/**
 *  点击申请 -按钮响应事件
    ***接口*** 该小区是否已申请开通手机开门
    ***接口*** 申请开通人数
 *
 *  @param sender <#sender description#>
 */
- (IBAction)clickApplyBtnAction:(id)sender{
    
    
    ApplyOpenEntranceGuardViewController * applyOpenEntranceGuardViewController = [ApplyOpenEntranceGuardViewController new];
    
    //该小区是否已申请开通手机开门
   
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSLog(@"%@",weakSelf.communityInfoDict);
    [params setObject:[weakSelf.communityInfoDict objectForKey:@"bid"] forKey:@"bid"];
    NSLog(@"%@",params);
    
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"module":@"wetown",
                               @"func":@"doorapply/isapply",
                               @"params":[weakSelf dictionaryToJson:params]
                               };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/BusinessAgentRequest" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            applyOpenEntranceGuardViewController.isapply = [[dicDictionary objectForKey:@"isapply"] intValue];
            
            NSDictionary *sendDict = @{
                                    @"customer_id":self.infomDic[@"id"],
                                       @"module":@"wetown",
                                       @"func":@"doorapply/count",
                                       @"params":[weakSelf dictionaryToJson:params]
                                       };

            [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/BusinessAgentRequest" parameters:sendDict success:^(id responseObject) {
                
                NSDictionary *dicDictionary = responseObject;
                NSLog(@"%@",dicDictionary);
                if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
                {
                    applyOpenEntranceGuardViewController.appliedNum = [[dicDictionary objectForKey:@"count"] intValue];//申请开通人数
                    
                    applyOpenEntranceGuardViewController.infomDic = weakSelf.infomDic;//用户信息数据
                    
                    applyOpenEntranceGuardViewController.communityInfoDict = _communityInfoDict;//小区信息数据
                    
                    [weakSelf.navigationController pushViewController:applyOpenEntranceGuardViewController animated:YES];
                    
                    
                    
                } else
                {
                    [SVProgressHUD showWithStatus:dicDictionary[@"reason"]];
                }
                
                
                
                
                
                
            } failure:^(NSError *error) {
                
                
                
                
            }];


            
        } else
        {
            [SVProgressHUD showWithStatus:dicDictionary[@"reason"]];
        }
        
        
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
    }];
    

    
        
}


- (IBAction)moreBtnAction:(id)sender{
    
   
    
    if (self.popView.isShow) {
    
        [self.popView dismissFromKeyWindow];
        
    }
    else
    {
        
        NSArray * popView_DicArr = @[@{@"title":@"扫一扫",@"iconName":@"btn_open_scan"},@{@"title":@"申请权限",@"iconName":@"icon_apply"},@{@"title":@"权限授权",@"iconName":@"icon_author"},@{@"title":@"编辑门禁",@"iconName":@"icon_compile"},@{@"title":@"门禁说明",@"iconName":@"icon_open_help"}];
        
        self.popView = [CFPopView popViewWithFuncDicts:popView_DicArr];
        
        [self.popView showInKeyWindow];
        
    }
    
    
    ApplyAuthViewController * applyAuthVC = [ApplyAuthViewController new];
    
    applyAuthVC.infomDic = self.infomDic;
    
    AuthrozationViewController * authrozationVC = [AuthrozationViewController new];
    
    authrozationVC.infomDic = self.infomDic;
    
    CLEntranceGuardEditVCViewController * cLEntranceGuardEditVC = [CLEntranceGuardEditVCViewController new];
    
    cLEntranceGuardEditVC.infomDic = self.infomDic;
    
    cLEntranceGuardEditVC.reloadCommonEntrData = ^(){
        
        [self postBusinessAgentRequest_doorfixedGetlist];
        
    };
    
    __weak typeof (self) weakSelf = self;
    
    weakSelf.popView.myFuncBlock = ^(NSInteger index){
        
        NSLog(@"当前选中的是第 %ld 行，处理跳转到XX页面的操作", (long)index);
        
//        [self.popView dismissFromKeyWindow];//消失当前视图
        
        switch (index) {
                
            case 0:
            {
                {
                    HCScanQRViewController *scan = [[HCScanQRViewController alloc]init];
                    //调用此方法来获取二维码信息
                    [scan successfulGetQRCodeInfo:^(NSString *QRCodeInfo) {
                        
                        NSRange range1 = [QRCodeInfo rangeOfString:@"/" options:NSBackwardsSearch];
                        
                        NSString * qrcode = [QRCodeInfo substringFromIndex:range1.location +1];
                        
                        
                        
                        __weak typeof(self) weakSelf = self;
                        
                        NSDictionary *sendDict = @{
                                                   @"customer_id":self.infomDic[@"id"],
                                                   @"qrcode":qrcode                                       };
                        [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
                        [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/DoorOpen" parameters:sendDict success:^(id responseObject) {
                            [SVProgressHUD dismiss];
                            NSDictionary *dicDictionary = responseObject;
                            NSLog(@"%@",dicDictionary);
                            OpenDoorViewController * openDoorViewController = [OpenDoorViewController new];
                            
                            openDoorViewController.isfrom = @"uncommonUse";//默认是非常用的
                            
                            openDoorViewController.entranceGuardViewController = weakSelf;
                            if ([dicDictionary[@"result"] integerValue] == 0 )
                            {
                                
                                
                                NSDictionary *sendDict = @{
                                                           @"customer_id":self.infomDic[@"id"],
                                                           @"qrcode":qrcode                                       };
                                [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
                                [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/wetown/DoorGet" parameters:sendDict success:^(id responseObject) {
                                    [SVProgressHUD dismiss];
                                    
                                    NSDictionary *sendDict = @{
                                                               @"customer_id":self.infomDic[@"id"],
                                                               @"qrcode":qrcode                                       };
                                    [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
                                    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/wetown/DoorGet" parameters:sendDict success:^(id responseObject) {
                                        [SVProgressHUD dismiss];
                                        NSDictionary *dicDictionary2 = responseObject;
                                        if (dicDictionary2 && [[dicDictionary2 objectForKey:@"result"] intValue] == 0)
                                        {
                                            for (NSDictionary * dic in weakSelf.commonUseColleVmArry)
                                            {
                                                if ([[[dicDictionary2 objectForKey:@"door"] objectForKey:@"id"] intValue] == [[dic objectForKey:@"doorid"] intValue])
                                                {
                                                    openDoorViewController.isfrom = @"commonUse";//commonUse 常用门禁里面已经存在
                                                }
                                            }
                                            
                                            //开门成功
                                            openDoorViewController.openSuccess = @"0";
                                            
                                            openDoorViewController.isSucceed_FromScan = @"0";
                                            
                                            openDoorViewController.infomDic = weakSelf.infomDic;
                                            
                                            openDoorViewController.currenDoorInfomDic = [dicDictionary2 objectForKey:@"door"];
                                            
                                            [weakSelf.navigationController pushViewController:openDoorViewController animated:NO];
                                        }
                                        else {
                                            
                                            [SVProgressHUD showErrorWithStatus:dicDictionary[@"message"]];
                                            
                                        }
                                        
                                        
                                        
                                        
                                        
                                    } failure:^(NSError *error) {
                                        
                                        
                                        
                                        
                                    }];
                                    
                                    
                                    
                                    
                                } failure:^(NSError *error) {
                                    
                                    
                                    
                                    
                                }];
                                
                                
                                
                            }else{
                                openDoorViewController.openSuccess = @"1";
                                
                                openDoorViewController.isSucceed_FromScan = @"1";
                                
                                [weakSelf.navigationController pushViewController:openDoorViewController animated:NO];
                                
                                [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"reason"]];
                            }
                            
                            
                            
                            
                        } failure:^(NSError *error) {
                            
                            
                            
                            
                        }];
                        
                        scan.scanFaileBlock = ^(){
                            
                            NSLog(@"scan faile");
                        };
                        
                       // [self.navigationController pushViewController:scan animated:NO];
                        //调用“扫码开门”接口。成功/失败 跳到相应的提示页面
                        
                        
                        
                    }];
                    //扫描失败
                    scan.scanFaileBlock = ^(){
                        [SVProgressHUD showErrorWithStatus:@"扫码失败"];
                        NSLog(@"scan faile");
                    };
                    
                    [self.navigationController pushViewController:scan animated:YES];
                }

 
            }
                break;
                
                //跳转到“申请权限”
            case 1:{
                
                
                [weakSelf.navigationController pushViewController:applyAuthVC animated:YES];
            }
                break;
                
                //跳转到“权限授权”
            case 2:
            {
                
                NSDictionary *sendDict = @{
                                           @"customer_id":self.infomDic[@"id"],
                                                                               };
                [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
                [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/AuthorizationIsGranted" parameters:sendDict success:^(id responseObject) {
                    [SVProgressHUD dismiss];
                    NSDictionary *dicDictionary = responseObject;
                    NSLog(@"%@",dicDictionary);
                    if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0) {
                        
                        //isgranted = 0 没有授权权限；isgranted = 1 有授权权限;
                        if ([[dicDictionary objectForKey:@"isgranted"] intValue] != 1) {
                            [SVProgressHUD showErrorWithStatus:@"您没有权限"];
                        }
                        else
                        {
                              [weakSelf.navigationController pushViewController:authrozationVC animated:YES];
                        }
                        
                        
                        
                    }else{
                    [SVProgressHUD showErrorWithStatus:dicDictionary[@"reason"]];
                    
                    }

                    
                 
                 
                }
                 failure:^(NSError *error) {
                     
                     
                     
                     
}];

                
                                
            }
                
                break;
            
                //跳转到“编辑门禁”
            case 3:{
                
                [weakSelf.navigationController pushViewController:cLEntranceGuardEditVC animated:YES];
            }
                break;
                
                //跳转到“门禁说明”
            case 4:
            {
                MCWebViewController *webVC = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.colourlife.com/Advertisement/Menjin"]] titleString:@"使用帮助"];
                [self.navigationController pushViewController:webVC animated:YES];
            }
                
                break;
                
            default:
                
                break;

        }
        
    };
    
}


-(NSMutableArray *)doorOpenlogMArry
{
    if (!_doorOpenlogMArry)
    {
        _doorOpenlogMArry = [NSMutableArray new];
        
        //获取缓存数据
        NSArray *doorOpenlogMArryCache = [self readFromUserDefaults:@"doorOpenlogMArry_Cache"];
        
        if (doorOpenlogMArryCache != nil) {
            
            [_doorOpenlogMArry addObjectsFromArray:doorOpenlogMArryCache];
        }
    }
    return _doorOpenlogMArry;
}

-(NSMutableArray *)commonUseColleVmArry
{
    if (!_commonUseColleVmArry)
    {
        _commonUseColleVmArry = [NSMutableArray new];
        
        //获取缓存数据
        NSArray *commonUseColleVmArryCache = [self readFromUserDefaults:@"CommonListmArray_Cache"];
        
        if (commonUseColleVmArryCache != nil) {
            
            [_commonUseColleVmArry addObjectsFromArray:commonUseColleVmArryCache];
        }
        
    }
    return _commonUseColleVmArry;
}

-(NSMutableDictionary *)communityInfoDict
{
    if (!_communityInfoDict)
    {
        _communityInfoDict = [NSMutableDictionary new];
    }
    return _communityInfoDict;
}

-(CFPopView *)popView
{
    if (!_popView)
    {
        _popView = [CFPopView new];
        
        [_popView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH-64)];//弹框视图的背景视图的位置大小
    }
    return _popView;
}




#pragma mark - 检查是否已经提交申请开通

-(void)checkOpen
{
//    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
//    
//    [params setObject:[self.communityInfoDict objectForKey:@"bid"] forKey:@"bid"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    [PMApps postBusinessAgentRequest:[weakSelf.infomDic objectForKey:@"id"] Module:@"wetown" Func:@"door/checkopen" Params:[weakSelf dictionaryToJson:params] BlockSuccess:^(NSURL *url, id result){
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//        
//        if (result && [[result objectForKey:@"result"] intValue] == 0)
//        {
//            if ([[result objectForKey:@"isopen"] intValue] != 1)
//            {
////                [[AppPlusAppDelegate sharedAppDelegate] showSucMsg:@"已经申请开通手机开门" WithInterval:1.0];
//                [[AppPlusAppDelegate sharedAppDelegate] showSucMsg:@"当前小区未开通手机开门" WithInterval:1.0];
//            }
//            else{
//                
//                
//            }
//            
//        }
//        else{
//            
//            [[AppPlusAppDelegate sharedAppDelegate] showErrMsg:[result objectForKey:@"reason"] WithInterval:1.0];
//        }
//            
//        });
//        
//    }BlockFailed:^(NSURL *url, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[AppPlusAppDelegate sharedAppDelegate] showErrMsg:[error localizedDescription] WithInterval:1.0];
//        });
//        
//    }];
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
