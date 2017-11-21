//
//  CommonEntranceGuardCollectionViewCell.h
//  WeiTown
//
//  Created by 方燕娇 on 16/8/16.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonEntranceGuardCollectionViewCell : UICollectionViewCell

@property (retain, nonatomic) IBOutlet UIImageView *commonDoorImageV;//图标

@property (retain, nonatomic) IBOutlet UILabel *commonDoorName;//门的名称

@property (retain, nonatomic) IBOutlet UIView *editingView;

@property (retain, nonatomic) IBOutlet UIButton *deleteBtn;//删除按钮

@property (retain, nonatomic) IBOutlet UIButton *editBtn;//编辑按钮
@property (retain, nonatomic) IBOutlet UIButton *addDoorBtn;

@end
