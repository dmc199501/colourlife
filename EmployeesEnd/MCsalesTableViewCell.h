//
//  MCsalesTableViewCell.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/24.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCsalesTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *salesLabel;
@property (nonatomic, strong) UIButton *stateButton;

@end
