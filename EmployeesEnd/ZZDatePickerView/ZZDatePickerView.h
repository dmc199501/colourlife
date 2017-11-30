//
//  ZZPickerView.h
//  ZZUnproforRepairer
//
//  Created by wangshaosheng on 15/11/2.
//  Copyright © 2015年 cug. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZDatePickerViewDelegate;

@interface ZZDatePickerView : UIView
{
    
    UIView *backgroundView;
    
    UILabel *lineImageView;
    
}
@property (nonatomic, assign)id delegate;

@property(nonatomic, strong, readonly)UILabel *titleLabel;
@property(nonatomic, strong, readonly)UIButton *cancelButton;
@property(nonatomic, strong, readonly)UIButton *finishButton;
@property (nonatomic, strong)UIDatePicker *choosePickerView;
@property (nonatomic, strong)UIView *headView;

- (void)showInView:(UIView *)view animation:(BOOL )animation;

- (void)dismissAnimation:(BOOL )animation;

@end


@protocol ZZDatePickerViewDelegate <NSObject>

@optional
- (void)datePickerView:(ZZDatePickerView *)datePickerView  finishFirstComponentRow:(NSInteger)row;
- (void)datePickerView:(ZZDatePickerView *)datePickerView  cancelFirstComponentRow:(NSInteger)row;

@end