//
//  ScannerViewController.m
//  WeiTown
//
//  Created by 沿途の风景 on 14-8-26.
//  Copyright (c) 2014年 Hairon. All rights reserved.
//
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height>=1136) : NO)
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#import "ScannerViewController.h"
#import "UIView+Helper.h"
@interface ScannerViewController ()

@property (nonatomic, retain) UIButton *lightBtn;
@property (nonatomic,retain) UIButton *carportBnt;//开启车库闸门
@property (nonatomic,retain) UIButton *helpBnt;//紧急求救
@end

@implementation ScannerViewController

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
    
    [self setupCamera];
    
    [self prepareScanView];
    
}

- (void)prepareScanView
{
    UIImageView *readerBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    if (IS_IPHONE_5) {
        readerBg.image = [UIImage imageNamed:@"scan5_bg.png"];
    }
    else {
        readerBg.image = [UIImage imageNamed:@"scan4_bg.png"];
    }
    readerBg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:readerBg];
    
    
    //test
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,460 , 100, 20)];
    //    label.text = @"New iOS7 Scan";
    //    [self.view addSubview:label];
    //    [label release];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 26, 55, 33);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_white.png"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(scanCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIImageView *retArrow = [[UIImageView alloc] initWithFrame:CGRectMake(12, 33, 11, 18)];
    retArrow.image = [UIImage imageNamed:@"ret_arrow"];
    [self.view addSubview:retArrow];
    
    
    //开启相机闪光灯按钮
    self.lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lightBtn.frame =  CGRectMake(260, 25, 35, 35);
    _lightBtn.backgroundColor = [UIColor clearColor];
    _lightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_lightBtn setBackgroundImage:[UIImage imageNamed:@"saomiao_button_01.png"] forState:UIControlStateNormal];
//    [_lightBtn setBackgroundImage:[UIImage imageNamed:@"saomiao_button_02.png"] forState:UIControlStateSelected];
    [_lightBtn addTarget:self action:@selector(openCameraFlashlight:) forControlEvents:UIControlEventTouchUpInside];
    //对当前设备做出判断
//    NSString *realnum = [NSString stringWithFormat:@"tel://%@",@"18842652090"];
//    NSURL *callUrl=[NSURL URLWithString:realnum];
//    if (![[UIApplication sharedApplication] openURL:callUrl]) {
//        _lightBtn.hidden = YES;
//    }
    //开启车库闸门
    self.carportBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _carportBnt.frame = CGRectMake(200, 390, 101, 37);
    _carportBnt.backgroundColor = [UIColor clearColor];
    _carportBnt.titleLabel.font = [UIFont systemFontOfSize:15];
    [_carportBnt setBackgroundImage:[UIImage imageNamed:@"saomiao_button_04.png"] forState:UIControlStateNormal];
    [_carportBnt addTarget:self action:@selector(openCarportBntClick:) forControlEvents:UIControlEventTouchUpInside];
    _carportBnt.hidden=YES;
    //紧急求救
    self.helpBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _helpBnt.frame = CGRectMake(20, 390, 101, 37);
    _helpBnt.backgroundColor = [UIColor clearColor];
    _helpBnt.titleLabel.font = [UIFont systemFontOfSize:15];
    [_helpBnt setBackgroundImage:[UIImage imageNamed:@"saomiao_button_03.png"] forState:UIControlStateNormal];
    [_helpBnt addTarget:self action:@selector(helpBntClick:) forControlEvents:UIControlEventTouchUpInside];
    _helpBnt.hidden=YES;
    
    if (IS_IPHONE_5) {
        // _lightBtn.frameOriginY = 390;
        _carportBnt.frameOriginY = 400;
        _helpBnt.frameOriginY = 400;
    }
    
    [self.view addSubview:_lightBtn];
    [self.view addSubview:_carportBnt];
    [self.view addSubview:_helpBnt];
    //扫描线
    UIImageView *scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 125, 320, 29)];
    scanLine.image = [UIImage imageNamed:@"scan_line"];
    scanLine.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scanLine];
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    theAnimation.duration=2.f;
    theAnimation.repeatCount=FLT_MAX;
    theAnimation.autoreverses=NO;
    theAnimation.removedOnCompletion=NO;
    if (IS_IPHONE_5) {
        CGRect rect = scanLine.frame;
        rect.origin.y += 35;
        scanLine.frame = rect;
        
        theAnimation.toValue=[NSNumber numberWithFloat:190];
    }
    else {
        theAnimation.toValue=[NSNumber numberWithFloat:185];
    }
    
    [scanLine.layer addAnimation:theAnimation forKey:@"animateLayer"];
}
#pragma mark --点击开启车库闸门按钮
- (void)openCarportBntClick:(id)sender{
    //回到主界面
//    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedItemAtIndex:)]) {
//        [self.delegate selectedItemAtIndex:0];
//    }
    //返回权限值
    [[NSNotificationCenter defaultCenter] postNotificationName:@"qrCodeScanSuccess" object:@"http://kkt.me/dr/-1"];
//    [self dismissModalViewControllerAnimated:YES];
    
     [self dismissViewControllerAnimated:NO completion:nil];
    
    
    
}
#pragma mark --紧急求助按钮
- (void)helpBntClick:(id)sender{
    
    
}
//开启闪光灯
- (void)openCameraFlashlight:(id)sender
{
    if (self.device.torchMode == AVCaptureTorchModeOff) {
        [self.device lockForConfiguration:nil];
        self.device.torchMode = AVCaptureTorchModeOn;//开启
        [self.device unlockForConfiguration];
        //[self.lightBtn setTitle:@"关闭闪光灯" forState:UIControlStateNormal];
        [_lightBtn setBackgroundImage:[UIImage imageNamed:@"saomiao_button_02.png"] forState:UIControlStateNormal];
    }
    else if (self.device.torchMode == AVCaptureTorchModeOn) {
        [self.device lockForConfiguration:nil];
        self.device.torchMode = AVCaptureTorchModeOff;//关闭
        [self.device unlockForConfiguration];
        //[self.lightBtn setTitle:@"开启闪光灯" forState:UIControlStateNormal];
        [_lightBtn setBackgroundImage:[UIImage imageNamed:@"saomiao_button_01.png"] forState:UIControlStateNormal];
    }
}

- (void)setupCamera
{
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Session
    self.session = [[AVCaptureSession alloc] init ];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    @try {
        
        // 条码类型 AVMetadataObjectTypeQRCode
        self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的 设置-隐私-相机 中允许访问相机。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
       
    }
    @finally {
        
    }
    
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [self.session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    for(AVMetadataObject *current in metadataObjects) {
        
        if ([current.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            if([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
                
                NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
                
                if (scannedValue.length != 0) {
                    //播放扫描声音
                    [self playScanSound];
                    [self.session stopRunning];
                    
                    //将扫描结果通知首页（处理扫描结果）
                    NSLog(@"############################################## Scaner : %@",scannedValue);
                    
                    
                    
                    if (self.isWeb) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"qrCodeScanSuccess_html5" object:scannedValue];
                        
                    } else {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"qrCodeScanSuccess" object:scannedValue];
                    }
                    
                    [self dismissViewControllerAnimated:NO completion:nil];
                    
                }
            }
        }
    }
    
}

#pragma mark - 取消扫描

- (void)scanCancel
{
    [self.session stopRunning];
    //回到首页
//    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedItemAtIndex:)]) {
//        [self.delegate selectedItemAtIndex:0];
//    }
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - 播放扫描声音

- (void)playScanSound
{
    //系统音频ID，用来注册我们将要播放的声音
    SystemSoundID scanSoundID;
    //音乐文件路径
    CFURLRef thesoundURL = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"caf"]];
    //变量SoundID与URL对应
    AudioServicesCreateSystemSoundID(thesoundURL, &scanSoundID);
    //播放SoundID声音
    AudioServicesPlaySystemSound(scanSoundID);
}

#pragma mark - delloc

- (void)dealloc
{
   
   
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
