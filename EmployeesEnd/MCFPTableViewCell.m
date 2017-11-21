//
//  MCFPTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/9.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCFPTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCFPTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
       
        
        
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 15, SCREEN_WIDTH-40, 20)];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dateLabel];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setTextColor:[UIColor colorWithRed:169 / 255.0 green:169 / 255.0 blue:169/ 255.0 alpha:1]];
        [_dateLabel setFont:[UIFont systemFontOfSize:13]];
        [_dateLabel setText:@"2007年2月11日 20:50"];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH-40, 20)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setText:@"集体奖金"];
        
       _LYlabel = [[UILabel alloc]initWithFrame:CGRectMake(100,42 , SCREEN_WIDTH-40, 20)];
        _LYlabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_LYlabel];
        [_LYlabel setBackgroundColor:[UIColor clearColor]];
        [_LYlabel setTextColor:[UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102/ 255.0 alpha:1]];
        [_LYlabel setFont:[UIFont systemFontOfSize:13]];
        _LYlabel.hidden = YES;
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 65, SCREEN_WIDTH-40, 40)];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_contentLabel];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setTextColor:[UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102/ 255.0 alpha:1]];
        [_contentLabel setFont:[UIFont systemFontOfSize:13]];
        [_contentLabel setText:@"订单[1112131313]获得饭票222"];
        _contentLabel.numberOfLines = 2;
        
        _contentLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(16, BOTTOM_Y(_contentLabel), SCREEN_WIDTH-40, 20)];
        _contentLabel2.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_contentLabel2];
        [_contentLabel2 setBackgroundColor:[UIColor clearColor]];
        [_contentLabel2 setTextColor:[UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102/ 255.0 alpha:1]];
        [_contentLabel2 setFont:[UIFont systemFontOfSize:13]];
        [_contentLabel2 setText:@"集团总部2017年3月奖金包"];
        
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-230, 30, 200, 20)];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_moneyLabel];
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextColor:[UIColor colorWithRed:233 / 255.0 green:176 / 255.0 blue:38/ 255.0 alpha:1]];
        [_moneyLabel setFont:[UIFont systemFontOfSize:18]];
        [_moneyLabel setText:@"+1150"];
        
        
        
        
        
        
        
        
        
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
