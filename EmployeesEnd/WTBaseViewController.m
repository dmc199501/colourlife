//
//  WTBaseViewController.m
//  WeiTown
//
//  Created by 沿途の风景 on 14-8-8.
//  Copyright (c) 2014年 Hairon. All rights reserved.
//
#define BACKGROUNDCOLOR UIColorFromRGB(0xf1f1f1)    //背景色
#define CELLLINECOLOR UIColorFromRGB(0xbdd3d9)  //分割线
#import "WTBaseViewController.h"


@interface WTBaseViewController ()

@end

@implementation WTBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //iOS7 导航栏
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 20)];
        //stateView.backgroundColor = [UIColor colorWithRed:65.0f/255.0f green:6.0f/255.0f blue:115.0f/255.0f alpha:1];
       // _barView.backgroundColor = HAPPYCLOUD;//84,27,134
        [self.view addSubview:_barView];
 
    }
    
    //设置统一的背景颜色
//    self.view.backgroundColor = [UIColor redColor];
//    self.navTitle.textColor = [UIColor whiteColor];
    
}

-(void)hideBaseKeyboardClicked:(id)sender
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self adjustVCForHotspot];
}

- (void)adjustVCForHotspot {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat statusHeight = statusBarFrame.size.height;
    
    CGRect origViewFrame = self.view.frame;
    if (statusHeight == 40) { //tabBarHeight/2
        self.view.frame = CGRectMake(CGRectGetMinX(origViewFrame), CGRectGetMinY(origViewFrame), CGRectGetWidth(origViewFrame), CGRectGetHeight(origViewFrame) - 20);
    } else {
//        self.view.frame = CGRectMake(CGRectGetMinX(origViewFrame), CGRectGetMinY(origViewFrame), CGRectGetWidth(origViewFrame), CGRectGetHeight(origViewFrame));
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 用于管理网络连接

//-(void)goBackCancelRequest
//{
//    [[WTAppDelegate sharedAppDelegate] hideLoading];
//    
//    [self clearRequest];
//}
//
//-(void)clearRequest
//{
//    if (_requestURLs!=nil&&[_requestURLs count]>0) {
//        [ShareAPI cancelAllRequest:_requestURLs];
//        [_requestURLs removeAllObjects];
//    }
//}
//
//- (void)removeRequestedURL: (NSURL *)url {
//    
//    if (url==nil) {
//        return;
//    }
//    
//    for (int i=0;i<_requestURLs.count; ) {
//        if ([[(NSURL *)[_requestURLs objectAtIndex:i] absoluteString] isEqualToString:[url absoluteString]]) {
//            [_requestURLs removeObjectAtIndex:i];
//        }
//        else {
//            i++;
//        }
//    }
//}
//
//-(void)addRequestedURL: (NSURL *)url
//{
//    if (_requestURLs) {
//        [_requestURLs addObject:url];
//    }
//}


-(void)dealloc
{
//    [_requestURLs release],_requestURLs=nil;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
