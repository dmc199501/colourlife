//
//  SubViewController.h
//  SeleceView
//
//  Created by apple on 15/4/14.
//  Copyright (c) 2015年 ___liupei___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TypeDelegate;
@interface SubViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UIView *backView;
    UIView *showView;
}
@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)NSMutableArray *dataArray;
@property(nonatomic, assign)id <TypeDelegate> typeDelegate;
@property(nonatomic, copy)NSString *checkMark;
@property(nonatomic, copy)NSString *headTitle;
@property(nonatomic)CGFloat typeOrginY;
- (void)showViw:(UIView *)currentView;
- (void)hideView;
@end
@protocol TypeDelegate <NSObject>

- (void)typeViewdidClick:(SubViewController *)type AtIndex:(NSInteger)index;
- (void)typeviewControllerDidCancel:(SubViewController *)type;
@end