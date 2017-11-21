//
//  OpenDoorRecordTableViewCell.h
//  WeiTown
//
//  Created by 方燕娇 on 16/8/22.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenDoorRecordTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *doorName;//门的名称
@property (retain, nonatomic) IBOutlet UILabel *lastTime;//最近一次的时间
@property (retain, nonatomic) IBOutlet UIButton *openDoorBtn;//点击开门
@property (retain, nonatomic) IBOutlet UIImageView *lightImgV;//小圆点

@end
