//
//  DownListManager.m
//  js-native
//
//  Created by Robert Xu on 15/5/22.
//  Copyright (c) 2015年 wooyou. All rights reserved.
//

#import "DownListManager.h"

@implementation DownListManager

//读取下载文件名列表
+ (NSMutableArray *)readDownPlist
{
    NSString *plistPath = [self getDownPlistPath];
    NSFileManager *fMgr = [NSFileManager defaultManager];
    
    if (![fMgr fileExistsAtPath:plistPath]) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr writeToFile:plistPath atomically:YES];
    }
    return [NSMutableArray arrayWithContentsOfFile:plistPath];
}

//增加下载文件名
+ (void)writeDownPlist:(NSString *)fileName
{
    NSString *plistPath = [self getDownPlistPath];
    NSMutableArray *arr = [self readDownPlist];
//    [arr addObject:fileName];
    [arr insertObject:fileName atIndex:0];
    [arr writeToFile:plistPath atomically:YES];
}

//删除下载文件
+ (void)deleteDownPlist:(NSUInteger)index
{
    NSString *plistPath = [self getDownPlistPath];
    NSMutableArray *arr = [self readDownPlist];
    [arr removeObjectAtIndex:index];
    [arr writeToFile:plistPath atomically:YES];
}

//获取保存下载文件名的文件路径
+ (NSString *)getDownPlistPath
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSLog(@"%@", [[documentPaths lastObject] stringByAppendingPathComponent:DOWNLOAD_PLIST_NAME]);
    return [[documentPaths lastObject] stringByAppendingPathComponent:DOWNLOAD_PLIST_NAME];
}

//根据文件名获取文件全URL路径
+ (NSURL *)getFileURLByName:(NSString *)fileName
{
    NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString* documentPath = [documentPaths lastObject];
    NSString *previewFileFullPath = [documentPath stringByAppendingPathComponent:fileName];
    return [NSURL fileURLWithPath:previewFileFullPath];
}

@end
