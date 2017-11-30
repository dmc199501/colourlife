//
//  XWXAuth.h
//  ColourlifeAuth
//
//  Created by Robert Xu on 16/7/12.
//  Copyright © 2016年 listcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - enum XWXOAuthStatus
typedef NS_ENUM(NSUInteger, XWXOAuthStatus) {
    XWXOAuthStatusCancel = 0,
    XWXOAuthStatusSuccess,
    XWXOAuthStatusError
};


#pragma mark - XWXAuthResult
@interface XWXAuthResult : NSObject

@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *tokenType;
@property (copy, nonatomic) NSString *refreshToken;
@property (copy, nonatomic) NSString *scope;
@property (copy, nonatomic) NSString *expiresIn;
@property (copy, nonatomic) NSString *accountType;
@property (copy, nonatomic) NSString *username;

- (void)setResultData:(NSDictionary *)data;

@end

#pragma mark - XWXAuthDelegate
@protocol XWXAuthDelegate <NSObject>

@required

- (void)authWithOAuthStatus:(XWXOAuthStatus)status result:(XWXAuthResult *)result;

@end

#pragma mark - XWXAuth
@interface XWXAuth : NSObject

+ (XWXAuth *)sharedServices;
- (void)oauthWithAppId:(NSString *)appId
              delegate:(__kindof UIViewController<XWXAuthDelegate> *)delegate
              clientId:(NSString *)clientId
           redirectURI:(NSString *)redirectURI
                 state:(NSString *)state
           accountType:(NSString *)accountType
                 isDev:(BOOL)isDev; //true代表使用测试环境，false代表使用正式环境

- (BOOL)handleURL:(NSURL *)url;

- (NSString *)currentVersion;

@end
