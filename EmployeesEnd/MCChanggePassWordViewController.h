//
//  MCChanggePassWordViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/9/15.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCChanggePassWordViewController : MCRootViewControler
<UITextFieldDelegate>{
    UIScrollView *scrollView;
    UITextField *IDTextField;
    UITextField *nameTextField;
    UITextField *phoneTextField;
    
    
}
@property(nonatomic,strong)NSString *username;
@end
