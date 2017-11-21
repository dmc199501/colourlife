//
//  UIView+IPhone5View.h
//  Diving
//
//  Created by iMac on 12-10-25.
//  Copyright (c) 2012年 Coortouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IPhone5View)

-(void) fixYForIPhone5:(BOOL) isFixY addHight:(BOOL) isAddHight;
-(void)fixIOS7;

-(void)addTapAction:(SEL)action forTarget:(id) aTarget;

- (void) exaggerationBorderWidth:(CGFloat)borderWidth radius:(CGFloat)radius color:(CGColorRef)color;

- (void) exaggerationShadowOffset:(CGSize)offset radius:(CGFloat)radius color:(CGColorRef)color ;
@end
