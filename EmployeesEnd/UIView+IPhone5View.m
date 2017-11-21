//
//  UIView+IPhone5View.m
//  Diving
//
//  Created by iMac on 12-10-25.
//  Copyright (c) 2012年 Coortouch. All rights reserved.
//
#define GT_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7

#define STATUS_BAR_OFFSET ( GT_IOS7 ? 20.0 : 0.0)

#import "UIView+IPhone5View.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (IPhone5View)
-(void)fixYForIPhone5:(BOOL)isFixY addHight:(BOOL)isAddHight
{
    CGRect oldFrame = self.frame;
    if (isFixY) {
       oldFrame.origin.y +=88.0f; 
    }
    if (isAddHight) {
       oldFrame.size.height+=88.0f;
    }
    
    self.frame = oldFrame;
}

-(void)addTapAction:(SEL)action forTarget:(id) aTarget
{
    self.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:aTarget action:action];
    
    [self addGestureRecognizer:tap];
    
    ;tap=nil;
}

- (void) exaggerationBorderWidth:(CGFloat)borderWidth radius:(CGFloat)radius color:(CGColorRef)color {
    
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:radius];
    [self.layer setBorderWidth:borderWidth];
    [self.layer setBorderColor:color];
}

- (void) exaggerationShadowOffset:(CGSize)offset radius:(CGFloat)radius color:(CGColorRef)color {
    [self.layer setShadowOffset:offset];
    [self.layer setShadowOpacity:0];
    [self.layer setShadowRadius:radius];
    [self.layer setShadowColor:color];
}

-(void)fixIOS7
{
    CGRect oldFrame = self.frame;
    
    oldFrame.origin.y += STATUS_BAR_OFFSET;
    
    self.frame = oldFrame;
    
}
@end
