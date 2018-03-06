//
//  MCBindCZYViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/6/14.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCBindCZYViewController.h"

@interface MCBindCZYViewController ()
@property(nonatomic,strong)NSString *cardID;
@end

@implementation MCBindCZYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定彩之云账号";
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    _userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, 185, 60)];
    [_userNameTextField setPlaceholder:@"请输入手机号码"];
    [_userNameTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_userNameTextField setTextAlignment:NSTextAlignmentLeft];
    [_userNameTextField setBackgroundColor:[UIColor clearColor]];
    [_userNameTextField setFont:[UIFont systemFontOfSize:14]];
    [_userNameTextField setDelegate:self];
    [_userNameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    _cardTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, SCREEN_WIDTH, 60)];
    [_cardTextField setPlaceholder:@"请输入姓名"];
    [_cardTextField setTextAlignment:NSTextAlignmentLeft];
    [_cardTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_cardTextField setBackgroundColor:[UIColor clearColor]];
    [_cardTextField setFont:[UIFont systemFontOfSize:14]];
    [_cardTextField setDelegate:self];
    
    _IDcardTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, SCREEN_WIDTH, 60)];
    
    [_IDcardTextField setPlaceholder:@"请输入小区"];
    [_IDcardTextField setTextAlignment:NSTextAlignmentLeft];
    [_IDcardTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_IDcardTextField setBackgroundColor:[UIColor clearColor]];
    [_IDcardTextField setFont:[UIFont systemFontOfSize:14]];
    [_IDcardTextField setDelegate:self];
    
    
    typefield = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, SCREEN_WIDTH - 110 - 25, 60)];
    [typefield setPlaceholder:@"请选择"];
    [typefield setBackgroundColor:[UIColor clearColor]];
    [typefield setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1] ];
    [typefield setFont:[UIFont systemFontOfSize:13]];
    //    [floorLabel setText:@"A栋"];
    typefield.userInteractionEnabled = NO;
    [typefield setTextAlignment:NSTextAlignmentLeft];
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    listTableView.scrollEnabled = NO;
    
    
    
    UIButton *leaveButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 220, SCREEN_WIDTH-40, 40)];
    [leaveButton setBackgroundColor:BLUK_COLOR];
    
    [leaveButton setTitle:@"下一步" forState:UIControlStateNormal];
    [leaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leaveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leaveButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leaveButton];
    [leaveButton.layer setCornerRadius:4];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_userNameTextField resignFirstResponder];
    [_cardTextField resignFirstResponder];
    
}
- (void)next{
    
    
    if (_cardTextField.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请填写卡号再进行提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (_IDcardTextField.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请填身份证再进行提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    
    
    NSDictionary *sendDict = @{
                               
                               
                               @"bank_id":_cardID,
                               @"card_num":_cardTextField.text,
                               @"card_holder":_userNameTextField.text,
                               @"ide_num":_IDcardTextField.text,
                               @"key":key,
                               @"secret":secret
                               };
    
    [MCHttpManager PostWithIPString:BASEURL_AREA urlMethod:@"/hongbao/bindBank" parameters:sendDict success:^(id responseObject)
     {
         
         NSDictionary *dicDictionary = responseObject;
         NSLog(@"---%@",dicDictionary);
         
         if ([dicDictionary[@"code"] integerValue] == 0 )
         {
             if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
             {
                 [SVProgressHUD showSuccessWithStatus:@"申请添加成功"];
                 
             }
             
             
             
         }
         
         
         
     } failure:^(NSError *error) {
         
         NSLog(@"****%@", error);
         
     }];
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    switch (section)
    {
        case 0:
        {
            return 0.00001;
        }
            break;
            
        default:
        {
            return 0.0001;
        }
            break;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    switch (section)
    {
        case 0:
        {
            return 3;
        }
            break;
        case 1:
        {
            return 3;
        }
            break;
            
        default:
        {
            return 1;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *indentifier = [NSString stringWithFormat:@"cell%@%@",@(indexPath.section), @(indexPath.row)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        //[cell.textLabel setTextColor:GRAY_LIGHT_COLOR_ZZ];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
        
        switch (indexPath.section)
        {
            case 0:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        [cell.textLabel setText:@"银行卡类型"];
                        
                        [cell addSubview:typefield];
                        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 22, 22.5, 10, 15)];
                        [arrowImageView setImage:[UIImage imageNamed:@"huise"]];
                        [cell addSubview:arrowImageView];
                        
                        
                    }
                        break;
                        
                    case 1:
                    {
                        [cell.textLabel setText:@"持卡人"];
                        [cell addSubview:_userNameTextField];
                    }
                        break;
                        
                    case 2:
                    {
                        [cell.textLabel setText:@"银行卡号"];
                        [cell addSubview:_cardTextField];
                    }
                        break;
                    case 3:
                    {
                        [cell.textLabel setText:@"身份证号"];
                        [cell addSubview:_IDcardTextField];
                    }
                        break;
                        
                        
                        
                    default:
                        break;
                }
                
                
            }
                break;
                
                
        }
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    _currentSelectIndexPath = indexPath;
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    //                    MCPickerView *pickerView = [[MCPickerView alloc]initWithFrame:self.view.bounds];
                    //                    pickerView.delegate = self;
                    //                    [pickerView showInView:self.view animation:YES];
                    //[self showFloorView:nil];
                    
                    
                }
                    break;
                case 1:
                {
                    
                }
                    break;
                case 3:
                {
                    
                }
                    break;
                case 4:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
    }
}

- (void)showFloorView:(UIButton *)senderButton
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    NSString *secret = [defaults objectForKey:@"secret"];
    
    
    
    _currenSelect= 0;
    if(cardArray == nil)
    {
        NSDictionary *sendDict = @{
                                   
                                   @"key":key,
                                   @"secret":secret
                                   };
        
        [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/hongbao/bankList" parameters:sendDict success:^(id responseObject)
         {
             
             NSDictionary *dicDictionary = responseObject;
             NSLog(@"---%@",dicDictionary);
             
             if ([dicDictionary[@"code"] integerValue] == 0 )
             {
                 if ([dicDictionary[@"content"] isKindOfClass:[NSArray class]] )
                 {
                     
                     cardArray = dicDictionary[@"content"];
                     NSLog(@"%@",cardArray);
                     [self showChooseFloorView];
                     
                 }
                 
                 
                 
             }
             
             
             
         } failure:^(NSError *error) {
             
             NSLog(@"****%@", error);
             
         }];
    }
    else
    {
        [self showChooseFloorView];
    }
    
}

- (void)showChooseFloorView
{
    _currenSelect = 0;
    MCPickerView *pickerView = [[MCPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [pickerView showInView:self.view animation:YES];
    [pickerView setDelegate:self];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    
    switch (_currenSelect)
    {
        case 0:
        {
            return cardArray.count;
        }
            break;
        case 1:
        {
            
        }
            break;
            
        default:
        {
            
        }
            break;
    }
    
    
    
    return 0;
}

#pragma -mark UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
{
    NSString *string = nil;
    switch (_currenSelect)
    {
        case 0://
            
        {
            string = [NSString stringWithFormat:@"%@",[[cardArray objectAtIndex:row] objectForKey:@"name"]];
        }
            break;
        case 1://
            
        {
            
            
        }
            break;
            
        default:
        {
            
        }
            break;
    }
    
    
    __unsafe_unretained Class labelClass = [UILabel class];
    if ([view isKindOfClass:labelClass])
    {
        [((UILabel *)view) setText:string];
    }
    else
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 30)];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor blackColor]];
        [label setText:string];
        return label;
    }
    
    
    return view;
    
}

- (void)pickerView:(MCPickerView *)pickerView  finishFirstComponentRow:(NSInteger)row;//代理只返第一组，多的可以使用pickerView本身的去调用；
{
    
    switch (_currenSelect)
    {
        case 0:
        {
            self.currentIndexType = row;
            
            self.cardID = [[cardArray objectAtIndex:self.currentIndexType] objectForKey:@"id"];
            [typefield setText:[NSString stringWithFormat:@"%@",[[cardArray objectAtIndex:self.currentIndexType] objectForKey:@"name"]]];
        }
            break;
        case 1:
        {
            
        }
            break;
            
        default:
        {
            
        }
            break;
    }
    
    
    [pickerView dismissAnimation:YES];
    
}

- (void)pickerView:(MCPickerView *)pickerView  cancelFirstComponentRow:(NSInteger)row;//代理只返第一组，多的可以使用pickerView本身的去调用；
{
    [pickerView dismissAnimation:YES];
}



#pragma -mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    //    [listTableView setContentOffset:CGPointMake(0, (self.view_ZZ.frame.size.width - 120) * 0.4 + 70) animated:YES];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    
    //    [listTableView setContentOffset:CGPointMake(0, 0) animated:YES];
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
