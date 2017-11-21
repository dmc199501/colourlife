//
//  SubViewController.m
//  SeleceView
//
//  Created by apple on 15/4/14.
//  Copyright (c) 2015年 ___liupei___. All rights reserved.
//

#import "SubViewController.h"
#import "SubViewControllerTableViewCell.h"
#import "MCMacroDefinitionHeader.h"
@interface SubViewController ()

@end

@implementation SubViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBaseInfo];
    
    [self createTableView];
    
    NSLog(@"小区列表数据  %@",self.dataArray);
    
    // Do any additional setup after loading the view.
}
- (void)createTableView{
    
    CGRect rect = self.view.bounds;
    
    int count;
    
    if (self.dataArray.count >= 3)
    {
        
        count = 3;
        
    }else {
        
        count = self.dataArray.count;
        
    }
    
    int high = 40 + count * 40;
    
    rect.origin.y = SCREEN_HEIGHT - high;
    
    rect.size.height = high;
    
    rect.origin.x = 0;
    
    rect.size.width = SCREEN_WIDTH;
    
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    
    self.tableView.layer.borderWidth = 0.5;
    
    self.tableView.layer.cornerRadius = 5;
    
    self.tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.tableView setBounces:NO];
    
    [self.view addSubview:self.tableView];
    
}
- (void)createBaseInfo{
    
    self.view.backgroundColor = [UIColor clearColor];
    
    backView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    [self.view addSubview:backView];
}
#pragma mark 外接口方法
- (void)showViw:(UIView *)currentView{
    showView = currentView;
    backView.alpha = 0;
    self.tableView.alpha = 0;
    [self.tableView setTransform:CGAffineTransformMakeTranslation(0, self.tableView.frame.size.height)];
    [showView addSubview:self.view];
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.alpha = 1;
        backView.alpha = 1;
        [self.tableView setTransform:CGAffineTransformIdentity];
    } completion:nil];
}
-(void)hideView{
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform t = CGAffineTransformIdentity;
        [showView setTransform:t];
        backView.alpha = 0;
        self.tableView.alpha = 0;
        [self.tableView setTransform:CGAffineTransformMakeTranslation(0, self.tableView.frame.size.height)];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}
#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SubViewControllerTableViewCell";
    
    SubViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SubViewControllerTableViewCell" owner:self options:nil].lastObject;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = NO;
    
    [cell.communityName setText:[self.dataArray[indexPath.row] objectForKey:@"name"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.typeDelegate typeViewdidClick:self AtIndex:indexPath.row];
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(SubViewControllerTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = [self.dataArray[indexPath.row] objectForKey:@"name"];
    
    if ([self.checkMark isEqualToString:str]) {
        
        [cell.communityName setTextColor:[UIColor orangeColor]];
        
        [cell.colorView setBackgroundColor:[UIColor orangeColor]];
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        UIView *view=[[UIView alloc] init];
    
        view.userInteractionEnabled = NO;
    
        view.backgroundColor=[UIColor orangeColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, self.tableView.frame.size.width - 30, 40-6)];
    
        label.text=[NSString stringWithFormat:@"%@",self.headTitle];
    
        label.highlighted = YES;
    
        label.adjustsFontSizeToFitWidth = YES;
    
        label.textAlignment = NSTextAlignmentCenter;
    
        label.textColor = [UIColor whiteColor];
    
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    
        [view addSubview:label];
    
        return view;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.typeDelegate typeviewControllerDidCancel:self];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
