//
//  MCJxViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/8.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCJxViewController : MCRootViewControler
<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *JXlistMutableArray;
    NSMutableArray *JFlistMutableArray;

    UITableView *JXlistTableView;
    UITableView *JFlistTableView;
    
    
    
    
    
    
}
@property(nonatomic,strong)NSDictionary *jtDic;
@property(nonatomic,strong)NSDictionary *grDic;
@property(nonatomic,strong)NSString *type;


@end
