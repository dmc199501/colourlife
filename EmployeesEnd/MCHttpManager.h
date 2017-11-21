//
//  MCHttpManager.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/9.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCHttpManager : NSObject
/**
 *  发送get请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)GETWithIPString:(NSString *)IPString  urlMethod:(NSString *)urlMethod parameters:(NSDictionary *)sendDictionary success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)GETTsWithIPString:(NSString *)IPString  urlMethod:(NSString *)urlMethod parameters:(NSDictionary *)sendDictionary success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
/**
 *  发送post请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)PostWithIPString:(NSString *)IPString  urlMethod:(NSString *)urlMethod parameters:(NSDictionary *)sendDictionary success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;



+ (void)PutWithIPString:(NSString *)IPString  urlMethod:(NSString *)urlMethod parameters:(NSDictionary *)sendDictionary success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)DeleteWithIPString:(NSString *)IPString  urlMethod:(NSString *)urlMethod parameters:(NSDictionary *)sendDictionary success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+(void)upUserHeadWithIPString:(NSString *)IPString  urlMethod:(NSString *)url andDictionary:(NSDictionary *)parame andImage:(NSMutableArray *)imageArray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end
