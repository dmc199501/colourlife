//
//  MCButTheTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2018/1/10.
//  Copyright © 2018年 邓梦超. All rights reserved.
//

#import "MCButTheTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCButTheTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 10, 15)];
        [iconView setImage:[UIImage imageNamed:@"duigong"]];
        [self addSubview:iconView];

        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(33, 8, 60, 20)];
        label1.textAlignment = NSTextAlignmentLeft;
        //[self addSubview:label1];
        [label1 setBackgroundColor:[UIColor clearColor]];
        [label1 setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
        [label1 setFont:[UIFont systemFontOfSize:13]];
        [label1 setText:@"种类:"];
        [self addSubview:label1];
        
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 8, SCREEN_WIDTH-16, 20)];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_typeLabel];
        [_typeLabel setBackgroundColor:[UIColor clearColor]];
        [_typeLabel setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
        [_typeLabel setFont:[UIFont systemFontOfSize:13]];
        
        
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(16, 40, 60, 20)];
        label2.textAlignment = NSTextAlignmentLeft;
        //[self addSubview:label2];
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label2 setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
        [label2 setFont:[UIFont systemFontOfSize:13]];
        [label2 setText:@"账户名:"];
        [self addSubview:label2];
        
        _zhLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, SCREEN_WIDTH-16, 20)];
        _zhLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_zhLabel];
        [_zhLabel setBackgroundColor:[UIColor clearColor]];
        [_zhLabel setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
        [_zhLabel setFont:[UIFont systemFontOfSize:13]];
       
        
        
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(16, 70, 60, 20)];
        label3.textAlignment = NSTextAlignmentLeft;
        //[self addSubview:label2];
        [label3 setBackgroundColor:[UIColor clearColor]];
        [label3 setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
        [label3 setFont:[UIFont systemFontOfSize:13]];
        [label3 setText:@"卡号:"];
        [self addSubview:label3];
        
        
        _cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 70, 250, 20)];
        _cardLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_cardLabel];
        [_cardLabel setBackgroundColor:[UIColor clearColor]];
        [_cardLabel setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
        [_cardLabel setFont:[UIFont systemFontOfSize:13]];
        
        
        UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(_cardLabel)+10, SCREEN_WIDTH, 10)];
        backview.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242/ 255.0 alpha:1];
        [self addSubview:backview];
        
        UIImageView *next = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -20, 47.5, 10, 15)];
        [next setImage:[UIImage imageNamed:@"xiayibu"]];
        [self addSubview:next];

        
        
        
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
