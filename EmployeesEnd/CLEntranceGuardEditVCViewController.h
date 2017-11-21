//
//  CLEntranceGuardEditVCViewController.h
//  WeiTown
//
//  Created by 方燕娇 on 16/8/16.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "WTBaseViewController.h"

typedef void(^ReloadCommonEntrData)();//刷新常用门禁列表数据


@interface CLEntranceGuardEditVCViewController : WTBaseViewController

@property (strong, nonatomic) NSMutableDictionary * infomDic;//根据移动OA获取彩之云帐号ID信息

@property (copy, nonatomic) ReloadCommonEntrData reloadCommonEntrData;

@end
