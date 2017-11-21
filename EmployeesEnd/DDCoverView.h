//
//  ScrollableCoverView.h
//  ScrollabelCoverView
//
//  Created by tondyzhang on 16/7/20.
//  Copyright © 2016年 tondy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCoverView : UIView

@property(nonatomic, strong)UIButton* leftButton;
@property(nonatomic, strong)UIButton* rightButton;
@property(nonatomic, strong)UIImageView* backgroundView;

/**
 *  注册tableView，coverview将检测tableview的contentOffset来更新自己的UI
 *
 *  @param tableView
 */
-(void)registerTableView:(UITableView*)tableView;


@end
