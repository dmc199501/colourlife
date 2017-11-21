//
//  MCsousuoViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/2.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCsousuoViewController : MCRootViewControler<UINavigationControllerDelegate>{

 NSMutableArray *personnellistMutableArray;
    NSMutableArray *APPlistMutableArray;
    NSMutableArray *APPArray;

  NSMutableArray *messagelistMutableArray;
    UIButton *moneyButton;
    UIButton *  pButton;
    UIButton *  APPButton;
    
}
@property(nonatomic,strong)NSString *souStr;
@end
