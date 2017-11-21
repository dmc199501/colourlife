//
//  MCTransferMoneyTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/9.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCTransferMoneyTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCTransferMoneyTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 20, 40, 40)];
        [self addSubview:self.iconImageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(72, 20, [[UIScreen mainScreen] bounds].size.width - 130, 20)];
        [self addSubview:self.titleLabel];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(72, 40, [[UIScreen mainScreen] bounds].size.width - 92, 20)];
        [self addSubview:self.contentLabel];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentLabel setTextColor:[UIColor colorWithRed:138 / 255.0 green:138 / 255.0 blue:138/ 255.0 alpha:1]];
        [self.contentLabel setFont:[UIFont systemFontOfSize:12]];
        self.contentLabel.numberOfLines = 0;
        
        
        
    }
    
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect contentFrame = self.contentLabel.frame;
    CGSize contentLabelSize = ZZ_MULTILINE_TEXTSIZE(self.contentLabel.text, self.contentLabel.font, CGSizeMake(self.contentLabel.frame.size.width, 999), self.contentLabel.lineBreakMode);
    
    contentFrame.size.height = contentLabelSize.height;
    [self.contentLabel setFrame:contentFrame];

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
