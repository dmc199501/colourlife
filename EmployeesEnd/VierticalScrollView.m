//
//  VierticalScrollView.m
//  上下滚动btn
//
//  Created by 李杨 on 16/2/25.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "VierticalScrollView.h"
#import "UIView+FrameExtension.h"
#define MMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define MMRandomColor MMColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
#define Screen_width ([UIScreen mainScreen].bounds.size.width)
#define Screen_height ([UIScreen mainScreen].bounds.size.height)
#define BTNWidth self.bounds.size.width
#define BTNHeight self.bounds.size.height
@interface VierticalScrollView ()
@property (nonatomic,strong) NSMutableArray *titles;
@property(assign, nonatomic)int titleIndex;
@property(assign, nonatomic)int index;

@end
@implementation VierticalScrollView

-(instancetype)initWithArray:(NSArray *)titles AndFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        NSMutableArray *MutableTitles = [NSMutableArray arrayWithArray:titles];
        NSString *str = @"";
        self.titles = MutableTitles;
        [self.titles addObject:str];
        self.index = 1;
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(80, 1, BTNWidth, BTNHeight);
        btn.tag = self.index;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *titel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 20)];
        [btn addSubview:titel];
        [titel setText:self.titles[0]];
        [titel setFont:[UIFont systemFontOfSize:13]];
        [titel setTextColor:[UIColor grayColor]];
        [titel setTextAlignment:NSTextAlignmentLeft];

        
//        [btn setTitle:self.titles[0] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [btn setBackgroundColor:[UIColor greenColor]];
//        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        [btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
//       
        // [btn setLeft:100];
        
       //btn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        
        [self addSubview:btn];
        self.clipsToBounds = YES;
        
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextButton) userInfo:nil repeats:YES];
    }

    return self;
}

+(instancetype)initWithTitleArray:(NSArray *)titles AndFrame:(CGRect)frame{

  

    return [[self alloc]initWithArray:titles AndFrame:frame];
}

-(void)nextButton{
    UIButton *firstBtn = [self viewWithTag:self.index];
    UIButton *modelBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, BTNHeight+1, BTNWidth, BTNHeight)];
    [modelBtn setBackgroundColor:[UIColor clearColor]];
    modelBtn.tag = self.index + 1;
    if ([self.titles[self.titleIndex+1] isEqualToString:@""]) {
        self.titleIndex = -1;
        self.index = 0;
    }
    if (modelBtn.tag == self.titles.count) {
        
        modelBtn.tag = 1;
    }
    
    [modelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 20)];
    [modelBtn addSubview:titel];
    [titel setText:self.titles[self.titleIndex+1] ];
    [titel setFont:[UIFont systemFontOfSize:13]];
    [titel setTextAlignment:NSTextAlignmentLeft];
    [titel setTextColor:[UIColor grayColor]];
//    [modelBtn setTitle:self.titles[self.titleIndex+1] forState:UIControlStateNormal];
//    [modelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [modelBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    
   // [modelBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    // modelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -180, 0, 0);
    [self addSubview:modelBtn];
    
    [UIView animateWithDuration:0.25 animations:^{
        firstBtn.y = -BTNHeight;
        modelBtn.y = 0;
        
        
    } completion:^(BOOL finished) {
        [firstBtn removeFromSuperview];
        //[titel removeFromSuperview];
        
    } ];
    self.index++;
    self.titleIndex++;
    
    
    
    
    
    
    
}

-(void)clickBtn:(UIButton *)btn{

    if ([self.delegate respondsToSelector:@selector(clickTitleButton:)]) {
        
        [self.delegate clickTitleButton:btn];
        
    }
    
    
    
    
}

@end
