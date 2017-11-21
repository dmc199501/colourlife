//
//  MCDatachanggeTableViewCell.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/7/12.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCDatachanggeTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) id delegate;
@end
@protocol MCMembersTableViewCellDelegate <NSObject>
@optional
- (void)MCDatachanggeTableViewCell:(MCDatachanggeTableViewCell *)MCDatachanggeTableViewCell deleteMembers:(UIButton *)Button ;


@end
