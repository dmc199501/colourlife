//
//  MCJSFPTableViewCell.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/12.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCJSFPTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) id delegate;
@end
@protocol MCJSFPTableViewCellDelegate <NSObject>
@optional
- (void)MCJSFPTableViewCell:(MCJSFPTableViewCell *) JSFPListTableViewCell exchange:(UIButton *)Button ;

@end
