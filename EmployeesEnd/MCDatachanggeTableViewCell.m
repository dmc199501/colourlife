//
//  MCDatachanggeTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/7/12.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCDatachanggeTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCDatachanggeTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 20, 20)];
        [self addSubview:self.iconImageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, [[UIScreen mainScreen] bounds].size.width - 130, 20)];
        [self addSubview:self.titleLabel];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        self.arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake( SCREEN_WIDTH- 35,15, 20, 20)];
        [self addSubview:self.arrowImageView];
        [self.arrowImageView  setImage:[UIImage imageNamed:@"next-1"]];
        
        UIView *fgView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 15, 1, 20)];
        
        fgView.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        [self addSubview:fgView];
        _line2 = [[UIView alloc]initWithFrame:CGRectMake(10, 49, SCREEN_WIDTH-10, 1)];
        _line2.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        [self addSubview:_line2];
        
        
        _button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 50, 15, 120, 20)];
        
        [_button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_button setTitleColor:GRAY_COLOR_BACK_ZZ forState:UIControlStateNormal];
        [self addSubview:_button];
        [_button addTarget:self action:@selector(deleteMembers:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return self;
}
- (void)deleteMembers:(UIButton *) button{
    
    
    if ([_delegate respondsToSelector:@selector(MCDatachanggeTableViewCell:deleteMembers:)])
    {
        [_delegate MCDatachanggeTableViewCell:self deleteMembers:button];
    }
    
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
