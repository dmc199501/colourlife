//
//  MCdgmxTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2018/1/8.
//  Copyright © 2018年 邓梦超. All rights reserved.
//

#import "MCdgmxTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCdgmxTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        backview.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242/ 255.0 alpha:1];
        [self addSubview:backview];

               
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 20, SCREEN_WIDTH, 20)];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dateLabel];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setTextColor:GRAY_COLOR_ZZ];
        [_dateLabel setFont:[UIFont systemFontOfSize:13]];
        [_dateLabel setText:@"2018-1-1"];

        
        
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-220, 20, 200, 30)];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_moneyLabel];
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextColor:[UIColor colorWithRed:255 / 255.0 green:101 / 255.0 blue:76/ 255.0 alpha:1]];
        [_moneyLabel setFont:[UIFont systemFontOfSize:30]];
        [_moneyLabel setText:@"90.23"];
        
        _bzLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, BOTTOM_Y(_dateLabel)+10, SCREEN_WIDTH, 35)];
        _bzLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_bzLabel];
        [_bzLabel setBackgroundColor:[UIColor clearColor]];
        [_bzLabel setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
        [_bzLabel setFont:[UIFont systemFontOfSize:14]];
        [_bzLabel setText:@"备注:"];
        _bzLabel.numberOfLines = 2;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, BOTTOM_Y(_bzLabel)+10, SCREEN_WIDTH-32, 1)];
        [self addSubview:line];
        line.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, BOTTOM_Y(line)+10, SCREEN_WIDTH-32, 40)];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_contentLabel];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
        [_contentLabel setFont:[UIFont systemFontOfSize:15]];
        [_contentLabel setText:@""];
        _contentLabel.numberOfLines = 2;
        
        
        
        
        
        
        
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
