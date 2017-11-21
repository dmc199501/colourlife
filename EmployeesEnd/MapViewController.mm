//
//  MapViewController.m
//  WeiTown
//
//  Created by kakatool on 15-3-23.
//  Copyright (c) 2015年 Hairon. All rights reserved.
//
#define GT_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8

#import "MapViewController.h"
#import "APIKey.h"
#import "NSString+COLStringSize.h"
#import "UIView+Helper.h"
#import "PMMapDataAPI.h"
#import "ISNull.h"

#define MainScreenSize [UIScreen mainScreen].bounds.size
@interface MapViewController ()<MAMapViewDelegate>
@property (nonatomic,retain) NSArray *provinceArray;
@property (nonatomic,retain) NSArray *colorArray;
@property (nonatomic,retain) UIColor *color;

@property (nonatomic,assign) NSInteger annotationType;

@property (nonatomic,retain) NSMutableArray *areaArray;
@property (nonatomic,retain) NSString *bouchID;
@property (nonatomic,retain) NSString *communityCountID;
@property (nonatomic,retain) NSMutableArray *bouchIDArray;
@property (nonatomic,assign) NSInteger level;
//@property (nonatomic,retain) PMAreaDetail *areaDetail;
@property (nonatomic,assign) BOOL isArea;
@property (nonatomic, assign) BOOL isJobV2;
@end

@implementation MapViewController

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    
   
    
    self.delegate=nil;
    [_titleImage release];
    [_titleLabel release];
    [_areaLabel release];
    [_ratioLabel release];
    [_satisfactionLabel release];
//    if (_mapView) {
//        _mapView.delegate = nil;
//        [_mapView release];
//    }
    [_areaArray release];
    [_bouchIDArray release];
    [_receivable release];
    [_paidIn release];
    [_amountBtn release];
    [_complaintBtn release];
    [_depotBtn release];
    [_amountLabel release];
    [_complaintLabel release];
    [_depotLabel release];
    [_lastBtn release];
    [_retArrow release];
    [_label1 release];
    [_label2 release];
    [_label3 release];
    [_label4 release];
    [_label5 release];
    [_bouchID release];
    [_label6 release];
    [_labelContent release];
    [_sixthRowBg release];
    [_kpiBgView release];
    [_titleScrollLable release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleText:@"全国大区分布"];
    
    //加载Kpi数据显示区域，并保存长宽
    self.origFiveLineBgRect = self.fiveLineBg.frame;
  self.origThreeLineBgRect = self.threeLineBg.frame;
    self.origLabel1Rect = self.label1.frame;
    self.origLabel2Rect = self.label2.frame;
    self.origLabel3Rect = self.label3.frame;
    self.origLabel4Rect = self.label4.frame;
    self.origLabel5Rect = self.label5.frame;
    self.origLabel6Rect = self.label6.frame;
    
    self.origLabel1ValueRect = self.areaLabel.frame;
    self.origLabel2ValueRect = self.receivable.frame;
    self.origLabel3ValueRect = self.paidIn.frame;
    self.origLabel4ValueRect = self.ratioLabel.frame;
    self.origLabel5ValueRect = self.satisfactionLabel.frame;
    self.origLabel6NewValueRect = self.labelContent.frame;
    
    self.origLabel6ValueRect = self.amountLabel.frame;
    self.origLabel7ValueRect = self.complaintLabel.frame;
    self.origLabel8ValueRect = self.depotLabel.frame;
    
    
    self.label1.text = @"上线面积:";
    self.label2.text = @"车位数量:";
    self.label3.text = @"应       收:";
    self.label4.text = @"实       收:";
    self.label5.text = @"收  缴  率:";
    self.label6.text = @"满  意  度:";
    
    
//    self.kpiBg = [[UIView alloc] initWithFrame:CGRectMake(0, 52, HEIGHT/3, WIDTH - 52)];
//    self.kpiBg.backgroundColor = UIColorFromRGBA(0x4C4C4C, 0.9);
//    [self.view addSubview:self.kpiBg];
//    [self.kpiBg release];

    
    //旋转
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    
    if(GT_IOS8){
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIDeviceOrientationLandscapeRight]
                                    forKey:@"orientation"];
    }
    
    
    //配置导航条宽度
    CGFloat frameWidth =[UIScreen mainScreen].bounds.size.width;
    if ([UIScreen mainScreen].bounds.size.height>[UIScreen mainScreen].bounds.size.width) {
        frameWidth =[UIScreen mainScreen].bounds.size.height;
    }
    self.titleImage.frameSizeWidth = frameWidth;
    self.titleImage.backgroundColor = [UIColor yellowColor];
    
    //数据
//    self.bouchID = MAP_ORIG_82;
//    self.communityCountID = MAP_ORIG_2;
    self.annotationType = 0;
    self.level = 1;
    self.lastBtn.hidden = YES;
    self.retArrow.hidden = YES;
    _areaArray = [[NSMutableArray alloc]init];
    _bouchIDArray = [[NSMutableArray alloc]init];
    
      [self initMapView];
//    
//    [self getJobV2];
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        //        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        CLLocationCoordinate2D center  = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        [_mapView setCenterCoordinate:center];
        
        
        [self.mapView setRegion:(MACoordinateRegion){center, {0.07, 0.07}} animated:YES];
        //调用获取附近小区
        //[self getPoiCommunityLocation:userLocation];
        
    }
}

- (void)setTitleText:(NSString *)text {
    CGSize size = [text sizeByOneLineWithFont:self.titleLabel.font textLabelFrame:self.titleLabel.frame];
    self.titleLabel.frame = CGRectMake(0, 0, size.width, size.height);
    self.titleLabel.text = text;
    self.titleScrollLable.contentSize = self.titleLabel.frame.size;
    if (self.titleScrollLable.contentSize.width <= self.titleScrollLable.frameSize.width) {
        self.titleLabel.center = CGPointMake(self.titleScrollLable.frameSize.width/2, self.titleScrollLable.frameSize.height/2);
    }
}

- (void)getJobV2 {
//    typeof(self) __block weakSelf = self;
//    [PMMapDataAPI getInitMapDataBlockSuc:^(NSURL *url, id result) {
//        if (weakSelf) {
//            
//            [weakSelf retain];
//           
//            if (![ISNull  isNilOfSender:result]&&[[result objectForKey:@"code"] intValue]==0) {
//                
//                NSArray *array = (NSArray *)[result objectForKey:@"content"];
//                
//                //若果有数据则走新岗位分支
//                if (array && [array count] == 1) {
//                    NSInteger allCommunityCount = 0;
//                    
//                    [weakSelf.areaArray removeAllObjects];
//                    
//                    for(NSInteger i = 0 ;i < array.count;i++){
//                        NSDictionary *dic = [array objectAtIndex:i];
//                        PMArea *area = [PMArea getPMAreaWithDic:dic];
//                        [weakSelf.areaArray addObject:area];
//                        
//                        allCommunityCount += [area.communityCount integerValue];
//                    }
//                    
//                    if (weakSelf.level != 1) {
//                        
////                        weakSelf.depotLabel.text = [NSString stringWithFormat:@"%ld", (long)allCommunityCount];
//                    }
//                    
//                    if(weakSelf.level == 1){
//                        //区域
//                        [weakSelf addAnnotationWithType:0];
//                        
//                    }
//                    if (weakSelf.level == 2) {
//                        //事业部
//                        [weakSelf addAnnotationWithType:1];
//                    }
//                    if (weakSelf.level== 3) {
//                        //片区
//                        [weakSelf addAnnotationWithType:2];
//                    }
//                    if (weakSelf.level == 4) {
//                        //小区
//                        [weakSelf addAnnotationWithType:3];
//                    }
//                    
//                    self.bouchID = array[0][@"uuid"];
//                    self.isJobV2 = YES;
//                    self.communityCountID = self.bouchID;
//                    
//                } else {
//                    //没有数据则调用原有流程
//                    [self loadData];
//                }
//                
//                //原流程
//                [self loadAreaDetailData];
////                [self loadCommunityCount];
//                
//            }else{
//                [weakSelf changeMapZoomLevel:YES];
//            }
//            
//            [weakSelf release];
//            
//        }
//    } BlockFailed:^(NSURL *url, NSError *error) {
//        
//    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.barView.frameSizeWidth = self.titleImage.frameSizeWidth;
    self.mapView.delegate = self;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    self.barView.frameSizeWidth = 320;
    self.mapView.delegate = nil;
    
}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//
//- (void)dealloc {
//    
//    DLog(@"MapViewController已经释放");
//    
//    self.delegate=nil;
//    [_titleImage release];
//    [_titleLabel release];
//    [_areaLabel release];
//    [_ratioLabel release];
//    [_satisfactionLabel release];
//    if (_mapView) {
//        _mapView.delegate = nil;
//        [_mapView release];
//    }
//    [_areaArray release];
//    [_bouchIDArray release];
//    [_receivable release];
//    [_paidIn release];
//    [_amountBtn release];
//    [_complaintBtn release];
//    [_depotBtn release];
//    [_amountLabel release];
//    [_complaintLabel release];
//    [_depotLabel release];
//    [_lastBtn release];
//    [_retArrow release];
//    [_label1 release];
//    [_label2 release];
//    [_label3 release];
//    [_label4 release];
//    [_label5 release];
//    [_bouchID release];
//    [_label6 release];
//    [_labelContent release];
//    [_sixthRowBg release];
//    [_kpiBgView release];
//    [_titleScrollLable release];
//    [super dealloc];
//}
//
//
//#pragma mark -横屏设置
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeRight;
//}
//
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeRight;
//}
//
//
//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
//
//
//
#pragma mark -- Guide key
- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}


#pragma mark - 创建地图
- (void)initMapView{
    [self  configureAPIKey];
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, self.titleImage.frameOriginY+self.titleImage.frameSizeHeight, self.view.frameSizeWidth, self.view.frameSizeHeight-self.titleImage.frameOriginY-self.titleImage.frameSizeHeight)];
    _mapView.showsScale = NO;
    _mapView.showsCompass = NO;
    
    _mapView.delegate = self;
    _mapView.mapType = MAMapTypeStandard;
    _mapView.userInteractionEnabled = YES;
    
    _mapView.headingFilter = 360;
    _mapView.distanceFilter = 500;
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];
    [self setVisibleMapRect];
    
}

#pragma mark - Helpers
#pragma mark -- 第一层地图显示区域
- (void)setVisibleMapRect{
    //116.452671,39.933144
    CLLocationCoordinate2D center  = CLLocationCoordinate2DMake(39.933144, 113.452671);
    [self.mapView setCenterCoordinate:center];
    MACoordinateBounds coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake
                                                                 (19.8458518, 71.18867188),CLLocationCoordinate2DMake(56.3487108, 137.08789063));
    MAGroundOverlay *groundOverlay = [MAGroundOverlay groundOverlayWithBounds:coordinateBounds icon:nil];
    _mapView.visibleMapRect = groundOverlay.boundingMapRect;
    
}

#pragma mark -- 清除地图上的覆盖物
- (void)clearMapView
{
    
    //显示标注之前先把地图上个的标注清除
    NSMutableArray *annoArray = [NSMutableArray arrayWithArray:self.mapView.annotations];
    
    [self.mapView removeAnnotations:annoArray];
    
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    
}
#pragma mark - MAMapViewDelegate
//覆盖物加载回调
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    
    // is Line
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay ];
        
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
        MAPolygonView *polygonView = [[MAPolygonView alloc]initWithPolygon:overlay] ;
        return polygonView;
    }
    
    return nil;
}

#pragma mark - UI隐藏
- (void)hiddenView:(BOOL)hidden{
    
    
    self.areaLabel.hidden = hidden; //物管面积
    self.receivable.hidden = hidden;//应收
    self.paidIn.hidden = hidden;//实收
    self.ratioLabel.hidden = hidden; //收缴率
    self.satisfactionLabel.hidden = hidden; //满意度
    self.amountBtn.hidden = hidden;
    self.complaintBtn.hidden = hidden;
    self.depotBtn.hidden = hidden;
    self.amountLabel.hidden = hidden;
    self.complaintLabel.hidden = hidden;
    self.depotLabel.hidden = hidden;
    self.label1.hidden = hidden;
    self.label2.hidden = hidden;
    self.label3.hidden = hidden;
    self.label4.hidden = hidden;
    self.label5.hidden = hidden;
}




#pragma mark - 点击事件
//返回上一级
- (IBAction)upperStoryClick:(id)sender {
    
    self.level --;
    self.annotationType = self.level -1;
    if (self.level > 0) {
        [self clearMapView];
        
        //大区域
        if(self.level == 1){
            self.lastBtn.hidden = YES;
            self.retArrow.hidden = YES;
            
            if (self.isJobV2) {
                self.bouchID = self.communityCountID;
            } else {
                //self.bouchID = [NSString stringWithFormat:MAP_ORIG_82];
            }
            
            if (self.isArea) {
               // [self switchAreaAndGlobal:NO];
            }
            //设置标题
            //            self.titleLabel.text = @"全国大区分布";
            [self setTitleText:@"全国大区分布"];
            
            if (self.isJobV2) {
                //[self getJobV2];
            } else {
                //[self loadData];
            }
            
            //[self loadAreaDetailData];
            //            [self loadCommunityCount];
            [self setVisibleMapRect];
            [self.bouchIDArray removeAllObjects];
        }else{
            
            [self hiddenView:NO];
            
            //            NSDictionary *last = [NSDictionary dictionaryWithDictionary:[self.bouchIDArray lastObject]];
            [self.bouchIDArray removeLastObject];
            NSMutableDictionary *dic = [self.bouchIDArray lastObject];
            self.bouchID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            double lat = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"lat"]] doubleValue];
            double lon = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"lon"]] doubleValue];
            //            self.titleLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
            [self setTitleText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake(lat,lon);
            [self.mapView setCenterCoordinate:center animated:YES];
            CGFloat zoomLevel = [[dic objectForKey:@"zoomLevel"] floatValue];
            [self.mapView setZoomLevel:zoomLevel animated:YES];
            
            
            if (self.isArea) {
               // [self switchAreaAndGlobal:NO];
            }
            
            //[self loadData];
            //[self loadAreaDetailData];
        }
    }
}

//关闭
- (IBAction)backClick:(id)sender {
    
    self.mapView.delegate = nil;
    self.mapView.showsUserLocation = NO;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


//邮件
- (IBAction)mapClick:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showEmail)]) {
        [self.delegate showEmail];
    }
    
}

//审批
- (IBAction)feedbackClick:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showOA)]) {
        [self.delegate showOA];
    }
}

//打开侧边栏
- (IBAction)openOrCloseKPI:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.userInteractionEnabled = NO;
    if (self.isClose) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.kpiBgView.center = CGPointMake(self.kpiBgView.center.x + self.kpiBgView.frame.size.width, self.kpiBgView.center.y);
        } completion:^(BOOL finished) {
            self.isClose = NO;
            btn.userInteractionEnabled = YES;
        }];
        
    } else {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.kpiBgView.center = CGPointMake(self.kpiBgView.center.x - self.kpiBgView.frame.size.width, self.kpiBgView.center.y);
        } completion:^(BOOL finished) {
            self.isClose = YES;
            btn.userInteractionEnabled = YES;
        }];
    }
    
}

//
//#pragma mark - Helpers
//#pragma mark -- 第一层地图显示区域
//- (void)setVisibleMapRect{
//    //116.452671,39.933144
//    CLLocationCoordinate2D center  = CLLocationCoordinate2DMake(39.933144, 113.452671);
//    [self.mapView setCenterCoordinate:center];
//    MACoordinateBounds coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake
//                                                                 (19.8458518, 71.18867188),CLLocationCoordinate2DMake(56.3487108, 137.08789063));
//    MAGroundOverlay *groundOverlay = [MAGroundOverlay groundOverlayWithBounds:coordinateBounds icon:nil];
//    _mapView.visibleMapRect = groundOverlay.boundingMapRect;
//
//}
//
//#pragma mark -- 添加大头针
////这里的type其实是层级，isArea才是标明是否是小区
//- (void)addAnnotationWithType:(NSInteger)type{
//    
//    
//    if(type == 0 || type == 1 || type == 2 || type == 3){
//        for (int i = 0; i <self.areaArray.count; i++) {
//            PMMApAnnotBaseMapViewation *pointAnnotation = [[[PMMApAnnotation alloc] init] autorelease];
//            pointAnnotation.tag = 1000+i;
//            pointAnnotation.type = type;
//            PMArea *area = [self.areaArray objectAtIndex:i];
//            
////            pointAnnotation.isArea = [area.orgType isEqualToString:@"小区"] ? YES:NO;
//            double lat = [area.lat doubleValue];
//            double lon = [area.lon doubleValue];
//            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(lat, lon);
//            pointAnnotation.coordinate = coor;
//            [self.mapView addAnnotation:pointAnnotation];
//            if(type > 0&& i == 0){
//                [self.mapView setCenterCoordinate:coor animated:YES];
//                
//                NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:[self.bouchIDArray objectAtIndex:type-1]];
//                [dic setObject:[NSString stringWithFormat:@"%@",area.lat] forKey:@"lat"];
//                [dic setObject:[NSString stringWithFormat:@"%@",area.lon] forKey:@"lon"];
//                [self.bouchIDArray removeObjectAtIndex:type-1];
//                [self.bouchIDArray insertObject:dic atIndex:type-1];
//                
//            }
//        }
//        [self changeMapZoomLevel:NO];
//    }
//    
//}
//#pragma mark -- 清除地图上的覆盖物
//- (void)clearMapView
//{
//    
//    //显示标注之前先把地图上个的标注清除
//    NSMutableArray *annoArray = [NSMutableArray arrayWithArray:self.mapView.annotations];
//    
//    [self.mapView removeAnnotations:annoArray];
// 
//    
//    [self.mapView removeOverlays:self.mapView.overlays];
//    
//    
//}
//
//#pragma mark -- show area detail
//- (void)showAreaDetail{
//
//    if (!self.areaDetail) {
//        return;
//    }
//    
////    MapTableRow *mapRow = [[MapTableRow alloc] initWithFrame:CGRectMake(0, 100, 200, 100)];
////    [self.view addSubview:mapRow];
////    [mapRow release];
//   
//    if (!self.areaDetail.floorArea) {
//        self.areaLabel.text = @"0";
//    }else{
//     self.areaLabel.text =[NSString stringWithFormat:@"%@", self.areaDetail.floorArea ];
//    }
//    
//    if (!self.areaDetail.parkingCount) {
//        self.receivable.text = @"0";
//    }else{
//        self.receivable.text = [NSString stringWithFormat:@"%@", self.areaDetail.parkingCount];
//    }
//    
//    if (!self.areaDetail.normalFee) {
//        self.paidIn.text = @"0";
//    }else{
//        self.paidIn.text = [NSString stringWithFormat:@"%@",self.areaDetail.normalFee ];
//    }
//    
//    if (!self.areaDetail.receivedFee) {
//        self.ratioLabel.text = @"0";
//    }else{
//     self.ratioLabel.text = [NSString stringWithFormat:@"%@", self.areaDetail.receivedFee];
//    }
//    
//    if (!self.areaDetail.feeRate) {
//        self.satisfactionLabel.text = @"0";
//    }else{
//        self.satisfactionLabel.text = [NSString stringWithFormat:@"%@",self.areaDetail.feeRate];
//    }
//    
//    //第六行
//    if (!self.areaDetail.satisfactionK) {
//        self.labelContent.text = @"0";
//    }else{
//        self.labelContent.text = [NSString stringWithFormat:@"%@",self.areaDetail.satisfactionK];
//    }
//    
//    //下方头两行
//    if (!self.areaDetail.appCount) {
//        self.amountLabel.text = @"0";
//    }else{
//      self.amountLabel.text = [NSString stringWithFormat:@"%@", self.areaDetail.appCount];
//    }
//  
//    if (!self.areaDetail.complainCount) {
//        self.complaintLabel.text = @"0";
//    }else{
//        self.complaintLabel.text =[NSString stringWithFormat:@"%@",self.areaDetail.complainCount ];
//    }
//    
//    if (!self.areaDetail.communityCount) {
//        self.depotLabel.text = @"0";
//    }else{
//        self.depotLabel.text =[NSString stringWithFormat:@"%@",self.areaDetail.communityCount ];
//    }
//    
//}
//-(void)changeMapZoomLevel:(BOOL)isNull{
//    
//    if(self.annotationType == 0){
//        return;
//    }
//    
//
//    //大区域->事业部
//    if(self.annotationType == 1 && !isNull){
//       [self.mapView setZoomLevel:self.mapView.zoomLevel+3 animated:YES];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.bouchIDArray objectAtIndex:0] ];
//        NSString *level = [NSString stringWithFormat:@"%f",self.mapView.zoomLevel];
//        [dic setObject:level forKey:@"zoomLevel"];
//        [self.bouchIDArray removeObjectAtIndex:0];
//        [self.bouchIDArray insertObject:dic atIndex:0];
//        return;
//    }
//    //事业部->片区
//    else if (self.annotationType == 2 && !isNull) {
//        [self.mapView setZoomLevel:10 animated:YES];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.bouchIDArray objectAtIndex:1] ];
//        [dic setObject:[NSString stringWithFormat:@"%f",self.mapView.zoomLevel] forKey:@"zoomLevel"];
//         [self.bouchIDArray removeObjectAtIndex:1];
//        [self.bouchIDArray insertObject:dic atIndex:1];
//          return;
//    }
//    //片区->小区
//   else if (self.annotationType == 3&&!isNull) {
//        [self.mapView setZoomLevel:12 animated:YES];
//       NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithDictionary:[self.bouchIDArray objectAtIndex:2] ];
//        [dic setObject:[NSString stringWithFormat:@"%f",self.mapView.zoomLevel] forKey:@"zoomLevel"];
//         [self.bouchIDArray removeObjectAtIndex:2];
//        [self.bouchIDArray insertObject:dic atIndex:2];
//         return;
//    }
//    // 事业部->小区
//   else if (self.annotationType == 3 &&isNull) {
//        [self clearMapView];
//        [self.mapView setZoomLevel:17 animated:YES];
//        [self  hiddenView:YES];
//         return;
//    }
//  
//    
//    //小区放大
//    else if (self.annotationType == 4||isNull) {
//        [self clearMapView];
//        [self.mapView setZoomLevel:17 animated:YES];
//        [self  hiddenView:YES];
//          return;
//    }
//   
//}
//#pragma mark - MAMapViewDelegate
////覆盖物加载回调
//- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
//{
//    
//    // is Line
//    if ([overlay isKindOfClass:[MAPolyline class]])
//    {
//        MAPolylineView *polylineView = [[[MAPolylineView alloc] initWithPolyline:overlay] autorelease];
//        
//        polylineView.lineWidth   = 4.f;
//        polylineView.strokeColor = self.color;
//        
//        return polylineView;
//    }
//    //is image
//    if ([overlay isKindOfClass:[MAGroundOverlay class]])
//    {
//        MAGroundOverlayView *groundOverlayView = [[[MAGroundOverlayView alloc]
//                                                   initWithGroundOverlay:overlay] autorelease];
//        
//        return groundOverlayView;
//    }
//    //is polygon
//    if([overlay isKindOfClass:[MAPolygon class]]){
//        MAPolygonView *polygonView = [[[MAPolygonView alloc]initWithPolygon:overlay] autorelease];
//        return polygonView;
//    }
//    
//    return nil;
//}
////定制大头针样式
//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
//{
//    
//    if ([annotation isMemberOfClass:[AreaApAnnotation class]])
//    {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
//        
//        AreaApAnnotation *ann = (AreaApAnnotation *)annotation;
//        CuAnnotationView *annotationView = (CuAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[[CuAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier annotationType:0] autorelease];
//        }
//        
//        //        UIImage *paopao=[UIImage imageNamed:@"map_paopao.png"];
//        //        UIImage *strechImage =[paopao stretchableImageWithLeftCapWidth:5 topCapHeight:6];
//        //        annotationView.image = strechImage;
//        [annotationView setSelected:YES animated:YES];
//        annotationView.delegate = self;
//        annotationView.pointType = 1;//1.小区
//        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
//        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
//        annotationView.calloutOffset = CGPointMake(0, -5);//气泡弹出的位置
//        UIImage *paopao=[UIImage imageNamed:@"map_paopao_small"];
//        UIImage *strechImage =[paopao stretchableImageWithLeftCapWidth:5 topCapHeight:6];
//        annotationView.portrait = strechImage;
//        annotationView.name = [ann.info objectForKey:@"name"];
//        annotationView.info = ann.info;
//        [annotationView setWidth:annotationView.name];
//        
//        return annotationView;
//    }
//    
//    if ([annotation isKindOfClass:[PMMApAnnotation class]])
//    {
//        PMMApAnnotation *pointAnnotation = (PMMApAnnotation *)annotation;
//        static NSString *customReuseIndetifier = @"cuReuseIndetifier";
//        CuAnnotationView *annotationView = (CuAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier ];
//        if (annotationView == nil)
//        {
//            
////            annotationView = [[[CuAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier] autorelease];
//            annotationView = [[[CuAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier annotationType:pointAnnotation.type] autorelease];
//        }
//        if (pointAnnotation.type == 0|| pointAnnotation.type == 1|| pointAnnotation.type == 2|| pointAnnotation.type == 3) {
//            annotationView.delegate = self;
//            annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
//            annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
//            annotationView.calloutOffset = CGPointMake(0, -5);//气泡弹出的位置
//            UIImage *paopao=[UIImage imageNamed:@"map_paopao_small"];
//            UIImage *strechImage =[paopao stretchableImageWithLeftCapWidth:5 topCapHeight:6];
//            annotationView.portrait = strechImage;
//            annotationView.tag = pointAnnotation.tag;
//            annotationView.annotationType = pointAnnotation.type;
//            PMArea *area = [self.areaArray objectAtIndex:pointAnnotation.tag-1000];
//            annotationView.name = area.name;
//           
//            if (![area.orgType isEqualToString:@"小区"]) {
//                annotationView.name = [annotationView.name stringByAppendingFormat:@"(%@)",area.communityCount];
//                annotationView.isArea = NO;
//            } else {
//                annotationView.isArea = YES;
//            }
//            
//        
//             [annotationView setWidth:annotationView.name];
//            return annotationView;
//            
//            
//        }
//        
//    }
//    
//    return nil;
//}
//
//#pragma mark -- customAnnotationDelegate
//
//- (void)didSelectedEventWithCuAnnotationView:(CuAnnotationView *)annotationView
//{
//    if (annotationView.pointType == 1) {
//        //附近小区
//
//        self.areaLabel.text = @"";
//        self.ratioLabel.text = @"";
//        self.receivable.text = @"";
//        self.paidIn.text = @"";
//        self.satisfactionLabel.text = @"";
//        
//        self.amountLabel.text = @"";
//        self.complaintLabel.text = @"";
//        self.depotLabel.text = @"";
//        
//        
//        NSDictionary *dic = [LocalDataAccessor fetchOAUserInfo];
//        NSString *name = [dic objectForKey:@"name"];
//        
//        NSCalendar *cal = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
//        NSDate* now = [NSDate date];
//        NSDateComponents* component = [cal components:NSYearCalendarUnit fromDate:now];
//        int year = (int)[component year];
//        NSString *currentYear = [NSString stringWithFormat:@"%d",year];
//        
//        
//        NSString *branchID = [annotationView.info objectForKey:@"uuid"];
//        
//        typeof(self) __block weakSelf = self;
//        [PMMapDataAPI getBigDataKpiByUid:name andBranchId:branchID AtYear:currentYear BlockSuc:^(NSURL *url, id result) {
//            
//            [weakSelf retain];
//            if (![ISNull isNilOfSender:result]&&[[result objectForKey:@"code"] intValue]==0) {
//                
//                id dic =  (NSDictionary *)[result objectForKey:@"content"];
//                
//                if ([dic isKindOfClass:[NSDictionary class]]) {
//                    
//                    DLog(@"%@", dic);
//                    
//                    weakSelf.areaLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"qrcode2open"]];
//                    weakSelf.ratioLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"parkingFee"]];
//                    weakSelf.ratioLabel.text = [PMAreaDetail getFormatString:weakSelf.ratioLabel.text];
//                    
//                    weakSelf.receivable.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"cameraStatus"]];
//                    weakSelf.paidIn.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"guardStatus"]];
//                    weakSelf.satisfactionLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"barrierStatus"]];
//                    
////                    weakSelf.amountLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"appCount"]];
////                    weakSelf.complaintLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"complainCount"]];
////                    weakSelf.depotLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"-"]];
//                    weakSelf.labelContent.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"appCount"]];
//                    weakSelf.amountLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"complainCount"]];
//                    weakSelf.complaintLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"-"]];
//                    
//                } else if ([dic isKindOfClass:[NSArray class]]){
//                    
//                }
//                
//            }
//            [weakSelf release];
//        } BlockFailed:^(NSURL *url, NSError *error) {
//            NSLog(@"get area detail where bouch_id = %@  error:%@ ",self.bouchID,error.localizedDescription);
//        }];
//        
////        self.titleLabel.text = [annotationView.info objectForKey:@"name"];
//        [self setTitleText:[annotationView.info objectForKey:@"name"]];
//    } else {
//        
//        if (self.lastBtn.hidden) {
//            self.lastBtn.hidden = NO;
//            self.retArrow.hidden = NO;
//        }
//        self.annotationType = annotationView.annotationType+1;
////        self.level = self.annotationType+1;
//        
//        PMArea *area = (PMArea *)[self.areaArray objectAtIndex:annotationView.tag-1000];
//        self.bouchID = [NSString stringWithFormat:@"%@",area.uuid];
////        self.titleLabel.text = [NSString stringWithFormat:@"%@-%@", self.titleLabel.text,area.name];
//        [self setTitleText:[NSString stringWithFormat:@"%@-%@", self.titleLabel.text,area.name]];
//        //    self.titleLabel.textColor = [UIColor blueColor];
//        CLLocationCoordinate2D center = CLLocationCoordinate2DMake([area.lat  doubleValue], [area.lon doubleValue]);
//        [self.mapView setCenterCoordinate:center animated:YES];
//        
////        if (self.annotationType<4) {
////            
////            self.level = self.annotationType+1;
////            [self clearMapView];
////            
////            if (self.annotationType>0) {
////                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
////                [dic setObject:[NSString stringWithFormat:@"%@",area.uuid] forKey:@"id"];
////                [dic setObject:[NSString stringWithFormat:@"%@",self.titleLabel.text] forKey:@"title"];
////                [self.bouchIDArray addObject:dic];
////                
////            }
////            [self loadData];
////            [self loadAreaDetailData];
////        }else{
////            //组织结构最底层的小区，之前是点击小区，直接进行地图放大，现在点击小区要在左侧显示小区数据。
////            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
////            [dic setObject:[NSString stringWithFormat:@"%@",area.uuid] forKey:@"id"];
////            [dic setObject:[NSString stringWithFormat:@"%@",self.titleLabel.text] forKey:@"title"];
////            [dic setObject:@"area" forKey:@"small"];
//////            [self.bouchIDArray addObject:dic];
//////            [self clearMapView];
//////            [self.mapView setZoomLevel:18 animated:YES];
////            [self hiddenView:NO];
////            [self showAreaSidebar];
////            [self getAreaInfoWith:area.uuid andName:self.titleLabel.text];
////        }
//        
//        if (annotationView.isArea) {
//            
//            self.isArea = YES;
//            //组织结构最底层的小区，之前是点击小区，直接进行地图放大，现在点击小区要在左侧显示小区数据。
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
//            [dic setObject:[NSString stringWithFormat:@"%@",area.uuid] forKey:@"id"];
//            [dic setObject:[NSString stringWithFormat:@"%@",self.titleLabel.text] forKey:@"title"];
//            [dic setObject:@"area" forKey:@"small"];
//            //            [self.bouchIDArray addObject:dic];
//            //            [self clearMapView];
//            //            [self.mapView setZoomLevel:18 animated:YES];
//            [self hiddenView:NO];
//            [self showAreaSidebar];
//            [self getAreaInfoWith:area.uuid andName:self.titleLabel.text];
//        } else {
//            
//            self.isArea = NO;
//            self.level = self.annotationType+1;
//            [self clearMapView];
//            
//            if (self.annotationType>0) {
//                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
//                [dic setObject:[NSString stringWithFormat:@"%@",area.uuid] forKey:@"id"];
//                [dic setObject:[NSString stringWithFormat:@"%@",self.titleLabel.text] forKey:@"title"];
//                [self.bouchIDArray addObject:dic];
//                
//            }
//            [self loadData];
//            [self loadAreaDetailData];
//        }
//    }
//}
//
//
//- (void)getAreaInfoWith:(NSString *)uuid andName:(NSString *)areaName {
//    //附近小区
//    
//    self.areaLabel.text = @"";
//    self.ratioLabel.text = @"";
//    self.receivable.text = @"";
//    self.paidIn.text = @"";
//    self.satisfactionLabel.text = @"";
//    
//    self.amountLabel.text = @"";
//    self.complaintLabel.text = @"";
//    self.depotLabel.text = @"";
//    
//    
//    NSDictionary *dic = [LocalDataAccessor fetchOAUserInfo];
//    NSString *name = [dic objectForKey:@"name"];
//    
//    NSCalendar *cal = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
//    NSDate* now = [NSDate date];
//    NSDateComponents* component = [cal components:NSYearCalendarUnit fromDate:now];
//    int year = (int)[component year];
//    NSString *currentYear = [NSString stringWithFormat:@"%d",year];
//    
//    
//    NSString *branchID = uuid;
//    
//    typeof(self) __block weakSelf = self;
//    [PMMapDataAPI getBigDataKpiByUid:name andBranchId:branchID AtYear:currentYear BlockSuc:^(NSURL *url, id result) {
//        
//        [weakSelf retain];
//        if (![ISNull isNilOfSender:result]&&[[result objectForKey:@"code"] intValue]==0) {
//            
//            id dic =  (NSDictionary *)[result objectForKey:@"content"];
//            
//            if ([dic isKindOfClass:[NSDictionary class]]) {
//                
//                DLog(@"%@", dic);
//                
//                weakSelf.areaLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"qrcode2open"]];
//                weakSelf.receivable.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"parkingFee"]];//停车场收费
//                weakSelf.paidIn.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"cameraStatus"]];//摄像头
//                weakSelf.ratioLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"guardStatus"]];//门禁
//                weakSelf.satisfactionLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"barrierStatus"]];
//                weakSelf.labelContent.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"appCount"]];
//                weakSelf.amountLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"complainCount"]];
//                weakSelf.complaintLabel.text = [NSString stringWithFormat:@"%@", @""];
//                
//            } else if ([dic isKindOfClass:[NSArray class]]){
//                
//            }
//            
//        }
//        [weakSelf release];
//    } BlockFailed:^(NSURL *url, NSError *error) {
//        NSLog(@"get area detail where bouch_id = %@  error:%@ ",self.bouchID,error.localizedDescription);
//    }];
//    
////    self.titleLabel.text = areaName;
//    [self setTitleText:areaName];
//}
//
//#pragma mark -- 请求网络数据
//- (void)loadData{
//    
//    [self.areaArray removeAllObjects];
//    NSString *bid = [NSString stringWithFormat:@"%@",self.bouchID];
//    
//    typeof(self) __block weakSelf = self;
//    [PMMapDataAPI getBigDataBranch:bid BlockSuc:^(NSURL *url, id result) {
// //可复用begin
//        if (weakSelf) {
//            
//            [weakSelf retain];
//            DLog(@"%@", result);
//            if (![ISNull  isNilOfSender:result]&&[[result objectForKey:@"code"] intValue]==0) {
//                
//                NSArray *array = (NSArray *)[result objectForKey:@"content"];
//                
//                NSInteger allCommunityCount = 0;
//                
//                for(NSInteger i = 0 ;i < array.count;i++){
//                    NSDictionary *dic = [array objectAtIndex:i];
//                    PMArea *area = [PMArea getPMAreaWithDic:dic];
//                    [weakSelf.areaArray addObject:area];
//                    
//                    allCommunityCount += [area.communityCount integerValue];
//                }
//                
//                if (weakSelf.level != 1) {
//                    
////                    weakSelf.depotLabel.text = [NSString stringWithFormat:@"%ld", (long)allCommunityCount];
//                }
//                
//                if(weakSelf.level == 1){
//                    //区域
//                    [weakSelf addAnnotationWithType:0];
//                    
//                }
//                if (weakSelf.level == 2) {
//                    //事业部
//                    [weakSelf addAnnotationWithType:1];
//                }
//                if (weakSelf.level== 3) {
//                    //片区
//                    [weakSelf addAnnotationWithType:2];
//                }
//                if (weakSelf.level == 4) {
//                    //小区
//                    [weakSelf addAnnotationWithType:3];
//                }
//                
//            }else{
//                [weakSelf changeMapZoomLevel:YES];
//            }
//            
//            [weakSelf release];
//            
//        }
////可复用end
//     } BlockFailed:^(NSURL *url, NSError *error) {
//         
//     }];
//    
//    
//}
//- (void)loadAreaDetailData{
//    
//    NSDictionary *dic = [LocalDataAccessor fetchOAUserInfo];
//    NSString *name = [dic objectForKey:@"name"];
//    
//    NSString *bid = [NSString stringWithFormat:@"%@",self.bouchID];
//    NSCalendar *cal = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
//    NSDate* now = [NSDate date];
//    NSDateComponents* component = [cal components:NSYearCalendarUnit fromDate:now];
//    int year = (int)[component year];
//    NSString *currentYear = [NSString stringWithFormat:@"%d",year];
//    
//    typeof(self) __block weakSelf = self;
//    [PMMapDataAPI getBigDataKpiByUid:name andBranchId:bid AtYear:currentYear BlockSuc:^(NSURL *url, id result) {
//    
//        [weakSelf retain];
//        if (![ISNull isNilOfSender:result]&&[[result objectForKey:@"code"] intValue]==0) {
//            
//            DLog(@"%@", result);
//            NSDictionary *dic =  (NSDictionary *)[result objectForKey:@"content"];
//            
//            if ([dic isKindOfClass:[NSDictionary class]]) {
//                
//                weakSelf.areaDetail = [PMAreaDetail getAreaDetailWithDic:dic];
//                
//                [weakSelf showAreaDetail];
//                
//            } else if ([dic isKindOfClass:[NSArray class]]){
//                
//            }
//        }
//        [weakSelf release];
//        
//    } BlockFailed:^(NSURL *url, NSError *error) {
//        NSLog(@"get area detail where bouch_id = %@  error:%@ ",self.bouchID,error.localizedDescription);
//    }];
//    
//    
//  
//    
//}
//-(void)loadCommunityCount{
//    
//    typeof(self) __block weakSelf = self;
//    [PMMapDataAPI getBigDataBranch:self.communityCountID BlockSuc:^(NSURL *url, id result) {
//     
//        if (weakSelf) {
//            [weakSelf retain];
//            if(![ISNull isNilOfSender:result]&&[[result objectForKey:@"code"] intValue]==0){
//                
//                NSArray *array = (NSArray *)[result objectForKey:@"content"];
//                
//                NSDictionary *dic=nil;
//                
//                if (array) {
//                    
//                    if (array.count==1) {
//                        dic = [array firstObject];
//                    }
//                    else if(array.count>1){
//                        
//                        //                    for (NSDictionary *item in array) {
//                        //                        if ([[item objectForKey:@"id"] intValue]==83) {
//                        //                            dic = item;
//                        //                            break;
//                        //                        }
//                        //                    }
//                        
//                        for (NSDictionary *item in array) {
//                            if ([[item objectForKey:@"uuid"] isEqualToString:MAP_ORIG_82]) {
//                                dic = item;
//                                
//                                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//                                formatter.numberStyle = NSNumberFormatterDecimalStyle;
//                                
//                                NSString *cCount = [formatter stringFromNumber:[NSNumber numberWithLongLong:[[item objectForKey:@"communityCount"] longLongValue]]];
//                                weakSelf.depotLabel.text = cCount;
//                                
//                                [formatter release];
//                                break;
//                            }
//                        }
//                        
//                    }
//                    
//                    if (dic) {
//                        
//                        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//                        formatter.numberStyle = NSNumberFormatterDecimalStyle;
//                        NSString *cCount = [formatter stringFromNumber:[NSNumber numberWithLongLong:[[dic objectForKey:@"communityCount"] longLongValue]]];
//                        weakSelf.depotLabel.text = cCount;
////                        weakSelf.titleLabel.text = @"全国大区分布";
//                        [weakSelf setTitleText:@"全国大区分布"];
//                        [formatter release];
//                    }
//                }
//                
//            }
//            [weakSelf release];
//        }
//     } BlockFailed:^(NSURL *url, NSError *error) {
//         NSLog(@"get community count  error:%@",error.localizedDescription);
//     }];
//    
//
//}
//
//
//#pragma mark - UI隐藏
//- (void)hiddenView:(BOOL)hidden{
//  
// 
//    self.areaLabel.hidden = hidden; //物管面积
//    self.receivable.hidden = hidden;//应收
//    self.paidIn.hidden = hidden;//实收
//    self.ratioLabel.hidden = hidden; //收缴率
//    self.satisfactionLabel.hidden = hidden; //满意度
//    self.amountBtn.hidden = hidden;
//    self.complaintBtn.hidden = hidden;
//    self.depotBtn.hidden = hidden;
//    self.amountLabel.hidden = hidden;
//    self.complaintLabel.hidden = hidden;
//    self.depotLabel.hidden = hidden;
//    self.label1.hidden = hidden;
//    self.label2.hidden = hidden;
//    self.label3.hidden = hidden;
//    self.label4.hidden = hidden;
//    self.label5.hidden = hidden;
//}
//
//
//
//
//#pragma mark - 点击事件
////返回上一级
//- (IBAction)upperStoryClick:(id)sender {
//    
//    self.level --;
//    self.annotationType = self.level -1;
//    if (self.level > 0) {
//        [self clearMapView];
//        
//        //大区域
//        if(self.level == 1){
//            self.lastBtn.hidden = YES;
//            self.retArrow.hidden = YES;
//            
//            if (self.isJobV2) {
//                self.bouchID = self.communityCountID;
//            } else {
//                self.bouchID = [NSString stringWithFormat:MAP_ORIG_82];
//            }
//            
//            if (self.isArea) {
//                [self switchAreaAndGlobal:NO];
//            }
//            //设置标题
////            self.titleLabel.text = @"全国大区分布";
//            [self setTitleText:@"全国大区分布"];
//            
//            if (self.isJobV2) {
//                [self getJobV2];
//            } else {
//                [self loadData];
//            }
//            
//            [self loadAreaDetailData];
////            [self loadCommunityCount];
//            [self setVisibleMapRect];
//            [self.bouchIDArray removeAllObjects];
//        }else{
//            [self hiddenView:NO];
//            
////            NSDictionary *last = [NSDictionary dictionaryWithDictionary:[self.bouchIDArray lastObject]];
//            [self.bouchIDArray removeLastObject];
//            NSMutableDictionary *dic = [self.bouchIDArray lastObject];
//            self.bouchID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
//            double lat = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"lat"]] doubleValue];
//            double lon = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"lon"]] doubleValue];
////            self.titleLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
//            [self setTitleText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]]];
//            CLLocationCoordinate2D center = CLLocationCoordinate2DMake(lat,lon);
//            [self.mapView setCenterCoordinate:center animated:YES];
//            CGFloat zoomLevel = [[dic objectForKey:@"zoomLevel"] floatValue];
//            [self.mapView setZoomLevel:zoomLevel animated:YES];
//            
//
//            if (self.isArea) {
//                [self switchAreaAndGlobal:NO];
//            }
//            
//            [self loadData];
//            [self loadAreaDetailData];
//        }
//    }
//}
//
////关闭
//- (IBAction)backClick:(id)sender {
//  
//    self.mapView.delegate = nil;
//    self.mapView.showsUserLocation = NO;
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//
////邮件
//- (IBAction)mapClick:(id)sender {
//
//    [self dismissViewControllerAnimated:NO completion:nil];
//    
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(showEmail)]) {
//        [self.delegate showEmail];
//    }
//    
//}
//
////审批
//- (IBAction)feedbackClick:(id)sender {
//    [self dismissViewControllerAnimated:NO completion:nil];
//    
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(showOA)]) {
//        [self.delegate showOA];
//    }
//}
//
////打开侧边栏
//- (IBAction)openOrCloseKPI:(id)sender {
//    
//    UIButton *btn = (UIButton *)sender;
//    btn.userInteractionEnabled = NO;
//    if (self.isClose) {
//        
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            self.kpiBgView.center = CGPointMake(self.kpiBgView.center.x + self.kpiBgView.frame.size.width, self.kpiBgView.center.y);
//        } completion:^(BOOL finished) {
//            self.isClose = NO;
//            btn.userInteractionEnabled = YES;
//        }];
//        
//    } else {
//        
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            self.kpiBgView.center = CGPointMake(self.kpiBgView.center.x - self.kpiBgView.frame.size.width, self.kpiBgView.center.y);
//        } completion:^(BOOL finished) {
//            self.isClose = YES;
//            btn.userInteractionEnabled = YES;
//        }];
//    }
//
//}
//
////获取小区
//- (IBAction)getPoiCommunity:(id)sender {
//    
//    UIButton *btn = (UIButton *)sender;
//    if (btn.tag == 0) {
//        
//        //小区地图
//        [btn setImage:[UIImage imageNamed:@"map_area"] forState:UIControlStateNormal];
//
//        btn.tag = 1;
//        //开启定位
//        self.mapView.showsUserLocation = YES;
//        [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
//        
//        [self.mapView setZoomEnabled:YES];
//        [self.mapView setZoomLevel:15 animated:YES];
//        
////        self.titleLabel.text = @"";
//        [self setTitleText:@""];
//        
//        [self switchAreaAndGlobal:YES];
//        
//    } else {
//        
//        //事业地图
//        //group_unfav.png
//        [btn setImage:[UIImage imageNamed:@"map_map"] forState:UIControlStateNormal];
//        btn.tag = 0;
//        //关闭定位
//        self.mapView.showsUserLocation = NO;
//        
//        self.level = 2;
//        if (self.bouchID == nil || [self.bouchID isEqualToString:@""]) {
//            
//            [self clearMapView];
//            
//        } else {
//            
//            [self upperStoryClick:nil];
//        }
//        
//        [self switchAreaAndGlobal:NO];
//    }
//    
//}
//
//
//#define X(theFrame) theFrame.origin.x
//#define Y(theFrame) theFrame.origin.y
//#define W(theFrame) theFrame.size.width
//#define H(theFrame) theFrame.size.height
//
//#define OFFSET_OF_WIDTH 0
//#define EXPEND_WIDTH    90
//- (void)switchAreaAndGlobal:(BOOL)isArea {
//    
//    if (isArea) {
//        
//        
//        [self clearMapView];
//        //小区
////        [self.fiveLineBg setFrame:CGRectMake(X(self.origFiveLineBgRect), Y(self.origFiveLineBgRect), W(self.origFiveLineBgRect) + OFFSET_OF_WIDTH, H(self.origFiveLineBgRect))];
////        [self.threeLineBg setFrame:CGRectMake(X(self.origThreeLineBgRect), Y(self.origThreeLineBgRect), W(self.origThreeLineBgRect) + OFFSET_OF_WIDTH, H(self.origThreeLineBgRect))];
//        [self.label1 setFrame:CGRectMake(X(self.origLabel1Rect), Y(self.origLabel1Rect), W(self.origLabel1Rect) + EXPEND_WIDTH, H(self.origLabel1Rect))];
//        [self.label2 setFrame:CGRectMake(X(self.origLabel2Rect), Y(self.origLabel2Rect), W(self.origLabel2Rect) + EXPEND_WIDTH, H(self.origLabel2Rect))];
//        [self.label3 setFrame:CGRectMake(X(self.origLabel3Rect), Y(self.origLabel3Rect), W(self.origLabel3Rect) + EXPEND_WIDTH, H(self.origLabel3Rect))];
//        [self.label4 setFrame:CGRectMake(X(self.origLabel4Rect), Y(self.origLabel4Rect), W(self.origLabel4Rect) + EXPEND_WIDTH, H(self.origLabel4Rect))];
//        [self.label5 setFrame:CGRectMake(X(self.origLabel5Rect), Y(self.origLabel5Rect), W(self.origLabel5Rect) + EXPEND_WIDTH, H(self.origLabel5Rect))];
//        
////        [self.areaLabel setFrame:CGRectMake(X(self.origLabel1ValueRect) + OFFSET_OF_WIDTH, Y(self.origLabel1ValueRect), W(self.origLabel1ValueRect), H(self.origLabel1ValueRect))];
////        [self.receivable setFrame:CGRectMake(X(self.origLabel2ValueRect) + OFFSET_OF_WIDTH, Y(self.origLabel2ValueRect), W(self.origLabel2ValueRect), H(self.origLabel2ValueRect))];
////        [self.paidIn setFrame:CGRectMake(X(self.origLabel3ValueRect) + OFFSET_OF_WIDTH, Y(self.origLabel3ValueRect), W(self.origLabel3ValueRect), H(self.origLabel3ValueRect))];
////        [self.ratioLabel setFrame:CGRectMake(X(self.origLabel4ValueRect) + OFFSET_OF_WIDTH, Y(self.origLabel4ValueRect), W(self.origLabel4ValueRect), H(self.origLabel4ValueRect))];
////        [self.satisfactionLabel setFrame:CGRectMake(X(self.origLabel5ValueRect) + OFFSET_OF_WIDTH, Y(self.origLabel5ValueRect), W(self.origLabel5ValueRect), H(self.origLabel5ValueRect))];
//        
////        [self.amountLabel setFrame:CGRectMake(X(self.origLabel6ValueRect) + EXPEND_WIDTH, Y(self.origLabel6ValueRect), W(self.origLabel6ValueRect), H(self.origLabel6ValueRect))];
////        [self.complaintLabel setFrame:CGRectMake(X(self.origLabel7ValueRect) + EXPEND_WIDTH, Y(self.origLabel7ValueRect), W(self.origLabel7ValueRect), H(self.origLabel7ValueRect))];
////        [self.depotLabel setFrame:CGRectMake(X(self.origLabel8ValueRect) + EXPEND_WIDTH, Y(self.origLabel8ValueRect), W(self.origLabel8ValueRect), H(self.origLabel8ValueRect))];
//        
//        self.label1.text = @"二维码开门次数:";
//        self.label2.text = @"停车场累计收费总额:";
//        self.label3.text = @"海康摄像头在线情况:";
//        self.label4.text = @"门禁在线情况:";
//        self.label5.text = @"格美特道闸系统在线情况:";
//        //隐藏第六行
////        self.sixthRowBg.hidden = YES;
////        self.label6.hidden = YES;
////        self.labelContent.hidden = YES;
//        
//        self.areaLabel.text = @"";
//        self.receivable.text = @"";
//        self.paidIn.text = @"";
//        self.ratioLabel.text = @"";
//        self.satisfactionLabel.text = @"";
//        
//        self.amountLabel.text = @"";//1
//        self.complaintLabel.text = @"";//2
//        self.depotLabel.text = @"";//3
//
//        self.label6.text = @"APP安装数:";
//        self.labelContent.text = @"";
//        [self.amountBtn setTitle:@" 业主投诉数:" forState:UIControlStateNormal];
//        [self.complaintBtn setTitle:@" 停车场非法起杆:" forState:UIControlStateNormal];
//        [self.depotBtn setTitle:@"" forState:UIControlStateNormal];
//    } else {
//        //全国
////        [self.fiveLineBg setFrame:self.origFiveLineBgRect];
////        [self.threeLineBg setFrame:self.origThreeLineBgRect];
//        
//        [self.label1 setFrame:self.origLabel1Rect];
//        [self.label2 setFrame:self.origLabel2Rect];
//        [self.label3 setFrame:self.origLabel3Rect];
//        [self.label4 setFrame:self.origLabel4Rect];
//        [self.label5 setFrame:self.origLabel5Rect];
//        [self.label6 setFrame:self.origLabel6Rect];
//        
////        [self.areaLabel setFrame:self.origLabel1ValueRect];
////        [self.receivable setFrame:self.origLabel2ValueRect];
////        [self.paidIn setFrame:self.origLabel3ValueRect];
////        [self.ratioLabel setFrame:self.origLabel4ValueRect];
////        [self.satisfactionLabel setFrame:self.origLabel5ValueRect];
//        
////        [self.amountLabel setFrame:self.origLabel6ValueRect];
////        [self.complaintLabel setFrame:self.origLabel7ValueRect];
////        [self.depotLabel setFrame:self.origLabel8ValueRect];
//        
//        self.label1.text = @"上线面积:";
//        self.label2.text = @"车位数量:";
//        self.label3.text = @"应       收:";
//        self.label4.text = @"实       收:";
//        self.label5.text = @"收  缴  率:";
//        
//        //显示第六行
//        self.sixthRowBg.hidden = NO;
//        self.label6.hidden = NO;
//        self.labelContent.hidden = NO;
//        self.label6.text = @"满  意  度:";
//        
//        [self.amountBtn setTitle:@" APP安装数:" forState:UIControlStateNormal];
//        [self.complaintBtn setTitle:@" 业主投诉数:" forState:UIControlStateNormal];
//        [self.depotBtn setTitle:@" 上 线 小 区:" forState:UIControlStateNormal];
//        
//        
//        self.areaLabel.text = @"";
//        self.receivable.text = @"";
//        self.paidIn.text = @"";
//        self.ratioLabel.text = @"";
//        self.satisfactionLabel.text = @"";
//        
//        self.amountLabel.text = @"";//1
//        self.complaintLabel.text = @"";//2
//        self.depotLabel.text = @"";//3
//    }
//}
//
//- (void)showAreaSidebar {
//    
//    [self.label1 setFrame:CGRectMake(X(self.origLabel1Rect), Y(self.origLabel1Rect), W(self.origLabel1Rect) + EXPEND_WIDTH, H(self.origLabel1Rect))];
//    [self.label2 setFrame:CGRectMake(X(self.origLabel2Rect), Y(self.origLabel2Rect), W(self.origLabel2Rect) + EXPEND_WIDTH, H(self.origLabel2Rect))];
//    [self.label3 setFrame:CGRectMake(X(self.origLabel3Rect), Y(self.origLabel3Rect), W(self.origLabel3Rect) + EXPEND_WIDTH, H(self.origLabel3Rect))];
//    [self.label4 setFrame:CGRectMake(X(self.origLabel4Rect), Y(self.origLabel4Rect), W(self.origLabel4Rect) + EXPEND_WIDTH, H(self.origLabel4Rect))];
//    [self.label5 setFrame:CGRectMake(X(self.origLabel5Rect), Y(self.origLabel5Rect), W(self.origLabel5Rect) + EXPEND_WIDTH, H(self.origLabel5Rect))];
//    
//    
//    
//    self.label1.text = @"二维码开门次数:";
//    self.label2.text = @"停车场累计收费总额:";
//    self.label3.text = @"海康摄像头在线情况:";
//    self.label4.text = @"门禁在线情况:";
//    self.label5.text = @"格美特道闸系统在线情况:";
//    
//    
//    self.areaLabel.text = @"";
//    self.receivable.text = @"";
//    self.paidIn.text = @"";
//    self.ratioLabel.text = @"";
//    self.satisfactionLabel.text = @"";
//    
//    self.amountLabel.text = @"";//1
//    self.complaintLabel.text = @"";//2
//    self.depotLabel.text = @"";//3
//    
//    self.label6.text = @"APP安装数:";
//    self.labelContent.text = @"";
//    [self.amountBtn setTitle:@" 业主投诉数:" forState:UIControlStateNormal];
//    [self.complaintBtn setTitle:@" 停车场非法起杆:" forState:UIControlStateNormal];
//    [self.depotBtn setTitle:@"" forState:UIControlStateNormal];
//}
//
//
//-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
//updatingLocation:(BOOL)updatingLocation
//{
//    if(updatingLocation)
//    {
//        //取出当前位置的坐标
////        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
//        CLLocationCoordinate2D center  = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//        [_mapView setCenterCoordinate:center];
//        
//
//        [self.mapView setRegion:(MACoordinateRegion){center, {0.07, 0.07}} animated:YES];
//        //调用获取附近小区
//        [self getPoiCommunityLocation:userLocation];
//        
//    }
//}
//
//-(void)getPoiCommunityLocation:(MAUserLocation *)userLocation
//{
//    if (userLocation) {
//        
//        
//        NSDictionary *dic = [LocalDataAccessor fetchOAUserInfo];
//        NSString *name = [dic objectForKey:@"name"];
//        
//        CLLocation *cuLocation = userLocation.location;
//        
//        if (cuLocation) {
//            
//            typeof(self) __block weakSelf = self;
//            [DiscoverData getPoiCommunityByUserName:name Lng:cuLocation.coordinate.longitude andLat:cuLocation.coordinate.latitude andRadius:@"3000" andBlockSuc:^(NSURL *url, id result) {
//                
//                [weakSelf retain];
//                DLog(@"获取POI People的返回信息 %@", [(NSDictionary *)result objectForKey:@"message"]);
//                NSMutableArray *content = [result objectForKey:@"content"];
//                
//                DLog(@"%@", content);
//                for (NSDictionary *area in content) {
//                    
//                    NSMutableDictionary *mArea = [NSMutableDictionary dictionaryWithDictionary:area];
////                    [mArea setObject:[area objectForKey:@"id"]forKey:@"uuid"];
//                    [weakSelf addCommunityToMapByInfo:mArea];
//                }
//                [weakSelf release];
//                
//            } BlockFailed:^(NSURL *url, NSError *error) {
//                
//                DLog(@"获取POI People返回错误 error:%@",[error localizedDescription]);
//            }];
//            
//        }
//    }
//}
//
//
//- (void)addCommunityToMapByInfo:(NSDictionary *)area{
//    
//    NSString *lng = [area objectForKey:@"lng"];
//    NSString *lat = [area objectForKey:@"lat"];
//    CLLocationDegrees longitude = [lng doubleValue];
//    CLLocationDegrees latitude = [lat doubleValue];
//    
////    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
////    pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
////    pointAnnotation.title = name;
//////    pointAnnotation.subtitle = detail;
//    
//    AreaApAnnotation *pointAnnotation = [[[AreaApAnnotation alloc] init] autorelease];
//    pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
//    pointAnnotation.info = area;
//    
//    [_mapView addAnnotation:pointAnnotation];
//}
//
//#pragma mark --获取用户branch id
//
////- (void)getUserBranchID {
////    
////    NSDictionary *dic = [LocalDataAccessor fetchOAUserInfo];
////    if (!dic) {
////        return;
////    }
////    
////    NSString *name = [dic objectForKey:@"name"];
//////    NSString *key = [NSString stringWithFormat:FUNCTION,name];
////    
////    //    [[WTAppDelegate sharedAppDelegate] showLoading:@"获取用户信息..."];
////    
////    [HomeData getUserBranchIdByUserName:name andBlockSuc:^(NSURL *url, id result) {
////        
////        NSDictionary *data = (NSDictionary *)result;
////        DLog(@"%@", data);
////        DLog(@"%@", [data objectForKey:@"message"]);
////        
////        if (![ISNull isNilOfSender:data]&&[[data objectForKey:@"code"] intValue]==0) {
////            
////            NSDictionary *content = (NSDictionary *)[data objectForKey:@"content"];
////            
////            if (content) {
////                
////                DLog(@"获取用户BranchID %@", content);
////                
////                self.bouchID = [content objectForKey:@"orgId"];
////                
////                [self.bouchID retain];
////                self.annotationType = 0;
////                self.level = 1;
////                
////                [self loadData];
////                [self loadAreaDetailData];
////                [self loadCommunityCount];
////                
//////                [ShareCache setDicCache:content ForKey:key];
////                
////                [[WTAppDelegate sharedAppDelegate] hideLoading];
////            }
////        } else {
////            
////            [[WTAppDelegate sharedAppDelegate] hideLoadingWithErr:@"发生错误" WithInterval:1.0f];
////        }
////        
////    } BlockFailed:^(NSURL *url, NSError *error) {
////        
////        
////        //        DLog(@"获取用户 BranchID  错误 error:%@",[error localizedDescription]);
////        [[WTAppDelegate sharedAppDelegate] hideLoadingWithErr:[error localizedDescription] WithInterval:1.0f];
////    }];
////}
//
//- (void)setTitleText:(NSString *)text {
//    CGSize size = [text sizeByOneLineWithFont:self.titleLabel.font textLabelFrame:self.titleLabel.frame];
//    self.titleLabel.frame = CGRectMake(0, 0, size.width, size.height);
//    self.titleLabel.text = text;
//    self.titleScrollLable.contentSize = self.titleLabel.frame.size;
//    if (self.titleScrollLable.contentSize.width <= self.titleScrollLable.frameSize.width) {
//        self.titleLabel.center = CGPointMake(self.titleScrollLable.frameSize.width/2, self.titleScrollLable.frameSize.height/2);
//    }
//}


@end
