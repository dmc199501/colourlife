//
//  MCRedEnvelopesViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/9.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCRedEnvelopesViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    
    
    
}

@property (nonatomic, strong)UITextField *moneyTextField;//
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *balance;
@property (nonatomic,strong)NSString *OASting;

@end
