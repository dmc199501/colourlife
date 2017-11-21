//
//  MCShopMyViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/3/3.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

#import "MCWebViewController.h"
@interface MCShopMyViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    
    UIView *tableHeaderView;
    UIImageView *userPhotoImageView;
    UIButton *showUploadPhotoButton;
    UILabel *userNameLabel;
    UIImageView *headerView;
    UIView *lineView;
    UIView *lineView2;
    UILabel *balanceLabel;
    UILabel *iconBadgeNumberLabel;
    UILabel *newLabel;
    
    
    
    
    
}


@end
