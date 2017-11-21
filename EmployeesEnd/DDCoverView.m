//
//  ScrollableCoverView.m
//  ScrollabelCoverView
//
//  Created by tondyzhang on 16/7/20.
//  Copyright © 2016年 tondy. All rights reserved.
//

#import "DDCoverView.h"

#define kNavigationHeight 64

@interface DDCoverView()
{
    
}

@property(nonatomic, assign)float defaultOffsetY;
@property(nonatomic, assign)float defaultHeight;
@property(nonatomic, strong)UITableView* tableView;

@end

@implementation DDCoverView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

-(void)registerTableView:(UITableView*)tableView
{
    self.tableView = tableView;
    self.defaultOffsetY = (0 - tableView.contentInset.top);
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view = [super hitTest:point withEvent:event];
    if (view == self || view == self.backgroundView) {
        return nil;
    }
    return view;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if ([object isKindOfClass:[UITableView class]]) {
            [self updateUIWithContentOffsetY:((UITableView*)object).contentOffset.y];
        }
    }
}

-(void)updateUIWithContentOffsetY:(float)contentOffsetY
{
    float height = MAX((kNavigationHeight-contentOffsetY), kNavigationHeight);
    self.frame = CGRectMake(0, 0, self.frame.size.width, height);
}

#pragma mark -- setters

-(void)setLeftButton:(UIButton *)leftButton
{
    _leftButton = leftButton;
    [self addSubview:leftButton];
}

-(void)setRightButton:(UIButton *)rightButton
{
    _rightButton = rightButton;
    [self addSubview:rightButton];
}

-(void)setBackgroundView:(UIImageView *)backgroundView
{
    _backgroundView = backgroundView;
    _backgroundView.frame = self.bounds;
    self.defaultHeight = _backgroundView.frame.size.height;
    [self addSubview:backgroundView];
    if (self.leftButton) {
        [self bringSubviewToFront:self.leftButton];
    }
    if (self.rightButton) {
        [self bringSubviewToFront:self.rightButton];
    }
}

#pragma mark -- methods to override

-(void)layoutSubviews
{
    if (self.backgroundView) {
        
        float width = self.bounds.size.width*MAX(1, (self.bounds.size.height/self.defaultHeight));
        float height = self.bounds.size.height;
        self.backgroundView.frame = CGRectMake(0, 0, width, height);
    }
}

@end
