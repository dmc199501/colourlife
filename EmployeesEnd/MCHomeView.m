//
//  MCHomeView.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/12/22.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCHomeView.h"
#import "MCMacroDefinitionHeader.h"
@implementation MCHomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, 150, 20)];
        _title.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_title];
        [_title setBackgroundColor:[UIColor clearColor]];
        [_title setTextColor:[UIColor blackColor]];
        [_title setFont:[UIFont systemFontOfSize:17]];
        
        
        _content = [[UILabel alloc]initWithFrame:CGRectMake(50, 55, self.frame.size.width -70, 20)];
        _content.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_content];
        [_content setBackgroundColor:[UIColor clearColor]];
        [_content setTextColor:GRAY_COLOR_ZZ];
        [_content setFont:[UIFont systemFontOfSize:14]];
        
        
        _data = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-170, 30, 150, 20)];
        _data.textAlignment = NSTextAlignmentRight;
        [self addSubview:_data];
        [_data setBackgroundColor:[UIColor clearColor]];
        [_data setTextColor:GRAY_COLOR_ZZ];
        [_data setFont:[UIFont systemFontOfSize:14]];
        
        
        
        UIView *lien = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(_content)+20, self.frame.size.width, 1)];
        [self  addSubview:lien];
        lien.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        
        
        UIButton *leaveButton = [[UIButton alloc]initWithFrame:CGRectMake((self.frame.size.width-100)/2, BOTTOM_Y(lien)+25, 100, 40)];
        [leaveButton setBackgroundColor:BLUK_COLOR_ZAN_MC];
        
        [leaveButton setTitle:@"查看详情" forState:UIControlStateNormal];
        [leaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        leaveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [leaveButton addTarget:self action:@selector(leave:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leaveButton];
        [leaveButton.layer setCornerRadius:20];

        
    }
    
    return self;
}

- (void)leave:(UIButton *)button{
    //[self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(pushToWebView)] ){
        [self.delegate pushToWebView];
    }
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
