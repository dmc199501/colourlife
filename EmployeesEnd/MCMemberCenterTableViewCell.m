//
//  MCMemberCenterTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/12/15.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCMemberCenterTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCMemberCenterTableViewCell
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
        
        self.arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake( SCREEN_WIDTH- 30,17.5, 10, 15)];
        [self addSubview:self.arrowImageView];
        [self.arrowImageView  setImage:[UIImage imageNamed:@"huise"]];
        
       
        _line2 = [[UIView alloc]initWithFrame:CGRectMake(10, 49, SCREEN_WIDTH-10, 1)];
        _line2.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        [self addSubview:_line2];
        
        
        
        
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
