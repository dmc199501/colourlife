//
//  CustomAlertView.h
//  Sonneteck
//
//  Created by 方燕娇 on 16/4/5.
//  Copyright © 2016年 listcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView

-(void)setTimerWithDuration:(NSTimeInterval)duration;

-(void)setAlertString:(NSString *)alertStr;

/**
 *  时间戳转时间
 *
 *  @param timestamp <#timestamp description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)convertTimestampToString:(long long)timestamp;

@end
