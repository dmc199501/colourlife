//
//  main.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <tingyunApp/NBSAppAgent.h>
int main(int argc, char * argv[]) {
    @autoreleasepool {
        
          [NBSAppAgent startWithAppID:@"3e046c0d8235434a83e89fab74330e76"];//设置成听云报表生成的appkey
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
       
    }
}
