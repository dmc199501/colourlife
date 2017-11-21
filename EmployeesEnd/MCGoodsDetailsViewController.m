//
//  MCGoodsDetailsViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 17/2/22.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCGoodsDetailsViewController.h"
#import "MCPhotoBrowseViewController.h"
@interface MCGoodsDetailsViewController ()
@property (nonatomic ,strong)NSString *image;
@end

@implementation MCGoodsDetailsViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        imageMutableArray = [NSMutableArray array];
        typeArray = @[@"实物商品", @"虚拟商品",@"服务商品"];
       
    }
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
    [self setUI];
    // Do any additional setup after loading the view.
}
- (void)setUI{

    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 450)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-40, 20)];
    [titleLabel setText:_dataDic[@"name"]];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:titleLabel];
    
    
    UILabel *state = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH-40, 20)];
    [state setText:@"商品状态:"];
    state.font = [UIFont systemFontOfSize:13];
    state.textAlignment = NSTextAlignmentLeft;
    state.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    [backView addSubview:state];
    
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, SCREEN_WIDTH-40, 20)];
    
    stateLabel.font = [UIFont systemFontOfSize:13];
    stateLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:stateLabel];
    if ([_dataDic[@"state"] integerValue] == 0) {
        [stateLabel setText:@"已下架"];
        stateLabel.textColor = BLUK_COLOR;
        
    }else{
        [stateLabel setText:@"已上架"];
        stateLabel.textColor = ORANGE_COLOR_ZZ;
    }
    
    _typeTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 200, 0, 175, 45)];
    [_typeTextField setPlaceholder:@""];
    [_typeTextField setTextAlignment:NSTextAlignmentRight];
    [_typeTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_typeTextField setBackgroundColor:[UIColor clearColor]];
    [_typeTextField setFont:[UIFont systemFontOfSize:14]];
    [_typeTextField setDelegate:self];
     [_typeTextField setUserInteractionEnabled:NO];
    if ([_dataDic[@"type"] integerValue] == 0) {
        [_typeTextField setText:[NSString stringWithFormat:@"%@",@"实物商品"]];
    }else if ([_dataDic[@"type"] integerValue] == 1){
     [_typeTextField setText:[NSString stringWithFormat:@"%@",@"虚拟商品"]];
    }else if ([_dataDic[@"type"] integerValue] == 2){
    [_typeTextField setText:[NSString stringWithFormat:@"%@",@"服务商品"]];
    }
    
    _priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 220, 0, 195, 45)];
    [_priceTextField setPlaceholder:@""];
    [_priceTextField setTextAlignment:NSTextAlignmentRight];
    [_priceTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_priceTextField setBackgroundColor:[UIColor clearColor]];
    [_priceTextField setFont:[UIFont systemFontOfSize:14]];
    [_priceTextField setUserInteractionEnabled:YES];
    [_priceTextField setText:[NSString stringWithFormat:@"%@",_dataDic[@"price"]]];
    
    _SuggestedPriceTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 220, 0, 195, 45)];
    [_SuggestedPriceTextField setPlaceholder:@""];
    [_SuggestedPriceTextField setTextAlignment:NSTextAlignmentRight];
    [_SuggestedPriceTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_SuggestedPriceTextField setBackgroundColor:[UIColor clearColor]];
    [_SuggestedPriceTextField setFont:[UIFont systemFontOfSize:14]];
    [_SuggestedPriceTextField setUserInteractionEnabled:YES];
    [_SuggestedPriceTextField setText:[NSString stringWithFormat:@"%@",_dataDic[@"originalPrice"]]];

    _inventoryTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 220, 0, 195, 45)];
    [_inventoryTextField setPlaceholder:@""];
    [_inventoryTextField setTextAlignment:NSTextAlignmentRight];
    [_inventoryTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_inventoryTextField setBackgroundColor:[UIColor clearColor]];
    [_inventoryTextField setFont:[UIFont systemFontOfSize:14]];
    [_inventoryTextField setUserInteractionEnabled:YES];
    [_inventoryTextField setText:[NSString stringWithFormat:@"%@",_dataDic[@"amount"]]];
    
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height  - 49) style:UITableViewStyleGrouped];
    [backView addSubview:listTableView];
    [listTableView setBackgroundColor:[UIColor clearColor]];
    [listTableView setBackgroundView:nil];
    //[listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [listTableView setDelegate:self];
    [listTableView setDataSource:self];
    listTableView.scrollEnabled = NO;
    
    UILabel *describe = [[UILabel alloc]initWithFrame:CGRectMake(15, 270, SCREEN_WIDTH-40, 20)];
    [describe setText:@"商品摘要"];
    describe.font = [UIFont systemFontOfSize:13];
    describe.textAlignment = NSTextAlignmentLeft;
    describe.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    [backView addSubview:describe];
    
    UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 295, SCREEN_WIDTH-40, 20)];
    [describeLabel setText:[NSString stringWithFormat:@"%@",_dataDic[@"describe"]]];
    describeLabel.font = [UIFont systemFontOfSize:13];
    describeLabel.textAlignment = NSTextAlignmentLeft;
    describeLabel.textColor = [UIColor blackColor];
    describeLabel.numberOfLines= 0;
    [backView addSubview:describeLabel];
        CGRect contentFrame = describeLabel.frame;
    CGSize contentLabelSize = ZZ_MULTILINE_TEXTSIZE(describeLabel.text, describeLabel.font, CGSizeMake(describeLabel.frame.size.width, 999), describeLabel.lineBreakMode);
    
    contentFrame.size.height = contentLabelSize.height;
    [describeLabel setFrame:contentFrame];
    NSLog(@"%f",describeLabel.frame.size.height);
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, BOTTOM_Y(describeLabel)+10, SCREEN_WIDTH-15, 1)];
    line.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
    [backView addSubview:line];
    
    UILabel *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, BOTTOM_Y(line)+15, SCREEN_WIDTH-40, 20)];
    [iconLabel setText:@"商品主图"];
    iconLabel.font = [UIFont systemFontOfSize:13];
    iconLabel.textAlignment = NSTextAlignmentLeft;
    iconLabel.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    [backView addSubview:iconLabel];
    
    
    UIButton *IconButton = [[UIButton alloc]initWithFrame:CGRectMake(15, BOTTOM_Y(iconLabel)+10, 113, 25)];
    
    [IconButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [backView addSubview:IconButton];
    [IconButton addTarget:self action:@selector(changeIcon:) forControlEvents:UIControlEventTouchUpInside];
    
    

    _userPhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, BOTTOM_Y(line)+15, 70, 70)];
    //[_userPhotoImageView setCompressScale:20];
    [_userPhotoImageView setImage:[UIImage imageNamed:@"moren"]];
    [_userPhotoImageView setUserInteractionEnabled:NO];
    [_userPhotoImageView.layer setCornerRadius:5];
    [backView addSubview:_userPhotoImageView];
    
    
    backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, describeLabel.frame.size.height +405);
    
    UIButton *promoteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 40)];
    [self.view addSubview:promoteButton];
    [promoteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [promoteButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    promoteButton.titleLabel.font = [UIFont systemFontOfSize:13];
   
    if ([_dataDic[@"state"] integerValue ] == 0) {
        
        promoteButton.backgroundColor = ORANGE_COLOR_ZZ;
        promoteButton.tag = 1001;
        [promoteButton setTitle:@"立即上架" forState:UIControlStateNormal];
    }else{
          promoteButton.tag = 1000;
        promoteButton.backgroundColor = BLUK_COLOR;
        [promoteButton setTitle:@"立即下架" forState:UIControlStateNormal];

    }
    
    

}


- (void)changeIcon:(UIButton *)senderButton{

    NSDictionary *userInfoDictionary = [MCPublicDataSingleton sharePublicDataSingleton].userDictionary;
    NSString *urlString = [userInfoDictionary objectForKey:@"icon"];
    if ([urlString isKindOfClass:[NSString class]] && [urlString length] > 0)//有地址
    {
        MCPhotoBrowseViewController *photoBrowseViewController = [[MCPhotoBrowseViewController alloc]initWithPhotos:@[urlString] currentShowIndex:senderButton.tag];
        [self.navigationController pushViewController:photoBrowseViewController animated:YES];
        
        
        return;
    }
    
    if (_userPhotoChanged == NO)//照片没改变
    {
        NSDictionary *userInfoDictionary = [MCPublicDataSingleton sharePublicDataSingleton].userDictionary;
        NSString *urlString = [userInfoDictionary objectForKey:@"icon"];
        if ([urlString isKindOfClass:[NSString class]] && [urlString length] > 0)//有地址
        {
            MCPhotoBrowseViewController *photoBrowseViewController = [[MCPhotoBrowseViewController alloc]initWithPhotos:@[urlString] currentShowIndex:senderButton.tag];
            [photoBrowseViewController setShowDeleteButton:YES];
            [photoBrowseViewController setDelegate:self];
            [self.navigationController pushViewController:photoBrowseViewController animated:YES];
            
        }
        else
        {
            [self showChoosePhotoActionSheet];
            
        }
    }
    else
    {
        if (_userPhotoImageView.image == nil)
        {
            [self showChoosePhotoActionSheet];
        }
        else
        {
            NSMutableArray *photoMutableArray = [NSMutableArray array];
            for (NSDictionary *dictionary in imageMutableArray)
            {
                [photoMutableArray addObject:[dictionary objectForKey:@"image"]];
            }
            
            MCPhotoBrowseViewController *photoBrowseViewController = [[MCPhotoBrowseViewController alloc]initWithPhotos:photoMutableArray currentShowIndex:senderButton.tag];
            [photoBrowseViewController setShowDeleteButton:YES];
            [photoBrowseViewController setDelegate:self];
            [self.navigationController pushViewController:photoBrowseViewController animated:YES];
            
            
        }
    }
    
    
    



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
    
    [sendDictionary1 setValue:@"colourlife" forKey:@"appID"];
    [sendDictionary1 setValue:@"image" forKey:@"file"];
    
    
    [MCHttpManager upUserHeadWithIPString:BASEURL_UPDATA urlMethod:@"/picupload"andDictionary:sendDictionary1 andImage:imageMutableArray success:^(id responseObject) {
        NSLog(@"------%@",responseObject);
        self.image = [NSString stringWithFormat:@"%s%@","http://114.119.7.98:30020",responseObject[@"filename"]];
        [self submit:nil];
    } failure:^(NSError *error) {
        
        
        
    }];
    
    
    
    
}


- (void)submit:(UIButton *)button;
{
    
    
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    
    [sendDictionary setValue:self.image forKey:@"imgs"];
    [sendDictionary setValue:_dataDic[@"id"] forKey:@"id"];
    [sendDictionary setValue:_dataDic[@"name"] forKey:@"name"];
    [sendDictionary setValue:@1 forKey:@"isPlatform"];
    [sendDictionary setValue:_inventoryTextField.text forKey:@"amount"];
    [sendDictionary setValue:_dataDic[@"describe"] forKey:@"describe"];
    [sendDictionary setValue:_priceTextField.text forKey:@"price"];
    [sendDictionary setValue:_SuggestedPriceTextField.text forKey:@"originalPrice"];
    [sendDictionary setValue:_typeTextField.text forKey:@"type"];
    [sendDictionary setValue:@(button.tag-1000) forKey:@"state"];

    
       
    [MCHttpManager PutWithIPString:BASEURL_SHOP urlMethod:@"/commodity"parameters:sendDictionary success:^(id responseObject)
     {
         
         NSDictionary *dicDictionary = responseObject;
         NSLog(@"---%@",dicDictionary);
         
         if ([dicDictionary[@"code"] integerValue] == 0 )
         {
             
             [SVProgressHUD showSuccessWithStatus:@"修改成功"];
             [self.navigationController popViewControllerAnimated:YES];
             return;
             
             
         }
         [SVProgressHUD showErrorWithStatus:@"修改失败"];
         
         
         
     } failure:^(NSError *error) {
         
         NSLog(@"****%@", error);
         
     }];
    
    
    
    
    
}

- (void)sendToServer:(UIButton *)senderButton
{
    [self.view endEditing:YES];
    
    if (_userPhotoChanged == NO)
    {
        [self submit:nil];
    }
    else
    {
        
        
        
        [self updatePhotos:0 finish:^(BOOL finishedAll) {
            
            if (finishedAll == NO)
            {
                // [hub setDetailsLabelText:@"提交图片出错....."];
                // [hub hide:YES afterDelay:3];
            }
            else
            {
                // [hub setDetailsLabelText:@"正在提交"];
                [self submit:nil];
            }
            
        }];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _userPhotoChanged = YES;
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    //    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (originalImage.size.width > 320 * 2)
    {
        originalImage = [MCPublicDataSingleton scaleImage:originalImage toScale: (320 * 2) / originalImage.size.width];
        
    }
    originalImage = [MCPublicDataSingleton fixOrientation:originalImage];
    
    NSMutableDictionary *imageDictionary = [NSMutableDictionary dictionary];
    [imageDictionary setValue:originalImage forKey:@"image"];
    [imageMutableArray addObject:imageDictionary];
    
    [_userPhotoImageView setImage:originalImage];
    //[userPhotoButton setBackgroundImage:nil forState:UIControlStateNormal];
    
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
    //[userPhotoButton setBackgroundImage:[UIImage imageNamed:@"moren_"] forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
        return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
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
  return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *indentifier = [NSString stringWithFormat:@"cell%@%@",@(indexPath.section), @(indexPath.row)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        [cell.textLabel setTextColor:[UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 44, SCREEN_WIDTH-15, 1)];
        line.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
        [cell addSubview:line];
        
        switch (indexPath.section)
        {
            case 0:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        [cell.textLabel setText:@"商品类型"];
                        
                        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 22, 17, 8, 10)];
                        [arrowImageView setImage:[UIImage imageNamed:@"huise"]];
                        [cell addSubview:arrowImageView];
                        
                        [cell addSubview:_typeTextField];
                       
                    }
                        break;
                        
                    case 1:
                    {
                        [cell.textLabel setText:@"商品供货价"];
                        [cell addSubview:_priceTextField];
                    }
                        break;
                        
                    case 2:
                    {
                        [cell.textLabel setText:@"建议零售价"];
                        [cell addSubview:_SuggestedPriceTextField];
                        
                    }
                        break;
                        
                    case 3:
                    {
                        [cell addSubview:_inventoryTextField];
                        [cell.textLabel setText:@"商品库存"];
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
                       
                    }
                        break;
                        
                    case 1:
                    {
                                            }
                        break;
                        
                    case 2:
                    {
                                            }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
            default:
            {
                
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
                    MCPickerView *pickerView = [[MCPickerView alloc]initWithFrame:self.view.bounds];
                    pickerView.delegate = self;
                    [pickerView showInView:self.view animation:YES];

                }
                    break;
                case 1:
                {
                    
                }
                    break;
                case 3://性别
                {
                    
//                    MCPickerView *pickerView = [[MCPickerView alloc]initWithFrame:self.view.bounds];
//                    pickerView.delegate = self;
//                    [pickerView showInView:self.view animation:YES];
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
                    
                }
                    
                    break;
                case 2://修改密码
                {
                    
                    
                   
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
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
   
        return typeArray.count;
    
    
    
    return 0;
}


#pragma -mark UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
{
    NSString *string = nil;
    NSLog(@"%ld",_currentSelectIndexPath.row);
    
  
        string = [typeArray objectAtIndex:row];
    
    
    
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
    
            _currentIndexType = row;
        string = [typeArray objectAtIndex:row];
        [_typeTextField setText:string];
        
   
        
    
    
    [pickerView dismissAnimation:YES];
    
}

- (void)pickerView:(MCPickerView *)pickerView  cancelFirstComponentRow:(NSInteger)row;//代理只返第一组，多的可以使用pickerView本身的去调用；
{
    [pickerView dismissAnimation:YES];
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

@end
