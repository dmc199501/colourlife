//
//  MCCZYViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/14.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCCZYViewController : MCRootViewControler<UITextFieldDelegate>{
    
    UIScrollView *zzView;
    
    UILabel *moneyLabel;
    
}

@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,strong)UITextField *moneyTextField;
@property(nonatomic,assign)NSString *money;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *balance;
@property (nonatomic, assign)NSInteger currenSelect;//当前点击的是哪个
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *passWordView;
@property(nonatomic,strong)NSString *passWord;
@property(nonatomic,strong)NSString *mobile;
@end
