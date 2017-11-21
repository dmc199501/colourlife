//
//  MCCGViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/15.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCCGViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    
    
    
    
}
@property(nonatomic,strong)NSString *card;
@property(nonatomic,strong)NSString *money;
@property(nonatomic,strong)NSString *money2;


@end
