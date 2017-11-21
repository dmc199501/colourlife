//
//  MCUploadReportRepairViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/11.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
#import "MCPickerView.h"
#import "MCTextsView.h"
#import "MCPhotoBrowseViewController.h"
@interface MCUploadReportRepairViewController : MCRootViewControler<UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCPickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIScrollView *backgroundScrollView;
    
    UIButton *typeBackgroundView;
    UILabel *typeNameLabel;
    UILabel *typeLabel;
    UIImageView *arrowImageView;
     UIButton *imageViewButton;
    UITextField *addressField;

    
    UIButton *addressBackgroundView;
    UILabel *addressNameLabel;
    UILabel *addressLabel;
    
    MCTextsView *contentTextView;
    
    
    UIView *photoBackgroundView;
    UIButton *addButton;
    NSMutableArray *imageMutableArray;
    
    NSArray *floorArray;
    NSArray *addressArray;
}
@property (nonatomic, assign)NSInteger currentIndexType;//类型
@property (nonatomic, assign)NSInteger currentIndexAddress;//地址
@property (nonatomic, assign)NSInteger currenSelect;//当前点击的是哪个


@end
