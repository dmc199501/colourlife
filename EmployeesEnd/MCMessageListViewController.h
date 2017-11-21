//
//  MCMessageListViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/27.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCMessageListViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>{
     UITableView *listTableView;
    NSMutableArray *listMutableArray;
    UITableView *headerScrollView;
}
@property(nonatomic,strong)NSString *code;


@end
