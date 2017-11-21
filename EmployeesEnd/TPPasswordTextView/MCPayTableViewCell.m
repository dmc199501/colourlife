//
//  MCPayTableViewCell.m
//  CommunityThrough
//
//  Created by 邓梦超 on 17/4/17.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCPayTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCPayTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(0, 110, self.frame.size.width, 1)];
        [self addSubview:_line];
        _line.backgroundColor = [UIColor colorWithWhite:242 / 255.0 alpha:1];
        
        _stateV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32, 19, 12, 12)];
        [_stateV setImage:[UIImage imageNamed:@"Unchecked"]];
        [self addSubview:_stateV];
        
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 14, 22, 22)];
       
        [self addSubview:_icon];
        
        
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, self.frame.size.width, 20)];
        [self addSubview:_addressLabel];
        [_addressLabel setBackgroundColor:[UIColor clearColor]];
        [_addressLabel setTextColor:[UIColor blackColor]];
        [_addressLabel setFont:[UIFont systemFontOfSize:15]];
        [_addressLabel setText:@"广东省 深圳市 龙岗区"];
        [_addressLabel setNumberOfLines:2];
        [_addressLabel setTextAlignment:NSTextAlignmentCenter];
        
        _available = [[UILabel alloc]initWithFrame:CGRectMake(50, 35, self.frame.size.width, 20)];
        [self addSubview:_available];
        [_available setBackgroundColor:[UIColor clearColor]];
        [_available setTextColor:[UIColor grayColor]];
        [_available setFont:[UIFont systemFontOfSize:14]];
        [_available setText:@""];
        [_available setNumberOfLines:1];
        [_available setTextAlignment:NSTextAlignmentLeft];
        

        
        _houseLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, self.frame.size.width, 20)];
        [self addSubview:_houseLabel];
        [_houseLabel setBackgroundColor:[UIColor clearColor]];
        [_houseLabel setTextColor:[UIColor grayColor]];
        [_houseLabel setFont:[UIFont systemFontOfSize:13]];
        [_houseLabel setText:@"金银园一栋一单元101房"];
        [_houseLabel setNumberOfLines:2];
        [_houseLabel setTextAlignment:NSTextAlignmentCenter];
        
      _hidenView   = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _hidenView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:0.5];
        [self addSubview:_hidenView];
        
    }
    return self;
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [_stateV setImage:[UIImage imageNamed:@"Selected"]];
        
    }
    
    // Configure the view for the selected state
}




@end
