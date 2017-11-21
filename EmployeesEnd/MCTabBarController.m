//
//  MCTabBarController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCTabBarController.h"
#import "MCMicroServiceControl.h"
#import "MCAddressBookController.h"
#import "MCMemberCenterController.h"
#import "MCHomePageController.h"
#import "UIImage+image.h"
#import "MCNavigationController.h"
#import "MCWebViewController.h"
#import "AudioToolbox/AudioToolbox.h"
#import "MCGeneralHomeViewController.h"
#import "MCZZHomeViewController.h"
@interface MCTabBarController ()
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSDictionary *noticeDic;


@end

@implementation MCTabBarController
- (NSMutableArray *)items
{
    if (_items == nil) {
        
        _items = [NSMutableArray array];
        
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    self.date = [defaults objectForKey:@"date"];
    
    
    [self setUpAllChildViewController];
    
   
    //[self getPromptData];
//    NSLog(@"-----------------------------------");
//    
    
    
}


- (void)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *token  = [defaults objectForKey:@"access_token"];;
     NSString *username = [defaults objectForKey:@"userName"];//根据键值取
    
    
    NSString * URLString = self.noticeDic[@"HTML5url"];
    NSString *URLstring = @"";
    if ([URLString rangeOfString:@"?"].location != NSNotFound) {
        URLstring = [NSString stringWithFormat:@"%@&username=%@&access_token=%@",URLString,username,token];
    }else{
        URLstring = [NSString stringWithFormat:@"%@?username=%@&access_token=%@",URLString,username,token];
        
    }
    
    

    MCWebViewController *wbViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring] titleString:self.noticeDic[@"weiappname"]];
    wbViewController.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:wbViewController animated:YES];
    }


- (void)setUpAllChildViewController
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
   
    NSString *corpType = [defaults objectForKey:@"corpType"];
    
    if ([corpType isEqualToString:@"100"] && corpType.length>0) {
        //通用皮肤
        
        MCGeneralHomeViewController *home = [[MCGeneralHomeViewController alloc] init];
        [self setUpOneChildViewController:home image:[UIImage imageNamed:@"homepage@3x"] selectedImage:[UIImage imageWithOriginalName:@"homepage_fill"] title:@"首页"];
        
        
    } else
    
    if([corpType isEqualToString:@"101"] && corpType.length>0){
        
        MCHomePageController *home = [[MCHomePageController alloc] init];
        [self setUpOneChildViewController:home image:[UIImage imageNamed:@"homepage@3x"] selectedImage:[UIImage imageWithOriginalName:@"homepage_fill"] title:@"首页"];
        
        //彩管家4.0
    }else{
    // 中柱
        MCZZHomeViewController *home = [[MCZZHomeViewController alloc] init];
        [self setUpOneChildViewController:home image:[UIImage imageNamed:@"homepage@3x"] selectedImage:[UIImage imageWithOriginalName:@"homepage_fill"] title:@"首页"];
        

    
    }

    // 首页
   
    //home.view.backgroundColor = [UIColor whiteColor];
    
    // 通讯录
    MCAddressBookController *addressBookVC = [[MCAddressBookController alloc] init];
    [self setUpOneChildViewController:addressBookVC image:[UIImage imageNamed:@"addressbook@2x.png"] selectedImage:[UIImage imageWithOriginalName:@"addressbook_fill"] title:@"联系人"];
    // message.view.backgroundColor = [UIColor blueColor];
    
    // 微服务
    MCMicroServiceControl *serviceVC = [[MCMicroServiceControl alloc] init];
    [self setUpOneChildViewController:serviceVC image:[UIImage imageNamed:@"manage@3x"] selectedImage:[UIImage imageWithOriginalName:@"manage_fill"] title:@"工作"];
    // Neighborhood.view.backgroundColor = [UIColor purpleColor];
    
    
    // 我
    MCMemberCenterController *my = [[MCMemberCenterController alloc] init];
    [self setUpOneChildViewController:my image:[UIImage imageNamed:@"people@2x.png"] selectedImage:[UIImage imageWithOriginalName:@"people_fill"] title:@"我的"];
    
    
    
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
