//
//  MCDgSearchViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2018/1/10.
//  Copyright © 2018年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCDgSearchViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listMutableArray;
    NSMutableArray *namelistMutableArray;
    UITableView *listTableView;
     UITableView *ZZlistTableView;
    NSMutableArray *listSearchArray;
    
    
}
@property(nonatomic,strong)NSDictionary *dataDic;


@end
