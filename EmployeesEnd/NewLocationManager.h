//
//  NewLocationManager.h
//  WeiTown
//
//  Created by Robert Xu on 16/2/23.
//  Copyright © 2016年 Hairon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NewLocationManager : NSObject <CLLocationManagerDelegate>

@property(nonatomic,retain) CLLocationManager *manager;

+ (NewLocationManager *)sharedInstance;

-(void)startLocation;

@end
