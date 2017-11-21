//
//  MCPQTableViewCell.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/12.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCPQTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *budgetLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *basisLabel;
@property (nonatomic, strong) UILabel *rewardLabel;
@property (nonatomic, strong) UILabel *ChargeLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *PQtotalLabel;
@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) UIImageView *noReadImageView;
@end
@protocol MCPQTableViewCellDelegate <NSObject>
@optional
- (void)MCPQTableViewCell:(MCPQTableViewCell *)PQListTableViewCell details:(UIButton *)Button ;
@end
