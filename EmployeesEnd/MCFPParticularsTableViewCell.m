//
//  MCFPParticularsTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/12.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCFPParticularsTableViewCell.h"
#import "MCMicroServiceControl.h"
@implementation MCFPParticularsTableViewCell
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
        [_moneyLabel setTextColor:[UIColor colorWithRed:255 / 255.0 green:101 / 255.0 blue:76/ 255.0 alpha:1]];
        [_moneyLabel setFont:[UIFont systemFontOfSize:15]];
        [_moneyLabel setText:@"200"];
        
        _oderLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH-40, 20)];
        _oderLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_oderLabel];
        [_oderLabel setBackgroundColor:[UIColor clearColor]];
        [_oderLabel setTextColor:GRAY_COLOR_ZZ];
        [_oderLabel setFont:[UIFont systemFontOfSize:13]];
        [_oderLabel setText:@"业务订单号"];
        
        _tradingLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,50, SCREEN_WIDTH-40, 20)];
        _tradingLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_tradingLabel];
        [_tradingLabel setBackgroundColor:[UIColor clearColor]];
        [_tradingLabel setTextColor:GRAY_COLOR_ZZ];
        [_tradingLabel setFont:[UIFont systemFontOfSize:13]];
        [_tradingLabel setText:@"交易流水号"];
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, 300, 20)];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dateLabel];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setTextColor:GRAY_COLOR_ZZ];
        [_dateLabel setFont:[UIFont systemFontOfSize:13]];
        [_dateLabel setText:@"2017-01-01"];

        
        
        
        
        
        
        
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
