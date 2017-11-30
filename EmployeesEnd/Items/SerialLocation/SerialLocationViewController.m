//
//  SerialLocationViewController.m
//  officialDemoLoc
//
//  Created by 刘博 on 15/9/21.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import "SerialLocationViewController.h"

@interface SerialLocationViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate>

@property (nonatomic, strong) UISegmentedControl *showSegment;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;

@end

@implementation SerialLocationViewController

#pragma mark - Action Handle

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];

    [self.locationManager setDelegate:self];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置允许连续定位逆地理
    [self.locationManager setLocatingWithReGeocode:YES];
}

- (void)showsSegmentAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex)
    {
        //停止定位
        [self.locationManager stopUpdatingLocation];
        
        //移除地图上的annotation
        [self.mapView removeAnnotations:self.mapView.annotations];
        self.pointAnnotaiton = nil;
    }
    else
    {
        //开始进行连续定位
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f; reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);
    NSString *province = [NSString stringWithFormat:@"%@",reGeocode.province];
    NSString *district = [NSString stringWithFormat:@"%@",reGeocode.district];
    NSString *city = [NSString stringWithFormat:@"%@",reGeocode.city];
    NSDictionary *dic = @{@"message":@"coordinate",@"content":@{@"province":province,@"longitude":@(location.coordinate.longitude),@"latitude":@(location.coordinate.latitude),@"district":district,@"city":city},@"code":@"0"};
    [self convertToJsonData:dic];
    

   
    

    //获取到定位信息，更新annotation
    if (self.pointAnnotaiton == nil)
    {
        self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
        [self.pointAnnotaiton setCoordinate:location.coordinate];
        
        [self.mapView addAnnotation:self.pointAnnotaiton];
    }
    
    [self.pointAnnotaiton setCoordinate:location.coordinate];
    
    [self.mapView setCenterCoordinate:location.coordinate];
    [self.mapView setZoomLevel:15.1 animated:NO];
}

#pragma mark - Initialization

-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    NSLog(@"%@",mutStr);
    return mutStr;
    
}
- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        [self.mapView setDelegate:self];
        
        [self.view addSubview:self.mapView];
    }
}

- (void)initToolBar
{
    UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil];
    
    self.showSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Start", @"Stop", nil]];
    [self.showSegment addTarget:self action:@selector(showsSegmentAction:) forControlEvents:UIControlEventValueChanged];
    self.showSegment.selectedSegmentIndex = 0;
    UIBarButtonItem *showItem = [[UIBarButtonItem alloc] initWithCustomView:self.showSegment];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexble, showItem, flexble, nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initToolBar];
    
   // [self initMapView];
    
    [self configLocationManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.translucent   = YES;
    self.navigationController.toolbarHidden         = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = NO;
        annotationView.animatesDrop     = NO;
        annotationView.draggable        = NO;
        annotationView.image            = [UIImage imageNamed:@"icon_location.png"];
        
        return annotationView;
    }
    
    return nil;
}

@end
