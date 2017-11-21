//
//  MCjspush.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/9/12.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPUSHService.h"
@interface MCjspush : NSObject
- (void)setTags:(NSMutableSet **)tags addTag:(NSString *)tag;
- (void)analyseInput:(NSString **)alias tags:(NSSet **)tags;
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias;
- (NSString *)logSet:(NSSet *)dic;
@end
