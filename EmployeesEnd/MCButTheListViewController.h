//
//  MCButTheListViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2018/1/10.
//  Copyright © 2018年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCButTheListViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listMutableArray;
    
    UITableView *listTableView;
}
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,strong)NSDictionary *dataDic;

@end
