//
//  NSArray+deleteNill.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/9/11.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (deleteNill)
+ (NSMutableDictionary *)removeNullFromDictionary:(NSDictionary *)dic;
+ (NSMutableArray *)removeNullFromArray:(NSArray *)arr;

@end
