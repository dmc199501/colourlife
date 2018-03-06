//
//  AppDelegate.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "AppDelegate.h"
#import "MCNavigationController.h"
#import "MCLoginViewControler.h"
#import "MCTabBarController.h"
#import "SPTabBarController.h"
#import <ColourlifeAuth/ColourlifeAuth.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "APIKey.h"
#import "MCWebViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"

#endif


@interface AppDelegate ()<JPUSHRegisterDelegate,AMapSearchDelegate>

@property (nonatomic, assign)int isPushData;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self chooseRoot];
        
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10以上
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //iOS8以上可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //iOS8以下categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    BOOL isProduction = YES;// NO为开发环境，YES为生产环境
    
    
    [JPUSHService setupWithOption:launchOptions appKey:@"a923c16ad07f805480d67b2b"
                          channel:@"channel"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    

    [self configureAPIKey];
    [self share];
   
    // Override point for customization after application launch.
    
    return YES;
}
- (void)share{
    [ShareSDK registerApp:@"215979e18d853"
     
          activePlatforms:@[
                            
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
                 
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx2cd55a3733a9aa2e"
                                       appSecret:@"2c64f186555de7b3eeca3d6203c4573a"];
                 break;
             
             default:
                 break;
         }
     }];
    
}

- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
    [AMapSearchServices sharedServices].apiKey = (NSString *)APIKey;

}

- (void)chooseRoot{
    
    // 创建tabBarVc
    
    //SPTabBarController *tabBarVc = [[SPTabBarController alloc]init];
    MCTabBarController *tabBarVc = [[MCTabBarController alloc]init];
    NSLog(@"----%@",tabBarVc.viewControllers);
   

    // 设置窗口的根控制器
    MCLoginViewControler *login = [[MCLoginViewControler alloc]init];
    
    MCNavigationController *nv = [[MCNavigationController alloc]initWithRootViewController:login];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *password = [defaults objectForKey:@"passWord"];//根据键值取出
    NSString *corpId = [defaults objectForKey:@"corpId"];
    NSString *push = [defaults objectForKey:@"ispush"];
    
   
    
    if (username.length>0 && password.length>0 &&corpId.length>0) {
        
        NSLog(@"%@",push);
        
        if ([push isEqualToString:@"yes"]) {
            
             self.window.rootViewController = tabBarVc;
            
        }else{
        
            self.window.rootViewController = nv;

        }
       
        
       
        
    }else{
        
        self.window.rootViewController = nv;
        
        
    }
    
    
    
    
    
}



- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    
    

    [JPUSHService registerDeviceToken:deviceToken];
    
   
    
    
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@",
          [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        
    }
    NSDictionary *dic = (NSDictionary *)userInfo;
    
    //判断应用是在前台还是后台
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
 [[NSNotificationCenter defaultCenter] postNotificationName:@"pushList" object:nil];
    }else{
        
        //第二种情况后台挂起时
       
        
        
        [self goToMssageViewControllerWith:dic];
            
            
       
    }
    application.applicationIconBadgeNumber = 0;
     [JPUSHService setBadge:0];
    completionHandler(UIBackgroundFetchResultNewData);
}

//点击App图标，使App从后台恢复至前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"pushList" object:nil];
    
}



//按Home键使App进入后台

- (void)applicationDidEnterBackground:(UIApplication *)application{
[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (NSString*)dictionaryToJson:(NSDictionary *)dic { NSError *parseError = nil; NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError]; return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}



#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = 0;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    NSDictionary *dic = (NSDictionary *)userInfo;

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@",
              [self logDic:userInfo]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushList" object:nil];
        //[rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    
        [JPUSHService setBadge:0];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    NSDictionary *dic = (NSDictionary *)userInfo;

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
         [self goToMssageViewControllerWith:dic];
        
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    [JPUSHService setBadge:0];
    
    completionHandler();  // 系统要求执行这个方法
    
}
#endif
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)goToMssageViewControllerWith:(NSDictionary*)msgDic{ NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@"push"forKey:@"push"];
    [pushJudge synchronize];
    
    [self changgeRedNumber:[msgDic objectForKey:@"client_code"]];
    NSString *auth_type = [NSString stringWithFormat:@"%@",[msgDic objectForKey:@"auth_type"]];
   
    if ([auth_type integerValue] == 0) {
        [self getoauth1:[msgDic objectForKey:@"url"] andTitle:[msgDic objectForKey:@"msgtype"] andClientCode:[msgDic objectForKey:@"client_code"]];
    }else{
        [self getoauth2:[msgDic objectForKey:@"url"] andTitle:[msgDic objectForKey:@"msgtype"] anddeveloperCode:[msgDic objectForKey:@"client_code"]];
    
    }
    
  // }
}
- (void)getoauth1:(NSString *)url andTitle:(NSString *)name andClientCode:(NSString *)clientCode{
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *passWord = [defaults objectForKey:@"passWordMI"];//根据键值取出name
    
    [sendDictionary setValue:username forKey:@"username"];
    [sendDictionary setValue:passWord forKey:@"password"];
    [sendDictionary setValue:@"case" forKey:@"clientCode"];
    
    NSLog(@"%@",sendDictionary);
    
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/auth" parameters:sendDictionary success:^(id responseObject) {
       
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                
                NSString *URLstring = @"";
                NSDictionary *dic = dicDictionary[@"content"];
                if ([url rangeOfString:@"?"].location != NSNotFound) {
                    URLstring = [NSString stringWithFormat:@"%@&openID=%@&accessToken=%@",url,dic[@"openID"],dic[@"accessToken"]];
                }else{
                    
                    URLstring = [NSString stringWithFormat:@"%@?openID=%@&accessToken=%@",url,dic[@"openID"],dic[@"accessToken"]];
                    
                }

                
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring]  titleString:name];
                UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:webViewController];
                [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
                


            }
            
            return ;
            
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"应用授权失败"];
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
       
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        NSLog(@"****%@", error);
        
    }];
    
    
    
}
- (void)getoauth2:(NSString *)url andTitle:(NSString *)name anddeveloperCode:(NSString *)developerCode{
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *passWord = [defaults objectForKey:@"passWordMI"];//根据键值取出name
    
    [sendDictionary setValue:username forKey:@"username"];
    [sendDictionary setValue:passWord forKey:@"password"];
    [sendDictionary setValue:@"case" forKey:@"developerCode"];
    [sendDictionary setValue:@"cgj" forKey:@"accountType"];
    [sendDictionary setValue:@"1" forKey:@"getExpire"];
    NSLog(@"%@",sendDictionary);
   
    
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/auth2" parameters:sendDictionary success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
                NSString *URLstring = @"";
                NSDictionary *dic = dicDictionary[@"content"];
                if ([url rangeOfString:@"?"].location != NSNotFound) {
                    URLstring = [NSString stringWithFormat:@"%@&username=%@&access_token=%@",url,username,dic[@"access_token"]];
                    NSLog(@"%@",URLstring);
                }else{
                    
                    URLstring = [NSString stringWithFormat:@"%@?username=%@&access_token=%@",url,username,dic[@"access_token"]];
                    
                }

              
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring]  titleString:name];
                webViewController.hidesBottomBarWhenPushed = YES;
                UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:webViewController];
                [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
                
                             

                
                
                
            }
            
            return ;
            
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"应用授权失败"];
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
       
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        NSLog(@"****%@", error);
        
    }];
    
    
}

- (void)changgeRedNumber:(NSString *)code{
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];
    
    [sendDictionary setValue:code forKey:@"client_code"];
    [sendDictionary setValue:username forKey:@"username"];
    
    
    
    [MCHttpManager PutWithIPString:BASEURL_AREA urlMethod:@"/push2/homepush/readhomePush" parameters:sendDictionary success:^(id responseObject)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"pushList" object:nil];
         
     } failure:^(NSError *error) {
         
         NSLog(@"****%@", error);
         
     }];
    
    
    
    
    
    
}

    

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}




- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //处理回调
    [[XWXAuth sharedServices] handleURL:url];
    return true;
}


@end
