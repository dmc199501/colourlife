//
//  MCHomeMapViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/6.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCHomeMapViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "PMMApAnnotation.h"
#import "CuAnnotationView.h"
@interface MCHomeMapViewController ()<MAMapViewDelegate,CuAnnotationDelegate>

@end

@implementation MCHomeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"战略地图";
    
    _mapViewBg = [[MapView alloc] init];
    [self.view addSubview:self.mapViewBg];
    
    
    
    // Do any additional setup after loading the view.
}
#pragma mark - 创建地图
- (void)initMapView{
    [self  configureAPIKey];
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, self.mapViewBg.frame.size.width, self.mapViewBg.frame.size.height)];
    _mapView.showsScale = NO;
    _mapView.showsCompass = NO;
    _mapView.delegate = self;
    
    _mapView.mapType = MAMapTypeStandard;
    _mapView.userInteractionEnabled = YES;
    [self.mapViewBg addSubview:_mapView];
    [self.mapViewBg sendSubviewToBack:_mapView];
    [self setVisibleMapRect];
    
}
//Guide key
- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
    [AMapSearchServices sharedServices].apiKey = (NSString *)APIKey;
}

//第一层地图显示区域
- (void)setVisibleMapRect{
    //116.452671,39.933144
    CLLocationCoordinate2D center  = CLLocationCoordinate2DMake(39.933144, 113.452671);
    [self.mapView setCenterCoordinate:center];
    MACoordinateBounds coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake
                                                                 (19.8458518, 71.18867188),CLLocationCoordinate2DMake(56.3487108, 137.08789063));
    MAGroundOverlay *groundOverlay = [MAGroundOverlay groundOverlayWithBounds:coordinateBounds icon:nil];
    _mapView.visibleMapRect = groundOverlay.boundingMapRect;
    
}

//地图相关
#pragma mark - 地图相关
#pragma mark -- 添加大头针
- (void)addAnnotationWithArray:(NSArray *)arr{
    
    NSMutableArray *pointArr = [NSMutableArray arrayWithCapacity:120];
    
    for (NSDictionary *loc in arr) {
        PMMApAnnotation *pointAnnotation = [[PMMApAnnotation alloc] init];
        
        double lat = [[loc valueForKey:@"lat"] doubleValue];
        double lon = [[loc valueForKey:@"lng"] doubleValue];
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(lat, lon);
        pointAnnotation.coordinate = coor;
        [pointArr addObject:pointAnnotation];
    }
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (self.mapView) {
            [self.mapView addAnnotations:pointArr];
        }
    });
}
#pragma mark -- 清除地图上的覆盖物
- (void)clearMapView
{
    //显示标注之前先把地图上个的标注清除
    NSMutableArray *annoArray = [NSMutableArray arrayWithArray:self.mapView.annotations];
    
    [self.mapView removeAnnotations:annoArray];
    
    [self.mapView removeOverlays:self.mapView.overlays];
}

#pragma mark -- show area detail
- (void)showAreaDetail{
    
    
}

-  (void)showAreaCount:(NSString *)count {
    
    //小区数
    if (!count) {
        self.mapViewBg.yingshouData.text = @"-";
    }else{
        self.mapViewBg.yingshouData.text = [NSString stringWithFormat:@"%@", count];
    }
}

#pragma mark - MAMapViewDelegate
//覆盖物加载回调
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    
    // is Line
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 4.f;
        polylineView.strokeColor = self.color;
        
        return polylineView;
    }
    //is image
    if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayView *groundOverlayView = [[MAGroundOverlayView alloc]
                                                   initWithGroundOverlay:overlay];
        
        return groundOverlayView;
    }
    //is polygon
    if([overlay isKindOfClass:[MAPolygon class]]){
        MAPolygonView *polygonView = [[MAPolygonView alloc]initWithPolygon:overlay];
        return polygonView;
    }
    
    return nil;
}
//定制大头针样式
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[PMMApAnnotation class]])
    {
        PMMApAnnotation *pointAnnotation = (PMMApAnnotation *)annotation;
        static NSString *customReuseIndetifier = @"cuReuseIndetifier";
        CuAnnotationView *annotationView = (CuAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier ];
        if (annotationView == nil)
        {
            
            //            annotationView = [[[CuAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier] autorelease];
            annotationView = [[CuAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier annotationType:pointAnnotation.type];
        }
        annotationView.delegate = self;
        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        //        annotationView.calloutOffset = CGPointMake(0, -5);//气泡弹出的位置
        UIImage *paopao=[UIImage imageNamed:@"map_dot"];
        annotationView.image = paopao;
        //        UIImage *strechImage =[paopao stretchableImageWithLeftCapWidth:5 topCapHeight:6];
        //        annotationView.portrait = strechImage;
        //        annotationView.tag = pointAnnotation.tag;
        //        annotationView.annotationType = pointAnnotation.type;
        //        PMArea *area = [self.areaArray objectAtIndex:pointAnnotation.tag];
        //        annotationView.name = area.name;
        //
        //        annotationView.name = [annotationView.name stringByAppendingFormat:@"(%@)",area.communityCount];
        //
        //        [annotationView setWidth:annotationView.name];
        return annotationView;
    }
    return nil;
    
    
}

#pragma mark -- customAnnotationDelegate

- (void)didSelectedEventWithCuAnnotationView:(CuAnnotationView *)annotationView
{
    return;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
