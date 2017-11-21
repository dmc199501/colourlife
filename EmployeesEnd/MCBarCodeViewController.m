//
//  MCBarCodeViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/10.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCBarCodeViewController.h"

@implementation MCBarCodeViewController
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
    x = rect.origin.y / readerViewBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / readerViewBounds.size.width;
    width = rect.size.height / readerViewBounds.size.height;
    height = rect.size.width / readerViewBounds.size.width;
    
    return CGRectMake(x, y, width, height);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"扫条码";
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //    readerView = [[ZBarReaderView alloc]initWithImageScanner:nil];
    readerView = [[ZBarReaderView alloc]init];
    [readerView setBackgroundColor:[UIColor blackColor]];
    
    [readerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    readerView.readerDelegate = self;
    //关闭闪光灯
    readerView.torchMode = 0;
    //    //扫描区域
    //    CGRect scanMaskRect = CGRectMake(readerX, readerY, readerW, readerH) ;
    //扫描区域计算
    //    readerView.scanCrop = CGRectMake(0, 0, readerView.frame.size.width, readerView.frame.size.height);
    readerView.scanCrop = [self getScanCrop:CGRectMake(20, 120, self.view.frame.size.width - 40, 130) readerViewBounds:readerView.bounds];
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR)
    {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = readerView;
    }
    [self.view addSubview:readerView];
    
    
    //透明区域
    
    UIImageView *img_top = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    [img_top setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]] ;
    [self.view addSubview:img_top] ;
    
    
    UIImageView *img_foot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 120, 20, 130)];
    [img_foot setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]] ;
    [self.view addSubview:img_foot] ;
    
    
    UIImageView *img_left = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 20, 120, self.view.frame.size.width, 130)];
    [img_left setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]] ;
    [self.view addSubview:img_left] ;
    
    
    
    UIImageView *img_right = [[UIImageView alloc] initWithFrame:CGRectMake(0, 120 + 130, self.view.frame.size.width, self.view.frame.size.height - 120 - 130)];
    [img_right setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]] ;
    [self.view addSubview:img_right] ;
    
    UIImageView *maskImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 120, self.view.frame.size.width - 40, 130)];
    [maskImageView setImage:[UIImage imageNamed:@"barcode_box"]];
    [self.view addSubview:maskImageView];
    
    UILabel *lab_top2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 100)];
    [lab_top2 setBackgroundColor:[UIColor clearColor]] ;
    [lab_top2 setTextColor:[UIColor whiteColor]] ;
    lab_top2.textAlignment = NSTextAlignmentCenter;
    [lab_top2 setText:@"将条码放入框内，\r\n即可自动扫描快递单号"] ;
    //设置换行
    lab_top2.numberOfLines = 0;
    
    [self.view addSubview:lab_top2];
    
    [readerView start];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)codeCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

//获取返回值
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    NSString *codeRes = @"" ;
    for (ZBarSymbol *symbol in symbols) {
        codeRes = symbol.data ;
        NSLog(@"%@", codeRes);
        break;
    }
    
    
    if ([_delegate respondsToSelector:@selector(barCodeViewController:codeString:)])
    {
        [_delegate barCodeViewController:self codeString:codeRes];
    }
    
    //    //判断是否包含 头'http:'
    //    NSString *regex = @"http+:[^\\s]*";
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //
    //
    //    if ([predicate evaluateWithObject:codeRes]) {
    //        NSURL *url = [NSURL URLWithString:codeRes];
    //        [[UIApplication sharedApplication]openURL:url];
    //    }else{
    //        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
    //                                                        message:codeRes
    //                                                       delegate:nil
    //                                              cancelButtonTitle:@"Close"
    //                                              otherButtonTitles:@"Ok", nil];
    //        [alert show];
    //
    //    }
    //
    
    
    
    //[self.readerView stop];
    
    //NSURL *url = [NSURL URLWithString:urlStr];
    //[[UIApplication sharedApplication]openURL:url];
}

@end
