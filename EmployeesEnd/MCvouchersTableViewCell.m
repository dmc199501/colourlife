//
//  MCvouchersTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/23.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCvouchersTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCvouchersTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        backgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20,150)];
        [self addSubview:backgroundView];
        [backgroundView setBackgroundColor:[UIColor whiteColor]];
        [backgroundView.layer setBorderColor:GRAY_LIGHTS_COLOR_ZZ.CGColor];
        [backgroundView.layer setBorderWidth:1];
        [backgroundView.layer setCornerRadius:5];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 20)];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        
        
        _wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, self.frame.size.width- 100, 20)];
        [backgroundView addSubview:_wordLabel];
        _wordLabel.textAlignment = NSTextAlignmentLeft;
        [_wordLabel setBackgroundColor:[UIColor clearColor]];
        [_wordLabel setTextColor:[UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:1] ];
        [_wordLabel setFont:[UIFont systemFontOfSize:14]];
        [_wordLabel setText:@"煮粥的鸭子"];
        
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-150, 15, 100, 20)];
        [backgroundView addSubview:_stateLabel];
        _stateLabel.textAlignment = NSTextAlignmentRight;
        [_stateLabel setBackgroundColor:[UIColor clearColor]];
        [_stateLabel setTextColor:[UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:1] ];
        [_stateLabel setFont:[UIFont systemFontOfSize:14]];
        [_stateLabel setText:@"鸭子"];

        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH-20, 1)];
        line.backgroundColor = [UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:0.1];
        [backgroundView addSubview:line];
        
        
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH-100, 20)];
        [backgroundView addSubview:_priceLabel];
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        [_priceLabel setTextColor:[UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:1]];
        [_priceLabel setFont:[UIFont systemFontOfSize:13]];
        [_priceLabel setText:@"哈哈哈哈哈哈哈哈哈哈哈"];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, SCREEN_WIDTH-100, 20)];
        [backgroundView addSubview:_nameLabel];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:1]];
        [_nameLabel setFont:[UIFont systemFontOfSize:13]];
        [_nameLabel setText:@"哈哈哈哈哈哈哈哈哈哈哈"];
        
        _userLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-100, 20)];
        [backgroundView addSubview:_userLabel];
        [_userLabel setBackgroundColor:[UIColor clearColor]];
        [_userLabel setTextColor:[UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:1]];
        [_userLabel setFont:[UIFont systemFontOfSize:13]];
        [_userLabel setText:@"哈哈哈哈哈哈哈哈哈哈哈"];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, SCREEN_WIDTH-100, 20)];
        [backgroundView addSubview:_timeLabel];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setTextColor:[UIColor colorWithRed:92 / 255.0 green:98 / 255.0 blue:102 / 255.0 alpha:1]];
        [_timeLabel setFont:[UIFont systemFontOfSize:13]];
        [_timeLabel setText:@"哈哈哈哈哈哈哈哈哈哈哈"];
        
        
       

        
        
       
        
        
        
        
        
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
