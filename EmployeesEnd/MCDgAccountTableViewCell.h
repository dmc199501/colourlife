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
@property (nonatomic, strong) UIButton *syButton;
@property (nonatomic, strong) UIButton *dhButton;
@property (nonatomic, strong) UIButton *netButton;

@property (nonatomic, strong) id delegate;
@end
@protocol MCDgAccountTableViewCellDelegate <NSObject>
@optional
- (void)MCDgAccountTableViewCell:(MCDgAccountTableViewCell *) MCDgAccountTableViewCell exchange:(UIButton *)Button ;

- (void)MCDgAccountTableViewCell:(MCDgAccountTableViewCell *) MCDgAccountTableViewCell transfer:(UIButton *)Button ;

- (void)MCDgAccountTableViewCell:(MCDgAccountTableViewCell *) MCDgAccountTableViewCell dhAccount:(UIButton *)Button ;

@end
