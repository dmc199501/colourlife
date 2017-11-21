//
//  ProgressBar.m
//  WeiTown
//
//  Created by Austin on 9/2/14.
//  Copyright (c) 2014 Hairon. All rights reserved.
//

#import "ProgressBar.h"

@implementation ProgressBar

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect progressRect = rect;
    
    //change bar width on progress value (%)
    progressRect.size.width *= [self progress];
    
    //Fill color
    CGContextSetFillColorWithColor(ctx, [_tintColor CGColor]);
    CGContextFillRect(ctx, progressRect);
    
    //Hide progress with fade-out effect
    if (self.progress == 1.0f &&
        _animationTimer == nil) {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hideWithFadeOut) userInfo:nil repeats:YES];
    }
    
}

- (void) hideWithFadeOut {
    //initialize fade animation
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.5;
    [self.layer addAnimation:animation forKey:nil];
    
    //Do hide progress bar
    self.hidden = YES;
    self.progress=0;
    if (_animationTimer != nil) {
        [_animationTimer invalidate];
        _animationTimer = nil;
    }
}

- (void) setProgress:(CGFloat)value animated:(BOOL)animated {
    
    if ((!animated && value > self.progress) || animated) {
        self.hidden = NO;
        self.progress = value;
    }
}

- (ProgressBar *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self) {
        //set bar color
        _tintColor = [UIColor colorWithRed:51.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1];
		self.progress = 0;
        self.progressViewStyle = UIProgressViewStyleBar;
	}
    
	return self;
}



@end
