//
//  MCDgAccountTableViewCell.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/9/5.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCDgAccountTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *accountName;
@property (nonatomic, strong) UILabel *carNumber;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UIButton *mxButton;
@property (nonatomic, strong) UIButton *netButton;
@end
