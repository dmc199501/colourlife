//
//  MCAccountListViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/27.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCAccountListViewController : MCRootViewControler<UITableViewDataSource,UITableViewDelegate>{
    
    UISegmentedControl *segmentControl;
    
    
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    UIView *backView;
    UILabel*zclabel;
    UILabel*srlabel;
    int total;
    UIImageView *image;
     UIImageView *image2;
}
@property(nonatomic,strong)NSString *money;

@end
