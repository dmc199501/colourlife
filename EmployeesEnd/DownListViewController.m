//
//  DownListViewController.m
//  WeiTown
//
//  Created by Robert Xu on 15/5/21.
//  Copyright (c) 2015年 Hairon. All rights reserved.
//
#define HAPPYCLOUD UIColorFromRGB(0x302f35)   //红色
#define UIColorFromRGB(rgbValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height>=1136) : NO)

#import "DownListViewController.h"
#import "DownListManager.h"
#import "NoCell.h"
#import "UIView+IPhone5View.h"
@implementation DownListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.fileListArray = [self getDownFileArray];
        NSLog(@"%@",self.fileListArray);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"下载列表";
    // Do any additional setup after loading the view from its nib.
    self.titleImage.backgroundColor = HAPPYCLOUD;
//    if (IS_IPHONE_5) {
//        [self.tv fixYForIPhone5:NO addHight:YES];
//    }
     
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(setTabBarHidden:)]) {
//        [self.delegate setTabBarHidden:NO];
//    }
    //self.navigationController.navigationBarHidden=YES;
    if (self.navigationController.navigationBarHidden==NO) {
//        self.navigationController.navigationBarHidden=YES;
    }
    
}



#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.fileListArray&&self.fileListArray.count>0) {
        return self.fileListArray.count;
    }
    return 1;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fileListArray&&self.fileListArray.count>0) {
        return 44;
    }
    else{
        return 300;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *normalCell = @"normalCell";
    static NSString *noCell=@"noCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = UIColorFromRGB(0x313131);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    
    
    if (self.fileListArray&&self.fileListArray.count>0) {
       
        
        
        NSString *title =[self replaceUnicode:[self.fileListArray objectAtIndex:indexPath.row]] ;
        NSLog(@"%@",title);
        if (title) {
            cell.textLabel.text = title;
        }
        
    }
    else{
        NoCell *cell = (NoCell *)[tableView dequeueReusableCellWithIdentifier:noCell];
        if (!cell) {
            cell = [[NoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noCell];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
        
        
    }
    return cell;
}
- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.fileListArray&&self.fileListArray.count>0) {
        QLPreviewController *previewController = [[QLPreviewController alloc] init];
        previewController.dataSource = self;
       

        previewController.currentPreviewItemIndex = indexPath.row;
        [[self navigationController] pushViewController:previewController animated:YES];
        
        
//        if (self.navigationController.navigationBarHidden==YES) {
//            self.navigationController.navigationBarHidden=NO;
//        }
    }
        
  
}

//实现删除操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.fileListArray removeObjectAtIndex:indexPath.row];
        
        
        if ([self.fileListArray count] == 0) {
            
            [tableView reloadData];
        } else {
            
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
        }

        [DownListManager deleteDownPlist:indexPath.row];
    }
}


#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    if (self.fileListArray != nil) {
        
        return [self.fileListArray count];
    }
    return 0;
    
}

- (id)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [DownListManager getFileURLByName:[self.fileListArray objectAtIndex:index]];
}


- (void)backToRefreshBadge
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeBadgle" object:nil];
    
    [self.tv reloadData];
}


- (NSMutableArray *)getDownFileArray
{
    
    self.fileListArray = [DownListManager readDownPlist];
    return self.fileListArray;
}

- (void)dealloc {
//    [_tv release];
//    [_titleImage release];
//    [_fileListArray release];
//    [_previewController release];
//    [super dealloc];
}

- (IBAction)backClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
