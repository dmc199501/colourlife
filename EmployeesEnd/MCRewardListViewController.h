//
//  MCRewardListViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/8.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCRewardListViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{

    NSMutableArray *listMutableArray;
    NSMutableArray *htmlMutableArray;
    UITableView *listTableView;
    UITableView *PQlistTableView;
}
@property (nonatomic, assign) NSInteger isPQ;
@end
