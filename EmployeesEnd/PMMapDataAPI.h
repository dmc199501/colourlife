//
//  PMMapDataAPI.h
//  WeiTown
//
//  Created by kakatool on 15-4-2.
//  Copyright (c) 2015年 Hairon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMMapDataAPI : NSObject
+(void)getBigDataWithD:(NSString *)d m:(NSString *)m where:(NSString *)where BlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure;

//获取组织结构信息
+(void)getBigDataBranch:(NSString *)branchId BlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure;
//获取地图组织经纬度
+(void)getBigDataDistributionBlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure;
//获取kpi信息
+(void)getBigDataKpiByUid:(NSString *)uid andBranchId:(NSString *)branchId AtYear:(NSString *)year BlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure;
//获取新岗位信息
+ (void)getJobV2AccountBlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure;
//根据多个uuid获取初始节点数据
+ (void)getInitMapDataByUUIDs:(NSString *)uuids BlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure;
//根据用户名获取初始组织节点
+ (void)getInitMapDataBlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure;
@end
