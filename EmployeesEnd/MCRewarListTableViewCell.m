//
//  MCRewarListTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/8.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRewarListTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCRewarListTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
               
        UIImageView *dateIcon = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12.5, 24, 25)];
        [self addSubview:dateIcon];
        [dateIcon setImage:[UIImage imageNamed:@"data"]];
        
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 300, 20)];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dateLabel];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setTextColor:[UIColor colorWithRed:77 / 255.0 green:169 / 255.0 blue:234/ 255.0 alpha:1]];
        [_dateLabel setFont:[UIFont systemFontOfSize:18]];
        [_dateLabel setText:@"2007"];
        
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
        line1.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        [self addSubview:line1];
        
        UILabel *districtUnit = [[UILabel alloc]initWithFrame:CGRectMake(20, 65, SCREEN_WIDTH/3, 20)];
        districtUnit.text = @"基础奖金包";
        districtUnit.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1];
        districtUnit.backgroundColor = [UIColor clearColor];
        districtUnit.textAlignment = NSTextAlignmentLeft;
        [districtUnit setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:districtUnit];
        
        _basisLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 85, SCREEN_WIDTH/3, 20)];
        
        _basisLabel.textColor = [UIColor colorWithRed:138 / 255.0 green:138 / 255.0 blue:138/ 255.0 alpha:1];
        _basisLabel.backgroundColor = [UIColor clearColor];
        _basisLabel.textAlignment = NSTextAlignmentLeft;
        [_basisLabel setFont:[UIFont systemFontOfSize:12]];
        _basisLabel.text = @"000";
        [self addSubview:_basisLabel];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(20, 115, SCREEN_WIDTH-40, 1)];
        line2.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        [self addSubview:line2];
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 58, 1, 50)];
        line3.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        [self addSubview:line3];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20+SCREEN_WIDTH/2, 65, SCREEN_WIDTH/3, 20)];
        label.text = @"超预算奖金";
        label.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        [label setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:label];
        
        _budgetLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+SCREEN_WIDTH/2, 85, SCREEN_WIDTH/3, 20)];
        
        _budgetLabel.textColor = [UIColor colorWithRed:138 / 255.0 green:138 / 255.0 blue:138/ 255.0 alpha:1];
        _budgetLabel.backgroundColor = [UIColor clearColor];
        _budgetLabel.textAlignment = NSTextAlignmentLeft;
        [_budgetLabel setFont:[UIFont systemFontOfSize:12]];
        _budgetLabel.text = @"";
        [self addSubview:_budgetLabel];
        
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 130, SCREEN_WIDTH/3, 20)];
        label2.text = @"奖励总额";
        label2.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1];
        label2.backgroundColor = [UIColor clearColor];
        label2.textAlignment = NSTextAlignmentLeft;
        [label2 setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:label2];
        
        _rewardLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, SCREEN_WIDTH/3, 20)];
        
        _rewardLabel.textColor = [UIColor colorWithRed:138 / 255.0 green:138 / 255.0 blue:138/ 255.0 alpha:1];
        _rewardLabel.backgroundColor = [UIColor clearColor];
        _rewardLabel.textAlignment = NSTextAlignmentLeft;
        [_rewardLabel setFont:[UIFont systemFontOfSize:12]];
        _rewardLabel.text = @"";
        [self addSubview:_rewardLabel];
        
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20+SCREEN_WIDTH/2, 130, SCREEN_WIDTH/3, 20)];
        label3.text = @"扣款总额";
        label3.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1];
        label3.backgroundColor = [UIColor clearColor];
        label3.textAlignment = NSTextAlignmentLeft;
        [label3 setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:label3];
        
                
        UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 123, 1, 50)];
        line4.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        [self addSubview:line4];
        
        UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 181, SCREEN_WIDTH, 1)];
        line5.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        [self addSubview:line5];
        
        
        UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(20, 196, SCREEN_WIDTH/3, 20)];
        label4.text = @"总奖金包";
        label4.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51/ 255.0 alpha:1];
        label4.backgroundColor = [UIColor clearColor];
        label4.textAlignment = NSTextAlignmentLeft;
        [label4 setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:label4];
        
        _totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-212.5, 196, 200, 20)];
        
        _totalLabel.textColor = [UIColor colorWithRed:244 / 255.0 green:52 / 255.0 blue:61/ 255.0 alpha:1];
        _totalLabel.backgroundColor = [UIColor clearColor];
        _totalLabel.textAlignment = NSTextAlignmentRight;
        [_totalLabel setFont:[UIFont systemFontOfSize:18]];
        _totalLabel.text = @"";
        [self addSubview:_totalLabel];
        
        UIView *garView = [[UIView alloc]initWithFrame:CGRectMake(0, 231, SCREEN_WIDTH, 10)];
        garView.backgroundColor = [UIColor colorWithWhite:242 / 255.0 alpha:1];
        [self addSubview:garView];



        UIButton *DetailsButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100, 50)];
        [self addSubview:DetailsButton];
        [DetailsButton setTitleColor:[UIColor colorWithRed:167 / 255.0 green:167 / 255.0 blue:167/ 255.0 alpha:1] forState:UIControlStateNormal];
        DetailsButton.layer.cornerRadius = 4;
        [DetailsButton setTitle:@"详情" forState:UIControlStateNormal];
        DetailsButton.layer.masksToBounds = YES;
        [DetailsButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        DetailsButton.backgroundColor =[UIColor clearColor];
        [DetailsButton addTarget:self action:@selector(detailss:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *DetailsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -30, 17.5, 10, 15)];
        [self addSubview:DetailsImageView];
        [DetailsImageView setImage:[UIImage imageNamed:@"xiayibu"]];

        
        
        
    }
    return self;
}

- (void)detailss:(UIButton *)button{
    
    if ([_delegate respondsToSelector:@selector(MCRewarListTableViewCell:details:)])
    {
        [_delegate MCRewarListTableViewCell:self details:button];
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
