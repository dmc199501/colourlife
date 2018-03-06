//
//  MCExchangeRecordViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/15.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCExchangeRecordViewController : MCRootViewControler<UITableViewDataSource,UITableViewDelegate>{
    
    
    
    UIView *backView;
    UIView *oderView;
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    UIImageView *imagew;
    UILabel *labelw;
    UILabel *totle;
}
@property(nonatomic,strong)NSDictionary *datadic;



@end
