//
//  ApplyOpenEntranceGuardViewController.h
//  WeiTown
//
//  Created by 方燕娇 on 16/8/11.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "WTBaseViewController.h"

@interface ApplyOpenEntranceGuardViewController : WTBaseViewController



@property (strong, nonatomic) NSMutableDictionary * infomDic;//根据移动OA获取彩之云帐号ID信息

@property (retain, nonatomic) IBOutlet UILabel *appliedNum_Lab;//已有 X 位邻居申请开通

@property (assign, nonatomic) int appliedNum;//存放 调用“当前小区申请开通门禁的人数”接口的返回值

@property (assign, nonatomic) int isapply;//0:还未申请 显示申请按钮  ；  1：已提交申请，隐藏申请按钮

@property (strong, nonatomic) NSMutableDictionary * communityInfoDict;//当前用户所在的小区信息

@end
