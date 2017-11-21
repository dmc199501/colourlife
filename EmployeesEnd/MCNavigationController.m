//
//  MCNavigationController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//
#define  DARK_COLOER_ZZ   [UIColor colorWithRed:44 / 255.0 green:54 / 255.0 blue:64/ 255.0 alpha:1]  //
#import "MCNavigationController.h"
#import "MCWebViewController.h"
#import <QuickLook/QuickLook.h>
@interface MCNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSDictionary *noticeDic;
@property (assign, nonatomic) BOOL isSwitching;
@property (assign, nonatomic) BOOL isCanSideBack;

@end

@implementation MCNavigationController
+ (void)initialize{
    
    // 1 .设置导航栏的主题
    UINavigationBar *navBar = [UINavigationBar appearance];
    //（1）设置背景图片
    
    [navBar setBarTintColor:DARK_COLOER_ZZ];
    navBar.translucent = NO;
    //（2）设置标题文字的属性－－颜色，字体大小
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize: 18];
    navBar.titleTextAttributes = attrs;
    
    //----------------------------------------------------------------
    // 2 .设置导航条上面的导航按钮的主题（字体颜色， 字体大小）
    // (1)
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize: 15];
    [item setTitleTextAttributes: itemAttrs forState: UIControlStateNormal];
    // (2)设置返回剪头的的颜色（实际上设置的是导航栏的背景颜色）
    navBar.tintColor = [UIColor whiteColor]; //设置为了白色
    
    
}


//重写Push这个方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
        if (self.childViewControllers.count) {
//     viewController.hidesBottomBarWhenPushed = YES; //表示push到下一个页面的时候隐藏标签栏
            
            
        NSArray *vcArray = self.navigationController.viewControllers;
        
        
        for(UIViewController *vc in vcArray)
        {
            if ([vc isKindOfClass:[QLPreviewController class]])
            {
                UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(popCurrentViewController)];
                
                 viewController.navigationItem.leftBarButtonItem = left;
            }else{
            
                UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(popCurrentViewController)];
                
                
                viewController.navigationItem.leftBarButtonItem = left;

            }
    }
        

       
    }

//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = YES;
//    }
   [super pushViewController:viewController animated:animated];
    
    
    
    
    
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)popCurrentViewController
{
    
    [self popViewControllerAnimated:YES];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
       
    //[self setUpAllChildViewController];
    
//    __weak typeof (self) weakSelf = self;
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.delegate = weakSelf;
//    }
//   // [self getPromptData];
//    NSLog(@"-----------------------------------");
   
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self resetSideBack];
}
// 禁用边缘返回
-(void)forbiddenSideBack
{
    self.isCanSideBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate= self;
    }
}
// 恢复边缘返回
- (void)resetSideBack
{
    self.isCanSideBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    return self.isCanSideBack;
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

@end
