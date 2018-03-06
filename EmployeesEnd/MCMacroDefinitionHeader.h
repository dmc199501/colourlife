//
//  MCMacroDefinitionHeader.h
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/8.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define ZZ_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:CGSizeMake((maxSize.width) - 5.0, (maxSize.height)) options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define ZZ_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

#define BASEURL_AREA     @"https://openapi.colourlife.com/v1"
#define USER_ICON_URL @"http://iceapi.colourlife.com:8686/" //正式环境

//http://192.168.2.178:3011/v1
//http://114.119.7.98:30011/v1
#define BASEURL_USER     @"http://119.23.146.132::30012/v1"
//http://192.168.2.178:3012/v1
//http://114.119.7.98:30012/v1
#define BASEURL_COUMMUNITY   @"http://119.23.146.132:30002/v1"
//http://192.168.2.178:3002/v1
//http://114.119.7.98:30002/v1

#define BASEURL_UNIT     @"http://119.23.146.132:30003/v1"
#define BASEURL_PAY     @"http://119.23.146.132::3010/v1"
//http://192.168.2.143:3010/v1
//http://114.119.7.98:30010/v1
#define BASEURL_TASK    @"http://119.23.146.132:30014/v1"
#define BASEURL_FAMILY    @"http://119.23.146.132:30013/v1"
#define BASEURL_UPDATA    @"http://119.23.146.132:30020/v1"
#define BASEURL_COMMENTS  @"http://119.23.146.132:3015/v1"
//http://192.168.2.178:3015/v1
//http://114.119.7.98:30015/v1
#define BASEURL_HOUSEKEEPER   @"http://119.23.146.132:30013/v1"
#define BASEURL_COMPLAIN  @"http://119.23.146.132:30024/login"
#define BASEURL_SHOP @"http://192.168.2.178:30026/v1"
#define SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define LEFT_X(a)          CGRectGetMinX(a.frame)         //控件左边面的X坐标
#define RIGHT_X(a)         CGRectGetMaxX(a.frame)         //控件右面的X坐标
#define TOP_Y(a)           CGRectGetMinY(a.frame)         //控件上面的Y坐标
#define BOTTOM_Y(a)        CGRectGetMaxY(a.frame)         //控件下面的Y坐标

#define HEIGH(a)             CGRectGetHeight(a.frame)       //控件的高度
#define WIDTH(a)             CGRectGetWidth(a.frame)        //控件的宽度
#define CENTER_X(a)        CGRectGetMidX(a.frame)         //控件的中心X坐标
#define CENTER_Y(a)        CGRectGetMidY(a.frame)         //控件的中心Y坐标
#define  PURPLE_COLOER_ZZ   [UIColor colorWithRed:149 / 255.0 green:66 / 255.0 blue:154/ 255.0 alpha:1]  //紫色
#define  PURPLE_LIGHT_COLOER_ZZ   [UIColor colorWithRed:183 / 255.0 green:87 / 255.0 blue:184/ 255.0 alpha:1]  //紫色
#define  BLACKS_COLOR_ZZ      [UIColor colorWithRed:30 / 255.0 green:30 / 255.0 blue:30/ 255.0 alpha:1]    //黑色
#define  BLACK_COLOR_ZZ      [UIColor blackColor]    //黑色

#define  GRAY_COLOR_BACK_ZZ      [UIColor colorWithRed:180 / 255.0 green:180 / 255.0 blue:180 / 255.0 alpha:1]    //
#define  GRAY_COLOR_ZZ      [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1]    //灰色
#define  GRAY_LIGHT_COLOR_ZZ      [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1]    //浅灰色
#define  GRAY_LIGHTS_COLOR_ZZ      [UIColor colorWithRed:180 / 255.0 green:180 / 255.0 blue:180 / 255.0 alpha:0.2]    //浅浅灰色
#define  GRAY_LIGHTS_COLOR_BLAK      [UIColor colorWithRed:67 / 255.0 green:168 / 255.0 blue:232 / 255.0 alpha:1]    //浅浅灰色
#define  RED_COLOR_ZZ      [UIColor colorWithRed:255 / 255.0 green:64 / 255.0 blue:85/ 255.0 alpha:1]    //红色
#define  ORANGE_COLOR_ZZ      [UIColor colorWithRed:254 / 255.0 green:104 / 255.0 blue:2/ 255.0 alpha:1]    //橙色
#define  ORANGE_HIGHLIGHT_COLOR_ZZ      [UIColor colorWithRed:248 / 255.0 green:181 / 255.0 blue:81/ 255.0 alpha:1]    //亮橙色
#define  YELLOW_COLOR_ZZ      [UIColor colorWithRed:246 / 255.0 green:243 / 255.0 blue:238/ 255.0 alpha:1]    //黄色
#define  BACKGROUND_GRAY_COLOR_ZZ      [UIColor colorWithRed:250 / 255.0 green:249 / 255.0 blue:247/ 255.0 alpha:1]    //背景灰色
#define  GREEN_COLOR_ZZ      [UIColor colorWithRed:34 / 255.0 green:172 / 255.0 blue:56/ 255.0 alpha:1]    //绿色
#define  GREEN_HIGHLIGHT_COLOR_ZZ      [UIColor colorWithRed:0 / 255.0 green:139 / 255.0 blue:0/ 255.0 alpha:1]    //亮绿色
#define  LINE_GRAY_COLOR_ZZ      [UIColor colorWithWhite:237 / 255.0 alpha:1]    //线条灰色

#define RED_BUTTON_COLOR_ZZ     [UIColor colorWithRed:255 / 255.0 green:17 / 255.0 blue:72/ 255.0 alpha:1] //按钮红
#define BLUK_BUTTON_COLOR_ZZ    [UIColor colorWithRed:0/ 255.0 green:188 / 255.0 blue:255/ 255.0 alpha:1] //蓝
#define  YELLOW_COLOER_ZZ   [UIColor colorWithRed:255 / 255.0 green:227 / 255.0 blue:41/ 255.0 alpha:1]  //
#define BLUK_COLOR_MC    [UIColor colorWithRed:33/ 255.0 green:131 / 255.0 blue:254/ 255.0 alpha:1] //系统蓝
#define BLUK_COLOR    [UIColor colorWithRed:0/ 255.0 green:191 / 255.0 blue:254/ 255.0 alpha:1] //蓝
#define BLUK_COLOR_ZAN_MC    [UIColor colorWithRed:0/ 255.0 green:195 / 255.0 blue:255/ 255.0 alpha:1] //点赞

#define  DARK_COLOER_ZZ   [UIColor colorWithRed:44 / 255.0 green:54 / 255.0 blue:64/ 255.0 alpha:1]  //
#define ZZKeyWindow [UIApplication sharedApplication].keyWindow

#import <UIKit/UIKit.h>

@interface MCMacroDefinitionHeader : UIViewController

@end
