//
//  MCvouchersViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/23.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
#import "MCPickerView.h"
#import "ZZDatePickerView.h"
@interface MCvouchersViewController : MCRootViewControler<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, MCPickerViewDelegate, ZZDatePickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
     NSMutableArray *listMutableArray;
    UITableView *listTableView;
    UITextField *beginDateTextField;
    UITextField *endDateTextField;
    int total;
}
@property (nonatomic, strong)NSIndexPath *currentSelectIndexPath;

@end
