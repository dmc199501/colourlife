//
//  MCTemporarypasswordViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/8.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCTemporarypasswordViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{

    UIActivityIndicatorView *Activitydistrict;
    UILabel *labelTempPass;
    
    UITableView *listTableView;
}

@end
