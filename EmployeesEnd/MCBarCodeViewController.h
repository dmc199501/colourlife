//
//  MCBarCodeViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/10.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@protocol MCBarCodeViewControllerDelegate;
@interface MCBarCodeViewController : MCRootViewControler@property (nonatomic, assign)id delegate;


@end
@protocol MCBarCodeViewControllerDelegate <NSObject>
@optional
- (void)barCodeViewController:(MCBarCodeViewController *)barCodeViewController codeString:(NSString *)codeString;

@end
