//
//  MCPickerView.m
//  CommunityThrough
//
//  Created by 邓梦超 on 16/7/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCPickerView.h"

@implementation MCPickerView
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
        
        self.choosePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, 180)];
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

- (void)setDelegate:(id<UIPickerViewDataSource,UIPickerViewDelegate,MCPickerViewDelegate>)delegate
{
    _delegate = delegate;
    [self.choosePickerView setDataSource:_delegate];
    [self.choosePickerView setDelegate:_delegate];
}

- (void)cancel:(UIButton *)senderButton
{
    if ([self.delegate respondsToSelector:@selector(pickerView:cancelFirstComponentRow:)])
    {
        ([self.delegate pickerView:self cancelFirstComponentRow:[self.choosePickerView selectedRowInComponent:0]]);
    }
}

- (void)finish:(UIButton *)senderButton
{
    if ([self.delegate respondsToSelector:@selector(pickerView:finishFirstComponentRow:)])
    {
        ([self.delegate pickerView:self finishFirstComponentRow:[self.choosePickerView selectedRowInComponent:0]]);
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
