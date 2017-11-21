//
//  MCMicroServiceControl.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"

@interface MCMicroServiceControl : MCRootViewControler{

    UILabel *officeLabel;
    UILabel *managementLabel;
    UIView *officeButtonView;
    UIScrollView *ButtonView;
    UIView *managementButtonView;
    
    NSMutableArray *officeMutableArray;
    NSMutableArray *managementMutableArray;
    NSMutableArray *oneButtonMutableArray;
    NSMutableArray *twoButtonMutableArray;
    NSMutableArray *twoMutableArray;
    NSMutableArray *oneMutableArray;
    UIView *twoButtonView;
    UILabel *label;
    UILabel *label2;
    UIView *oneButtonView;
    NSMutableArray *activityMutableArray;

}
@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic, strong) UIScrollView *adScrollView;
@property (nonatomic, strong) UIPageControl *adPageControl;
@property(nonatomic,strong)NSString *amailNumStr;
@property(nonatomic,strong)NSString *examineNumStr;
@property(nonatomic,assign)NSInteger tol;
@end
