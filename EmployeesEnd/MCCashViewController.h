//
//  MCCashViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/24.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCCashViewController : MCRootViewControler<UITableViewDelegate, UITableViewDataSource>{
     UITableView *listTableView;
    
}
@property (nonatomic, strong)UITextField *priceTextField;
@end
