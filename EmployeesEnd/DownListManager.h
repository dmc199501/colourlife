//
//  DownListManager.h
//  js-native
//
//  Created by Robert Xu on 15/5/22.
//  Copyright (c) 2015年 wooyou. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DOWNLOAD_PLIST_NAME     @"colorlifedown.plist"

@interface DownListManager : NSObject

//读取下载文件名列表
+ (NSMutableArray *)readDownPlist;
//增加下载文件名
+ (void)writeDownPlist:(NSString *)fileName;
//获取保存下载文件名的文件路径
+ (NSString *)getDownPlistPath;
//根据文件名获取文件全URL路径
+ (NSURL *)getFileURLByName:(NSString *)fileName;
//删除下载文件
+ (void)deleteDownPlist:(NSUInteger)index;

@end
