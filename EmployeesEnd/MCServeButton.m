//
//  MCServeButton.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/9.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCServeButton.h"

@implementation MCServeButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - 20) / 2, 20, 20, 20)];
        [self addSubview:_iconImageView];
        
        _titleNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 16)];
        [self addSubview:_titleNameLabel];
        [_titleNameLabel setBackgroundColor:[UIColor clearColor]];
        [_titleNameLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleNameLabel setFont:[UIFont systemFontOfSize:12]];
        [_titleNameLabel setTextColor:[UIColor blackColor]];
        
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_iconImageView setFrame:CGRectMake((self.frame.size.width - 20) / 2, 20, 20, 20)];
    [_titleNameLabel setFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 16)];
    
}

@end
