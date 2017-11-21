//
//  MCTabBar.h
//  CommunityThrough
//
//  Created by 邓梦超 on 16/6/7.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCTabBar : UITabBar
@property (nonatomic, strong) id delegater;

@end
@protocol MCTabBarDelegate <NSObject>
@optional

@end
