//
//  CustomAlertView.m
//  Sonneteck
//
//  Created by 方燕娇 on 16/4/5.
//  Copyright © 2016年 listcloud. All rights reserved.
//

#import "CustomAlertView.h"
#import "MCMacroDefinitionHeader.h"

@interface CustomAlertView ()

{
    NSTimer *timer;
    NSString *alertString;
}

@property (strong,nonatomic) UIView *contentView;
@property (strong,nonatomic) UILabel *alertLabel;


@end

@implementation CustomAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.1]];
        [self addSubview:self.contentView];
    }
    
    return self;
}


-(void)setTimerWithDuration:(NSTimeInterval)duration{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(removeAlertView) userInfo:nil repeats:YES];
}


-(void)setAlertString:(NSString *)alertStr{
    
    CGFloat height = [self computeTextHeightWithString:alertStr andWidth:_alertLabel.frame.size.width andFontSize:_alertLabel.font];
    
    [_contentView setFrame:CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _contentView.frame.size.width, height + 20)];
    [_alertLabel setFrame:CGRectMake(_alertLabel.frame.origin.x, _alertLabel.frame.origin.y, _alertLabel.frame.size.width, height)];
    
    [_alertLabel setText:alertStr];
    
}

#pragma mark -- 响应方法


-(void)removeAlertView{
    
    [self removeFromSuperview];
    
    if (timer != nil) {
        
        [timer invalidate];
        timer = nil;
    }
    
}

#pragma mark -- 懒加载

-(UIView *)contentView{
    
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , 180, 44)];
        //设置居中位置
        
        [_contentView setCenter:ZZKeyWindow.center];
        
        [_contentView setBackgroundColor:[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:0.70]];
        
        [_contentView.layer setMasksToBounds:YES];
        [_contentView.layer setCornerRadius:10];
        
        [_contentView.layer setBorderWidth:0.5f];
        [_contentView.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        [_contentView addSubview:self.alertLabel];
    }
    
    return _contentView;
}

-(UILabel *)alertLabel{
    
    if (_alertLabel == nil) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (_contentView.frame.size.height - 24)/2, 160, 24)];
        [_alertLabel setTextAlignment:NSTextAlignmentCenter];
        [_alertLabel setTextColor:[UIColor whiteColor]];
        [_alertLabel setFont:[UIFont systemFontOfSize:16.0f]];
        
        [_alertLabel setNumberOfLines:0];
    }
    
    return _alertLabel;
}

/**
 *  计算文本高度
 *
 *  @param string   要计算的文本
 *  @param width    单行文本的宽度
 *  @param fontSize 文本的字体size
 *
 *  @return 返回文本高度
 */
-(CGFloat)computeTextHeightWithString:(NSString *)string andWidth:(CGFloat)width andFontSize:(UIFont *)fontSize{
    
    CGRect rect  = [string boundingRectWithSize:CGSizeMake(width, 10000)
                                        options: NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:fontSize}
                                        context:nil];
    return ceil(rect.size.height);
}


/**
 *  时间戳转时间
 *
 *  @param timestamp <#timestamp description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)convertTimestampToString:(long long)timestamp{
    
    //设置时间显示格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    //系统格式：
//    [formatter setDateStyle:NSDateFormatterFullStyle];
//    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    //自定义格式：
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    
    //将时间戳(long long 型)转化为NSDate ,注意除以1000(IOS要求是10位的时间戳)
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    
    //将NSDate按格式转化为对应的时间格式字符串
    NSString *timeString = [formatter stringFromDate:date];
    
    return timeString;
}


@end
