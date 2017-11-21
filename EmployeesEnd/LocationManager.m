//
//  LocationManager.m
//  WeiTown
//
//  Created by Austin on 8/29/14.
//  Copyright (c) 2014 Hairon. All rights reserved.
//

#import "LocationManager.h"
#import <UIKit/UIKit.h>
@implementation LocationManager


+ (LocationManager *)sharedInstance
{
    static LocationManager *_sharedInstance = nil;
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
        
//        NSMutableDictionary *locationDic = [NSMutableDictionary dictionaryWithCapacity:2];
//        [locationDic setObject:[NSNumber numberWithFloat:newLocation.coordinate.longitude ] forKey:@"lon"];
//        [locationDic setObject:[NSNumber numberWithFloat:newLocation.coordinate.latitude ] forKey:@"lat"];
//        
//        
//        //保存到本地
//        [[NSUserDefaults standardUserDefaults] setObject:locationDic forKey:@"LOCATION"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCATIONCHANGE" object:newLocation];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GETLOCATIONONCE" object:newLocation];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GETLOCATIONONCEFORWEATHER" object:newLocation];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GETLOCATIONONCEFORHTML5" object:newLocation];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GETPOILOCATION" object:newLocation];
        
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GETLOCATIONONCEFORHTML5" object:nil];
//    DLog(@"error: %@",error);
}

- (void)dealloc
{
    [_manager stopUpdatingLocation];
   
}


@end
