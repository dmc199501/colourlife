//
//  WTBaseViewController.h
//  WeiTown
//
//  Created by 沿途の风景 on 14-8-8.
//  Copyright (c) 2014年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTBaseViewController : UIViewController

@property (nonatomic,retain)UIView *barView;
@property (retain, nonatomic) IBOutlet UILabel *navTitle;
//用于取消网络请求
//@property(nonatomic,retain) NSMutableArray *requestURLs;
//
//-(void)goBackCancelRequest;
//-(void)clearRequest;
//-(void)removeRequestedURL: (NSURL *)url;
//-(void)addRequestedURL: (NSURL *)url;

//隐藏键盘
-(void)hideBaseKeyboardClicked:(id)sender;

@end
