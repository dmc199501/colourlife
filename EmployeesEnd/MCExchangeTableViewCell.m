//
//  MCExchangeTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/15.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCExchangeTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCExchangeTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 300, 20)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
        [_nameLabel setText:@"2007"];
        
        
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-340, 10, 300, 20)];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_moneyLabel];
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
        [_moneyLabel setFont:[UIFont systemFontOfSize:15]];
        [_moneyLabel setText:@"200"];
        
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(_nameLabel), 300, 20)];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dateLabel];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setTextColor:GRAY_COLOR_ZZ];
        [_dateLabel setFont:[UIFont systemFontOfSize:15]];
        [_dateLabel setText:@"2017-01-01"];
        
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-340, BOTTOM_Y(_nameLabel), 300, 20)];
        _stateLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_stateLabel];
        [_stateLabel setBackgroundColor:[UIColor clearColor]];
        [_stateLabel setTextColor:GRAY_COLOR_ZZ];
        [_stateLabel setFont:[UIFont systemFontOfSize:15]];
        [_stateLabel setText:@""];
        
        
        
        
        
        
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
