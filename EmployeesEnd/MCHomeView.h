//
//  MCHomeView.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/12/22.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MCGoWebViewDelegate <NSObject>

- (void)pushToWebView;

@end


@interface MCHomeView : UIView
@property (nonatomic, assign)id <MCGoWebViewDelegate>delegate;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *content;
@property (nonatomic,strong) UILabel *data;

- (void)showInView:(UIView *)view;
@end
