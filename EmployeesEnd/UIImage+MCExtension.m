//
//  UIImage+MCExtension.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/9/5.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "UIImage+MCExtension.h"

@implementation UIImage (MCExtension)
+(UIImage *)imageWithLineWithImageView:(UIImageView *)imageView{
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, width, height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGFloat lengths[] = {5,5};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0].CGColor);
    CGContextSetLineDash(line, 0, lengths, 1);
    CGContextMoveToPoint(line, 0, 1);
    CGContextAddLineToPoint(line, width-10, 1);
    CGContextStrokePath(line);
    return  UIGraphicsGetImageFromCurrentImageContext();
}
@end
