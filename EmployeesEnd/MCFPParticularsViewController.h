//
//  MCFPParticularsViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/12.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCFPParticularsViewController : MCRootViewControler<UITableViewDataSource,UITableViewDelegate>{
    
    
    
    
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    
    UIImageView *imagew;
    UILabel *labelw;
    
}
@property(nonatomic,strong)NSDictionary *datadic;

@end
