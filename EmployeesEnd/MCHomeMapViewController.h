//
//  MCHomeMapViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/6.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
#import "MapView.h"
#import <MAMapKit/MAMapKit.h>
#import "APIKey.h"
@interface MCHomeMapViewController : MCRootViewControler
@property (nonatomic, retain) MAMapView *mapView;
@property (retain, nonatomic) MapView *mapViewBg;//地图背景

@property (nonatomic,retain) UIColor *color;

@end
