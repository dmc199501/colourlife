//
//  NewLocationManager.m
//  WeiTown
//
//  Created by Robert Xu on 16/2/23.
//  Copyright © 2016年 Hairon. All rights reserved.
//
#define GT_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#import "NewLocationManager.h"
#import <UIKit/UIKit.h>
@implementation NewLocationManager

+ (NewLocationManager *)sharedInstance
{
    static NewLocationManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}


-(id)init
{
    if (self=[super init]) {
        
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.distanceFilter = 5.0;
    }
    
    return self;
}


/**
 *  开始获取地址
 */
-(void)startLocation
{
   
    if (_manager) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8
) {
            [_manager requestWhenInUseAuthorization];
        }
        [_manager startUpdatingLocation];
    }
}


#pragma mark - 获取地理位置delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if (_manager) {
        [_manager stopUpdatingLocation];
    }
    
    if (newLocation) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FORSINGLEUSERTOSINGLEDEVICE" object:newLocation];
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

- (void)dealloc
{
    [_manager stopUpdatingLocation];
   }

@end
