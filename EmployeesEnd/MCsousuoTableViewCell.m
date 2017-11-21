//
//  MCsousuoTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/2.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCsousuoTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCsousuoTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
        [self addSubview:self.iconImageView];
        [self.iconImageView setClipsToBounds:YES];
        [self.iconImageView.layer setCornerRadius:self.iconImageView.frame.size.width / 2];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, [[UIScreen mainScreen] bounds].size.width - 130, 20)];
        [self addSubview:self.titleLabel];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        self.jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, [[UIScreen mainScreen] bounds].size.width - 130, 20)];
        [self addSubview:self.jobLabel];
        [self.jobLabel setBackgroundColor:[UIColor clearColor]];
        [self.jobLabel setTextColor:GRAY_COLOR_ZZ];
        [self.jobLabel setFont:[UIFont systemFontOfSize:13]];
        
        
        self.arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake( SCREEN_WIDTH- 20,17.5, 10, 15)];
        [self addSubview:self.arrowImageView];
        [self.arrowImageView  setImage:[UIImage imageNamed:@"huise"]];
        
        
        
        
        
        
        
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
