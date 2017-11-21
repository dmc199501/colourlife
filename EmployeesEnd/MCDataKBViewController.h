//
//  MCDataKBViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/20.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCDataKBViewController : MCRootViewControler<UITableViewDataSource,UITableViewDelegate>{
    
    UISegmentedControl *segmentControl;
    
    
    NSMutableArray *listMutableArray;
    UITableView *listTableView;
    UIView *backView;
    UILabel*zclabel;
    UILabel*srlabel;
    int total;
    UIView *bacskView;
    UILabel *JGlabel;
    UIImageView *image;
    UIView *areView;
}
@property(nonatomic,strong)NSDictionary *dic ;
@property(nonatomic,strong)NSDictionary *datadic ;
@property(nonatomic,strong)NSDictionary *datadicTwo ;

@property(nonatomic,strong)NSString *name;
@end
