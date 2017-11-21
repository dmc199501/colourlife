//
//  MCHttpManager.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/9.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCHttpManager.h"
#import "AFNetworking.h"
#import "MyMD5.h"
#import "MCPublicDataSingleton.h"
#import "SVProgressHUD.h"
@implementation MCHttpManager
+ (void)GETWithIPString:(NSString *)IPString  urlMethod:(NSString *)urlMethod parameters:(NSDictionary *)sendDictionary success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: sendDictionary];
    
    // 创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [mgr.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //返回数据格式为json格式，不需要再json解析了
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    
//    NSString *ts  = @"1494383844";
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *ts = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"ts"]];
    
      NSLog(@"我是get--TS值%@",ts);
    
    //签名sign
    NSString *signStr = [MyMD5 md5:[NSString stringWithFormat:@"%@%@%@%@",@"ICEXCGJ0-5F89-4E17-BC44-7A0DB101B245",ts,@"AXPHrD48LRa8xYVkgV4c",@"false"]];
    
    NSLog(@"%@",signStr);
    //
    [param setObject:signStr forKey:@"sign"];
    [param setObject:ts forKey:@"ts"];
    [param setObject:@"ICEXCGJ0-5F89-4E17-BC44-7A0DB101B245" forKey:@"appID"];
    
    ;
    NSString *allURL = [NSString stringWithFormat:@"%@%@",IPString, urlMethod];
    NSLog(@"-allURL-%@--param---%@", allURL,param);
    
    [mgr GET:allURL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"MGR-----%@",[mgr description]);
        
        NSLog(@"----%lld",downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // AFN请求成功时候调用block
        // 先把请求成功要做的事情，保存到这个代码块
        NSLog(@"MGR-----%@",[mgr description]);
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(error);
        }
    }];
}

+ (void)GETTsWithIPString:(NSString *)IPString  urlMethod:(NSString *)urlMethod parameters:(NSDictionary *)sendDictionary success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: sendDictionary];
    
    // 创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [mgr.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //返回数据格式为json格式，不需要再json解析了
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    [mgr.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    
    
    
    
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    
    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
    
  //  NSString *ts  = [MCPublicDataSingleton sharePublicDataSingleton ].ts;
//    
//    NSInteger time = [curTime integerValue] + [ts integerValue];
//    
//    NSString * curTimeTs = [NSString stringWithFormat:@"%long",time];
//    NSLog(@"%@",curTimeTs);
    
    //在这里可以给sendDictionary配一些公共参数，以及签名操作
    
    //签名sign
//    NSString *signStr = [MyMD5 md5:[NSString stringWithFormat:@"%@%@%@%@",@"ICEOA000-ED69-4335-A475-A8BEF914D44A",ts,@"z3wF8oVvY6iAykqU9CIK",@"false"]];
//    
//    NSLog(@"%@",signStr);
//    //
//        [param setObject:signStr forKey:@"sign"];
//        [param setObject:ts forKey:@"ts"];
//    [param setObject:@"ICEOA000-ED69-4335-A475-A8BEF914D44A" forKey:@"appID"];
//    
//    ;
    NSString *allURL = [NSString stringWithFormat:@"%@%@",IPString, urlMethod];
    NSLog(@"-allURL-%@--param---%@", allURL,param);
    
    [mgr GET:allURL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"MGR-----%@",[mgr description]);
        
        NSLog(@"----%lld",downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // AFN请求成功时候调用block
        // 先把请求成功要做的事情，保存到这个代码块
        NSLog(@"MGR-----%@",[mgr description]);
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(error);
        }
    }];
}



+ (void)PostWithIPString:(NSString *)IPString  urlMethod:(NSString *)urlMethod parameters:(NSDictionary *)sendDictionary success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: sendDictionary];
    
    
    // 创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [mgr.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    //返回数据格式为json格式，不需要再json解析了
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
     //[mgr.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    
    
   
    
//    NSString *ts  = @"1494383844";
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *ts = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"ts"]];
         //在这里可以给sendDictionary配一些公共参数，以及签名操作
    
    //签名sign
    NSString *signStr = [MyMD5 md5:[NSString stringWithFormat:@"%@%@%@%@",@"ICEXCGJ0-5F89-4E17-BC44-7A0DB101B245",ts,@"AXPHrD48LRa8xYVkgV4c",@"false"]];
   
    NSLog(@"%@",signStr);
//    
    [param setObject:signStr forKey:@"sign"];
    [param setObject:ts forKey:@"ts"];
    [param setObject:@"ICEXCGJ0-5F89-4E17-BC44-7A0DB101B245" forKey:@"appID"];
    
    ;
    NSLog(@"%@",param);
    NSString *allURL = [NSString stringWithFormat:@"%@%@",IPString, urlMethod];
    //    // 设置超时时间
   
  
    
    
    
   
    [mgr POST:allURL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        NSLog(@"MGR-----%@",[mgr description]);
        
        NSLog(@"----%lld",downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        // AFN请求成功时候调用block
        // 先把请求成功要做的事情，保存到这个代码块
        NSLog(@"MGR-----%@",[mgr description]);
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        if (failure) {
            NSLog(@"%@",error);
            failure(error);
        }
    }];
}

+ (void)PutWithIPString:(NSString *)IPString  urlMethod:(NSString *)urlMethod parameters:(NSDictionary *)sendDictionary success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: sendDictionary];
    
    // 创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [mgr.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //返回数据格式为json格式，不需要再json解析了
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    //[mgr.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    
    
    
    
    //    NSString *ts  = @"1494383844";
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *ts = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"ts"]];
    NSLog(@"我是POST--TS值%@",ts);
    //在这里可以给sendDictionary配一些公共参数，以及签名操作
    
    //签名sign
    NSString *signStr = [MyMD5 md5:[NSString stringWithFormat:@"%@%@%@%@",@"ICEXCGJ0-5F89-4E17-BC44-7A0DB101B245",ts,@"AXPHrD48LRa8xYVkgV4c",@"false"]];
    
    NSLog(@"%@",signStr);
    //
    [param setObject:signStr forKey:@"sign"];
    [param setObject:ts forKey:@"ts"];
    [param setObject:@"ICEXCGJ0-5F89-4E17-BC44-7A0DB101B245" forKey:@"appID"];
    
    ;
    NSLog(@"%@",param);
    NSString *allURL = [NSString stringWithFormat:@"%@%@",IPString, urlMethod];
    
    [mgr PUT:allURL parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        // AFN请求成功时候调用block
        // 先把请求成功要做的事情，保存到这个代码块
        NSLog(@"MGR-----%@",[mgr description]);
        if (success) {
            
            success(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSLog(@"%@",error);
            failure(error);
        }
        
        
    }     ];
}

+ (void)DeleteWithIPString:(NSString *)IPString  urlMethod:(NSString *)urlMethod parameters:(NSDictionary *)sendDictionary success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: sendDictionary];
    
    // 创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [mgr.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //返回数据格式为json格式，不需要再json解析了
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgr.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    //[mgr.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    
    
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *ts = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"ts"]];
    
    
    //在这里可以给sendDictionary配一些公共参数，以及签名操作
    
    //签名sign
    NSString *signStr = [MyMD5 md5:[NSString stringWithFormat:@"%@%@%@%@",@"ICEXCGJ0-5F89-4E17-BC44-7A0DB101B245",ts,@"AXPHrD48LRa8xYVkgV4c",@"false"]];
    
    NSLog(@"%@",signStr);
    //
    [param setObject:signStr forKey:@"sign"];
    [param setObject:ts forKey:@"ts"];
    [param setObject:@"ICEXCGJ0-5F89-4E17-BC44-7A0DB101B245" forKey:@"appID"];
    
    ;
    NSLog(@"%@",param);
    NSString *allURL = [NSString stringWithFormat:@"%@%@",IPString, urlMethod];
    
    [mgr DELETE:allURL parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        // AFN请求成功时候调用block
        // 先把请求成功要做的事情，保存到这个代码块
        NSLog(@"MGR-----%@",[mgr description]);
        if (success) {
            
            success(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
        
    }];
}


+ (void)upUserHeadWithIPString:(NSString *)IPString  urlMethod:(NSString *)url andDictionary:(NSDictionary *)parame andImage:(NSMutableArray *)imageArray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary: parame];
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    // 创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //返回数据格式为json格式，不需要再json解析了
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    //[manager.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    
    
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    
    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
    
    NSString *ts  = [MCPublicDataSingleton sharePublicDataSingleton ].ts;
    
    NSInteger time = [curTime integerValue] + [ts integerValue];
    
    NSString * curTimeTs = [NSString stringWithFormat:@"%long",time];
    
    
    //在这里可以给sendDictionary配一些公共参数，以及签名操作
    NSString *allURL = [NSString stringWithFormat:@"%@%@",IPString, url];
    //签名sign
//    NSString *signStr = [MyMD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@",allURL,@"colourlife",curTimeTs,@"71D54718B0F6FFF07CE9",@"false"]];
//    NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@%@%@",allURL,@"colourlife",curTime,@"71D54718B0F6FFF07CE9",@"false"]);
//    NSLog(@"%@",signStr);
    
//    [param setObject:signStr forKey:@"sign"];
//    [param setObject:curTimeTs forKey:@"ts"];
    
    NSLog(@"-allURL-%@--param---%@", allURL,param);
    
    //   NSString* urlString = [allURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    [manager POST:allURL parameters:parame constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageArray.count) {
            NSData *data = [NSData data];
            for (NSDictionary *image in imageArray) {
                data = UIImagePNGRepresentation(image[@"image"]);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss.SS";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                
                [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"更换成功"];
        }else{
        
            [SVProgressHUD showErrorWithStatus:@"更换失败"];
        }
        if (success) {
            
            success(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         [SVProgressHUD showErrorWithStatus:@"上传失败"];
        NSLog( @"失败");
        NSLog(@"%@",error);
    }];
}

@end
