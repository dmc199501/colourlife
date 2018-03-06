//
//  MCJSFPListViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/12.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCWebViewController.h"

@interface MCJSFPListViewController : MCRootViewControler<UITableViewDataSource,UITableViewDelegate>{
    
   
    
    
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    UIImageView *imagew;
    UILabel *labelw;
}


@end
