//
//  MCBrowseScrollView.m
//  CommunityThrough
//
//  Created by 邓梦超 on 16/8/11.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCBrowseScrollView.h"

@implementation MCBrowseScrollView
- (void)dealloc
{
    isDealloc = YES;
    self.dataSource_ZZ = nil;
    self.delegate_ZZ = nil;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.widthSpace = 10;//默认为10
        self.visiblePhotosMutableSet = [NSMutableSet set];
        firshShowIndex = -1;
        super.delegate = self;
        //        for (int i = 0; i < 6; i++)
        //        {
        //            ZZZoomScrollView *zoomScrollView = [[ZZZoomScrollView alloc]initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        //            [self addSubview:zoomScrollView];
        //            NSString *nameString = [NSString stringWithFormat:@"%.1i.png",i + 1];
        //            UIImage *image = [UIImage imageNamed:nameString];
        //            [zoomScrollView.zoomPhotoImageView setImage:image];
        //
        //        }
        //        [self setContentSize:CGSizeMake(self.frame.size.width * 6, self.frame.size.height)];
        [self setPagingEnabled:YES];
    }
    
    
    return self;
}

- (void)setDataSource_ZZ:(id<ZZBrowseScrollViewDataSource>)dataSource_ZZ
{
    _dataSource_ZZ = dataSource_ZZ;
    [self reloadData];
}

- (void)setDelegate_ZZ:(id)delegate_ZZ
{
    _delegate_ZZ = delegate_ZZ;
    
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate
{
    if(isDealloc == YES) return;
    __weak id tempDelegate = delegate;
    _delegate_ZZ = tempDelegate;
    super.delegate = self;
}



- (void)setImageForZoomPage:(MCZoomScrollView *)zoomScrollView index:(NSInteger )index;
{
    
    id imageOrURL = nil;
    if ([self.dataSource_ZZ respondsToSelector:@selector(browseScrollView:photoAtIndex:)])
    {
        imageOrURL = [self.dataSource_ZZ browseScrollView:self photoAtIndex:index];
    }
    
    if ([imageOrURL isKindOfClass:[UIImage class]])
    {
        [zoomScrollView.zoomPhotoImageView setImage:(UIImage *)imageOrURL];
    }
    else if([imageOrURL isKindOfClass:[NSString class]])
    {
        if([imageOrURL length] > 0)
        {
            
            
            [zoomScrollView.zoomPhotoImageView set_ImageWithURL:[NSURL URLWithString:imageOrURL]];
        }
        
    }
    else if([imageOrURL isKindOfClass:[NSURL class]])//只考虑网络的url
    {
        [zoomScrollView.zoomPhotoImageView set_ImageWithURL:imageOrURL];
        
        /* //如果从像册取可考虑此
         if ([[[_photoURL scheme] lowercaseString] isEqualToString:@"assets-library"])
         {
         ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
         [assetslibrary assetForURL:_photoURL
         resultBlock:^(ALAsset *asset){
         ALAssetRepresentation *rep = [asset defaultRepresentation];
         CGImageRef iref = [rep fullScreenImage];
         if (iref) {
         self.underlyingImage = [UIImage imageWithCGImage:iref];
         }
         }
         failureBlock:^(NSError *error) {
         }];
         }
         
         */
        
    }
       
}


- (BOOL)isShowingPageForIndex:(NSUInteger)index
{
    for (MCZoomScrollView *page in self.visiblePhotosMutableSet)
    {
        if (page.index == index) return YES;
    }
    return NO;
}

- (void) setCurrentShowIndex:(NSInteger)currentShowIndex
{
    _currentShowIndex = currentShowIndex;
    [self setContentOffset:CGPointMake(currentShowIndex * self.frame.size.width, 0) animated:NO];
    
    [self layoutPhotoView];
    
}


- (void)layoutPhotoView
{
    
    CGRect visibleBounds = self.bounds;
    NSInteger iFirstIndex = (NSInteger)floor(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    NSInteger iLastIndex  = (NSInteger)floor(CGRectGetMaxX(visibleBounds) / CGRectGetWidth(visibleBounds));
    
    if (iFirstIndex > numberCount - 1) iFirstIndex = numberCount - 1;
    if (iFirstIndex < 0) iFirstIndex = 0;
    
    if (iLastIndex > numberCount - 1) iLastIndex = numberCount - 1;
    if (iLastIndex < 0) iLastIndex = 0;
    
    if(firshShowIndex == iFirstIndex)
    {
        return;
    }
    firshShowIndex = iFirstIndex;
    
    // Recycle no longer needed pages
    
    NSMutableSet *invisiblePhotosMutableSet = [NSMutableSet set];//不可见的视图
    
    for (MCZoomScrollView *page in self.visiblePhotosMutableSet)
    {
        NSInteger pageIndex = page.index;//清除不可见视图
        if (pageIndex < (NSUInteger)iFirstIndex || pageIndex > (NSUInteger)iLastIndex)
        {
            [page removeFromSuperview];
            [invisiblePhotosMutableSet addObject:page];
        }
    }
    [self.visiblePhotosMutableSet minusSet:invisiblePhotosMutableSet];//清掉不要的视图
    
    //可见的视图
    for (NSUInteger index = (NSUInteger)iFirstIndex; index <= (NSUInteger)iLastIndex; index++)
    {
        BOOL isShowingPageForIndex = [self isShowingPageForIndex:index];
        if (!isShowingPageForIndex)//本应出现，但还没创建
        {
            MCZoomScrollView *zoomScrollView = [[MCZoomScrollView alloc]initWithFrame:CGRectMake(index * self.frame.size.width + self.widthSpace / 2.0, 0, self.frame.size.width - self.widthSpace, self.frame.size.height)];
            [self addSubview:zoomScrollView];
            [self.visiblePhotosMutableSet addObject:zoomScrollView];
            [self setImageForZoomPage:zoomScrollView index:index];
            zoomScrollView.index = index;
        }
    }
    
    
}





- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"%@", scrollView);
    
    if (scrollView == self)
    {
        //-----------------------------------
        [self layoutPhotoView];
    }
    if ([self.delegate_ZZ respondsToSelector:@selector(browseScrollViewDidScroll:)])
    {
        [self.delegate_ZZ browseScrollViewDidScroll:self];
    }
    
    //-----------------------------------
    //计算刷新页面：当前页面移出屏幕时，下一页面开始刷新
    //1.界面右侧移出左边，2.界面左侧移出右边
    NSInteger lastIndex = _currentShowIndex;
    
    if (_currentShowIndex * scrollView.frame.size.width + scrollView.frame.size.width <= scrollView.contentOffset.x)//1.界面右侧移出左边
    {
        //当前的值取当前屏幕的中间
        _currentShowIndex = (scrollView.contentOffset.x + 0.5 * scrollView.frame.size.width) / scrollView.frame.size.width;
        if ([self.delegate_ZZ respondsToSelector:@selector(browseScrollView:changeShowIndex:fromIndex:NumberCount:)])
        {
            [self.delegate_ZZ browseScrollView:self changeShowIndex:_currentShowIndex fromIndex:lastIndex NumberCount:numberCount];
        }
        
    }
    else if(self.currentShowIndex * scrollView.frame.size.width >= scrollView.contentOffset.x + scrollView.frame.size.width)//2.界面左侧移出右边
    {
        //当前的值取当前屏幕的中间
        _currentShowIndex = (scrollView.contentOffset.x + 0.5 * scrollView.frame.size.width) / scrollView.frame.size.width;
        if ([self.delegate_ZZ respondsToSelector:@selector(browseScrollView:changeShowIndex:fromIndex:NumberCount:)])
        {
            [self.delegate_ZZ browseScrollView:self changeShowIndex:_currentShowIndex fromIndex:lastIndex NumberCount:numberCount];
        }
    }
    
    
}


- (void)reloadData
{
    if ([_dataSource_ZZ respondsToSelector:@selector(numberOfPhotosInBrowseScrollView:)])
    {
        numberCount = [_dataSource_ZZ numberOfPhotosInBrowseScrollView:self];
    }
    
    [self setContentSize:CGSizeMake(self.frame.size.width * numberCount, self.frame.size.height)];
    [self layoutPhotoView];
    
}



@end
