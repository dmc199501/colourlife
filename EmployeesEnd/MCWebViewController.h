//
//  MCWebViewController.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/9.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ProgressBar.h"
#import "WYWebProgressLayer.h"
#import <WebKit/WebKit.h>
@interface MCWebViewController : MCRootViewControler<UIWebViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>{
    
    NJKWebViewProgressView *_webViewProgressView;
    NJKWebViewProgress *_webViewProgress;
     WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
     NSString *identifierForVendor;
    
}
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIWebView *webView;
@property(nonatomic,strong)NSString *mapString;
@property(nonatomic,strong)NSData *mapData;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *loadHtmlString;
@property (nonatomic,strong) NSString *pidStr;
@property (nonatomic,assign)  NSInteger mids;
@property (retain, nonatomic) NSMutableArray *connArray;
@property (copy, nonatomic) NSString *currDownFileName;
@property (retain, nonatomic) NSMutableData *downloadedMutableData;
@property (retain, nonatomic) NSURLResponse *urlResponse;
@property (retain, nonatomic) NSString *savedFilePath;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property(nonatomic,strong)NSString *iosURL;
@property (nonatomic, retain) UIWebView *phoneCallWebView;
@property(retain,nonatomic) ProgressBar *progress;
@property(strong,nonatomic) NSString *push;
@property(nonatomic,strong)MBProgressHUD *weakHub;
@property (nonatomic, strong) MAMapView *mapView;
@property(nonatomic,assign)NSInteger tol;
@property (nonatomic, strong) AMapLocationManager *locationManager;

- (id)initWithTitleString:(NSString *)titleString;

- (id)initWithUrl:(NSURL *)url titleString:(NSString *)titleString;

- (id)initWithLoadHtmlString:(NSString *)loadHtmlString titleString:(NSString *)titleString;


@end
