//
//  MCZoomScrollView.m
//  CommunityThrough
//
//  Created by 邓梦超 on 16/8/11.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCZoomScrollView.h"

@implementation MCZoomScrollView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.compressScale = 3;
        self.zoomPhotoImageView = [[MCAutoSizeImage alloc]initWithFrame:CGRectMake(0, -64, self.frame.size.width, self.frame.size.height)];
        self.zoomPhotoImageView.compressScale = self.compressScale;
        [self addSubview:self.zoomPhotoImageView];
        [self setDelegate:self];
        [self setMinimumZoomScale:1];
        [self setMaximumZoomScale:self.compressScale];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollView:)];
        [tap setNumberOfTapsRequired:2];//双击
        [self addGestureRecognizer:tap];
        
        
        
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.zoomPhotoImageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (void)setCompressScale:(float)compressScale
{
    _compressScale = compressScale;
    self.zoomPhotoImageView.compressScale = compressScale;
    
}

- (void)setMaximumZoomScale:(CGFloat)maximumZoomScale
{
    super.maximumZoomScale = maximumZoomScale;
    
}

- (void)tapScrollView:(UITapGestureRecognizer *)tap
{
    if (self.zoomScale == 1)
    {
        [self setZoomScale:1.5 animated:YES];
    }
    else if(self.zoomScale > 1 && self.zoomScale <= 1.5)
    {
        [self setZoomScale:self.maximumZoomScale animated:YES];
    }
    else
    {
        [self setZoomScale:1 animated:YES];
    }
    
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomPhotoImageView;
}


@end
