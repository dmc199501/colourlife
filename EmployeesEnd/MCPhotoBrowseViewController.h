//
//  MCPhotoBrowseViewController.h
//  CommunityThrough
//
//  Created by 邓梦超 on 16/8/11.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCRootViewControler.h"
#import "MCBrowseScrollView.h"

@protocol ZZPhotoBrowseViewControllerDelegate;

@interface MCPhotoBrowseViewController : MCRootViewControler<UIScrollViewDelegate, ZZBrowseScrollViewDataSource, ZZBrowseScrollViewDelegate>
{
    MCBrowseScrollView *browseScrollView;
}
@property (nonatomic, assign)id delegate;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, assign) BOOL showDeleteButton;
@property (nonatomic, assign) NSInteger currnetIndex;


- (id)initWithPhotos:(NSArray *)imageArray currentShowIndex:(NSInteger )currnetIndex;


@end


@protocol ZZPhotoBrowseViewControllerDelegate <NSObject>

@optional
//点击删除按钮后，弹出的alertView选择
- (void)photoBrowseViewController:(MCPhotoBrowseViewController *)photoBrowseViewController deleteIndex:(NSInteger )currnetIndex currentPhotoArray:(NSArray *)photoArray;



@end
