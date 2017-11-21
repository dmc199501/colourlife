//
//  MCFPDetailsViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/9.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCFPDetailsViewController : MCRootViewControler<UITableViewDataSource,UITableViewDelegate>{
    
    UISegmentedControl *segmentControl;
    
    
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    UIView *backView;
    UILabel*zclabel;
    UILabel*srlabel;
    int total;
}


@end
