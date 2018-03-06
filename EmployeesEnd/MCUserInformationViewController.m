//
//  MCUserInformationViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/12/15.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCUserInformationViewController.h"

@interface MCUserInformationViewController ()
@property (nonatomic ,strong)NSString *image;
@property (nonatomic ,strong)NSString *type;

@end

@implementation MCUserInformationViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        imageMutableArray = [NSMutableArray array];
        sexArray = @[@"男", @"女"];
        _currentIndexPark = -1;
    }
    return  self;
}

- (void)hideKeyborad
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *userInfoDictionary = [MCPublicDataSingleton sharePublicDataSingleton].userDictionary;
    NSLog(@"%@",userInfoDictionary);
    self.navigationItem.title = @"个人资料";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(willEdit)];
    
    
    
    userPhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 60, 10, 50, 50)];
    [userPhotoButton setBackgroundImage:[UIImage imageNamed:@"moren_"] forState:UIControlStateNormal];//moren_xinxiguanli
    [userPhotoButton addTarget:self action:@selector(clickUserPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    [userPhotoButton setUserInteractionEnabled:YES];
    
    _userPhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 60, 10, 50, 50)];
    //[_userPhotoImageView setCompressScale:20];
    [_userPhotoImageView setUserInteractionEnabled:NO];
    [_userPhotoImageView.layer setCornerRadius:5];
    
    _userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 200, 0, 185, 45)];
    [_userNameTextField setPlaceholder:@"请输入姓名"];
    [_userNameTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_userNameTextField setTextAlignment:NSTextAlignmentRight];
    [_userNameTextField setBackgroundColor:[UIColor clearColor]];
    [_userNameTextField setFont:[UIFont systemFontOfSize:14]];
    [_userNameTextField setDelegate:self];
    [_userNameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_userNameTextField setUserInteractionEnabled:NO];
    
    _sexTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 200, 0, 185, 45)];
    [_sexTextField setPlaceholder:@"男"];
    [_sexTextField setTextAlignment:NSTextAlignmentRight];
    [_sexTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_sexTextField setBackgroundColor:[UIColor clearColor]];
    [_sexTextField setFont:[UIFont systemFontOfSize:14]];
    [_sexTextField setDelegate:self];
    [_sexTextField setUserInteractionEnabled:NO];
    
    _nicknameTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 200, 0, 185, 45)];
    [_nicknameTextField setPlaceholder:@"请输入昵称"];
    [_nicknameTextField setTextAlignment:NSTextAlignmentRight];
    [_nicknameTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_nicknameTextField setBackgroundColor:[UIColor clearColor]];
    [_nicknameTextField setFont:[UIFont systemFontOfSize:14]];
    [_nicknameTextField setDelegate:self];
    [_nicknameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_nicknameTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_nicknameTextField setUserInteractionEnabled:NO];
    
    _mobileTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 200, 0, 185, 45)];
    [_mobileTextField setPlaceholder:@"电话号码"];
    [_mobileTextField setTextAlignment:NSTextAlignmentRight];
    [_mobileTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_mobileTextField setBackgroundColor:[UIColor clearColor]];
    [_mobileTextField setFont:[UIFont systemFontOfSize:14]];
    [_mobileTextField setUserInteractionEnabled:NO];
    
    _addressTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 200, 0, 185, 45)];
    [_addressTextField setPlaceholder:@"请选择地址"];
    [_addressTextField setTextAlignment:NSTextAlignmentRight];
    [_addressTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_addressTextField setBackgroundColor:[UIColor clearColor]];
    [_addressTextField setFont:[UIFont systemFontOfSize:14]];
    [_addressTextField setUserInteractionEnabled:NO];
    
    
    
    
    
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    //    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    
   
    
    [self setUserInformation];
    [self getUserInformation];
    
    [self setphoto];

    
    
}
- (void)setphoto{
    self.type = @"222";
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@avatar?uid=%@", USER_ICON_URL,username]];
    NSLog(@"%@",[NSString stringWithFormat:@"%@avatar?uid=%@", USER_ICON_URL,username]);
    UIImage *defaultImage = [UIImage imageNamed:@"default.png"];
    
    [_userPhotoImageView sd_setImageWithURL:url placeholderImage:defaultImage options:SDWebImageRefreshCached];
    


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)viewWillAppear:(BOOL)animated
{
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)setUserInformation
{
    //    [self.view endEditing:YES];
    NSDictionary *userInfoDictionary = [MCPublicDataSingleton sharePublicDataSingleton].userDictionary;
    
        [_userNameTextField setText:[NSString stringWithFormat:@"%@", [userInfoDictionary objectForKey:@"realname"]]];
    NSString *sexSting = [NSString stringWithFormat:@"%@",userInfoDictionary[@"sex"]];
    NSLog(@"%@",userInfoDictionary);
    if ([sexSting length]>0) {
        [_sexTextField setText:[NSString stringWithFormat:@"%@",sexSting]];
    }else{
        [_sexTextField setText:[NSString stringWithFormat:@""]];
    }
    
    [_nicknameTextField setText:[NSString stringWithFormat:@"%@", [userInfoDictionary objectForKey:@"jobName"]]];
    [_addressTextField setText:[NSString stringWithFormat:@"%@", [userInfoDictionary objectForKey:@"familyName"]]];
    
    [_mobileTextField setText:[NSString stringWithFormat:@"%@", [userInfoDictionary objectForKey:@"mobile"]]];
    
    
    
}

- (void)getUserInformation
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"uid"];
    NSString *username = [defaults objectForKey:@"userName"];
    
    
    
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    [sendDict setObject:uid forKey:@"uid"];
    [sendDict setObject:username forKey:@"username"];
    
    [MCHttpManager GETWithIPString:BASEURL_AREA urlMethod:@"/account" parameters:sendDict success:^(id responseObject) {
        
        NSDictionary *dicDictionary = responseObject;
        
        if ([dicDictionary[@"code"] integerValue] == 0 )
        {
            if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]])
            {
                
               
                [MCPublicDataSingleton  sharePublicDataSingleton].userDictionary = dicDictionary[@"content"];
                [self setUserInformation];
               
                return;
                
                
            }
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"****%@", error);
        
        
        
    }];

    
    
    
}


- (void)willEdit
{
    
    
    
    
    
    [self sendToServer:nil];
    
    return;
    //
    //        [self.navigationBar_ZZ.rightBarButtonItem setTitle:@"编辑" forState:UIControlStateNormal];
    //        [userPhotoButton setUserInteractionEnabled:NO];
    //        [_userNameTextField setUserInteractionEnabled:NO];
    //        [_wxNumberIDTextField setUserInteractionEnabled:NO];
    //        [_companyTextField setUserInteractionEnabled:NO];
    
    
}



- (void)clickUserPhotoButton:(UIButton *)senderButton
{
//    NSLog(@"222222222");
//    NSDictionary *userInfoDictionary = [MCPublicDataSingleton sharePublicDataSingleton].userDictionary;
//    NSString *urlString = [userInfoDictionary objectForKey:@"icon"];
//    if ([urlString isKindOfClass:[NSString class]] && [urlString length] > 0)//有地址
//    {
//        MCPhotoBrowseViewController *photoBrowseViewController = [[MCPhotoBrowseViewController alloc]initWithPhotos:@[urlString] currentShowIndex:senderButton.tag];
//        [self.navigationController pushViewController:photoBrowseViewController animated:YES];
//        
//        
//        return;
//    }
//    
//    if (_userPhotoChanged == NO)//照片没改变
//    {
//        NSDictionary *userInfoDictionary = [MCPublicDataSingleton sharePublicDataSingleton].userDictionary;
//        NSString *urlString = [userInfoDictionary objectForKey:@"icon"];
//        if ([urlString isKindOfClass:[NSString class]] && [urlString length] > 0)//有地址
//        {
//            MCPhotoBrowseViewController *photoBrowseViewController = [[MCPhotoBrowseViewController alloc]initWithPhotos:@[urlString] currentShowIndex:senderButton.tag];
//            [photoBrowseViewController setShowDeleteButton:YES];
//            [photoBrowseViewController setDelegate:self];
//            [self.navigationController pushViewController:photoBrowseViewController animated:YES];
//            
//        }
//        else
//        {
//            [self showChoosePhotoActionSheet];
//            
//        }
//    }
//    else
//    {
//        if (_userPhotoImageView.image == nil)
//        {
//            [self showChoosePhotoActionSheet];
//        }
//        else
//        {
//            NSMutableArray *photoMutableArray = [NSMutableArray array];
//            for (NSDictionary *dictionary in imageMutableArray)
//            {
//                [photoMutableArray addObject:[dictionary objectForKey:@"image"]];
//            }
//            
//            MCPhotoBrowseViewController *photoBrowseViewController = [[MCPhotoBrowseViewController alloc]initWithPhotos:photoMutableArray currentShowIndex:senderButton.tag];
//            [photoBrowseViewController setShowDeleteButton:YES];
//            [photoBrowseViewController setDelegate:self];
//            [self.navigationController pushViewController:photoBrowseViewController animated:YES];
//            
//            
//        }
//    }
//    
    [self showChoosePhotoActionSheet];
    
}
- (void)showCamera
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
    
    
}

- (void)showPhotoLibary
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
    
}


- (void)showChoosePhotoActionSheet
{
    [self.view endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [actionSheet showInView:self.view];
    
    
}


- (void )updatePhotos:(NSInteger )index finish:(void (^)(BOOL finishedAll))finish;
{
    NSMutableDictionary *sendDictionary1 = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"userName"];//根据键值取出name

   
    [sendDictionary1 setValue:@"image" forKey:@"file"];
    [sendDictionary1 setObject:username forKey:@"uid"];
    NSLog(@"%@",sendDictionary1);
    
    [MCHttpManager upUserHeadWithIPString:USER_ICON_URL urlMethod:@"/avatar"andDictionary:sendDictionary1 andImage:imageMutableArray success:^(id responseObject) {
        NSLog(@"------%@",responseObject);
        
            //[self setphoto];
       
        
           
       
        self.image = [NSString stringWithFormat:@"%@%@",USER_ICON_URL,responseObject[@"filename"]];
        //[self submit];
    } failure:^(NSError *error) {
        
        
        
    }];
    
    
    
    
}


- (void)submit
{
    
    
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"userName"];

    [sendDictionary setValue:uid forKey:@"employeeAccount"];
   
    [sendDictionary setValue:_mobileTextField.text forKey:@"mobile"];
    
    
    [MCHttpManager PutWithIPString:BASEURL_AREA urlMethod:@"/account"parameters:sendDictionary success:^(id responseObject)
     {
         
         NSDictionary *dicDictionary = responseObject;
         NSLog(@"---%@",dicDictionary);
         
         if ([dicDictionary[@"code"] integerValue] == 0 )
         {
             
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alertView show];
             
             [self.navigationController popViewControllerAnimated:YES];
             return;
             
             
         }
         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
         [alertView show];
         
         
         
     } failure:^(NSError *error) {
         
         NSLog(@"****%@", error);
         
     }];
    
    
    
    
    
}

- (void)sendToServer:(UIButton *)senderButton
{
    [self.view endEditing:YES];
    
    [self updatePhotos:0 finish:^(BOOL finishedAll) {
        
        if (finishedAll == NO)
        {
            // [hub setDetailsLabelText:@"提交图片出错....."];
            // [hub hide:YES afterDelay:3];
        }
        else
        {
            // [hub setDetailsLabelText:@"正在提交"];
            // [self submit];
        }
        
    }];

    
//    if (_userPhotoChanged == NO)
//    {
//        [self submit];
//    }
//    else
//    {
//        
//        
//        
//        [self updatePhotos:0 finish:^(BOOL finishedAll) {
//            
//            if (finishedAll == NO)
//            {
//                // [hub setDetailsLabelText:@"提交图片出错....."];
//                // [hub hide:YES afterDelay:3];
//            }
//            else
//            {
//                // [hub setDetailsLabelText:@"正在提交"];
//               // [self submit];
//            }
//            
//        }];
//    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    return 65;
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
    return 45;
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
            return 1;
        }
            break;
            
        default:
        {
            return 1;
        }
            break;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
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
        [cell.textLabel setTextColor:BLACK_COLOR_ZZ];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        
        switch (indexPath.section)
        {
            case 0:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        [cell.textLabel setText:@"头像"];
                        [cell addSubview:userPhotoButton];
                        [cell addSubview:_userPhotoImageView];
                    }
                        break;
                        
                    case 1:
                    {
                        [cell.textLabel setText:@"姓名"];
                        [cell addSubview:_userNameTextField];
                        
                    }
                        break;
                        
                    case 2:
                    {
                        [cell.textLabel setText:@"性别"];
                        [cell addSubview:_sexTextField];
//                        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 22, 17, 10, 10)];
//                        [arrowImageView setImage:[UIImage imageNamed:@"huise"]];
//                        [cell addSubview:arrowImageView];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                
            }
                break;
                
            case 1:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        [cell.textLabel setText:@"部门"];
                        [cell addSubview:_addressTextField];
                        //                        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 22, 17, 10, 10)];
                        //                        [arrowImageView setImage:[UIImage imageNamed:@"huise"]];
                        //                        [cell addSubview:arrowImageView];
                    }
                        break;
                        
                    case 1:
                    {
                        [cell addSubview:_nicknameTextField];
                        [cell.textLabel setText:@"职位"];
                    }
                        break;
                        
                    case 2:
                    {
                        [cell addSubview:_mobileTextField];
                        [cell.textLabel setText:@"手机号码"];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
            default:
            {
                //                [cell.textLabel setText:@"退出登录"];
                //                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                
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
                    
                }
                    break;
                case 1:
                {
                    
                }
                    break;
                case 3://性别
                {
                    
                    MCPickerView *pickerView = [[MCPickerView alloc]initWithFrame:self.view.bounds];
                    pickerView.delegate = self;
                    [pickerView showInView:self.view animation:YES];
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
            
        case 1:
        {
            switch (indexPath.row)
            {
                case 0://地址
                {
                    if (_isEditing == NO)
                    {
                        return;
                    }
                    
                    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
                    [sendDictionary setValue:[[MCPublicDataSingleton sharePublicDataSingleton].userDictionary objectForKey:@"uid"] forKey:@"uid"];
                    [sendDictionary setValue:@1 forKey:@"pige"];
                    [sendDictionary setValue:@10 forKey:@"pagesize"];
                    [sendDictionary setValue:@"colourlife" forKey:@"appID"];
                    NSLog(@"%@",sendDictionary);
                    
                    
                    [MCHttpManager GETWithIPString:BASEURL_USER urlMethod:@"/house" parameters:sendDictionary success:^(id responseObject)
                     {
                         
                         NSDictionary *dicDictionary = responseObject;
                         NSLog(@"---%@",dicDictionary);
                         
                         if ([dicDictionary[@"code"] integerValue] == 0 )
                         {
                             if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
                             {
                                 NSLog(@"%@",dicDictionary[@"content"]);
                                 companyArray = dicDictionary[@"content"][@"data"];
                                 MCPickerView *pickerView = [[MCPickerView alloc]initWithFrame:self.view.bounds];
                                 pickerView.delegate = self;
                                 [pickerView showInView:self.view animation:YES];
                                 
                             }
                             
                         }
                         
                     } failure:^(NSError *error) {
                         
                         NSLog(@"****%@", error);
                         
                     }];
                    
                }
                    
                    break;
                case 2://修改密码
                {
                    
//                    
//                    MCChangePasswordViewController *ChangePasswordVC = [[MCChangePasswordViewController alloc]init];
//                    [self.navigationController pushViewController:ChangePasswordVC animated:YES];
                }
                    break;
                    
            }
            break;
            
        default:
            {
                
            }
            break;
        }
    }
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


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _userPhotoChanged = YES;
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    //    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (originalImage.size.width > 100)
    {
        originalImage = [MCPublicDataSingleton scaleImage:originalImage toScale: (100) / originalImage.size.width];
        
    }
    if (originalImage.size.height > 100)
    {
        originalImage = [MCPublicDataSingleton scaleImage:originalImage toScale: (100) / originalImage.size.height];
        
    }
    originalImage = [MCPublicDataSingleton fixOrientation:originalImage];
    
    NSMutableDictionary *imageDictionary = [NSMutableDictionary dictionary];
    [imageDictionary setValue:originalImage forKey:@"image"];
    [imageMutableArray addObject:imageDictionary];
    
    [_userPhotoImageView setImage:originalImage];
    [userPhotoButton setBackgroundImage:nil forState:UIControlStateNormal];
    NSLog(@"2222");
    self.type = 0;
    [self updatePhotos:0 finish:^(BOOL finishedAll) {
        
        if (finishedAll == NO)
        {
            // [hub setDetailsLabelText:@"提交图片出错....."];
            // [hub hide:YES afterDelay:3];
        }
        else
        {
            // [hub setDetailsLabelText:@"正在提交"];
            // [self submit];
        }
        
    }];

    NSLog(@"info:%@",[info description]);
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}



#pragma -mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self showCamera];
        }
            break;
        case 1:
        {
            [self showPhotoLibary];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma -mark ZZPhotoBrowseViewControllerDelegate
- (void)photoBrowseViewController:(MCPhotoBrowseViewController *)photoBrowseViewController deleteIndex:(NSInteger )currnetIndex currentPhotoArray:(NSArray *)photoArray;
{
    _userPhotoChanged = YES;
    
    [_userPhotoImageView setImage:nil];
    [userPhotoButton setBackgroundImage:[UIImage imageNamed:@"moren_"] forState:UIControlStateNormal];
    NSLog(@"333");
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (_currentSelectIndexPath.section == 0)
    {
        return sexArray.count;
    }
    
    if (_currentSelectIndexPath.section == 1 && _currentSelectIndexPath.row == 0)
    {
        return companyArray.count;
    }
    
    
    
    return 0;
}


#pragma -mark UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
{
    NSString *string = nil;
    
    
    if (_currentSelectIndexPath.section == 0)
    {
        NSLog(@"%@",sexArray);
        string = [sexArray objectAtIndex:row];
    }
    if (_currentSelectIndexPath.section == 1  &&_currentSelectIndexPath.row == 0)
    {
        NSLog(@"%@",companyArray);
        string = [[companyArray objectAtIndex:row] objectForKey:@"community"];
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
    NSString *string = nil;
    
    if (_currentSelectIndexPath.section == 0)
    {
        _currentIndexSex = row;
        string = [sexArray objectAtIndex:row];
        [_sexTextField setText:string];
        
    }
    if (_currentSelectIndexPath.section == 1 &&_currentSelectIndexPath.row == 0)
    {
        
        
        if (companyArray.count == 0 )
        {
            return;
        }
        
        _currentIndexCompany = row;
        string = [[companyArray objectAtIndex:row] objectForKey:@"community"];
        [_addressTextField setText:string];
        self.currentSelectCompany = [companyArray objectAtIndex:row];
    }
    
    
    
    [pickerView dismissAnimation:YES];
    
}

- (void)pickerView:(MCPickerView *)pickerView  cancelFirstComponentRow:(NSInteger)row;//代理只返第一组，多的可以使用pickerView本身的去调用；
{
    [pickerView dismissAnimation:YES];
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
