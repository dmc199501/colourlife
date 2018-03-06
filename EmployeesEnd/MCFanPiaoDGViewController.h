//
//  MCFanPiaoDGViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2018/2/7.
//  Copyright © 2018年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCFanPiaoDGViewController : MCRootViewControler<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listMutableArray;
    NSMutableArray *nameMutableArray;
    UITableView *listTableView;
    UIButton *shopButton;
}
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *taken;


@end
