//
//  ISNull.m
//  CardToon
//
//  Created by fengwanqi on 13-8-1.
//  Copyright (c) 2013年 com.coortouch.ender. All rights reserved.
//

#import "ISNull.h"

@implementation ISNull

+(BOOL)isNilOfSender:(NSObject *)sender
{
    if (!sender) {
        return YES;
    }
    if ([sender isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)sender;
        if (array.count) {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    //NSLog(@"sender.class=%@",[sender class]);
    if ([sender isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)sender;
        if ([dic allKeys].count) {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    if ([sender isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)sender;
        if (str != NULL && str.length > 0) {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    //NSLog(@"sender.class=%@,line=%d,func=%s",sender.class,__LINE__,__FUNCTION__);
    return YES;
}

@end
