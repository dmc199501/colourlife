//
//  AuthrozationListTableViewCell.h
//  WeiTown
//
//  Created by 方燕娇 on 16/8/24.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthrozationListTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *phoneLab;//电话号码

@property (retain, nonatomic) IBOutlet UILabel *typeLab;//授权类型

@property (retain, nonatomic) IBOutlet UILabel *communityName;//小区名称

@property (retain, nonatomic) IBOutlet UILabel *timeLab;//申请时间

@end
