//
//  DetailAuthrozationViewController.h
//  WeiTown
//
//  Created by 方燕娇 on 16/8/24.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "WTBaseViewController.h"
#import "AuthrozationViewController.h"

@interface DetailAuthrozationViewController : WTBaseViewController

@property (strong, nonatomic) NSMutableDictionary * infomDic;//根据移动OA获取彩之云帐号ID信息

@property (strong, nonatomic) NSMutableDictionary * currentCommunityInfomDic;//当前选中的小区的信息

@property (strong, nonatomic) NSMutableArray * userCommunityListmArray;//用户小区列表 数据源

@property (strong, nonatomic) NSString * community_aid;//授权编号

@property (retain, nonatomic) IBOutlet UILabel *autype;//通过／已失效／未批复／。。

@property (retain, nonatomic) IBOutlet UILabel *usertype;//授权类型：1＝永久 2＝七天  3＝一天 4＝两小时 5＝一年

@property (retain, nonatomic) IBOutlet UILabel *starttime;//申请时间

@property (retain, nonatomic) IBOutlet UILabel *memo;//备注

@property (strong, nonatomic) NSString * autype_Str;

@property (assign, nonatomic) int buttonTag;//11:已失效－（再次授权）；12:通过－（取消授权）

@property (retain, nonatomic) IBOutlet UIButton *button;//取消权限／再次授权

@property (strong, nonatomic) AuthrozationViewController * authrozationViewController;

@end

