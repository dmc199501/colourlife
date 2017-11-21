//
//  CLEntranceGuardEditVCViewController.m
//  WeiTown
//
//  Created by 方燕娇 on 16/8/16.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "CLEntranceGuardEditVCViewController.h"
#import "ApplyAuthViewController.h"//申请权限
#import "CommonEntranceGuardCollectionViewCell.h"//常用门禁CollectionViewCell
#import "OtherEntranceGuardCollectionViewCell.h"
#import "OpenDoorViewController.h"//请求开门接口的页面
#import "MCMacroDefinitionHeader.h"
#import "MCHttpManager.h"
#import "SVProgressHUD.h"
#import "UIView+Helper.h"
#import "CustomAlertView.h"


@interface CLEntranceGuardEditVCViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UIAlertViewDelegate>

{
    
    NSIndexPath * uncommonCollecSelectIndexPath;//当前选中的非常用门禁
    
    NSIndexPath * commonCollecSelectIndexPath;//当前选中的常用门禁
    
}
@property (retain, nonatomic) IBOutlet UIView *headView;

@property (retain, nonatomic) IBOutlet UIView *footView;

@property (retain, nonatomic) IBOutlet UIView *blankView;

@property (retain, nonatomic) IBOutlet UICollectionView *commonCollectionView;//常用门禁列表

@property (retain, nonatomic) IBOutlet UICollectionView *bgCollectionView;//常用门禁列表的背景collectionview

@property (retain, nonatomic) IBOutlet UICollectionView *otherCollectionView;//其他门禁列表

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic, strong) UILongPressGestureRecognizer * otherLongPress;

@property (assign, nonatomic) int hiddenTag;

@property (strong, nonatomic) NSMutableArray * uncommonListmArray;//非常用门禁列表

@property (strong, nonatomic) NSMutableArray * commonListmArray;//常用门禁列表

@property (strong, nonatomic) NSMutableArray * changeCommonListmArray;//移动常用门禁后的数据

@property (strong, nonatomic) OtherEntranceGuardCollectionViewCell *currentLongPressCell;


@end

@implementation CLEntranceGuardEditVCViewController
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
    
    [_blankView setHidden:YES];//请求“其他门禁列表”接口，没有数据的时候，设置为NO
    
    //创建常用门禁列表
    [self createCommonCollectionView];
    
    [self createBGCollectionView];
    
    //创建其他门禁列表
    [self createOtherCollectionView];
    
    [self getlist_commonUse];//获取常用门禁列表数据
    
    [self getlistnotfixed];//获取非常用门禁列表数据
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源

//获取非常用门禁列表
-(void)getlistnotfixed{
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"module":@"wetown",
                               @"func":@"doorfixed/getlistnotfixed",
                               @"params":@""
                               };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/BusinessAgentRequest" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"result"] integerValue] == 0 )
        {
            [weakSelf.uncommonListmArray removeAllObjects];
            
            NSArray *resultArray = [dicDictionary objectForKey:@"list"];
            
            //如果有数据
            if ([resultArray count] > 0) {
                
                [weakSelf.uncommonListmArray addObjectsFromArray:resultArray];
                
                //移除plist
                [weakSelf removeFromUserDefaults:@"UnCommonListmArray_Cache"];
                
                //将最新数据缓存到Plist中
                [weakSelf writeToUserDefaults:weakSelf.uncommonListmArray withKey:@"UnCommonListmArray_Cache"];
                
                //                    NSLog(@"非常用门禁列表数据：%@",weakSelf.uncommonListmArray);
                
            }
            else
            {
                [weakSelf.blankView setHidden:NO];
            }
            
            [weakSelf.otherCollectionView reloadData];

            
        }else{
            
            [SVProgressHUD showWithStatus:dicDictionary[@"reason"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
    }];

    
    
}


//获取常用门禁列表
-(void)getlist_commonUse{
    
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
            [weakSelf.commonListmArray removeAllObjects];
            
            //移除plist
            [weakSelf removeFromUserDefaults:@"CommonListmArray_Cache"];
            
            NSArray *resultArray = [dicDictionary objectForKey:@"list"];
            
            [weakSelf.commonListmArray addObjectsFromArray:resultArray];
            
            //将最新数据缓存到Plist中
            [weakSelf writeToUserDefaults:weakSelf.commonListmArray withKey:@"CommonListmArray_Cache"];
            
            //                NSLog(@"常用门禁列表数据：%@",weakSelf.commonListmArray);
            
            [weakSelf.commonCollectionView reloadData];
            
        }else{
            
            [SVProgressHUD showWithStatus:dicDictionary[@"reason"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
    }];
    

    
    
}

/**
 *  调整collectioncell的位置
 *
 *  @param doorid      <#doorid description#>
 *  @param newposition <#newposition description#>
 */
-(void)changeCollectionCellPosition_doorid:(NSString *)doorid newposition:(NSString *)newposition
{
    NSMutableDictionary * params = [NSMutableDictionary new];
    
    [params setObject:doorid forKey:@"doorid"];
    
    [params setObject:newposition forKey:@"newposition"];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"module":@"wetown",
                               @"func":@"doorfixed/index",
                               @"params":[weakSelf dictionaryToJson:params]
                               };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/BusinessAgentRequest" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
    }];
}

-(void)createBGCollectionView
{
    //先创建一个九宫格布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    //设置单元格的各个参数
    
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 12 - 2)/3 , _headView.frameSizeHeight/2 - 2);
    
    layout.minimumInteritemSpacing = 0.5;
    
    layout.minimumLineSpacing = 0.5;
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [_bgCollectionView setCollectionViewLayout:layout];
    
    [_bgCollectionView setScrollEnabled:NO];//关闭滚动
    
    //初始化九宫格
    _bgCollectionView.pagingEnabled = YES;
    
    _bgCollectionView.dataSource = self;
    
    _bgCollectionView.delegate = self;
    
#pragma mark -- <注册单元格>
    [_bgCollectionView registerClass:[CommonEntranceGuardCollectionViewCell class] forCellWithReuseIdentifier:@"CommonEntranceGuardCollectionViewCell"];
    
    _bgCollectionView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
}

#pragma mark - 常用门禁列表 操作
/**
 *  创建常用门禁列表
 */
-(void)createCommonCollectionView{
    
    
    //创建长按手势监听
    _longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(commonCollectionViewCellLongPressed:)];
    _longPress.minimumPressDuration = 0.3;
    
    //将长按手势添加到需要实现长按操作的视图里
    [_commonCollectionView addGestureRecognizer:_longPress];
    
    //先创建一个九宫格布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    //设置单元格的各个参数
//    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 12 - 2)/3 , _headView.frameSizeHeight/2 - 2);
    
    layout.minimumInteritemSpacing = 0.5;
    
    layout.minimumLineSpacing = 0.5;
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [_commonCollectionView setCollectionViewLayout:layout];
    
    [_commonCollectionView setScrollEnabled:NO];//关闭滚动
    
    //初始化九宫格
    _commonCollectionView.pagingEnabled = YES;
    
    _commonCollectionView.dataSource = self;
    
    _commonCollectionView.delegate = self;
    
#pragma mark -- <注册单元格>
    [_commonCollectionView registerClass:[CommonEntranceGuardCollectionViewCell class] forCellWithReuseIdentifier:@"CommonEntranceGuardCollectionViewCell"];
    
//    _commonCollectionView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
    [_commonCollectionView setBackgroundColor:[UIColor clearColor]];
    
}

-(void)commonCollectionViewCellLongPressed:(UILongPressGestureRecognizer *)longPress
{
    NSIndexPath * selectIndexPath = [_commonCollectionView indexPathForItemAtPoint:[_longPress locationInView:_commonCollectionView]];
    
//    if (selectIndexPath != nil) {
    
        //如果是有数据的单元格
        //    if (selectIndexPath.item < (int)[self.commonListmArray count]) {
        
        //如果
        if ((commonCollecSelectIndexPath != nil) && (commonCollecSelectIndexPath != selectIndexPath)) {
            
            // 找到已经被长按过的cell
            CommonEntranceGuardCollectionViewCell * cell = (CommonEntranceGuardCollectionViewCell *)[_commonCollectionView cellForItemAtIndexPath:commonCollecSelectIndexPath];
            [cell.editingView setHidden:YES];
            commonCollecSelectIndexPath = nil;
        }
        
        if (uncommonCollecSelectIndexPath != nil) {
            
            // 找到已经被长按过的cell
            OtherEntranceGuardCollectionViewCell * cell = (OtherEntranceGuardCollectionViewCell *)[_otherCollectionView cellForItemAtIndexPath:uncommonCollecSelectIndexPath];
            [cell.editingView setHidden:YES];
            uncommonCollecSelectIndexPath = nil;
        }
        
        
        switch (_longPress.state) {
                
            case UIGestureRecognizerStateBegan: {
                {
                    
                    if (selectIndexPath != nil){
                        
                        //在路径上则开始移动该路径上的cell
                        commonCollecSelectIndexPath = selectIndexPath;
                        
//                        NSLog(@"1-当前长按要编辑的门禁数据_selectIndexPath is %@",_commonListmArray[selectIndexPath.item]);
//                        
//                        NSLog(@"1-当前长按要编辑的门禁数据_selectCollectionIndexPath is %@",_commonListmArray[commonCollecSelectIndexPath.item]);
                        
                        // 找到当前的cell
                        CommonEntranceGuardCollectionViewCell * cell = (CommonEntranceGuardCollectionViewCell *)[_commonCollectionView cellForItemAtIndexPath:selectIndexPath];
                        
                        // 定义cell的时候btn是隐藏的, 在这里设置为NO
                        
                        [cell.editingView setHidden:NO];
                        
                        [cell.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [cell.deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                        
                        _hiddenTag = 1;
                        
                        [_commonCollectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];

                        
                    }
                    
                }
                
                break;
            }
            case UIGestureRecognizerStateChanged: {
                
                //移动过程当中随时更新cell位置
                
                [_commonCollectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_longPress.view]];
                
                break;
            }
            case UIGestureRecognizerStateEnded: {
                
                //移动结束后关闭cell移动
                
                [_commonCollectionView endInteractiveMovement];
                
//                NSLog(@"移动后的数组:%@",self.commonListmArray);
                
                break;
            }
            default: [_commonCollectionView cancelInteractiveMovement];
                break;
        }
        
        //    }
        
//    }
    
}

/**
 *  删除按钮
 *
 *  @param sender <#sender description#>
 */
-(void)deleteBtnAction:(id)sender
{
//    NSLog(@"2-当前长按要编辑的门禁数据_selectCollectionIndexPath is %@",_commonListmArray[commonCollecSelectIndexPath.item]);
    
    [self removeCommon_doorid:[self.commonListmArray[commonCollecSelectIndexPath.item] objectForKey:@"doorid"]];
}


//删除常用门禁
-(void)removeCommon_doorid:(NSString *)doorid
{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    
    [params setObject:doorid forKey:@"doorid"];
    
//    NSLog(@"params: %@",[self dictionaryToJson:params]);
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"module":@"wetown",
                               @"func":@"doorfixed/remove",
                               @"params":[weakSelf dictionaryToJson:params]
                               };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/BusinessAgentRequest" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            //刷新常用门禁列表数据
            [weakSelf getlist_commonUse];//重新获取常用门禁列表
            
            [weakSelf getlistnotfixed];//重新获取非常用门禁列表
            
            if (weakSelf.reloadCommonEntrData) {
                
                weakSelf.reloadCommonEntrData();//调用刷新首页常用门禁的代码块
            }
            
            //            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            
        }
        
        // 找到当前的cell
        CommonEntranceGuardCollectionViewCell * cell = (CommonEntranceGuardCollectionViewCell *)[_commonCollectionView cellForItemAtIndexPath:commonCollecSelectIndexPath];
        
        [cell.editingView setHidden:YES];
        
        commonCollecSelectIndexPath = nil;
        
   

     
     
     
    } failure:^(NSError *error) {
        
        
        
        
    }];

    
}



/**
 *  编辑按钮
 *
 *  @param sender <#sender description#>
 */
-(void)editBtnAction:(UIButton *)button
{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"编辑门禁名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView setTag:101];
    
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [alertView show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        switch (buttonIndex) {
            case 0:
                
                NSLog(@"取消");
                
                break;
           
            case 1:
            {
                NSLog(@"确认修改门禁名称");
                
                UITextField *nameField = [alertView textFieldAtIndex:0];
                
                if (nameField.text.length == 0) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"门禁名称不能为空!"] delegate:self cancelButtonTitle:@"好的~" otherButtonTitles:nil];
                    
                    [alert show];
                    
                    // 找到当前的cell
                    CommonEntranceGuardCollectionViewCell * cell = (CommonEntranceGuardCollectionViewCell *)[_commonCollectionView cellForItemAtIndexPath:commonCollecSelectIndexPath];
                    
                    [cell.editingView setHidden:YES];
                    commonCollecSelectIndexPath = nil;
                    
                }
                else
                {
                    
                    NSLog(@"3-当前长按要编辑的门禁数据_selectCollectionIndexPath is %@",_commonListmArray[commonCollecSelectIndexPath.item]);
                    
                    [self modifyCommonName_doorid:[_commonListmArray[commonCollecSelectIndexPath.item] objectForKey:@"doorid"] name:nameField.text];
                }
                
            }
                
                break;
                
            default:
                break;
        }
    } else {
        
    }
}

//编辑常用门禁的名称
-(void)modifyCommonName_doorid:(NSString *)doorid name:(NSString *)name
{
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    
    [params setObject:name forKey:@"name"];
    
    [params setObject:doorid forKey:@"doorid"];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"module":@"wetown",
                               @"func":@"doorfixed/modify",
                               @"params":[weakSelf dictionaryToJson:params]
                               };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/BusinessAgentRequest" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            [weakSelf getlist_commonUse];
            
            if (self.reloadCommonEntrData) {
                
                self.reloadCommonEntrData();//调用刷新首页常用门禁的代码块
            }
            
        } else
        {
            [SVProgressHUD showWithStatus:dicDictionary[@"reason"]];
        }

        
        
        CommonEntranceGuardCollectionViewCell * cell = (CommonEntranceGuardCollectionViewCell *)[_commonCollectionView cellForItemAtIndexPath:commonCollecSelectIndexPath];
        
        [cell.editingView setHidden:YES];
        commonCollecSelectIndexPath = nil;

        
        
    } failure:^(NSError *error) {
        
        
        
        
    }];
    

    
    
}

#pragma mark - 其他门禁列表 操作
/**
 *  创建其他门禁列表
 */
-(void)createOtherCollectionView{
    
    //创建长按手势监听
    _otherLongPress = [[UILongPressGestureRecognizer alloc]
                  initWithTarget:self
                  action:@selector(otherCollectionViewCellLongPressed:)];
    
    _otherLongPress.minimumPressDuration = 0.3;
    
    //将长按手势添加到需要实现长按操作的视图里
    [_otherCollectionView addGestureRecognizer:_otherLongPress];
    
    //先创建一个九宫格布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    //设置单元格的各个参数
//    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 12 - 2)/3 , _headView.frameSizeHeight/2 - 2);
    
    layout.minimumInteritemSpacing = 0.5;
    
    layout.minimumLineSpacing = 0.5;
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [_otherCollectionView setCollectionViewLayout:layout];
    
    //初始化九宫格
    _otherCollectionView.pagingEnabled = YES;
    
    _otherCollectionView.dataSource = self;
    
    _otherCollectionView.delegate = self;
    
#pragma mark -- <注册单元格>
    [_otherCollectionView registerClass:[OtherEntranceGuardCollectionViewCell class] forCellWithReuseIdentifier:@"OtherEntranceGuardCollectionViewCell"];
    
    _otherCollectionView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
}


-(void)otherCollectionViewCellLongPressed:(UILongPressGestureRecognizer *)longPress
{
    //如果存在被长按的常用门禁
    if (commonCollecSelectIndexPath != nil) {
        
        // 找到已经被长按过的cell
        CommonEntranceGuardCollectionViewCell * cell = (CommonEntranceGuardCollectionViewCell *)[_commonCollectionView cellForItemAtIndexPath:commonCollecSelectIndexPath];
        [cell.editingView setHidden:YES];
        commonCollecSelectIndexPath = nil;
    }
    
    NSIndexPath * selectIndexPath = [_otherCollectionView indexPathForItemAtPoint:[_otherLongPress locationInView:_otherCollectionView]];
    
    if (selectIndexPath != nil) {
        
        if ((uncommonCollecSelectIndexPath != nil) && (uncommonCollecSelectIndexPath != selectIndexPath)) {
            
            // 找到已经被长按过的cell
            OtherEntranceGuardCollectionViewCell * cell = (OtherEntranceGuardCollectionViewCell *)[_otherCollectionView cellForItemAtIndexPath:uncommonCollecSelectIndexPath];
            [cell.editingView setHidden:YES];
            uncommonCollecSelectIndexPath = nil;
        }
        switch (_otherLongPress.state) {
                
            case UIGestureRecognizerStateBegan: {
                {
                    
                    //                NSIndexPath * selectIndexPath = [_otherCollectionView indexPathForItemAtPoint:[_otherLongPress locationInView:_otherCollectionView]];
                    
                    uncommonCollecSelectIndexPath = selectIndexPath;
                    
                    NSLog(@"uncommonCollecSelectIndexPath is %ld",(long)selectIndexPath.item);
                    // 找到当前的cell
                    OtherEntranceGuardCollectionViewCell * cell = (OtherEntranceGuardCollectionViewCell *)[_otherCollectionView cellForItemAtIndexPath:selectIndexPath];
                    
                    // 定义cell的时候btn是隐藏的, 在这里设置为NO
                    
                    [cell.editingView setHidden:NO];
                    
                    [cell.addBtn setTag:selectIndexPath.item];
                    
                    [cell.addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    _hiddenTag = 1;
                    
                    [_otherCollectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
                    
                }
                
                break;
            }
            case UIGestureRecognizerStateChanged: {
                
                //            [_otherCollectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_otherLongPress.view]];
                
                break;
            }
            case UIGestureRecognizerStateEnded: {
                
                [_otherCollectionView endInteractiveMovement];
                
                break;
            }
            default: [_otherCollectionView cancelInteractiveMovement];
                break;
        }
        
    }
    
}

//添加常用门禁，先检查是不是6个了

-(void)addBtnAction:(UIButton *)sender
{
    if([_commonListmArray count] >= 6)
    {
        [self showAlertViewWithString:@"最多只能添加6个!" andDurationTime:1.0];
        
        OtherEntranceGuardCollectionViewCell * cell = (OtherEntranceGuardCollectionViewCell *)[_otherCollectionView cellForItemAtIndexPath:uncommonCollecSelectIndexPath];
        
        [cell.editingView setHidden:YES];
        uncommonCollecSelectIndexPath = nil;
    }
    else
    {
        [self addToCommonUseDoorList:sender];
    }
    
    
}

//添加到常用门禁
-(void)addToCommonUseDoorList:(UIButton *)sender
{
    
    // 找到当前的cell
    OtherEntranceGuardCollectionViewCell * cell = (OtherEntranceGuardCollectionViewCell *)[_otherCollectionView cellForItemAtIndexPath:uncommonCollecSelectIndexPath];
    
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[_uncommonListmArray[sender.tag] objectForKey:@"name"] forKey:@"name"];
    
    [params setObject:[_uncommonListmArray[sender.tag] objectForKey:@"doorid"] forKey:@"doorid"];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *sendDict = @{
                               @"customer_id":self.infomDic[@"id"],
                               @"module":@"wetown",
                               @"func":@"doorfixed/add",
                               @"params":[weakSelf dictionaryToJson:params]
                               };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/BusinessAgentRequest" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        [cell.editingView setHidden:YES];
        uncommonCollecSelectIndexPath = nil;
        if (dicDictionary && [[dicDictionary objectForKey:@"result"] intValue] == 0)
        {
            //添加成功
            
            [weakSelf getlist_commonUse];//重新获取常用门禁列表
            
            [weakSelf getlistnotfixed];//重新获取非常用门禁列表
            
            if (self.reloadCommonEntrData) {
                
                self.reloadCommonEntrData();//调用刷新首页常用门禁的代码块
            }

            
        }else{
          [SVProgressHUD showWithStatus:dicDictionary[@"reason"]];
        
        }
        
        
        
    } failure:^(NSError *error) {
        
        
        
        
    }];
    

    
    
}



#pragma mark - UICollectionViewDelegate 代理方法实现

//九宫格单元格数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (collectionView == self.commonCollectionView)
    {
        return [self.commonListmArray count];
//        return 6;
    }
    else if (collectionView == self.otherCollectionView)
    {
        return [self.uncommonListmArray count];
    }
    else
    {
        return 6;
    }
    
}
//九宫格实际内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (collectionView == self.commonCollectionView)
    {
#pragma mark --- <获取CommonEntranceGuardCollectionViewCell已注册的单元格>
        static NSString * CommonEntranceGuardCollectionViewCellIdentifier = @"CommonEntranceGuardCollectionViewCell";
        
        UINib *nib = [UINib nibWithNibName:@"CommonEntranceGuardCollectionViewCell" bundle: [NSBundle mainBundle]];
        
        [collectionView registerNib:nib forCellWithReuseIdentifier:CommonEntranceGuardCollectionViewCellIdentifier];
        
        CommonEntranceGuardCollectionViewCell * cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommonEntranceGuardCollectionViewCell" forIndexPath:indexPath];
        
        [cell1.editingView setHidden:YES];
//
        cell1.backgroundColor = [UIColor whiteColor];
        
        [cell1.addDoorBtn setHidden:YES];
        
       
        //如果是默认的空数据
//        if (indexPath.item >= (int)[self.commonListmArray count]) {
//            
//            NSLog(@"");
//            [cell1.commonDoorName setHidden:YES];
//            [cell1.commonDoorImageV setHidden:YES];
//            
//        }else{
//            
//            [cell1.commonDoorName setHidden:NO];
//            [cell1.commonDoorImageV setHidden:NO];
        
            [cell1.commonDoorName setText:[_commonListmArray[indexPath.item] objectForKey:@"name"]];
            
            if ([[_commonListmArray[indexPath.item] objectForKey:@"type"] intValue] == 2) {
                
                [cell1.commonDoorImageV setImage:[UIImage imageNamed:@"icon_bussine"]];//大楼
                
            }else if ([[_commonListmArray[indexPath.item] objectForKey:@"type"] intValue] == 1)
            {
            
                [cell1.commonDoorImageV setImage:[UIImage imageNamed:@"icon_home"]];//房子
            
            }
        
        return cell1;
    }
    
    else if(collectionView == self.otherCollectionView)
    {
        
#pragma mark --- <获取OtherEntranceGuardCollectionViewCell已注册的单元格>
        
        
        static NSString * OtherEntranceGuardCollectionViewCellIdentifier = @"OtherEntranceGuardCollectionViewCell";
        
        UINib *nib = [UINib nibWithNibName:@"OtherEntranceGuardCollectionViewCell" bundle: [NSBundle mainBundle]];
        
        [collectionView registerNib:nib forCellWithReuseIdentifier:OtherEntranceGuardCollectionViewCellIdentifier];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        
        OtherEntranceGuardCollectionViewCell *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:@"OtherEntranceGuardCollectionViewCell" forIndexPath:indexPath];
        
        [cell2.editingView setHidden:YES];
        
        cell2.backgroundColor = [UIColor whiteColor];
        
        [cell2.otherName setText:[self.uncommonListmArray[indexPath.item] objectForKey:@"name"]];
        
        if ([[self.uncommonListmArray[indexPath.item] objectForKey:@"doortype"] intValue] == 2) {
            
            [cell2.otherDoorImageV setImage:[UIImage imageNamed:@"icon_bussine"]];//大楼
            
        }
        else if([[self.uncommonListmArray[indexPath.item] objectForKey:@"doortype"] intValue] == 1){
            
            [cell2.otherDoorImageV setImage:[UIImage imageNamed:@"icon_home"]];//房子
            
        }
        
        return cell2;
    }
    else if (collectionView == self.bgCollectionView)
    {
        
#pragma mark --- <获取CommonEntranceGuardCollectionViewCell已注册的单元格>
        static NSString * CommonEntranceGuardCollectionViewCellIdentifier2 = @"CommonEntranceGuardCollectionViewCell";
        
        UINib *nib = [UINib nibWithNibName:@"CommonEntranceGuardCollectionViewCell" bundle: [NSBundle mainBundle]];
        
        [collectionView registerNib:nib forCellWithReuseIdentifier:CommonEntranceGuardCollectionViewCellIdentifier2];
        
        CommonEntranceGuardCollectionViewCell * cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommonEntranceGuardCollectionViewCell" forIndexPath:indexPath];
        
        [cell2.commonDoorImageV setHidden:YES];
        
        [cell2.commonDoorName setHidden:YES];
        
        [cell2.editingView setHidden:YES];
        
        [cell2.addDoorBtn setHidden:YES];
        
        [cell2 setBackgroundColor:[UIColor whiteColor]];
        
        return cell2;
    }
    return nil;
}

//选中单元格执行跳转页面
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _commonCollectionView)
    {
        
        //如果是有数据的单元格
//        if (indexPath.item < (int)[self.commonListmArray count]) {
        
            // 找到当前正在编辑的cell
            CommonEntranceGuardCollectionViewCell * cell = (CommonEntranceGuardCollectionViewCell *)[_commonCollectionView cellForItemAtIndexPath:commonCollecSelectIndexPath];
            
            if (_hiddenTag == 1)
            {
                [cell.editingView setHidden:YES];
                commonCollecSelectIndexPath = nil;
            }
            else
            {
                
                __weak typeof(self) weakSelf = self;
               
                
                NSDictionary *sendDict = @{
                                           @"customer_id":self.infomDic[@"id"],
                                           @"qrcode":[weakSelf.commonListmArray[indexPath.row] objectForKey:@"qrcode"],
                                           
                                           };
                [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
                [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/DoorOpen" parameters:sendDict success:^(id responseObject) {
                    [SVProgressHUD dismiss];
                    NSDictionary *dicDictionary = responseObject;
                    NSLog(@"%@",dicDictionary);
                    OpenDoorViewController * openDoorViewController = [OpenDoorViewController new];
                    openDoorViewController.isfrom = @"uncommonUse";//默认是非常用的
                    
                    
                    
                    
                    
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
            
            _hiddenTag = 0;
//        }
        
    }
    else if (collectionView == _otherCollectionView)
    {
        OtherEntranceGuardCollectionViewCell * cell2 = (OtherEntranceGuardCollectionViewCell *)[_otherCollectionView cellForItemAtIndexPath:uncommonCollecSelectIndexPath];
        
        if (_hiddenTag == 1)
        {
            [cell2.editingView setHidden:YES];
        }
        else
        {
            __weak typeof(self) weakSelf = self;
            
            
            NSDictionary *sendDict = @{
                                       @"customer_id":self.infomDic[@"id"],
                                       @"qrcode":[weakSelf.uncommonListmArray[indexPath.row] objectForKey:@"qrcode"],
                                       
                                       };
            [SVProgressHUD showWithStatus:@"正在提交提交数据，请稍后..."];
            [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/newczy/wetown/DoorOpen" parameters:sendDict success:^(id responseObject) {
                [SVProgressHUD dismiss];
                NSDictionary *dicDictionary = responseObject;
                NSLog(@"%@",dicDictionary);
                OpenDoorViewController * openDoorViewController = [OpenDoorViewController new];
                openDoorViewController.currenDoorInfomDic = weakSelf.uncommonListmArray[indexPath.item];
                
                
                
                
                openDoorViewController.infomDic = self.infomDic;
                
                
                
                
                
                if ([_commonListmArray count] >= 6)
                {
                    openDoorViewController.isfrom = @"commonUse";
                    
                }
                else
                {
                    openDoorViewController.isfrom = @"uncommonUse";
                }
                
                
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
                
                openDoorViewController.reloadData = ^(){
                    
                    [weakSelf getlist_commonUse];
                    
                    [weakSelf getlistnotfixed];
                };
                
                
           
             
             
             
             
             
            } failure:^(NSError *error) {
                
                
                
                
            }];
            
        }
        
        _hiddenTag = 0;
    }
}


-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    if (collectionView == _commonCollectionView)
    {
        NSIndexPath *selectIndexPath = [_commonCollectionView indexPathForItemAtPoint:[_longPress locationInView:_commonCollectionView]];
        
//        找到当前的cell
        CommonEntranceGuardCollectionViewCell *cell = (CommonEntranceGuardCollectionViewCell *)[_commonCollectionView cellForItemAtIndexPath:selectIndexPath];
        
        [cell.editingView setHidden:YES];
        commonCollecSelectIndexPath = nil;
        
        [_commonCollectionView setAllowsSelection:YES];
        
        //取出源item数据
        id objc = [self.commonListmArray objectAtIndex:sourceIndexPath.item];
        
        //从资源数组中移除该数据
        [self.commonListmArray removeObject:objc];
        
        //将数据插入到资源数组中的目标位置上
        [self.commonListmArray insertObject:objc atIndex:destinationIndexPath.item];
        
        
        for (int i=0; i<self.commonListmArray.count; i++)
        {
            [self changeCollectionCellPosition_doorid:[self.commonListmArray[i] objectForKey:@"doorid"] newposition:[NSString stringWithFormat:@"%d",i]];
        }
        
        [self getlist_commonUse];
        
        
    }
    else if (collectionView == _otherCollectionView)
    {
        NSIndexPath *selectIndexPath = [_otherCollectionView indexPathForItemAtPoint:[_otherLongPress locationInView:_otherCollectionView]];
        
        //     找到当前的cell
        OtherEntranceGuardCollectionViewCell *cell = (OtherEntranceGuardCollectionViewCell *)[_otherCollectionView cellForItemAtIndexPath:selectIndexPath];
        
        [cell.editingView setHidden:YES];
        uncommonCollecSelectIndexPath = nil;
        
        [_otherCollectionView setAllowsSelection:YES];
        
//        //取出源item数据
//        id objc = [self.uncommonListmArray objectAtIndex:sourceIndexPath.item];
//        
//        //从资源数组中移除该数据
//        [self.uncommonListmArray removeObject:objc];
//        
//        //将数据插入到资源数组中的目标位置上
//        [self.uncommonListmArray insertObject:objc atIndex:destinationIndexPath.item];
//        
//        
//        for (int i=0; i<self.uncommonListmArray.count; i++)
//        {
//            [self changeCollectionCellPosition_doorid:[self.uncommonListmArray[i] objectForKey:@"doorid"] newposition:[NSString stringWithFormat:@"%d",i]];
//        }
//        
//        [self getlistnotfixed];
    }
}


- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  还没有门禁，立即申请
 *
 *  @param sender <#sender description#>
 */
- (IBAction)applyClickButton:(id)sender {
    
    [_blankView setHidden:NO];
    
    ApplyAuthViewController * applyAuthViewController = [ApplyAuthViewController new];
    
    applyAuthViewController.infomDic = self.infomDic;
    
    [self.navigationController pushViewController:applyAuthViewController animated:YES];
}


//- (void)dealloc {
//    [_headView release];
//    [_footView release];
//    [_blankView release];
//    [_commonCollectionView release];
//    [_otherCollectionView release];
//    [_footView release];
//    [super dealloc];
//}

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


-(NSMutableArray *)commonListmArray{
    
    if (_commonListmArray == nil) {
        
        _commonListmArray = [NSMutableArray new];
        
        //获取缓存数据
        NSArray *commonListmArrayCache = [self readFromUserDefaults:@"CommonListmArray_Cache"];
        
        if (commonListmArrayCache != nil) {
            
            [_commonListmArray addObjectsFromArray:commonListmArrayCache];
        }
    }
    
    return _commonListmArray;
}

-(NSMutableArray *)uncommonListmArray
{
    if (!_uncommonListmArray)
    {
        _uncommonListmArray = [NSMutableArray new];
        
        //获取缓存数据
        NSArray *unCommonListmArrayCache = [self readFromUserDefaults:@"UnCommonListmArray_Cache"];
        
        if (unCommonListmArrayCache != nil) {
            
            [_uncommonListmArray addObjectsFromArray:unCommonListmArrayCache];
        }
    }
    return _uncommonListmArray;
}

-(NSMutableArray *)changeCommonListmArray
{
    if (!_changeCommonListmArray)
    {
        _changeCommonListmArray = [NSMutableArray new];
    }
    return _changeCommonListmArray;
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


- (void)dealloc {
//    [_bgCollectionView release];
//    [super dealloc];
}
@end
