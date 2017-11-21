//
//  MCMemberCenterController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCMemberCenterController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    UIImageView *navBarHairlineImageView;
    UIImageView *userPhotoImageView;
    UIImageView *back;
    UILabel *userNameLabel;
    UILabel *jobNameLabel;

    
    
}



@end
