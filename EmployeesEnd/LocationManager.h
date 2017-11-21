//
//  LocationManager.h
//  WeiTown
//
//  Created by Austin on 8/29/14.
//  Copyright (c) 2014 Hairon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject<CLLocationManagerDelegate>

@property(nonatomic,retain) CLLocationManager *manager;

+ (LocationManager *)sharedInstance;

-(void)startLocation;

@end
