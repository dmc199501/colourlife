//
//  MCHomePageController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
#import "MCAutoSizeImage.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "DDCoverView.h"
#import "MyMD5.h"
@interface MCHomePageController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>{
    UIView *headerView;
    UITableView *headerScrollView;
    DDCoverView *backView ;
    UIImageView *photoImageView;
    UILabel *userNameLabel;
    UILabel *workNumberLabel;
    UILabel *officeLabel;
    UILabel *appraiseLabel;
    
    NSMutableArray *listMutableArray;
    NSMutableArray *listOneMutableArray;
    NSMutableArray *redIDMutableArray;
    NSMutableArray *htmlMutableArray;
    UITableView *listTableView;
    
    int total;
 NSMutableArray *officeMutableArray;
    NSMutableArray *homeButtonMutableArray;
    NSMutableArray *ggtzMutableArray;
    NSMutableArray *yjMutableArray;
    NSMutableArray *mfMutableArray;
    NSMutableArray *spMutableArray;
     NSMutableArray *listGDMutableArray;
    
    UIButton *shopButton;


    UILabel *stockLaber;
    UILabel *scoreLaber;
    UILabel *myMealLaber;
    UILabel *areaLaber;
    UILabel *districtlLaber;
    UILabel *accountLaber;
    
    
    UIActivityIndicatorView *Activitystock;
    UIActivityIndicatorView *Activityscore;
    UIActivityIndicatorView *Activitymeal;
    UIActivityIndicatorView *Activityarea;
    UIActivityIndicatorView *Activitydistrict;
     UIActivityIndicatorView *ActivityFZ;
    UILabel *labelHome;
    UIImageView *imageHome;
    

}
@property (nonatomic, strong)NSMutableArray *buttonMutableArray;
@property (nonatomic, strong)NSDictionary *areaDic;
@property (nonatomic, strong)NSString *flamname;
@property (nonatomic, strong)NSString *fzstring;

@end
