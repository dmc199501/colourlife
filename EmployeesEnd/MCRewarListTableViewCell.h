//
//  MCRewarListTableViewCell.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/8.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCRewarListTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *budgetLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *basisLabel;
@property (nonatomic, strong) UILabel *rewardLabel;
@property (nonatomic, strong) UILabel *ChargeLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) UIImageView *noReadImageView;
@end
@protocol MCRewarListTableViewCellDelegate <NSObject>
@optional
- (void)MCRewarListTableViewCell:(MCRewarListTableViewCell *)rewarListTableViewCell details:(UIButton *)Button ;

@end
