//
//  MCPublicDataSingleton.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/9.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MCPublicDataSingleton : NSObject
@property(nonatomic, strong) NSDictionary *userDictionary;//保存在本地
@property(nonatomic, strong) NSDictionary *MailDictionary;
@property(nonatomic, assign) BOOL isRequestVersion;
@property(nonatomic, strong) NSString *ts;
@property(nonatomic, strong) NSString *isclean;
@property(nonatomic, strong) NSString *mail;
@property(nonatomic, strong) NSString *token;
@property(nonatomic, strong) NSString *isClean;
@property(nonatomic, strong) NSString *fanpiao;
@property(nonatomic, strong) NSString *honbao;
@property(nonatomic, strong) NSMutableArray *arrayOne;
@property(nonatomic, strong) NSMutableArray *arrayTwo;
@property(nonatomic, strong) NSDictionary *mapDic;



@property(nonatomic, strong) NSString *userNumber;
@property(nonatomic, strong) NSString *passWord;
@property(nonatomic, strong) NSString *dateString;// 时间
@property(nonatomic, assign) BOOL isLogin;


//等比压缩图片

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

//纠正ios图片方向
+ (UIImage *)fixOrientation:(UIImage *)srcImg;

+ (MCPublicDataSingleton *)sharePublicDataSingleton;

@end
