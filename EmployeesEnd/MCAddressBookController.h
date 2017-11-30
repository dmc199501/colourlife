//
//  MCAddressBookController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCAddressBookController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    UILabel *organizationLabel;
    UILabel *jobLabel;
    NSMutableArray *contactListMutableArray;
    UITableView *contactListTableView;
     UILabel *remindLabel;
    
    
    
    
}
@property(nonatomic,strong)NSString *orgName;
@property(nonatomic,strong)NSString *orgid;


@end
