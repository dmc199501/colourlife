//
//  MCAutoSizeImage.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/9.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"
#import "SDWebImageManager.h"
typedef NS_ENUM(NSInteger, ZZAutoSizeType)
{
    ZZAutoSizeTypeZoomRealFull          = 0,//实际全景缩放，图片实际像素比显示小时，只显示实际像素
    ZZAutoSizeTypeZoomCoveredFull          = 0,//铺满全景缩放，无论图片大小，都会以最大的宽或高去缩放，可视全景。
    ZZAutoSizeTypeZoomCovered       = 1,//宽或高铺满，保证整张图片都有图显示
    ZZAutoSizeTypeNone              = 2,//默认填满，与UIImageView一样。
    ZZAutoSizeTypeFill = ZZAutoSizeTypeNone,
    ZZAutoSizeTypeDefault = ZZAutoSizeTypeZoomRealFull,
};

@interface MCAutoSizeImage : UIView<SDWebImageManagerDelegate>
{
    UIActivityIndicatorView *activityIndicatorView;
}
@property (nonatomic, assign) float compressScale;//压缩图片后的最大倍数(显示效果更清晰)，不足的以原图大小为准，默认最大倍数：1.5倍，//要需要放大查看的话，先设置此值。正常显示为限制内存

@property (nonatomic, retain)UIImageView *placeholderImageView;
@property (nonatomic, retain)UIImageView *imageView;
@property (nonatomic, retain)UIImage *placeholderImage;
@property (nonatomic, assign)ZZAutoSizeType autoSizeType;
@property (nonatomic, strong)UIImage *image;

@property (nonatomic, strong)UILabel *titleLabel;


- (void)set_ImageWithURL:(NSURL *)url;
- (void)set_ImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)set_ImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder autoSizeTtype:(ZZAutoSizeType )autoSizeType;


@end
