//
//  MCSendComplaintAndSuggestViewControler.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/11.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
#import "MCPickerView.h"
#import "MCTextsView.h"
#import "MCPhotoBrowseViewController.h"
@interface MCSendComplaintAndSuggestViewControler : MCRootViewControler<UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCPickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIScrollView *backgroundScrollView;
    
    UIButton *typeBackgroundView;
    UILabel *typeNameLabel;
    UILabel *typeLabel;
    UIImageView *arrowImageView;
    
    
    
    MCTextsView *contentTextView;
    
    
    UIView *photoBackgroundView;
    UIButton *addButton;
    NSMutableArray *imageMutableArray;
    
    NSArray *floorArray;
    UIButton *imageViewButton;

    
}
@property (nonatomic, assign)NSInteger currentIndexType;//类型


@end
