//
//  OpenDoorRecordTableViewCell.m
//  WeiTown
//
//  Created by 方燕娇 on 16/8/22.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "OpenDoorRecordTableViewCell.h"

@implementation OpenDoorRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_lightImgV setImage:[UIImage imageNamed:@"icon_dot"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
