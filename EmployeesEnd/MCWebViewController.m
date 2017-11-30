//
//  MCWebViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/9.
//  Copyright © 2016年 邓梦超. All rights reserved.
//
#define DOWN_TAG        @"download"//下载
#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5
#import "MCWebViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "APIKey.h"
#import "MainViewController.h"
#import "SerialLocationViewController.h"
#import  <JavaScriptCore/JavaScriptCore.h>
#import "APService.h"
#import "DownListManager.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "Base64.h"
#import "LocationManager.h"
#import "CLLocation+YCLocation.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

@interface MCWebViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate,AMapSearchDelegate>{
    
        NSURLConnection *theConnection;
    

}

@property (nonatomic, strong) UISegmentedControl *showSegment;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;
@property (retain, nonatomic) AMapSearchAPI *mapSearch;
@property (retain, nonatomic) AMapReGeocodeSearchRequest *regeo;
@property (retain, nonatomic) AMapSearchAPI *mapSearchs;

@end

@implementation MCWebViewController


- (id)initWithTitleString:(NSString *)titleString{
    
    self = [super init];
    if (self)
    {
        self.titleString = titleString;
    }
    
    return self;
    
}

- (id)initWithUrl:(NSURL *)url titleString:(NSString *)titleString
{
    self = [super init];
    if (self)
    {
        self.url = url;
        self.titleString = titleString;
    }
    
    return self;
    
}

- (id)initWithLoadHtmlString:(NSString *)loadHtmlString titleString:(NSString *)titleString;
{
    self = [super init];
    if (self)
    {
        self.loadHtmlString = loadHtmlString;
        self.titleString = titleString;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
//    self.mapSearch = [[AMapSearchAPI alloc] init];
//    self.mapSearch.delegate = self;
      self.tol = 0;
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_close_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(right1Click)];
    
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_refresh_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(newLoad)];
    //right2.width = -50;
    
    //添加到导航栏的右边（一个）
    self.navigationItem.rightBarButtonItem = right2;
    //右边数组里面有几个，就出现几个  （由右向左）（多个）
    //左边的话是由左向右的
    self.navigationItem.rightBarButtonItems = @[right2,right1];
    
    self.navigationItem.title = _titleString;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(returnUp)];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64 )];
    [self.view addSubview:self.webView];
     
   
    _webView.delegate = self;
//    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"test(1).html" withExtension:nil];
//    _webView.delegate = self;
//    NSURLRequest * request=[NSURLRequest requestWithURL:filePath];
//    [_webView loadRequest:request];
   [self loadHtml];
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _weakHub = hub;
    hub.opacity = 1.0;
    [hub setDetailsLabelText:@"正在加载网页..."];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    
   [super viewWillAppear:YES];
   
    
    
    
}

#pragma mark -返回上一级
- (void)rebackToRootViewAction {
    NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults]; [pushJudge setObject:@""forKey:@"push"]; [pushJudge synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (void)right1Click{
    //[self cleanCacheAndCookie];
    
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]){
        [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:@""forKey:@"push"];
        [pushJudge synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }else{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 清除缓存
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    
    
    
   
}

#pragma mark 加载url
- (void)loadHtml{
    
    NSMutableString * uglyMutableString = [[NSMutableString alloc] initWithString:[self.url absoluteString ]];
    NSRange range = [uglyMutableString rangeOfString:@" "];
    while (!(range.location == NSNotFound && range.length == 0)) {
        [uglyMutableString replaceCharactersInRange:range withString:@"-"];
        range = [uglyMutableString rangeOfString:@" "];
    }
    
    NSString * cleanString = [NSString stringWithString:uglyMutableString];
    NSURL * url = [[NSURL alloc] initWithString:cleanString];
   
    if (url)
    {
        
  [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        
        
    }
    else if(self.loadHtmlString)
    {
        [self.webView loadHTMLString:self.loadHtmlString baseURL:nil];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    }else{
        
       

    }
    
    
    
}

#pragma mark - UIWebViewDelegate代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [self.view.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
    
       
    
}


- (void)newLoad{
    self.tol = 0;
    [self.webView reload];
    
}

#pragma mark - 页面返回方法
- (void)returnUp{


    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
    }else{
        NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
        
       if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]){
            [NSUserDefaults standardUserDefaults];
            [pushJudge setObject:@""forKey:@"push"];
            [pushJudge synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
        
        
        }else{
        [self.view resignFirstResponder];
        //[self cleanUpAction];
        //[self cleanCacheAndCookie];
           
        [self.navigationController popViewControllerAnimated:YES];
        }
    }

}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_progressLayer finishedLoad];
     NSString *sss =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取
    self.navigationItem.title = sss;
    CGSize contentSize = _webView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
   
    float rw = viewSize.width / contentSize.width;
    
    
    _webView.scrollView.minimumZoomScale = rw;
    _webView.scrollView.maximumZoomScale = rw;
    _webView.scrollView.zoomScale = rw;

    
     [_weakHub hide:YES];
    //
    NSString *identifierForVendor1 = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
        NSDictionary *IDDic = @{@"message":@"deviceId",@"content":@{@"registrationId":identifierForVendor1},@"code":@"0"};
        
        NSString *appleID=[NSString stringWithFormat:@"returnByNativeWithResult('%@')",[self convertToJsonData:IDDic]]; //准备执行的js代码
        NSLog(@"%@",appleID);
        //[context evaluateScript:appleID];//通过oc方法调用js的alert
    
    
    
}
#pragma mark - 文件柜分享
- (void)setShare:(NSString *)url and:(NSString *)title{
    NSArray* imageArray = @[[UIImage imageNamed:@"cgjshare.png"]];
    
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:title
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:@"彩管家"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    
    


}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlString = [[request URL] absoluteString];
    
    
    
    NSArray *urlComps = [urlString componentsSeparatedByString:@":///"];
    if ([urlString containsString:@"cgj://share"]) {
         NSString *str = [urlString stringByReplacingOccurrencesOfString:@"cgj://share?url=" withString:@""];
        NSArray *strArray=[str  componentsSeparatedByString:@"&name="];
        NSString *url = @"";
        NSString *title = @"";
        if (strArray.count==2) {
            url = [strArray objectAtIndex:0];
            title = [strArray objectAtIndex:1];
           
       
            
        }
      NSString *strA =  [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",strA);
        [self setShare:url and:strA];
    }
       if ([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"colour"]) {
        
        NSString *funcStr = [urlComps objectAtIndex:1];
        NSLog(@"%@",funcStr);
        if ([funcStr isEqualToString:DOWN_TAG]) {
            
            if ([urlComps count] > 2) {
                
                NSString *downloadURLString = [urlComps objectAtIndex:2];
                
                NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:downloadURLString]];
                
                NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
                
                [self.connArray addObject:conn];
            }
           
            }
        else if ([funcStr isEqualToString:@"coordinate"]) {
 
            [self getCoordinate];
            

        }
        else if ([funcStr isEqualToString:@"deviceId"]) {
            [self getdeviceId];
            
        }else if ([funcStr isEqualToString:@"file"]) {
            [self popUploader];
            
        }else if ([funcStr isEqualToString:@"refresh"]){
            [self newLoad];
        }else if ([funcStr isEqualToString:@"return"]){
        
            [self returnUp];
        
        }else if ([funcStr isEqualToString:@"shutDown"]){
            [self right1Click];
        
        }
           
    
    
    }
    if ([[[request URL] scheme] isEqualToString:@"tel"]) {
        
        return YES;
    }

    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:request.URL];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
        
        [self.connArray addObject:conn];
        
        return NO;
    }

    NSString *url = request.URL.absoluteString;
    
    if ([url containsString:@"weitiao"]){
       self.tol +=1;
    }
    NSLog(@"跳转的URL:%@",url);
   
  
    
   
    
    
    return YES;
    
}

#pragma mark -- get lng lat



- (void)getCoordinate {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLocationOnce:) name:@"GETLOCATIONONCEFORHTML5" object:nil];
    
    LocationManager *manager = [LocationManager sharedInstance];
    
    [manager startLocation];
}

-(void)handleLocationOnce:(NSNotification *)noti
{
    if (noti) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GETLOCATIONONCEFORHTML5" object:nil];
        
        CLLocation *cuLocation = (CLLocation *)noti.object;
        NSLog(@"%@",cuLocation);
        if (cuLocation) {
            
            cuLocation = cuLocation.locationMarsFromEarth;
           
           // [self reverseGeoWithLng:cuLocation.coordinate.longitude andLat:cuLocation.coordinate.latitude];
           
            NSString *retStr = [self toJSONStringWithDictionary:@{@"longitude": @(cuLocation.coordinate.longitude), @"latitude": @(cuLocation.coordinate.latitude), @"province": @"", @"city":@"", @"district":@"", @"address":@""} andFunctionCode:@"coordinate"];
//
            [self nativeCallJSWithParamsByFunctionCode:@"coordinate" andData:retStr];
            
            
        } else {
            
            NSString *retStr = [self toJSONStringWithDictionary:nil andFunctionCode:@"coordinate"];
            [self nativeCallJSWithParamsByFunctionCode:@"coordinate" andData:retStr];
        }
    }
}
#pragma mark - 逆地理编码
//逆地址编码
- (void)reverseGeoWithLng:(double)lng andLat:(double)lat {
    
    //构造AMapReGeocodeSearchRequest对象  118.083943,24.444355
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:lat longitude:lng];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [self.mapSearch AMapReGoecodeSearch: regeo];

    
   
}
#pragma mark - 实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
   
    
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *address = [NSString stringWithFormat:@"%@", response.regeocode.formattedAddress];
        NSString *province = response.regeocode.addressComponent.province;
        NSString *city =     response.regeocode.addressComponent.city;
        NSString *district = response.regeocode.addressComponent.district;
        
        NSString *lng = [NSString stringWithFormat:@"%lf", request.location.longitude];
        NSString *lat = [NSString stringWithFormat:@"%lf", request.location.latitude];
        
        NSString *retStr = [self toJSONStringWithDictionary:@{@"longitude": lng, @"latitude": lat, @"province": province, @"city":city, @"district":district, @"address": address} andFunctionCode:@"coordinate"];
//         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:retStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"ok", nil];
//        [alert show];
        [self nativeCallJSWithParamsByFunctionCode:@"coordinate" andData:retStr];
        
        
    } else {
        
        NSString *retStr = [self toJSONStringWithDictionary:nil andFunctionCode:@"coordinate"];
        [self nativeCallJSWithParamsByFunctionCode:@"coordinate" andData:retStr];
    }
}

#pragma mark -- popUploader

- (void)popUploader {
    [self showChoosePhotoActionSheet];
    
    
}
- (void)showChoosePhotoActionSheet
{
    [self.view endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择", nil];
    [actionSheet showInView:self.view];
    
    
}
#pragma -mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    switch (buttonIndex)
    {
        case 0:
        {
            //[self showCamera];
            [self showPhotoLibary];
        }
            break;
        case 1:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)showPhotoLibary
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
    
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //    NSString *path = @"";
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            //得到图片
            UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            //            NSString *newFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent: @"temp.jpg"];
            NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
            
            if (imageData != nil) {
                
                NSString *dataStr = [Base64 encode:imageData];
                //                [imageData writeToFile:newFilePath atomically:YES];
                //                path = newFilePath;
                
                NSString *retStr = [self toJSONStringWithDictionary:@{@"bitmapToBase64": dataStr} andFunctionCode:@"camera"];
                [self nativeCallJSWithParamsByFunctionCode:@"camera" andData:retStr];
            }
            
        } else {
            
            //            NSURL* localUrl =(NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
            
            UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
            //            DLog(@"%@", [localUrl absoluteString]);
            //            path = [localUrl absoluteString];
            if (imageData != nil) {
                
                NSString *dataStr = [Base64 encode:imageData];
                
                
                NSString *retStr = [self toJSONStringWithDictionary:@{@"encodeBase64File": dataStr} andFunctionCode:@"file"];
                [self nativeCallJSWithParamsByFunctionCode:@"file" andData:retStr];
            }
            
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
   }

- (NSString *)toJSONStringWithDictionary:(NSDictionary *)dictionary andFunctionCode:(NSString *)code {
    
    NSDictionary *result = nil;
    if (dictionary != nil) {
        
        result = @{@"content":dictionary, @"message":code, @"code":@"0"};
    } else {
        
        result = @{@"content":@{}, @"message":code, @"code":@"1"};
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result
                                                       options:0
                                                         error:&error];
    if (! jsonData) {
        
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (void)getMapDatas{
    
    [self getMap];
   

    
    
    

}

- (void)getdeviceId{

NSString *identifierForVendor1 = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    NSDictionary *IDDic = @{@"message":@"deviceId",@"content":@{@"registrationId":identifierForVendor1},@"code":@"0"};
 [self nativeCallJSWithParamsByFunctionCode:@"deviceId" andData:[self convertToJsonData:IDDic]];

}

//OC调用JS
- (void)nativeCallJSWithParamsByFunctionCode:(NSString *)code andData:(NSString *)data {
    NSString *js = [NSString stringWithFormat:@"returnByNativeWithResult('%@');",data];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
   
       self.currDownFileName = [response suggestedFilename];;
    
    
    
    self.downloadedMutableData = [[NSMutableData alloc] init];
    self.urlResponse = response;
    
    NSString *mimeType = [response MIMEType];
    if ([mimeType isEqualToString:@"text/html"] || [mimeType containsString:@"htm"]) {
        
        [connection cancel];
        //        NSLog(@"调用的连接 %@", response.URL);
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:response.URL];
        [self.webView loadRequest:req];
        
        
    } else {
        
        
    }
   
    
    
   }


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    //    NSLog(@"Connection: didReceiveData");
    if ([_titleString isEqualToString:@"股票"]) {
    
    }else{
        [self.downloadedMutableData appendData:data];
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"下载中...(%.0f%%)",((100.0/self.urlResponse.expectedContentLength)*self.downloadedMutableData.length)]];
        float down = ((100.0/self.urlResponse.expectedContentLength)*self.downloadedMutableData.length);
        if (down == 100.0) {
            [SVProgressHUD showWithStatus:@"下载完成"];
            [SVProgressHUD dismiss];
        }

    }
        //    [[WTAppDelegate sharedAppDelegate] showLoading:[NSString stringWithFormat:@"下载中...(%.0f%%)", ((100.0/self.urlResponse.expectedContentLength)*self.downloadedMutableData.length)]];
//    
    //    NSLog(@"%.0f%%", ((100.0/self.urlResponse.expectedContentLength)*self.downloadedMutableData.length));
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //    NSLog(@"Connection: connectionDidFinishLoading");
    
    self.savedFilePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",self.currDownFileName );
    NSString *decodeFileName = [self.currDownFileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.savedFilePath =[self.savedFilePath stringByAppendingPathComponent:decodeFileName];
    
    NSLog(@"%@",self.savedFilePath);
    [self.downloadedMutableData writeToFile:self.savedFilePath atomically:YES];
    
    [DownListManager writeDownPlist:decodeFileName];
    
//    NSString *retStr = [self toJSONStringWithDictionary:@{@"status": @"下载完毕"} andFunctionCode:DOWN_TAG];
//    [self nativeCallJSWithParamsByFunctionCode:DOWN_TAG andData:retStr];
//    [[WTAppDelegate sharedAppDelegate] showSucMsg:@"下载完毕！" WithInterval:2.0];
    
    NSString *extent = [self.savedFilePath pathExtension];
    if ([extent isEqualToString:@"doc"] || [extent isEqualToString:@"docx"] || [extent isEqualToString:@"ppt"] || [extent isEqualToString:@"pptx"] || [extent isEqualToString:@"xls"] || [extent isEqualToString:@"xlsx"] || [extent isEqualToString:@"pdf"]) {
        
        //下载完毕后打开
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:self.savedFilePath]];
        [self.webView loadRequest:req];
        
    }
       
}

- (void)getMap{
    //[self configureAPIKey];
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    //self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    //self.locationManager.reGeocodeTimeout = 2;
    [self getmaop];
       // [self initToolBar];
    
    // [self initMapView];
    
    
}
- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}


- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
//    if ([_titleString isEqualToString:@"新e签到"]) {
//        [self reGeocodeAction];
//    }

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)setUrl:(NSURL *)url
{
    _url = url;
    //[self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    self.navigationItem.title = titleString;
    
}

#pragma mark - Action Handle

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
   
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}

- (void)reGeocodeAction
{
    //进行单次带逆地理定位请求
    NSLog(@"进行单次带逆地理定位请求");
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
    
    
}



#pragma mark - Initialization

- (void)getmaop{
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            NSString *province = [NSString stringWithFormat:@"%@",regeocode.province];
            NSString *district = [NSString stringWithFormat:@"%@",regeocode.district];
            NSString *city = [NSString stringWithFormat:@"%@",regeocode.city];
            NSLog(@"%@%@%@%lf%lf",province,district,city,location.coordinate.latitude,location.coordinate.longitude);
            _dic = @{@"message":@"coordinate",@"content":@{@"province":province,@"longitude":@(location.coordinate.longitude),@"latitude":@(location.coordinate.latitude),@"district":district,@"city":city},@"code":@"0"};
            [MCPublicDataSingleton sharePublicDataSingleton].mapDic = _dic;
            //NSLog(@"我是多少啊 啊啊啊  ----%d",_tol);
//            if (_tol == 0) {
//                NSLog(@"定位");
            
//                [self nativeCallJSWithParamsByFunctionCode:@"coordinate" andData:[self convertToJsonData:_dic]];
                
          //  }
            

        }
    }];


}

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
    self.mapString = mutStr;
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
@implementation NSURLRequest(DataController)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host

{
    
    return YES;
    
}

@end
