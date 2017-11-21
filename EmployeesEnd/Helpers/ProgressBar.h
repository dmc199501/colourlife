//
//  ProgressBar.h
//  WeiTown
//
//  Created by Austin on 9/2/14.
//  Copyright (c) 2014 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ProgressBar : UIProgressView {
	UIColor *_tintColor;
    NSTimer *_animationTimer;
}

- (ProgressBar *)initWithFrame:(CGRect)frame;

- (void)setProgress:(CGFloat)value animated:(BOOL)animated;

@end
