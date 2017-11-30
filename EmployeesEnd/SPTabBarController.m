//
//  SPTabBarController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/16.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "SPTabBarController.h"
#import "UIImage+image.h"
#import "MCNavigationController.h"
#import "MCShopViewController.h"
#import "MCServiceViewController.h"
#import "MCShopMyViewController.h"
@interface SPTabBarController ()

@end

@implementation SPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUpAllChildViewController];
    
    //[self setUpTabBar];
   
    //    NSLog(@"-----------------------------------");
    //
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUpAllChildViewController
{
    // 首页
    MCShopViewController *shop = [[MCShopViewController alloc] init];
    [self setUpOneChildViewController:shop image:[UIImage imageNamed:@"shouye_1"] selectedImage:[UIImage imageWithOriginalName:@"shouye_2"] title:@"格外商家"];
    //home.view.backgroundColor = [UIColor whiteColor];
    
    
       // 微服务
    MCServiceViewController *serviceVC = [[MCServiceViewController alloc] init];
    [self setUpOneChildViewController:serviceVC image:[UIImage imageNamed:@"SPweifiwu_1"] selectedImage:[UIImage imageWithOriginalName:@"SPweifiwu_2"] title:@"微服务"];
    // Neighborhood.view.backgroundColor = [UIColor purpleColor];
    
    
    // 我
    MCShopMyViewController *my = [[MCShopMyViewController alloc] init];
    [self setUpOneChildViewController:my image:[UIImage imageNamed:@"wode_1"] selectedImage:[UIImage imageWithOriginalName:@"wode_2"] title:@"我的"];
    
    
    
}


#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = image;
    
    
    vc.tabBarItem.selectedImage = selectedImage;
    
    MCNavigationController *nav = [[MCNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
    
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
