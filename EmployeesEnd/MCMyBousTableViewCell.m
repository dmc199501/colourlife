//
//  MCMyBousTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/9.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCMyBousTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCMyBousTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _bous = [[UILabel alloc]initWithFrame:CGRectMake(16, 15, 100, 20)];
        _bous.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_bous];
        [_bous setBackgroundColor:[UIColor clearColor]];
        [_bous setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
        [_bous setFont:[UIFont systemFontOfSize:15]];
        [_bous setText:@"奖金"];
        

        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 35, 300, 20)];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dateLabel];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
        [_dateLabel setFont:[UIFont systemFontOfSize:13]];
        [_dateLabel setText:@"2007年2月"];
        
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-230, 22, 200, 20)];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_moneyLabel];
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextColor:[UIColor colorWithRed:233 / 255.0 green:176 / 255.0 blue:38/ 255.0 alpha:1]];
        [_moneyLabel setFont:[UIFont systemFontOfSize:18]];
        [_moneyLabel setText:@"+1150"];
        
        UIImageView *next = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -20, 24.5, 10, 15)];
        [next setImage:[UIImage imageNamed:@"xiayibu"]];
        [self addSubview:next];

        
        
        
               
        
        
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
