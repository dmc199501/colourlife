//
//  MCZoomScrollView.h
//  CommunityThrough
//
//  Created by 邓梦超 on 16/8/11.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCAutoSizeImage.h"
@interface MCZoomScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, assign)NSUInteger index;//供外部使用做记录
@property (nonatomic, assign)float compressScale;

@property (nonatomic, strong)MCAutoSizeImage *zoomPhotoImageView;

@end
