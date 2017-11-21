//
//  CFPopView.m
//  CFPopViewDemo
//
//  Created by TheMoon on 16/3/31.
//  Copyright © 2016年 CFJ. All rights reserved.
//

#import "CFPopView.h"
#import "CFFuncTableViewCell.h"
#import "CFFuncModel.h"
#define kScreenHeight  CGRectGetHeight([UIScreen mainScreen].bounds)
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
/**
 *  设置颜色RGB值
 */
#define RGBCOLOR(r,g,b,_alpha) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:_alpha]

@interface CFPopView ()<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end

static const CGFloat everyW = width;
static const CGFloat everyH = rowH;
// tableView的最小高度为10，会随着cell个数的增加改变
static CGFloat height = 10;
static const CGFloat maxH = 10 + everyH * 5;
@implementation CFPopView
 

/**
 *  传进来的字典数组对象
 */
+ (instancetype)popViewWithFuncDicts:(NSArray *)funcDictArr{
    
    CFPopView *popView = [[NSBundle mainBundle] loadNibNamed:@"CFPopView" owner:self options:nil].lastObject;
    
    popView.funcModels = [@[] mutableCopy];
    
    if (funcDictArr && funcDictArr.count) {
        
        for (NSDictionary *dict in funcDictArr) {
            
            CFFuncModel *funcModel = [[CFFuncModel alloc] initWithDict:dict];
            
            [popView.funcModels addObject:funcModel];
        }
        
        height = 10 + everyH * popView.funcModels.count;
        
    }
    // 最大高度为4个选项的高度
    height = height > maxH ? maxH : height;
    // 设置弹出视图的位置
    popView.frame = CGRectMake(kScreenWidth - everyW - 10 , 64, everyW, height);
    
    [popView createUIWithCount:popView.funcModels.count];
    
    return popView;
}


- (void)createUIWithCount:(NSInteger)count{
    
    self.tableView.layer.cornerRadius = 0;
    
    self.tableView.rowHeight = everyH;
    
    self.tableView.scrollEnabled = NO;
    
    self.bgView.layer.masksToBounds = YES;
    
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.28 green:0.33 blue:0.36 alpha:1.00];

    // 画三角形
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(width - 25, 10)];
    
    [path addLineToPoint:CGPointMake(width - 20, 2)];
    
    [path addLineToPoint:CGPointMake(width - 15, 10)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    // 颜色设置和cell颜色一样
    layer.fillColor = [UIColor colorWithRed:0.28 green:0.33 blue:0.36 alpha:1.00].CGColor;
    
    layer.strokeColor = [UIColor colorWithRed:0.28 green:0.33 blue:0.36 alpha:1.00].CGColor;
    
    layer.path = path.CGPath;
    
    [self.bgView.layer addSublayer:layer];
    
}


- (void)showInKeyWindow{
    
    _isShow = YES;
    
    self.alpha = 1.0;
    
    [self.bgView setAlpha:1.0];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.alpha = 1;
//    }];
}

- (void)dismissFromKeyWindow{
    
    _isShow = NO;
    
    self.alpha = 0;
    
    [self.bgView setAlpha:0];
    
    self.transform = CGAffineTransformIdentity;
    
    [self removeFromSuperview];
    
//    [UIView animateWithDuration:0.3 animations:^{
////        self.transform = CGAffineTransformMakeScale(0.7, 0.7);
////        self.transform = CGAffineTransformTranslate(self.transform, 40, -64);
////        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        self.transform = CGAffineTransformIdentity;
//        [self removeFromSuperview];
//    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.funcModels.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"funcCell";
    
    CFFuncTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"CFFuncTableViewCell" owner:self options:nil].lastObject;
    }
    
    if (!self.funcModels.count) {
        
        return cell;
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.funcModel = self.funcModels[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CFFuncTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
//    [tableView setSeparatorColor:[UIColor colorWithRed:0.39 green:0.43 blue:0.47 alpha:1.00]];

    
    cell.selected = NO;
    
    if(self.myFuncBlock){
        
        self.myFuncBlock (indexPath.row);
    }
    
    [self dismissFromKeyWindow];
}



@end
