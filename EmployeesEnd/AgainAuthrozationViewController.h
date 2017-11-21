//
//  AgainAuthrozationViewController.h
//  WeiTown
//
//  Created by 方燕娇 on 16/8/25.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "WTBaseViewController.h"

#import "UIImage+UIImageSetSize.h"
#import "SubViewController.h"

#import "AuthrozationViewController.h"


@interface AgainAuthrozationViewController : WTBaseViewController<TypeDelegate>

{
    SubViewController *_typeTableView;
}

@property (strong, nonatomic) NSMutableDictionary * infomDic;//根据移动OA获取彩之云帐号ID信息

@property (strong, nonatomic) NSMutableDictionary * currentCommunityInfomDic;//当前选中的小区的信息

@property (strong, nonatomic) NSMutableArray * userCommunityListmArray;//用户小区列表 数据源

@property (strong, nonatomic) NSString * community_bid;//

@property (strong, nonatomic) NSString * isPassAgain;//0：再次授权  1：批复

@property (strong, nonatomic) AuthrozationViewController * authrozationViewController;

@end
