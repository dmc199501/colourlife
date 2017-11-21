//
//  MCDgAccountViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/9/5.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCDgAccountViewController : MCRootViewControler
<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listMutableArray;
    NSMutableArray *nameMutableArray;
    UITableView *listTableView;
}

@end
