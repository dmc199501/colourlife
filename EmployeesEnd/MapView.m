//
//  MapView.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/6.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MapView.h"
#define MAPVIEW_WIDTH 320
#define MAPVIEW_HEIGHT 180

#define NUMBER_WIDTH 150
#define NUMBER_LABEL_WIDTH  55
#define NUMBER_NUM_WIDTH  100

#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]
@implementation MapView
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.frame = CGRectMake(0, 45, MAPVIEW_WIDTH, MAPVIEW_HEIGHT);
        self.backgroundColor = [UIColor whiteColor];
        
        
        //地图
        
        //标题
        _titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAPVIEW_WIDTH, 40)];
        _titleBgView.backgroundColor = UIColorFromRGBA(0xFFFFFF, 0.8);
        [self addSubview:_titleBgView];
        
        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(320 - 20, 15, 7, 11)];
        arrowView.image = [UIImage imageNamed:@"huise"];
        [_titleBgView addSubview:arrowView];
        
        _mapIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 25, 25)];
        _mapIcon.image = [UIImage imageNamed:@"mapico"];
        
        [_titleBgView addSubview:_mapIcon];
        
        _mapLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 7, 60, 25)];
        _mapLabel.text = @"战略地图";
        _mapLabel.font = [UIFont systemFontOfSize:14];
        _mapLabel.backgroundColor = [UIColor clearColor];
        
        [_titleBgView addSubview:_mapLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
