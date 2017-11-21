//
//  MyApplyTableViewCell.h
//  WeiTown
//
//  Created by 方燕娇 on 16/8/12.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyApplyTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *fromname;//
@property (retain, nonatomic) IBOutlet UILabel *name;//申请小区
@property (retain, nonatomic) IBOutlet UILabel *creationtime;//申请时间
@property (retain, nonatomic) IBOutlet UILabel *timetype;//授权的时间类型

@end
