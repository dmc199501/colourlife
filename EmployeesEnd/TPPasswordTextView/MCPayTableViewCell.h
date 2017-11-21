//
//  MCPayTableViewCell.h
//  CommunityThrough
//
//  Created by 邓梦超 on 17/4/17.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCPayTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *houseLabel;
@property (nonatomic, strong) UILabel *available;
@property (nonatomic, strong) UIImageView *stateV;
@property (nonatomic, strong) UIImageView *icon;
@property(nonatomic,strong) UIView *line;
@property(nonatomic,strong)UIView *hidenView ;
@end
