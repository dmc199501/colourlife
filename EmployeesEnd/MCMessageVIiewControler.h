//
//  MCMessageVIiewControler.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/9.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCMessageVIiewControler : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{


    NSMutableArray *listMutableArray;
    UITableView *listTableView;

}
@property (nonatomic,strong)NSString *codeString;
@property (nonatomic,strong)NSString *titleString;
@end
