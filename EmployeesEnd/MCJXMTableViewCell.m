//
//  MCJXMTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/8.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCJXMTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCJXMTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(18, 15, 8, 8)];
        [self addSubview:icon];
        [icon setImage:[UIImage imageNamed:@"yuandian"]];
        
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16+16+12, 10, SCREEN_WIDTH-80, 20)];
        
        _titleLabel.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        _titleLabel.text = @"彩生活研究院上级领导绩效评分";
        [self addSubview:_titleLabel];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16+16+12, 30, SCREEN_WIDTH-80, 20)];
        
        label.textColor = [UIColor colorWithRed:134 / 255.0 green:135 / 255.0 blue:134/ 255.0 alpha:1];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        [label setFont:[UIFont systemFontOfSize:12]];
        label.text = @"金额:";
        [self addSubview:label];
        
        
        _moenyLabel = [[UILabel alloc]initWithFrame:CGRectMake(16+16+50, 30, SCREEN_WIDTH-80, 20)];
        
        _moenyLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:95 / 255.0 blue:57/ 255.0 alpha:1];
        _moenyLabel.backgroundColor = [UIColor clearColor];
        _moenyLabel.textAlignment = NSTextAlignmentLeft;
        [_moenyLabel setFont:[UIFont systemFontOfSize:15]];
        _moenyLabel.text = @"800";
        [self addSubview:_moenyLabel];
        
        _label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -150, 30, 100, 20)];
        _label2.textColor = [UIColor colorWithRed:134 / 255.0 green:135 / 255.0 blue:134/ 255.0 alpha:1];
        _label2.backgroundColor = [UIColor clearColor];
        _label2.textAlignment = NSTextAlignmentRight;
        [_label2 setFont:[UIFont systemFontOfSize:12]];
        _label2.text = @"评分:";
        [self addSubview:_label2];
        
        
        _pinfenLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, 30, 100, 20)];
        
        _pinfenLabel.textColor = [UIColor colorWithRed:75 / 255.0 green:74 / 255.0 blue:74/ 255.0 alpha:1];
        _pinfenLabel.backgroundColor = [UIColor clearColor];
        _pinfenLabel.textAlignment = NSTextAlignmentRight;
        [_pinfenLabel setFont:[UIFont systemFontOfSize:15]];
        _pinfenLabel.text = @"85";
        [self addSubview:_pinfenLabel];
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-220, 30, 200, 20)];
        
        _dateLabel.textColor = [UIColor colorWithRed:134 / 255.0 green:134 / 255.0 blue:134/ 255.0 alpha:1];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [_dateLabel setFont:[UIFont systemFontOfSize:12]];
        
        [self addSubview:_dateLabel];

                
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
