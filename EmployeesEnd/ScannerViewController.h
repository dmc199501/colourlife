//
//  ScannerViewController.h
//  WeiTown
//
//  Created by 沿途の风景 on 14-8-26.
//  Copyright (c) 2014年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ScannerViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (retain,nonatomic)AVCaptureDevice * device;
@property (retain,nonatomic)AVCaptureDeviceInput * input;
@property (retain,nonatomic)AVCaptureMetadataOutput * output;
@property (retain,nonatomic)AVCaptureSession * session;
@property (retain,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (assign, nonatomic) BOOL isWeb;

//@property (nonatomic, assign) id<WTTabBarChinldVIewControllerDelegate>delegate;

@end
