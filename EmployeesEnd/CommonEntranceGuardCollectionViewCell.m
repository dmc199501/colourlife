//
//  CommonEntranceGuardCollectionViewCell.m
//  WeiTown
//
//  Created by 方燕娇 on 16/8/16.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "CommonEntranceGuardCollectionViewCell.h"

@interface CommonEntranceGuardCollectionViewCell()


@end

@implementation CommonEntranceGuardCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [_editingView setBackgroundColor:[UIColor colorWithRed:0.69 green:0.69 blue:0.70 alpha:0.60]];
    
    [self.editingView setBackgroundColor:[UIColor clearColor]];
    
    [_commonDoorImageV setImage:[UIImage imageNamed:@"icon_home"]];
    
    [_commonDoorName setText:@"我家"];
}



@end
