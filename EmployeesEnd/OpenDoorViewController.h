//
//  OpenDoorViewController.h
//  WeiTown
//
//  Created by 方燕娇 on 16/8/16.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "WTBaseViewController.h"
#import "EntranceGuardViewController.h"

typedef void(^ReloadData)();

@interface OpenDoorViewController : WTBaseViewController

@property (retain, nonatomic) IBOutlet UIImageView *imageView;

@property (retain, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) NSString * openSuccess;//0:开门成功; 1:开门失败

@property (retain, nonatomic) IBOutlet UITextField *editName_Txt;

@property (retain, nonatomic) IBOutlet UIButton *addCommonUse_Btn;

@property (retain, nonatomic) IBOutlet UIButton *backBtn;

@property (strong, nonatomic) NSString * isfrom;//commonUse:常用；uncommonUse:非常用

@property (strong, nonatomic) NSMutableDictionary * currenDoorInfomDic;//存储当前操作的这个门的信息

@property (strong, nonatomic) NSMutableDictionary * infomDic;//根据移动OA获取彩之云帐号ID信息

@property (strong, nonatomic) EntranceGuardViewController * entranceGuardViewController;//

@property (copy, nonatomic) ReloadData reloadData;//刷新数据代码块

@property (strong, nonatomic) NSString * isSucceed_FromScan;//0:扫描成功 1:扫描失败

@end
