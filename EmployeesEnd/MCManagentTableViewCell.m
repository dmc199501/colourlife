//
//  MCManagentTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/20.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCManagentTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCManagentTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 17, 65, 65)];
        [self addSubview:_iconImageView];
        [_iconImageView setImage:[UIImage imageNamed:@"shouhou_w"]];
        [_iconImageView.layer setCornerRadius:5];
        
        
      
        
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 20, self.frame.size.width- 100, 20)];
        [self addSubview:_titleLabel];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor colorWithRed:13 / 255.0 green:40 / 255.0 blue:53 / 255.0 alpha:1] ];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setText:@"煮粥的鸭子"];
        
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 40, SCREEN_WIDTH-100, 20)];
        [self addSubview:_priceLabel];
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [_priceLabel setTextColor:[UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:1]];
        [_priceLabel setFont:[UIFont systemFontOfSize:13]];
        [_priceLabel setText:@"哈哈哈哈哈哈哈哈哈哈哈"];
        
        
        _salesLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 60, 150, 20)];
        [self addSubview:_salesLabel];
        [_salesLabel setBackgroundColor:[UIColor clearColor]];
        [_salesLabel setTextAlignment:NSTextAlignmentLeft];
        [_salesLabel setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1]];
        [_salesLabel setFont:[UIFont systemFontOfSize:13]];
        [_salesLabel setText:@"五块钱啊 五款起 啊"];
        
        
        _stateButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 60, 40, 20)];
        [self addSubview:_stateButton];
        _stateButton.userInteractionEnabled = NO;
        
        
        
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
