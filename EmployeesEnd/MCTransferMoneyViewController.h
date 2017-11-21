//
//  MCTransferMoneyViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/9.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCTransferMoneyViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listMutableArray;
   
    UITableView *listTableView;
       
    
    
}
@property(nonatomic,strong)NSString *balance;
@property(nonatomic,strong)NSMutableArray *datalistMutableArray;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *passWordView;
@property(nonatomic,strong)NSString *passWord;

@end
