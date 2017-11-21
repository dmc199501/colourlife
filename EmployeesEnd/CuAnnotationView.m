//
//  CuAnnotationView.m
//  WeiTown
//
//  Created by kakatool on 15-3-31.
//  Copyright (c) 2015年 Hairon. All rights reserved.
//

#import "CuAnnotationView.h"
//#define kWidth  120.f
#define kWidth  75.f
#define kHeight 40.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0
@interface CuAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@end

@implementation CuAnnotationView
@synthesize calloutView = _calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize   portrait = _portrait;
@synthesize nameLabel = _nameLabel;

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
                    annotationType:(NSInteger)type{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        self.annotationType = type;
        
        self.backgroundColor = [UIColor clearColor];
        
//                _portraitImageView =[[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitHeight)];
        _portraitImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_portraitImageView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth,25)];
//        if (self.annotationType == 0) {
//            _nameLabel.frameOriginY = -10;
//            _nameLabel.frameSizeHeight = 60;
//            _portraitImageView.frameSizeHeight+=30;
//        }
        _nameLabel.backgroundColor = [UIColor yellowColor];
        self.nameLabel.backgroundColor  = [UIColor clearColor];
       self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        = [UIColor whiteColor];
        self.nameLabel.font             = [UIFont systemFontOfSize:15.f];
        self.nameLabel.numberOfLines = 2;
        [self addSubview:self.nameLabel];
        
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(didSelectedEventWithCuAnnotationView:)]) {
            [self.delegate didSelectedEventWithCuAnnotationView:self];
        }
        
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];

    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}
- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
    
 
}

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}
//动态设置titleLabel 的宽度
- (void)setWidth:(NSString *)text{
    CGSize titleSize = [text sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
   }


@end
