//
//  AuthrozationViewController.h
//  WeiTown
//
//  Created by 方燕娇 on 16/8/15.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "WTBaseViewController.h"

#import "UIImage+UIImageSetSize.h"
#import "SubViewController.h"


@interface AuthrozationViewController : WTBaseViewController<TypeDelegate>

{
    SubViewController *_typeTableView;
}

@property (strong, nonatomic) NSMutableDictionary * infomDic;//根据移动OA获取彩之云帐号ID信息

@end
