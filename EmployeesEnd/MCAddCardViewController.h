//
//  MCAddCardViewController.h
//  CommunityThrough
//
//  Created by 邓梦超 on 17/3/31.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
#import "MCPickerView.h"
@interface MCAddCardViewController : MCRootViewControler<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MCPickerViewDelegate,  UIPickerViewDataSource, UIPickerViewDelegate>{

    UITableView *listTableView;
    NSArray *cardArray;
   UITextField *typefield;
}
@property (nonatomic, strong)UITextField *userNameTextField;//姓名
@property (nonatomic, strong)UITextField *cardTextField;//卡号
@property (nonatomic, strong)UITextField *IDcardTextField;
@property (nonatomic, strong)NSIndexPath *currentSelectIndexPath;
@property (nonatomic, assign)NSInteger currenSelect;//当前点击的是哪个
@property (nonatomic, assign)NSInteger currentIndexType;//类型
@property (nonatomic, assign)NSInteger currentIndexAddress;//地址
@property(nonatomic,strong)NSString *balance;
@end
