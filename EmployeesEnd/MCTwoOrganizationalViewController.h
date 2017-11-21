//
//  MCTwoOrganizationalViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/12/17.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCTwoOrganizationalViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    NSMutableArray *listMutableArrayZZ;
    NSMutableArray *listMutableArrayRY;
    NSMutableArray *contactListMutableArray;
    UITableView *contactListTableView;
    
    UILabel *notice1;
    UILabel *remindLabel;
    
    
}

@property(nonatomic,strong)NSString *IDString;
@property(nonatomic,strong)NSString *phoneString;
@property(nonatomic,strong)NSString *titleString;
@property(nonatomic,strong)NSString *nameString;
@end
