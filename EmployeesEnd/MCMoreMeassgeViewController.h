//
//  MCMoreMeassgeViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/7/6.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCMoreMeassgeViewController : MCRootViewControler{
    
    NSMutableArray *personnellistMutableArray;
    NSMutableArray *messagelistMutableArray;
    UIButton *moneyButton;
    UIButton *  pButton;
}
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *souStr;
@property(nonatomic,strong)NSMutableArray *array;

@end
