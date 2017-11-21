//
//  MCvouchersTableViewCell.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/23.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCvouchersTableViewCell : UITableViewCell{
    UIView *backgroundView;

}
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *wordLabel;

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *stateLabel;


@end
