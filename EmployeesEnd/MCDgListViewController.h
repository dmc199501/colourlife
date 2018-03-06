//
//  MCDgListViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2018/1/10.
//  Copyright © 2018年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCDgListViewController : MCRootViewControler
<UITextFieldDelegate>{
    
    UIScrollView *zzView;
    UILabel *moneyLabel;
    
}
@property(nonatomic,strong)UITextField *qqTextField;
@property(nonatomic,strong)UITextField *moneyTextField;
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,strong)NSDictionary *dataDic;

@end
