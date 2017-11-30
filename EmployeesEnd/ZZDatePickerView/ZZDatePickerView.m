//
//  ZZPickerView.m
//  ZZUnproforRepairer
//
//  Created by wangshaosheng on 15/11/2.
//  Copyright © 2015年 cug. All rights reserved.
//

#import "ZZDatePickerView.h"

@implementation ZZDatePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1]];
        
        backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 230, self.frame.size.width, 230)];
        [self addSubview:backgroundView];
        
        
        self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        [backgroundView addSubview:self.headView];
        [self.headView setBackgroundColor:[UIColor whiteColor]];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, self.headView.frame.size.width - 70 - 75, self.headView.frame.size.height)];
        [self.headView addSubview:_titleLabel];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setText:@"选择"];
        
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 70, self.headView.frame.size.height)];
        [self.headView addSubview:_cancelButton];
        [_cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
        _finishButton = [[UIButton alloc]initWithFrame:CGRectMake(self.headView.frame.size.width - 70, 0, 70, self.headView.frame.size.height)];
        [self.headView addSubview:_finishButton];
        [_finishButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
        
        self.choosePickerView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, 180)];
        [self.choosePickerView setDatePickerMode:UIDatePickerModeDateAndTime];
        [backgroundView addSubview:self.choosePickerView];
        [self.choosePickerView setBackgroundColor:[UIColor whiteColor]];

        lineImageView = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, 0.5)];
        [backgroundView addSubview:lineImageView];
        [lineImageView setBackgroundColor:[UIColor grayColor]];
        
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    [backgroundView setFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)];
    
}

- (void)cancel:(UIButton *)senderButton
{
    if ([_delegate respondsToSelector:@selector(datePickerView:cancelFirstComponentRow:)])
    {
        [_delegate datePickerView:self cancelFirstComponentRow:0];
    }
}

- (void)finish:(UIButton *)senderButton
{
    if ([_delegate respondsToSelector:@selector(datePickerView:finishFirstComponentRow:)])
    {
        [_delegate datePickerView:self finishFirstComponentRow:0];
    }
}

- (void)showInView:(UIView *)view animation:(BOOL )animation;
{
    [view addSubview:self];
    [self setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    if (animation)
    {
        [backgroundView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 230)];
        [UIView animateWithDuration:0.3 animations:^{
            
            [backgroundView setFrame:CGRectMake(0, self.frame.size.height - 230, self.frame.size.width, 230)];
        }];
    }
    else
    {
        [backgroundView setFrame:CGRectMake(0, self.frame.size.height - 230, self.frame.size.width, 230)];

    }
    
}


- (void)dismissAnimation:(BOOL )animation;
{
    if (animation)
    {
        [backgroundView setFrame:CGRectMake(0, self.frame.size.height - 230, self.frame.size.width, 230)];

        [UIView animateWithDuration:0.3 animations:^{
            
            [backgroundView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 230)];

        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else
    {
        [backgroundView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 230)];
        [self removeFromSuperview];
    }
}

@end
