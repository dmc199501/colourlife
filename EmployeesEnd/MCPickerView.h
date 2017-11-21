//
//  MCPickerView.h
//  CommunityThrough
//
//  Created by 邓梦超 on 16/7/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MCPickerViewDelegate;
@interface MCPickerView : UIView
{
    
    UIView *backgroundView;
    
    UILabel *lineImageView;
    
}
@property (nonatomic, assign)id <UIPickerViewDataSource, UIPickerViewDelegate, MCPickerViewDelegate>delegate;

@property(nonatomic, strong, readonly)UILabel *titleLabel;
@property(nonatomic, strong, readonly)UIButton *cancelButton;
@property(nonatomic, strong, readonly)UIButton *finishButton;
@property (nonatomic, strong)UIPickerView *choosePickerView;
@property (nonatomic, strong)UIView *headView;

- (void)showInView:(UIView *)view animation:(BOOL )animation;

- (void)dismissAnimation:(BOOL )animation;

@end


@protocol MCPickerViewDelegate <NSObject>

@optional
- (void)pickerView:(MCPickerView *)pickerView  finishFirstComponentRow:(NSInteger)row;//代理只返第一组，多的可以使用pickerView本身的去调用；
- (void)pickerView:(MCPickerView *)pickerView  cancelFirstComponentRow:(NSInteger)row;//代理只返第一组，多的可以使用pickerView本身的去调用；


@end
