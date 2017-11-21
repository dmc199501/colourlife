//
//  MCDataChanggeViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/7/12.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
@class MCDataChanggeViewController;
@protocol MCDataChanggeViewControllerDeleGete <NSObject>

@optional
-(void)viewController:(MCDataChanggeViewController*)ViewController didPushVlaueWithAddress:(id)address;

@end


@interface MCDataChanggeViewController : MCRootViewControler <UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listMutableArray;
    NSMutableArray *listMutableArrayZZ;
    NSMutableArray *listMutableArrayRY;
    UITableView *listTableView;
    
    NSMutableArray *contactListMutableArray;
    UITableView *contactListTableView;
    UILabel *notice1;
    UILabel *remindLabel;
    UILabel *label;
    
    
    
    
}
@property(nonatomic,strong)NSString *IDString;
@property(nonatomic,strong)NSString *phoneString;
@property(nonatomic,strong)NSString *titleString;
@property(nonatomic,strong)NSString *nameString;
@property(nonatomic,assign)NSInteger type;

@property (nonatomic,assign)id<MCDataChanggeViewControllerDeleGete>delegate;

@end
