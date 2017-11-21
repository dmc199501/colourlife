//
//  MapView.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/6.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapView : UIView
@property (nonatomic, retain) UIView *titleBgView;
@property (nonatomic, retain) UIImageView *mapIcon;
@property (nonatomic, retain) UILabel *mapLabel;

@property (nonatomic, retain) UIView *numberBgView;
@property (nonatomic, retain) UILabel *wuguanLabel;
@property (nonatomic, retain) UILabel *yingshouLabel;
@property (nonatomic, retain) UILabel *shishouLabel;
@property (nonatomic, retain) UILabel *shoujiaolvLabel;

@property (nonatomic, retain) UILabel *wuguanData;
@property (nonatomic, retain) UILabel *yingshouData;
@property (nonatomic, retain) UILabel *shishouData;
@property (nonatomic, retain) UILabel *shoujiaolvData;
@end
