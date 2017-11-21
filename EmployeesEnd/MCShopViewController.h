//
//  MCShopViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/16.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

#import "MCAutoSizeImage.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "DDCoverView.h"
@interface MCShopViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>{
    UIImageView *headerView;
    UITableView *headerScrollView;
    DDCoverView *backView ;
    UIImageView *photoImageView;
    UILabel *userNameLabel;
    UILabel *workNumberLabel;
    UILabel *officeLabel;
    UILabel *appraiseLabel;
    
    NSMutableArray *listMutableArray;
    NSMutableArray *htmlMutableArray;
    UITableView *listTableView;
    
    int total;
    
    
    
}
@property (nonatomic, strong)NSMutableArray *buttonMutableArray;
@end

