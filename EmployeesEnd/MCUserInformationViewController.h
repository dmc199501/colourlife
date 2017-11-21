//
//  MCUserInformationViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/12/15.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
#import "MCPickerView.h"
#import "MCPhotoBrowseViewController.h"
@interface MCUserInformationViewController : MCRootViewControler<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCPickerViewDelegate,  UIPickerViewDataSource, UIPickerViewDelegate>{
    UITableView *listTableView;
    
    UIButton *userPhotoButton;
    
    
    NSMutableArray *imageMutableArray;
    
    NSArray *sexArray;
    NSArray *companyArray;
    NSArray *parkArray;
    
}
@property (nonatomic, assign)BOOL isEditing;
@property (nonatomic, strong)UIImageView *userPhotoImageView;
@property (nonatomic, strong)UITextField *userNameTextField;//姓名
@property (nonatomic, strong)UITextField *sexTextField;//性别
@property (nonatomic, strong)UITextField *nicknameTextField;//昵称
@property (nonatomic, strong)UITextField *addressTextField;//地址
@property (nonatomic, strong)UITextField *mobileTextField;//电话

@property (nonatomic, assign)NSInteger currentIndexSex;//性别
@property (nonatomic, assign)NSInteger currentIndexCompany;//公司
@property (nonatomic, assign)NSInteger currentIndexPark;//园区
@property (nonatomic, strong)NSDictionary *currentSelectCompany;//数组的数据可能会变

@property (nonatomic, strong)NSIndexPath *currentSelectIndexPath;

@property (nonatomic, assign)BOOL userPhotoChanged;




@end
