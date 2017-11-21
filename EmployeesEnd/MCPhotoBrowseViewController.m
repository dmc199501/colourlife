//
//  MCPhotoBrowseViewController.m
//  CommunityThrough
//
//  Created by 邓梦超 on 16/8/11.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCPhotoBrowseViewController.h"
#import "UIBarButtonItem+Item.h"
@implementation MCPhotoBrowseViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        self.photoArray = [NSMutableArray array];
        _currnetIndex = 0;
    }
    
    return self;
}


- (id)initWithPhotos:(NSArray *)imageArray currentShowIndex:(NSInteger)currnetIndex;
{
    self = [self init];
    if (self)
    {
        [self.photoArray setArray:imageArray];
        _currnetIndex = currnetIndex;
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
//    [self.view setBackgroundColor:[UIColor clearColor]];
//    [self.view setHidden:YES];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    //[((UILabel *)self.navigationController.navigationBar.titleView) setTextColor:[UIColor whiteColor]];
   // self.navigationBar_ZZ.lineImageViewHidden = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"fanhui"] highImage:[UIImage imageNamed:@"fanhui"] target:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"shanchu"] highImage:[UIImage imageNamed:@"shanchu"] target:self action:@selector(showDeleteAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    browseScrollView = [[MCBrowseScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
    [self.view insertSubview:browseScrollView atIndex:0];
    [browseScrollView setDelegate_ZZ:self];
    [browseScrollView setDataSource_ZZ:self];
    
    self.showDeleteButton = self.showDeleteButton;
    
    browseScrollView.currentShowIndex = _currnetIndex;
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@/%@", @(_currnetIndex + (NSInteger)1), @(self.photoArray.count)]];
    
    if (self.photoArray.count == 0 )
    {
        [self.navigationItem setTitle:@"0/0"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)setCurrnetIndex:(NSInteger)currnetIndex
{
    _currnetIndex = currnetIndex;
    browseScrollView.currentShowIndex = currnetIndex;
}

- (void)setShowDeleteButton:(BOOL)showDeleteButton
{
    _showDeleteButton = showDeleteButton;
//    [self.navigationController.navigationItem.rightBarButtonItem setHidden:!_showDeleteButton];
    
    
}

- (void)popSelf
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)showDeleteAlertView
{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"你确定要删除照片吗？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", @"删除", nil];
    [alertView show];
    [alertView setTag:1213];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    switch (alertView.tag)
    {
        case 1213:
        {
            switch (buttonIndex)
            {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    if (self.photoArray.count > browseScrollView.currentShowIndex)
                    {
                        [self.photoArray removeObjectAtIndex:browseScrollView.currentShowIndex];
                        
                        [browseScrollView reloadData];
                        
                        if ([self.delegate respondsToSelector:@selector(photoBrowseViewController:deleteIndex:currentPhotoArray:)])
                        {
                            [self.delegate photoBrowseViewController:self deleteIndex:browseScrollView.currentShowIndex currentPhotoArray:self.photoArray];
                        }
                        
                        
                        [browseScrollView reloadData];
                        if (_currnetIndex > 0)
                        {
                            _currnetIndex--;
                        }
                        
                        browseScrollView.currentShowIndex = _currnetIndex;
                        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@/%@", @(_currnetIndex + 1), @(self.photoArray.count)]];
                        
                        if (self.photoArray.count == 0 )
                        {
                            [self.navigationItem setTitle:@"0/0"];
                        }
                        
                    }
                    
                    
                }
                    break;
                default:
                    break;
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark ZZBrowseScrollViewDataSource
- (NSUInteger)numberOfPhotosInBrowseScrollView:(MCBrowseScrollView *)browseScrollView;
{
    return self.photoArray.count;
}

- (id )browseScrollView:(MCBrowseScrollView *)browseScrollView photoAtIndex:(NSUInteger)index;//return value is a nsurl or uiimage object;
{
    if (index < self.photoArray.count)
    {
        return [self.photoArray objectAtIndex:index];
    }
    return nil;
    //    return [UIImage imageNamed:nameString];
}

- (void)browseScrollViewDidScroll:(MCBrowseScrollView *)browseScrollView;
{
    
    
}

- (void)browseScrollView:(MCBrowseScrollView *)browseScrollView changeShowIndex:(NSInteger )showIndex fromIndex:(NSInteger )fromIndex NumberCount:(NSInteger )numberCount;
{
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@/%@", @(showIndex + (NSInteger)1), @(numberCount)]];
    
}

@end
