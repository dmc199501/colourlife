//
//  MCShopMyTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/3/3.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCShopMyTableViewCell.h"
#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width

@implementation MCShopMyTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 17, 20, 20)];
        [self addSubview:self.iconImageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 17, [[UIScreen mainScreen] bounds].size.width - 130, 20)];
        [self addSubview:self.titleLabel];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        
        
//        self.ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 78)];
//        [self addSubview:self.self.ImageView ];
//        [self.ImageView  setImage:[UIImage imageNamed:@"backs_1.2"]];
//        self.ImageView.hidden = YES;
        
        self.arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width- 20, 20, 10, 15)];
       // [self.ImageView addSubview:self.arrowImageView];
        [self.arrowImageView  setImage:[UIImage imageNamed:@"zhiyin_geren"]];
        [self addSubview:_arrowImageView];
        
        //        headerLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5)];
        //        [self addSubview:headerLineImageView];
        //        [headerLineImageView setBackgroundColor:LINE_GRAY_COLOR_ZZ];
        //
        //        footerLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, [[UIScreen mainScreen] bounds].size.width, 0.5)];
        //        [self addSubview:footerLineImageView];
        //        [footerLineImageView setBackgroundColor:LINE_GRAY_COLOR_ZZ];
        
        
        
        
    }
    
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
