//
//  DownListViewController.h
//  WeiTown
//
//  Created by Robert Xu on 15/5/21.
//  Copyright (c) 2015年 Hairon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "WTBaseViewController.h"
@interface DownListViewController : WTBaseViewController <UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tv;
@property (retain, nonatomic) IBOutlet UIImageView *titleImage;


@property (retain, nonatomic) NSMutableArray *fileListArray;
@property (retain, nonatomic) QLPreviewController *previewController;

- (NSMutableArray *)getDownFileArray;

- (IBAction)backClicked:(id)sender;

@end
