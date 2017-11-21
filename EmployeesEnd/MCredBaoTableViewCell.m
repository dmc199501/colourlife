//
//  MCredBaoTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/9.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCredBaoTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCredBaoTableViewCell
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
        _titleLabel.text = @"研究院奖励金";
        [self addSubview:_titleLabel];
        
        _moenyLabel = [[UILabel alloc]initWithFrame:CGRectMake(16+16+12, 30, SCREEN_WIDTH-80, 20)];
        
        _moenyLabel.textColor = [UIColor colorWithRed:134 / 255.0 green:135 / 255.0 blue:134/ 255.0 alpha:1];
        _moenyLabel.backgroundColor = [UIColor clearColor];
        _moenyLabel.textAlignment = NSTextAlignmentLeft;
        [_moenyLabel setFont:[UIFont systemFontOfSize:12]];
        _moenyLabel.text = @"OA:cool";
        [self addSubview:_moenyLabel];
        
        
                
        
        
        
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
