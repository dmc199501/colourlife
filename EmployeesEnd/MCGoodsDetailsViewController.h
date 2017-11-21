//
//  MCGoodsDetailsViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/22.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
#import "MCPickerView.h"
@interface MCGoodsDetailsViewController : MCRootViewControler<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCPickerViewDelegate,  UIPickerViewDataSource, UIPickerViewDelegate>{
    NSMutableArray *imageMutableArray;
   

    NSArray *typeArray;
    UIView *backView ;
     UITableView *listTableView;

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
