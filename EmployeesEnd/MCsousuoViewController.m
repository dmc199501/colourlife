//
//  MCsousuoViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/2.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCsousuoViewController.h"
#import "MCsousuoTableViewCell.h"
#import "MCHomePageController.h"
#import "MCContactViewController.h"
#import "MCWebViewController.h"
#import "MCrelatedViewController.h"
#import "MCMoreMeassgeViewController.h"
@interface MCsousuoViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *resultArray;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong) NSMutableArray *personneArray;
@property(nonatomic,strong) NSMutableArray *messageArray;


//@property(nonatomic,strong)NSString *keyword;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MCsousuoViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        personnellistMutableArray = [NSMutableArray array];
        messagelistMutableArray = [NSMutableArray array];
        APPlistMutableArray = [NSMutableArray array];
        APPArray = [NSMutableArray array];


       
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSArray *appArray = [defaults objectForKey:@"searchAPPs"];
    NSArray *cyArray = [[appArray objectAtIndex:0] objectForKey:@"list"];
    NSArray *qtArray = [[appArray objectAtIndex:1] objectForKey:@"list"];
    for (int i= 0; i<cyArray.count; i++) {
        [APPlistMutableArray addObject:cyArray[i]];
    }
    for (int i= 0; i<qtArray.count; i++) {
        [APPlistMutableArray addObject:qtArray[i]];
    }
    NSLog(@"%@",APPlistMutableArray);
   

    
    
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    // self.navigationController.delegate = self;
    
   // self.view.backgroundColor = [UIColor grayColor];
    //[self prefersStatusBarHidden];
    
    [self.view addSubview:[self headView]];
    
    

    // Do any additional setup after loading the view.
}
//#pragma mark - 隐藏导航栏代理方法
///**
// *隐藏导航栏
// */
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//    // 判断要显示的控制器是否是自己
//    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(UITableView *)tableView{
    
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT-20) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 44;
        _tableView.layer.cornerRadius = 5;
        //_tableView.tableHeaderView = [self headView];
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
//UISearchBar作为tableview的头部
-(UIView *)headView{
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    if (iPhoneX) {
         searchBar.frame=CGRectMake(0, 40, SCREEN_WIDTH, 44);
    }else{
        searchBar.frame=CGRectMake(0, 20, SCREEN_WIDTH, 44);
        
    }
    
    searchBar.keyboardType = UIKeyboardTypeWebSearch;
    searchBar.placeholder = @"请输入搜索关键字";
    searchBar.delegate = self;
    
    
    [searchBar becomeFirstResponder];
   
    //底部的颜色
    searchBar.backgroundColor  = [UIColor grayColor];
    
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    searchBar.barStyle = UIBarStyleDefault;
    self.navigationController.hidesBarsWhenKeyboardAppears = YES;
        
    
//    for (UIView *view in searchBar.subviews) {
//        if ([view isKindOfClass:NSClassFromString(@"UIView")]&&view.subviews.count>0) {
//            [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor redColor]];
//            [[view.subviews objectAtIndex:0] removeFromSuperview];
//                        break;
//        }
//    }
    
    return searchBar;
}
#pragma mark-searchBarDelegate

//在搜索框中修改搜索内容时，自动触发下面的方法
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
    
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    NSLog(@"开始输入搜索内容");
    searchBar.showsCancelButton = YES;//取消的字体颜色，
    [searchBar setShowsCancelButton:YES animated:YES];
    
    //改变取消的文本
    for(UIView *view in [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    for (UIView *searchbuttons in [searchBar subviews]){
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            // 修改文字颜色
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            
            
        }
    }

    NSLog(@"输入搜索内容完毕");
}

//搜框中输入关键字的事件响应
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.souStr = [NSString stringWithFormat:@"%@",searchText];
    
    
}

//取消的响应事件
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"取消搜索");
    [searchBar setShowsCancelButton:NO animated:YES];
   
    [self.navigationController popViewControllerAnimated:YES];
    

}

//键盘上搜索事件的响应
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"搜索");
    
    [self getsearch];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)getsearch{
    [messagelistMutableArray removeAllObjects];
    [personnellistMutableArray removeAllObjects];
    [_tableView removeFromSuperview];
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITableView class]])
        {
            [view removeFromSuperview];
        }
    }
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setValue:self.souStr forKey:@"keyword"];
    
    [SVProgressHUD showWithStatus:@"卖力搜索中..."];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/phonebook/search" parameters:sendDictionary success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]])
            {
                _personneArray = dicDictionary[@"content"];
                if (_personneArray.count>3) {
                    NSArray *smallArray = [_personneArray subarrayWithRange:NSMakeRange(0, 3)];
                    [personnellistMutableArray setArray:smallArray];
                }else{
                [personnellistMutableArray setArray:dicDictionary[@"content"]];
                
                }
                 [self.view addSubview:self.tableView];
                
                [_tableView reloadData];

                
            }
            
            return ;
            
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:[dicDictionary objectForKey:@"message"]];
            
            [_tableView reloadData];

        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];
    NSString *corpID = [defaults objectForKey:@"corpId"];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:username forKey:@"username"];
    [dic setValue:@1 forKey:@"page"];
     [dic setValue:@9999 forKey:@"pagesize"];
    [dic setValue:self.souStr forKey:@"keyword"];
    
    NSString *corpType = [defaults objectForKey:@"corpType"];
    if ([corpType isEqualToString:@"101"]) {
       
        [dic setValue:@"" forKey:@"corp_id"];
        
    }else{
        
        [dic setValue:corpID forKey:@"corp_id"];
        
    }

   

    
   
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/push2/homepush" parameters:dic success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                _messageArray = dicDictionary[@"content"][@"data"];
                NSArray *array = dicDictionary[@"content"];
                if (array.count>3) {
                    NSArray *smallArray = [array subarrayWithRange:NSMakeRange(0, 3)];
                     [messagelistMutableArray setArray:smallArray];
                }else{
                [messagelistMutableArray setArray:dicDictionary[@"content"][@"data"]];
                
                }
                
               
              
                
                
               
                [_tableView reloadData];
                //[self setRedView];
                [_tableView.mj_header endRefreshing];
                
                
                
            }
            
        }else{
            
           
            [_tableView reloadData];
            //[self setRedView];
            [_tableView.mj_header endRefreshing];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];
    

    [self searchAPP];


}
- (void)searchAPP{
    //需要事先情况存放搜索结果的数组
    
    [APPArray removeAllObjects];
    
    //加个多线程，否则数量量大的时候，有明显的卡顿现象
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        if (self.souStr!=nil && self.souStr.length>0) {
        
            //遍历需要搜索的所有内容，其中self.dataArray为存放总数据的数组
            for (int i = 0 ;i<[APPlistMutableArray  count]; i++) {
                
                NSString *tempStr = APPlistMutableArray[i][@"name"];
                
                //----------->把所有的搜索结果转成成拼音
                NSString *pinyin = [self transformToPinyin:tempStr];
                NSLog(@"%@--%@",pinyin,self.souStr);
                
                if ([pinyin rangeOfString:self.souStr options:NSCaseInsensitiveSearch].length >0 ) {
                    //把搜索结果存放self.resultArray数组
                    
                    [APPArray addObject:APPlistMutableArray[i]];
                    
                }
            }
            NSLog(@"%@",self.resultArray);
            
        }else{
            
//            self.resultArray = [NSMutableArray arrayWithArray:self.dataArray];
        }
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
    });
   
}

- (NSString *)transformToPinyin:(NSString *)aString{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    int count = 0;
    
    for (int  i = 0; i < pinyinArray.count; i++)
    {
        
        for(int i = 0; i < pinyinArray.count;i++)
        {
            if (i == count) {
                [allString appendString:@"#"];//区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
            
        }
        [allString appendString:@","];
        count ++;
        
    }
    
    NSMutableString *initialStr = [NSMutableString new];//拼音首字母
    
    for (NSString *s in pinyinArray)
    {
        if (s.length > 0)
        {
            
            [initialStr appendString:  [s substringToIndex:1]];
        }
    }
    
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",%@",aString];
    
    return allString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
       return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 36;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 50;
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 3;
    
    //    return listMutableArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    switch (section)
    {
        case 0:
        {
            
            
            return personnellistMutableArray.count;
            
        }
            break;
        case 1:
        {
            
            return messagelistMutableArray.count;
            
        }
            break;
        case 2:
        {
            
            return APPArray.count;
            
        }
            break;
            
        default:
            break;
    }
    
    return 0;
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    static NSString *headerIdentifier = @"Footer";
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    
    if (footerView == nil)
    {
        footerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerIdentifier];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        [footerView.contentView setBackgroundColor:[UIColor whiteColor]];
        UILabel *titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        [footerView addSubview:titleLabel];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextColor:GRAY_LIGHT_COLOR_ZZ];
        [titleLabel setTag:1215];
        
        
        
   
        
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 10)];
        bgView.backgroundColor = [UIColor colorWithWhite:242 / 255.0 alpha:1];
        [footerView addSubview:bgView];
        
        
        
        
        
    }
    
    
    
    
   
    NSString *titleString = nil;
    switch (section)
    {
        case 0:
        {
            
            if (personnellistMutableArray.count>0) {
                 titleString = @"查看更多联系人>";
            }else{
            
             titleString = @"暂未搜到相关联系人";
            }
            
            UIButton * buoout= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
            
            [buoout.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [buoout setTitleColor:GRAY_LIGHT_COLOR_ZZ forState:UIControlStateNormal];
            [buoout setTag:12000];
            [buoout setBackgroundColor:[UIColor clearColor]];
            [buoout addTarget:self action:@selector(nextp) forControlEvents:UIControlEventTouchUpInside];
            
            [footerView addSubview:buoout];
            
        }
            break;
        case 1:
        {
            
            if (messagelistMutableArray.count>0) {
                 titleString = @"查看更多消息>";
            }else{
            titleString = @"暂未搜到相关消息";
            }
                    pButton= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
            
                    [pButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                    [pButton setTitleColor:GRAY_LIGHT_COLOR_ZZ forState:UIControlStateNormal];
                    [pButton setTag:1215];
                    [pButton setBackgroundColor:[UIColor clearColor]];
            [pButton addTarget:self action:@selector(nextMessage) forControlEvents:UIControlEventTouchUpInside];
            
             [footerView addSubview:pButton];
            
        }
            break;
        case 2:
        {
           
            if (APPArray.count>0) {
                titleString = @"查看更多应用>";
            }else{
                titleString = @"暂未搜到相关应用";
            }
            
            
                    APPButton= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
            
                    [APPButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                    [APPButton setTitleColor:GRAY_LIGHT_COLOR_ZZ forState:UIControlStateNormal];
                    [APPButton setTag:1216];
                    [APPButton setBackgroundColor:[UIColor clearColor]];
            
            
            //[APPButton addTarget:self action:@selector(nextMessage) forControlEvents:UIControlEventTouchUpInside];
                        [footerView addSubview:APPButton];
            
        }
            break;
        default:
            break;
    }
    
   
    UILabel *titleLabel = (UILabel *)[footerView viewWithTag:1215];
    [titleLabel setText:titleString];
    

   
   
   
    
    return footerView;
    
   
}
- (void)nextMessage{
    
    MCMoreMeassgeViewController *MoreVC = [[MCMoreMeassgeViewController alloc]init];
   
    MoreVC.souStr = self.souStr;
    MoreVC.array = self.messageArray;
    [self.navigationController pushViewController:MoreVC animated:YES];
}

- (void)nextp{
    
    MCrelatedViewController *relatedVC = [[MCrelatedViewController alloc]init];
   
    relatedVC.souStr = self.souStr;
    relatedVC.array = self.personneArray;
    [self.navigationController pushViewController:relatedVC animated:YES];
    

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height
{
    static NSString *headerIdentifier = @"header";
     UITableViewHeaderFooterView *headerView  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    
    if (headerView == nil)
    {
        headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerIdentifier];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        [headerView.contentView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(10, 0, tableView.frame.size.width - 80, 36)];
        [headerView addSubview:titleLabel];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextColor:GRAY_LIGHT_COLOR_ZZ];
        [titleLabel setTag:1213];
        
       
        
        
        
       
        
    }
    
   
    
    NSString *titleString = nil;
    
    switch (section)
    {
        case 0:
        {
            if (personnellistMutableArray.count == 0) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 1)];
                line.backgroundColor = [UIColor colorWithRed:228 / 255.0 green:227 / 255.0 blue:230 / 255.0 alpha:1];
                [headerView addSubview:line];
            }
            titleString = @"联系人";
            
        }
            break;
        case 1:
        {
            if (messagelistMutableArray.count == 0) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 1)];
                line.backgroundColor = [UIColor colorWithRed:228 / 255.0 green:227 / 255.0 blue:230 / 255.0 alpha:1];
                [headerView addSubview:line];
            }
            
            titleString = @"消息";
            
            
        }
            break;
        case 2:
        {
            if (APPArray.count == 0) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 1)];
                line.backgroundColor = [UIColor colorWithRed:228 / 255.0 green:227 / 255.0 blue:230 / 255.0 alpha:1];
                [headerView addSubview:line];
            }
            
            titleString = @"应用";
            
            
        }

            break;
                   default:
            break;
    }
    
    UILabel *titleLabel = (UILabel *)[headerView viewWithTag:1213];
    [titleLabel setText:titleString];
    
    
    return headerView;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
        NSString *indentifier = [NSString stringWithFormat:@"cell%@%@",@(indexPath.section), @(indexPath.row)];
        MCsousuoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil)
        {
            cell = [[MCsousuoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            
            
        }
    
    switch (indexPath.section)
    {
        case 0://
        {
            NSDictionary *dataDictionary =[personnellistMutableArray  objectAtIndex:indexPath.row];
            
            [cell.titleLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"realname"]]];
            NSString *job = [NSString stringWithFormat:@"%@",dataDictionary[@"job_name"]];
            if (job.length==0) {
                [cell.jobLabel setText:[NSString stringWithFormat:@"%@",@"无"]];
            }else{
                [cell.jobLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"job_name"]]];}
            
            
            cell.iconImageView.frame = CGRectMake(10, 5, 40, 40);
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataDictionary[@"avatar"]] placeholderImage:[UIImage imageNamed:@"moren"]];
        }
            break;
            
        case 1://
        {
            NSDictionary *dataDictionary =[messagelistMutableArray  objectAtIndex:indexPath.row];
            
            [cell.titleLabel setText:[NSString stringWithFormat:@"%@(%@)",dataDictionary[@"comefrom"],dataDictionary[@"owner_name"]]];
            [cell.jobLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"title"]]];
            
            [cell.iconImageView setClipsToBounds:NO];
            cell.iconImageView.frame = CGRectMake(10, 5, 40, 40);
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataDictionary[@"ICON"]] placeholderImage:[UIImage imageNamed:@"moren"]];
             cell.arrowImageView.hidden = YES;
            
        }
            break;
        case 2://
        {
            NSDictionary *dataDictionary =[APPArray  objectAtIndex:indexPath.row];
            
            [cell.titleLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"name"]]];
            cell.titleLabel.frame = CGRectMake(60, 15, [[UIScreen mainScreen] bounds].size.width - 130, 20);
            //[cell.jobLabel setText:[NSString stringWithFormat:@"%@",dataDictionary[@"title"]]];
            
            [cell.iconImageView setClipsToBounds:NO];
            cell.iconImageView.frame = CGRectMake(10, 5, 40, 40);
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataDictionary[@"icon"][@"ios"]] placeholderImage:[UIImage imageNamed:@"moren"]];
            cell.arrowImageView.hidden = YES;
        }
            break;
            

            
        default:
            break;
    }

    

    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    switch (indexPath.section)
    {
        case 0://园区通知
        {
            NSDictionary *dataDictionary = [personnellistMutableArray objectAtIndex:indexPath.row];
            
            
            MCContactViewController *contactVC = [[MCContactViewController alloc]init];
            contactVC.hidesBottomBarWhenPushed = YES;
            contactVC.dataDictionary = dataDictionary;
             
            [self.navigationController pushViewController:contactVC animated:YES];
            
        }
            break;
            
        case 1://活动召集
        {
            NSDictionary *dataDictionary = [messagelistMutableArray objectAtIndex:indexPath.row];
            NSLog(@"%@",dataDictionary);
            NSString * URLString = [NSString stringWithFormat:@"%@",dataDictionary[@"url"]];
            
            NSString *code = [NSString stringWithFormat:@"%@",dataDictionary[@"client_code"]];
            NSString *type = [NSString stringWithFormat:@"%@",dataDictionary[@"auth_type"]];
            if ([type integerValue]==0) {
                [self getoauth1:URLString andTitle:dataDictionary[@"name"] andClientCode:code];
            }else{
                [self getoauth2:URLString andTitle:dataDictionary[@"name"] anddeveloperCode:code];}
            
        }
            break;
        case 2:
        {
            NSDictionary *dataDictionary = [APPArray objectAtIndex:indexPath.row];
            NSLog(@"%@",dataDictionary);
            NSString * URLString = [NSString stringWithFormat:@"%@",dataDictionary[@"url"]];
            
            NSString *code = [NSString stringWithFormat:@"%@",dataDictionary[@"app_code"]];
            NSString *type = [NSString stringWithFormat:@"%@",dataDictionary[@"auth_type"]];
            if ([type integerValue]==0) {
                [self getoauth1:URLString andTitle:dataDictionary[@"name"] andClientCode:code];
            }else{
                [self getoauth2:URLString andTitle:dataDictionary[@"name"] anddeveloperCode:code];}
            
        }
            break;

            
        default:
            break;
    }

    
   

    
}
- (void)getoauth1:(NSString *)url andTitle:(NSString *)name andClientCode:(NSString *)clientCode{
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *passWord = [defaults objectForKey:@"passWordMI"];//根据键值取出name
    
    [sendDictionary setValue:username forKey:@"username"];
    [sendDictionary setValue:passWord forKey:@"password"];
    [sendDictionary setValue:clientCode forKey:@"clientCode"];
    
    NSLog(@"%@",sendDictionary);
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak  MBProgressHUD *weakHub = hub;
    hub.opacity = 1.0;
    [hub setDetailsLabelText:@"正在获取授权..."];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/auth" parameters:sendDictionary success:^(id responseObject) {
        [weakHub hide:YES];
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                NSString *URLstring = @"";
                NSDictionary *dic = dicDictionary[@"content"];
                if ([url rangeOfString:@"?"].location != NSNotFound) {
                    URLstring = [NSString stringWithFormat:@"%@&openID=%@&accessToken=%@",url,dic[@"openID"],dic[@"accessToken"]];
                }else{
                    
                    URLstring = [NSString stringWithFormat:@"%@?openID=%@&accessToken=%@",url,dic[@"openID"],dic[@"accessToken"]];
                    
                }
                
                
                
                
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring]  titleString:name];
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
                
                
                
            }
            
            return ;
            
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
}
- (void)getoauth2:(NSString *)url andTitle:(NSString *)name anddeveloperCode:(NSString *)developerCode{
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    NSString *passWord = [defaults objectForKey:@"passWordMI"];//根据键值取出name
    
    [sendDictionary setValue:username forKey:@"username"];
    [sendDictionary setValue:passWord forKey:@"password"];
    [sendDictionary setValue:developerCode forKey:@"developerCode"];
    [sendDictionary setValue:@"cgj" forKey:@"accountType"];
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak  MBProgressHUD *weakHub = hub;
    hub.opacity = 1.0;
    [hub setDetailsLabelText:@"正在获取授权..."];
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/auth2" parameters:sendDictionary success:^(id responseObject) {
        [weakHub hide:YES];
        
        NSDictionary *dicDictionary = responseObject;
        NSLog(@"%@",dicDictionary);
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                NSString *URLstring = @"";
                NSDictionary *dic = dicDictionary[@"content"];
                if ([url rangeOfString:@"?"].location != NSNotFound) {
                    URLstring = [NSString stringWithFormat:@"%@&username=%@&access_token=%@",url,username,dic[@"access_token"]];
                    NSLog(@"%@",URLstring);
                }else{
                    
                    URLstring = [NSString stringWithFormat:@"%@?username=%@&access_token=%@",url,username,dic[@"access_token"]];
                    
                }
                
                
                NSLog(@"%@",name);
                
                
                MCWebViewController *webViewController = [[MCWebViewController alloc]initWithUrl:[NSURL URLWithString:URLstring]  titleString:name];
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
                
                
                
            }
            
            return ;
            
            
            
        }
        
        
        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"****%@", error);
        
    }];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
