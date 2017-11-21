//
//  MCBrowseScrollView.h
//  CommunityThrough
//
//  Created by 邓梦超 on 16/8/11.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCZoomScrollView.h"

@protocol ZZBrowseScrollViewDataSource;
@protocol ZZBrowseScrollViewDelegate;
@interface MCBrowseScrollView : UIScrollView<UIScrollViewDelegate>{


    NSInteger numberCount;
    NSInteger firshShowIndex;//当前第一个显示的是第几页。
    
    BOOL isDealloc;

}
@property (nonatomic, strong)NSMutableArray *recycledPhotosMutableArray;//用于循环的视图
@property (nonatomic, strong)NSMutableSet *visiblePhotosMutableSet;//可见的视图

@property (nonatomic, assign)id<ZZBrowseScrollViewDataSource > dataSource_ZZ;//数据源。
@property (nonatomic, assign)id<ZZBrowseScrollViewDelegate> delegate_ZZ;//设置delegate无效果，delegate只允许内部使用。

@property (nonatomic, assign)NSInteger currentShowIndex;//当前是第几页。

@property (nonatomic, assign)float widthSpace;//默认为10

- (void )reloadData;


@end

@protocol ZZBrowseScrollViewDataSource <NSObject>

- (NSUInteger)numberOfPhotosInBrowseScrollView:(MCBrowseScrollView *)browseScrollView;
- (id )browseScrollView:(MCBrowseScrollView *)browseScrollView photoAtIndex:(NSUInteger)index;//return value is a nsurl or uiimage object;

@end


@protocol ZZBrowseScrollViewDelegate <NSObject>

- (void)browseScrollViewDidScroll:(MCBrowseScrollView *)browseScrollView;
- (void)browseScrollView:(MCBrowseScrollView *)browseScrollView  changeShowIndex:(NSInteger )showIndex fromIndex:(NSInteger )fromIndex NumberCount:(NSInteger )numberCount;



@end
