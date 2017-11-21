//
//  MCChangePasswordViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/12/15.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCChangePasswordViewController : MCRootViewControler<UITextFieldDelegate>{
    UIScrollView *scrollView;
    UITextField *NewpasswordTextField;
    UITextField *passwordTextField;
    UITextField *repeatTextField;
    
    
}



@end
