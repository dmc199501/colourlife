//
//  MCSalesViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/24.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCSalesViewController : MCRootViewControler<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    
    int total;
    
}


@end
