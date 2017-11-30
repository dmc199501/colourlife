/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

@class SDWebImageManager;
@class UIImage;

/**
 * Delegate protocol for SDWebImageManager
 */
@protocol SDWebImageManagerDelegate <NSObject>

@optional

/**
 * Called while an image is downloading with an partial image object representing the currently downloaded portion of the image.
 * This delegate is called only if ImageIO is available and `SDWebImageProgressiveDownload` option has been used.
 *
 * @param imageManager The image manager
 * @param image The retrived image object
 * @param url The image URL used to retrive the image
 * @param info The user info dictionnary
 */
- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info;
- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url;

/**
 * Called when image download is completed successfuly.
 *
 * @param imageManager The image manager
 * @param image The retrived image object
 * @param url The image URL used to retrive the image
 * @param info The user info dictionnary
 */
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info;
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url;
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image;

/**
 * Called when an error occurred.
 *
 * @param imageManager The image manager
 * @param error The error
 * @param url The image URL used to retrive the image
 * @param info The user info dictionnary
 */
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url userInfo:(NSDictionary *)info;
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url;
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error;



/**
 * Controls which image should be downloaded when the image is not found in the cache.
 *
 * @param imageManager The current `SDWebImageManager`
 * @param imageURL The url of the image to be downloaded
 *
 * @return Return NO to prevent the downloading of the image on cache misses. If not implemented, YES is implied.
 */
- (BOOL)imageManager:(SDWebImageManager *)imageManager shouldDownloadImageForURL:(NSURL *)imageURL;

/**
 * Allows to transform the image immediately after it has been downloaded and just before to cache it on disk and memory.
 * NOTE: This method is called from a global queue in order to not to block the main thread.
 *
 * @param imageManager The current `SDWebImageManager`
 * @param image The image to transform
 * @param imageURL The url of the image to transform
 *
 * @return The transformed image object.
 */
- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL;


@end
