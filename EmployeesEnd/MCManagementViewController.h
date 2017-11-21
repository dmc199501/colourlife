//
//  MCManagementViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/20.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCManagementViewController : MCRootViewControler<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    
    int total;

}

@end
