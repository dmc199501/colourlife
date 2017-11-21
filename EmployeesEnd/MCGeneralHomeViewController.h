//
//  MCGeneralHomeViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/7/21.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
#import "MCAutoSizeImage.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "DDCoverView.h"
#import "MyMD5.h"
@interface MCGeneralHomeViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>{
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
    NSMutableArray *officeMutableArray;
    NSMutableArray *homeButtonMutableArray;
    NSMutableArray *listGDMutableArray;
    NSMutableArray *listOneMutableArray;

    NSMutableArray *ggtzMutableArray;
    NSMutableArray *yjMutableArray;
    NSMutableArray *mfMutableArray;
    NSMutableArray *spMutableArray;
    
}
@property (nonatomic, strong)NSMutableArray *buttonMutableArray;


@end
