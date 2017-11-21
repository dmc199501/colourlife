//
//  PMMapDataAPI.m
//  WeiTown
//
//  Created by kakatool on 15-4-2.
//  Copyright (c) 2015年 Hairon. All rights reserved.
//

#import "PMMapDataAPI.h"

@implementation PMMapDataAPI
+(void)getBigDataWithD:(NSString *)d m:(NSString *)m where:(NSString *)where BlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure{
   NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSString *path = [NSString stringWithFormat:PM_MAPDATA_URL,d,m,where];
//    [[PMApiClient sharedClient] getShareApiPath:path Param:params BlockSuc:success BlockFailed:failure];

    
}


//获取组织结构信息
+(void)getBigDataBranch:(NSString *)branchId BlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSString *path = [NSString stringWithFormat:PM_BIGDATA_BRANCH,branchId];
//    [[PMApiClient sharedClient] getShareApiPath:path Param:params BlockSuc:success BlockFailed:failure];
}

//获取地图组织经纬度
+(void)getBigDataDistributionBlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSString *path = PM_BIGDATA_DISTRIBUTION;
//    [[PMApiClient sharedClient] getShareApiPath:path Param:params BlockSuc:success BlockFailed:failure];
}


//获取kpi信息
+(void)getBigDataKpiByUid:(NSString *)uid andBranchId:(NSString *)branchId AtYear:(NSString *)year BlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure
{
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSString *path = [NSString stringWithFormat:PM_BIGDATA_KPI,uid,branchId,year];
//    [[PMApiClient sharedClient] getShareApiPath:path Param:nil BlockSuc:success BlockFailed:failure];
}

//获取新岗位信息
+ (void)getJobV2AccountBlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure {
    
   // NSMutableDictionary *userInfo =[LocalDataAccessor fetchOAUserInfo];
    
//    if (!userInfo) {
//        return;
//    }
//    
//    NSString *name = [userInfo objectForKey:@"name"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSString *path = [NSString stringWithFormat:PM_MAPDATA_JOBV2_ACCOUNT, name];
//    [[PMApiClient sharedClient] getShareApiPath:path Param:params BlockSuc:success BlockFailed:failure];
}

//根据多个uuid获取初始节点数据
+ (void)getInitMapDataByUUIDs:(NSString *)uuids BlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure {
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSString *path = [NSString stringWithFormat:PM_BIGDATA_ORG, uuids];
//    [[PMApiClient sharedClient] getShareApiPath:path Param:nil BlockSuc:success BlockFailed:failure];
}

//根据用户名获取初始组织节点
+ (void)getInitMapDataBlockSuc:(void (^)(NSURL *url, id result))success BlockFailed:(void (^)(NSURL *url, NSError *error))failure {
    
    //NSMutableDictionary *userInfo =[LocalDataAccessor fetchOAUserInfo];
    
//    if (!userInfo) {
//        return;
//    }
    
   // NSString *username = [userInfo objectForKey:@"name"];
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSString *path = [NSString stringWithFormat:PM_BIGDATA_INIT_ORG, username];
//    [[PMApiClient sharedClient] getShareApiPath:path Param:nil BlockSuc:success BlockFailed:failure];
}

@end
