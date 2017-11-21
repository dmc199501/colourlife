//
//  ShareMethod.m
//  CardToon
//
//  Created by ender chen on 12-4-19.
//  Copyright (c) 2012年 com.ender.ender. All rights reserved.
//

#import "ShareMethod.h"
#import  <QuartzCore/QuartzCore.h>


@implementation ShareMethod

#pragma mark - 阴影

+(CALayer *)createShadowWithFrame:(CGRect)frame
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    
    
    UIColor* lightColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    UIColor* darkColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    gradient.colors = [NSArray arrayWithObjects:(id)darkColor.CGColor, (id)lightColor.CGColor, nil];
    
    return gradient;
}


#pragma mark - 随机字符串

+(NSString *)randString
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];  
    
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];   
    
    [nsdf2 setDateFormat:@"HHmmssSSSS"];   
    
    NSString *t2=[nsdf2 stringFromDate:[NSDate date]]; 
    
   ;nsdf2=nil;
    
    int timestamp = arc4random() % 10000;
    
    NSString *rand=[NSString stringWithFormat:@"%@%d",t2,timestamp];
    
//    NSLog(@"rand:%@",rand);
    
    return rand;
}

+(NSString *)randStringLong
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    
    [nsdf2 setDateFormat:@"yyyyMMddHHmmssSSSS"];
    
    NSString *t2=[nsdf2 stringFromDate:[NSDate date]];
    
    ;nsdf2=nil;
    
    int timestamp = arc4random() % 100000;
    
    NSString *rand=[NSString stringWithFormat:@"%@%d",t2,timestamp];
    
//    NSLog(@"Long rand:%@",rand);
    
    return rand;
}

+(NSString *)writeImageToFile:(UIImage *)image {
    
    NSData *fullImageData = UIImageJPEGRepresentation(image, 1.0f);
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Images/"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL directoryExists = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    if (directoryExists) {
//        NSLog(@"isDirectory: %d", isDirectory);
    } else {
        NSError *error = nil;
        BOOL success = [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        if (!success) {
//            NSLog(@"Failed to create directory with error: %@", [error description]);
        }
    }
    
    NSString *name = [NSString stringWithFormat:@"%@.jpg", [ShareMethod randString]];
    NSString *filePath = [path stringByAppendingPathComponent:name];
    NSError *error = nil;
    BOOL success = [fullImageData writeToFile:filePath options:NSDataWritingAtomic error:&error];
    if (!success) {
//        NSLog(@"Failed to write to file with error: %@", [error description]);
    }
    
    return filePath;
}

//计算字符串字节长度，中文2个字节，英文1个字节
+ (int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
    
}



@end
