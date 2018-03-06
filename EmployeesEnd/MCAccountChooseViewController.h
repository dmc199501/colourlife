//
//  MCAccountChooseViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/9.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCAccountChooseViewController : MCRootViewControler{
    UITableView *listTableView ;
    
}
@property(nonatomic,strong)NSArray *listArray;
@end
