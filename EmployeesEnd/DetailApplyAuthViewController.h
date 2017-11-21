//
//  DetailApplyAuthViewController.h
//  WeiTown
//
//  Created by 方燕娇 on 16/8/23.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "WTBaseViewController.h"

@interface DetailApplyAuthViewController : WTBaseViewController

@property (strong, nonatomic) NSMutableDictionary * infomDic;//根据移动OA获取彩之云帐号ID信息

@property (strong, nonatomic) NSMutableDictionary * currentApplyInfomDic;//当前选中行的申请记录的信息

@property (retain, nonatomic) IBOutlet UILabel *timetype;
@property (retain, nonatomic) IBOutlet UILabel *phoneLab;
@property (retain, nonatomic) IBOutlet UILabel *remarkLab;

@property (retain, nonatomic) IBOutlet UIButton *applyAgainBtn;

@property (strong, nonatomic) NSString * phone;
@property (strong, nonatomic) NSString * remark;
@property (strong, nonatomic) NSString * type;

@property (assign, nonatomic) BOOL ishidden;

@end
