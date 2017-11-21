//
//  MCAutoSizeImage.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/9.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCAutoSizeImage.h"
#import "objc/runtime.h"
static char operationKey;
static char operationArrayKey;
@implementation MCAutoSizeImage

//- (void)dealloc
//{
//    self.placeholderImageView = nil;
//    self.imageView = nil;
//    self.placeholderImage = nil;
//    
//    [activityIndicatorView removeFromSuperview];
//    activityIndicatorView = nil;
//}
//
//- (void)set_ImageWithURL:(NSURL *)url {
//    [self set_ImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
//}
//
//- (void)set_ImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
//    [self set_ImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
//}
//- (void)set_ImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder autoSizeTtype:(ZZAutoSizeType )autoSizeType
//{
//    self.autoSizeType = autoSizeType;
//    [self set_ImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
//    
//}
//
//- (void)set_ImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
//    [self set_ImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
//}
//
//- (void)set_ImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock {
//    [self set_ImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
//}
//
//- (void)set_ImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock {
//    [self set_ImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
//}
//
//- (void)set_ImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock {
//    [self set_ImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
//}
//
//
//
//- (void)set_ImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock {
//    
//    if (activityIndicatorView == nil)
//    {
//        activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    }
//    [self addSubview:activityIndicatorView];
//    [activityIndicatorView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    [activityIndicatorView startAnimating];
//    
//    
//    [self cancelCurrentImageLoad];
//    
//    self.placeholderImage = placeholder;
//    
//    if (url) {
//        __weak MCAutoSizeImage *wself = self;
//        //        __weak UIImageView *wselfPlaceholderImageView = self.placeholderImageView;
//        //        __weak UIImageView *wselfImageView = self.imageView;
//        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//            
//            if (!wself) return;
//            dispatch_main_sync_safe(^{
//                //                dispatch_async(dispatch_get_main_queue(), ^{
//                [activityIndicatorView stopAnimating];
//                [activityIndicatorView removeFromSuperview];
//                
//                //                NSLog(@"获取图片：%@ %@", wself, image);
//                if (!wself)
//                    return;
//                if (image) {
//                    if ((image.size.width == 0 && image.size.height == 0) || image == nil)
//                    {
//                        return;
//                    }
//                    //粗略计算超高或超宽的图片才计算。
//                    UIImage *setImage = image;
//                    if (setImage.size.height > wself.frame.size.height * self.compressScale && setImage.size.height > 0)
//                    {
//                        setImage = [self scaleImage:setImage toScale:wself.frame.size.height * wself.compressScale / setImage.size.height];
//                    }
//                    
//                    if (setImage.size.width > wself.frame.size.width * self.compressScale && setImage.size.width > 0)
//                    {
//                        setImage = [self scaleImage:setImage toScale:wself.frame.size.width * wself.compressScale / setImage.size.width];
//                    }
//                    
//                    wself.placeholderImageView.image = nil;
//                    wself.imageView.image = setImage;
//                    
//                    [wself autoSizeImageView];
//                    [wself setNeedsLayout];
//                }
//                if (completedBlock && finished) {
//                    completedBlock(image, error, cacheType);
//                }
//            });
//        }];
//        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//}
//
//
//- (void)cancelCurrentImageLoad {
//    // Cancel in progress downloader from queue
//    id <SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
//    if (operation) {
//        [operation cancel];
//        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//}
//
//- (void)cancelCurrentArrayLoad {
//    // Cancel in progress downloader from queue
//    NSArray *operations = objc_getAssociatedObject(self, &operationArrayKey);
//    for (id <SDWebImageOperation> operation in operations) {
//        if (operation) {
//            [operation cancel];
//        }
//    }
//    objc_setAssociatedObject(self, &operationArrayKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        self.compressScale = 3.0;
//        // Initialization code
//        self.placeholderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        [self addSubview:self.placeholderImageView];
//        
//        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self addSubview:self.imageView];
//        
//        
//        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
//        [self addSubview:self.titleLabel];
//        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
//        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
//        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
//        //        [self.titleLabel setTextColor:GRAY_COLOR_ZZ];
//    }
//    return self;
//}
//
//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    [self.placeholderImageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    [self.imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    if (((self.image.size.width == 0 && self.image.size.height == 0) || self.image == nil))
//    {
//        return;
//    }
//    [self autoSizeImageView];
//    [self.titleLabel setFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
//    
//}
//
//
////- (void)setCompressScale:(float)compressScale
////{
////    _compressScale = compressScale;
////    [self autoSizeImageView];
////}
//
//- (void)setImage:(UIImage *)image
//{
//    //粗略计算超高或超宽的图片才计算。
//    UIImage *setImage = image;
//    if (setImage.size.height > self.frame.size.height * self.compressScale && setImage.size.height > 0)
//    {
//        setImage = [self scaleImage:setImage toScale:self.frame.size.height * self.compressScale / setImage.size.height];
//    }
//    
//    if (setImage.size.width > self.frame.size.width * self.compressScale && setImage.size.width > 0)
//    {
//        setImage = [self scaleImage:setImage toScale:self.frame.size.width * self.compressScale / setImage.size.width];
//    }
//    
//    self.imageView.image = setImage;
//    self.placeholderImageView.image = nil;
//    [self autoSizeImageView];
//    
//}
//
//- (UIImage *)image
//{
//    return _imageView.image;
//}
//
//- (void)setPlaceholderImage:(UIImage *)image
//{
//    self.imageView.image = nil;
//    [self.placeholderImageView setImage:image];
//}
//
//- (UIImage *)placeholderImage
//{
//    return [self.placeholderImageView image];
//}
//
//
//#pragma mark 等比压缩图片
//- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
//{
//    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
//    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
//    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return scaledImage;
//    
//}
//
//- (void)autoSizeImageView
//{
//    
//    if (self.frame.size.width == 0 || self.frame.size.height == 0 || self.image.size.width == 0 || self.image.size.height == 0)
//    {
//        return;
//    }
//    
//    switch (self.autoSizeType)
//    {
//        case ZZAutoSizeTypeZoomCoveredFull:
//        {
//            CGFloat ascept1 = self.frame.size.width / self.frame.size.height;
//            CGFloat ascept2 = self.image.size.width / self.image.size.height;
//            if (ascept1 >= ascept2)
//            {
//                CGSize newSize;
//                newSize.height = self.frame.size.height;
//                newSize.width =  self.frame.size.height * self.image.size.width / self.image.size.height;
//                
//                CGRect frame;
//                frame.origin.x = (self.frame.size.width - newSize.width) / 2;
//                frame.origin.y = (self.frame.size.height - newSize.height) / 2;
//                frame.size = newSize;
//                self.imageView.frame = frame;
//                
//            }
//            else
//            {
//                CGSize newSize;
//                newSize.width = self.frame.size.width;
//                newSize.height = self.frame.size.width * self.image.size.height  / self.image.size.width;
//                
//                CGRect frame;
//                frame.origin.x = (self.frame.size.width - newSize.width) / 2;
//                frame.origin.y = (self.frame.size.height - newSize.height) / 2;
//                frame.size = newSize;
//                self.imageView.frame = frame;
//            }
//            
//        }
//            break;
//        case ZZAutoSizeTypeZoomCovered:
//        {
//            CGFloat ascept1 = self.frame.size.width / self.frame.size.height;
//            CGFloat ascept2 = self.image.size.width / self.image.size.height;
//            if (ascept1 <= ascept2)
//            {
//                CGSize newSize;
//                newSize.height = self.frame.size.height;
//                newSize.width =  self.frame.size.height * self.image.size.width / self.image.size.height;
//                
//                CGRect frame;
//                frame.origin.x = (self.frame.size.width - newSize.width) / 2;
//                frame.origin.y = (self.frame.size.height - newSize.height) / 2;
//                frame.size = newSize;
//                self.imageView.frame = frame;
//                
//            }
//            else
//            {
//                CGSize newSize;
//                newSize.width = self.frame.size.width;
//                newSize.height = self.frame.size.width * self.image.size.height  / self.image.size.width;
//                
//                CGRect frame;
//                frame.origin.x = (self.frame.size.width - newSize.width) / 2;
//                frame.origin.y = (self.frame.size.height - newSize.height) / 2;
//                frame.size = newSize;
//                self.imageView.frame = frame;
//            }
//        }
//            
//            break;
//        case ZZAutoSizeTypeFill:
//        {
//            [self.imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        }
//            break;
//            
//        default:
//        {
//            if (self.frame.size.width >= self.image.size.width && self.frame.size.height >= self.image.size.height)
//            {
//                CGRect frame;
//                frame.origin.x = (self.imageView.frame.size.width - self.image.size.width) / 2;
//                frame.origin.y = (self.imageView.frame.size.height - self.image.size.height) / 2;
//                frame.size = self.image.size;
//                self.imageView.frame = frame;
//            }
//            else
//            {
//                CGFloat ascept1 = self.frame.size.width / self.frame.size.height;
//                CGFloat ascept2 = self.image.size.width / self.image.size.height;
//                if (ascept1 >= ascept2)
//                {
//                    CGSize newSize;
//                    newSize.height = self.frame.size.height;
//                    newSize.width =  self.frame.size.height * self.image.size.width / self.image.size.height;
//                    
//                    CGRect frame;
//                    frame.origin.x = (self.frame.size.width - newSize.width) / 2;
//                    frame.origin.y = (self.frame.size.height - newSize.height) / 2;
//                    frame.size = newSize;
//                    self.imageView.frame = frame;
//                    
//                }
//                else
//                {
//                    CGSize newSize;
//                    newSize.width = self.frame.size.width;
//                    newSize.height = self.frame.size.width * self.image.size.height  / self.image.size.width;
//                    
//                    CGRect frame;
//                    frame.origin.x = (self.frame.size.width - newSize.width) / 2;
//                    frame.origin.y = (self.frame.size.height - newSize.height) / 2;
//                    frame.size = newSize;
//                    self.imageView.frame = frame;
//                }
//            }
//        }
//            break;
//    }
//    
//    
//}
//

@end
