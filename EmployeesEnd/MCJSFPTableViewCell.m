//
//  MCJSFPTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/12.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCJSFPTableViewCell.h"
#import "MCMicroServiceControl.h"
@implementation MCJSFPTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
               
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300, 20)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
        [_nameLabel setText:@"2007"];
        
        
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-340, 20, 300, 20)];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_moneyLabel];
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextColor:[UIColor colorWithRed:255 / 255.0 green:101 / 255.0 blue:76/ 255.0 alpha:1]];
        [_moneyLabel setFont:[UIFont systemFontOfSize:15]];
        [_moneyLabel setText:@"200"];
        
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 1)];
        line1.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        [self addSubview:line1];
        
        
        
        UIButton *DetailsButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 40)];
        [self addSubview:DetailsButton];
        [DetailsButton setTitleColor:BLUK_COLOR_ZAN_MC forState:UIControlStateNormal];
        DetailsButton.layer.cornerRadius = 4;
        [DetailsButton setTitle:@"兑换" forState:UIControlStateNormal];
        DetailsButton.layer.masksToBounds = YES;
        [DetailsButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        DetailsButton.backgroundColor =[UIColor clearColor];
        [DetailsButton addTarget:self action:@selector(detailss:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *DetailsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -30, 22.5, 10, 15)];
        [self addSubview:DetailsImageView];
        [DetailsImageView setImage:[UIImage imageNamed:@"xiayibu"]];
        
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 10)];
        back.backgroundColor = [UIColor colorWithWhite:242 / 255.0 alpha:1];
        [self addSubview:back];
        
        
        
    }
    return self;
}

- (void)detailss:(UIButton *)button{
    
    if ([_delegate respondsToSelector:@selector(MCJSFPTableViewCell:exchange:)])
    {
        [_delegate MCJSFPTableViewCell:self exchange:button];
    }
}

@end
