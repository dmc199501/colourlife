//
//  ShareMethod.h
//  CardToon
//
//  Created by ender chen on 12-4-19.
//  Copyright (c) 2012年 com.ender.ender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 工具方法类
 **/
@interface ShareMethod : NSObject


//产生阴影


//写图片到本地
+(NSString *)writeImageToFile:(UIImage *)image;

//短随机数
+(NSString *)randString;

//长随机数
+(NSString *)randStringLong;

//字符串长度
+ (int)convertToInt:(NSString*)strtemp ;

@end
