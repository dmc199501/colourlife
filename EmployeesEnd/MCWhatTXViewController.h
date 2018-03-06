//
//  MCWhatTXViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/14.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCWhatTXViewController : MCRootViewControler{

    UILabel *userName;
    UILabel *bankLabel;
    UILabel *cardLabel;
    UILabel *dzLabel;

}
@property(nonatomic,strong)NSString *passWord;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *passWordView;
@property(nonatomic,strong)UITextField *moneyTextField;
@property(nonatomic,strong)NSString *balance;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *bank;
@property(nonatomic,strong)NSString *card;
@property(nonatomic,strong)NSString *cardID;
@property(nonatomic,strong)NSString *bindID;
@end
