//
//  MCOAChooseTableViewCell.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/9.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCOAChooseTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCOAChooseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
       
        
        _stateV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 20, 20, 20)];
        [_stateV setImage:[UIImage imageNamed:@"Unchecked"]];
        [self addSubview:_stateV];
        
       
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.frame.size.width, 20)];
        [self addSubview:_name];
        [_name setBackgroundColor:[UIColor clearColor]];
        [_name setTextColor:[UIColor grayColor]];
        [_name setFont:[UIFont systemFontOfSize:15]];
        [_name setText:@""];
        [_name setTextAlignment:NSTextAlignmentLeft];
        
        _OAlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, self.frame.size.width, 20)];
        [self addSubview:_OAlabel];
        [_OAlabel setBackgroundColor:[UIColor clearColor]];
        [_OAlabel setTextColor:[UIColor grayColor]];
        [_OAlabel setFont:[UIFont systemFontOfSize:15]];
        [_OAlabel setText:@""];
        [_OAlabel setTextAlignment:NSTextAlignmentLeft];
        

        
        
        
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
