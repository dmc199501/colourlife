//
//  OtherEntranceGuardCollectionViewCell.m
//  WeiTown
//
//  Created by 方燕娇 on 16/8/16.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import "OtherEntranceGuardCollectionViewCell.h"

@implementation OtherEntranceGuardCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [_editingView setBackgroundColor:[UIColor colorWithRed:0.69 green:0.69 blue:0.70 alpha:0.60]];
    
    [self.editingView setBackgroundColor:[UIColor clearColor]];
    
//    [_otherDoorImageV setImage:[UIImage imageNamed:@"icon_home"]];
//    
//    [_otherName setText:@"公司电梯1"];
    
}

- (IBAction)addBtnAction:(id)sender {
}


@end
