//
//  MCExchangViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/15.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCExchangViewController : MCRootViewControler<UITextFieldDelegate>{

    UIButton *addressBackgroundView;
    UILabel *wMoneyLabel;
    UILabel *wMoneyTwoLabel;
    UITextField *wMoneyField;

}
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *passWordView;
@property(nonatomic,strong)NSString *passWord;

@end
