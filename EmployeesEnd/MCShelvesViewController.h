//
//  MCShelvesViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/23.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
#import "MCPickerView.h"
#import "MCTextsView.h"
@interface MCShelvesViewController : MCRootViewControler<UITableViewDelegate, UITextViewDelegate,UITableViewDataSource,UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCPickerViewDelegate,  UIPickerViewDataSource, UIPickerViewDelegate>{
    NSMutableArray *imageMutableArray;
    MCTextsView *contentTextView;
    MCTextsView *describeTextView;
    NSArray *typeArray;
    UIView *backView ;
    UITableView *listTableView;
     UIButton *userPhotoButton;
}
@property (nonatomic, strong)UITextField *typeTextField;
@property (nonatomic, strong)UITextField *priceTextField;
@property (nonatomic, strong)UITextField *SuggestedPriceTextField;
@property (nonatomic, strong)UITextField *inventoryTextField;
@property (nonatomic, strong)NSIndexPath *currentSelectIndexPath;
@property (nonatomic, assign)NSInteger currentIndexType;
@property (nonatomic, assign)BOOL userPhotoChanged;
@property (nonatomic, strong)UIImageView *userPhotoImageView;
@property(nonatomic,strong)NSDictionary *dataDic;


@end
