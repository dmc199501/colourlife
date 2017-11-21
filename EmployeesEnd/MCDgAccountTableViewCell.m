//
//  MCDgAccountTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/9/5.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCDgAccountTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
#import "UIImage+MCExtension.h"
@implementation MCDgAccountTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 60, 20)];
        label1.textAlignment = NSTextAlignmentLeft;
        //[self addSubview:label1];
        [label1 setBackgroundColor:[UIColor clearColor]];
        [label1 setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
        [label1 setFont:[UIFont systemFontOfSize:13]];
        [label1 setText:@"账户名:"];
        
        _accountName = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, SCREEN_WIDTH/2, 20)];
        _accountName.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_accountName];
        [_accountName setBackgroundColor:[UIColor clearColor]];
        [_accountName setTextColor:[UIColor colorWithRed:112 / 255.0 green:112 / 255.0 blue:112/ 255.0 alpha:1]];
        [_accountName setFont:[UIFont systemFontOfSize:13]];
        [_accountName setText:@"账户名:深圳大区事业部"];
        
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(16 +SCREEN_WIDTH/2, 10, 60, 20)];
        label2.textAlignment = NSTextAlignmentLeft;
        //[self addSubview:label2];
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label2 setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
        [label2 setFont:[UIFont systemFontOfSize:13]];
        [label2 setText:@"账户ID:"];
        
        _carNumber = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 10, SCREEN_WIDTH/2, 20)];
        _carNumber.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_carNumber];
        [_carNumber setBackgroundColor:[UIColor clearColor]];
        [_carNumber setTextColor:[UIColor colorWithRed:112 / 255.0 green:112 / 255.0 blue:112/ 255.0 alpha:1]];
        [_carNumber setFont:[UIFont systemFontOfSize:13]];
        [_carNumber setText:@"账户ID:13114324234242"];
        
        UIImageView * lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH- 32, 1)];
        lineView1.image = [UIImage imageWithLineWithImageView:lineView1];
        [self addSubview:lineView1];
        
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(16, BOTTOM_Y(lineView1)+15, 10, 15)];
        [iconView setImage:[UIImage imageNamed:@"duigong"]];
        [self addSubview:iconView];
        
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(31, BOTTOM_Y(lineView1)+15, 250, 15)];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_typeLabel];
        [_typeLabel setBackgroundColor:[UIColor clearColor]];
        [_typeLabel setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1]];
        [_typeLabel setFont:[UIFont systemFontOfSize:15]];
        [_typeLabel setText:@"积分饭票"];

        _mxButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, BOTTOM_Y(lineView1)+15, 100, 20)];
        [self addSubview:_mxButton];
        _mxButton.backgroundColor = [UIColor clearColor];
        [_mxButton setTitle:@"明细" forState:UIControlStateNormal];
        [_mxButton setTitleColor:[UIColor colorWithRed:112 / 255.0 green:112 / 255.0 blue:112/ 255.0 alpha:1] forState:UIControlStateNormal];
        [_mxButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        UIImageView *next = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -20, BOTTOM_Y(lineView1)+17.5, 10, 15)];
        [next setImage:[UIImage imageNamed:@"xiayibu"]];
        [self addSubview:next];
        
        
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(_typeLabel)+45, SCREEN_WIDTH, 30)];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_moneyLabel];
        [_moneyLabel setBackgroundColor:[UIColor clearColor]];
        [_moneyLabel setTextColor:[UIColor colorWithRed:255 / 255.0 green:101 / 255.0 blue:76/ 255.0 alpha:1]];
        [_moneyLabel setFont:[UIFont systemFontOfSize:30]];
        [_moneyLabel setText:@"90.23"];
        
        _sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(_moneyLabel)+5, SCREEN_WIDTH, 15)];
        _sourceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_sourceLabel];
        [_sourceLabel setBackgroundColor:[UIColor clearColor]];
        [_sourceLabel setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153/ 255.0 alpha:1]];
        [_sourceLabel setFont:[UIFont systemFontOfSize:12]];
        [_sourceLabel setText:@"来源:"];
        
        _mxButton = [[UIButton alloc]initWithFrame:CGRectMake(16, BOTTOM_Y(_sourceLabel)+30, SCREEN_WIDTH-32, 40)];
        [self addSubview:_mxButton];
        _mxButton.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204/ 255.0 alpha:1];
        [_mxButton setTitle:@"使用" forState:UIControlStateNormal];
        [_mxButton setTitleColor:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255/ 255.0 alpha:1] forState:UIControlStateNormal];
         [_mxButton.layer setCornerRadius:4];
        [_mxButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        

        UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(_mxButton)+17, SCREEN_WIDTH, 10)];
        backview.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242/ 255.0 alpha:1];
        [self addSubview:backview];
        
        
        
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
