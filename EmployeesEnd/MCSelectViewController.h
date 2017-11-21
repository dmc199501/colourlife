//
//  MCSelectViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/13.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCSelectViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listMutableArray;
    NSMutableArray *htmlMutableArray;
    UITableView *listTableView;
}
@property(nonatomic,strong)NSString *balance;


@end
