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

@end
