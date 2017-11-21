//
//  UIBarButtonItem+Item.h
//  CommunityThrough
//
//  Created by 邓梦超 on 16/6/7.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)
+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
