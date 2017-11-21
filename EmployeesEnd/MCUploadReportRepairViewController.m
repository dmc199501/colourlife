//
//  MCUploadReportRepairViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 16/11/11.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCUploadReportRepairViewController.h"
@interface MCUploadReportRepairViewController()
@property (nonatomic,strong)NSString *categoryid;
@property (nonatomic ,strong)NSString *image;
@property (nonatomic,strong)NSString *addressid;

@end
@implementation MCUploadReportRepairViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        imageMutableArray = [NSMutableArray array];
        _currentIndexType = -1;
        _currentIndexAddress = -1;
    }
    return  self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.navigationItem.title = @"公共报修";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    
    
    backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:backgroundScrollView];
    [backgroundScrollView setContentSize:CGSizeMake(backgroundScrollView.frame.size.width, backgroundScrollView.frame.size.height + 1)];
    
    addressBackgroundView = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, backgroundScrollView.frame.size.width - 20, 40)];
    [addressBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [backgroundScrollView addSubview:addressBackgroundView];
    [addressBackgroundView.layer setBorderColor:LINE_GRAY_COLOR_ZZ.CGColor];
    [addressBackgroundView.layer setBorderWidth:1];
    [addressBackgroundView.layer setCornerRadius:5];
    //[addressBackgroundView addTarget:self action:@selector(showAddressView:) forControlEvents:UIControlEventTouchUpInside];
    
    addressNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    [addressBackgroundView addSubview:addressNameLabel];
    [addressNameLabel setBackgroundColor:[UIColor clearColor]];
    [addressNameLabel setTextColor:BLACK_COLOR_ZZ];
    [addressNameLabel setFont:[UIFont systemFontOfSize:15]];
    [addressNameLabel setText:@"填写地址"];
    
    
    addressField  =[[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-280, 10, 250, 20)];
    addressField.backgroundColor = [UIColor clearColor];
    addressField.placeholder = @"请填写地址";
    [addressBackgroundView addSubview:addressField];
    addressField.textAlignment = NSTextAlignmentRight;
    addressField.font = [UIFont systemFontOfSize:14];
    
    
    
    
    typeBackgroundView = [[UIButton alloc]initWithFrame:CGRectMake(10, BOTTOM_Y(addressBackgroundView)+10, backgroundScrollView.frame.size.width - 20, 40)];
    [typeBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [backgroundScrollView addSubview:typeBackgroundView];
    [typeBackgroundView.layer setBorderColor:LINE_GRAY_COLOR_ZZ.CGColor];
    [typeBackgroundView.layer setBorderWidth:1];
    [typeBackgroundView.layer setCornerRadius:5];
    [typeBackgroundView addTarget:self action:@selector(showFloorView:) forControlEvents:UIControlEventTouchUpInside];
    
    typeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    [typeBackgroundView addSubview:typeNameLabel];
    [typeNameLabel setBackgroundColor:[UIColor clearColor]];
    [typeNameLabel setTextColor:BLACK_COLOR_ZZ];
    [typeNameLabel setFont:[UIFont systemFontOfSize:15]];
    [typeNameLabel setText:@"选择类型"];
    
    typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, typeBackgroundView.frame.size.width - 110 - 25, 40)];
    [typeBackgroundView addSubview:typeLabel];
    [typeLabel setBackgroundColor:[UIColor clearColor]];
    [typeLabel setTextColor:BLACK_COLOR_ZZ];
    [typeLabel setFont:[UIFont systemFontOfSize:15]];
    //    [floorLabel setText:@"A栋"];
    [typeLabel setTextAlignment:NSTextAlignmentRight];
    
    arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(typeBackgroundView.frame.size.width - 22, 15, 10, 10)];
    [typeBackgroundView addSubview:arrowImageView];
    [arrowImageView  setImage:[UIImage imageNamed:@"huise"]];
    
    
    contentTextView = [[MCTextsView alloc]initWithFrame:CGRectMake(10, BOTTOM_Y(typeBackgroundView)+10, backgroundScrollView.frame.size.width - 20, 160)];
    [backgroundScrollView addSubview:contentTextView];
    
    [contentTextView setPlaceholder:@"请简要描述报修内容,以便我们更好的处理"];
    [contentTextView setFont:[UIFont systemFontOfSize:15]];
    [contentTextView.layer setBorderColor:LINE_GRAY_COLOR_ZZ.CGColor];
    [contentTextView.layer setBorderWidth:1];
    [contentTextView.layer setCornerRadius:5];
    
    photoBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, BOTTOM_Y(contentTextView)+10, backgroundScrollView.frame.size.width - 20, 80)];
    [backgroundScrollView addSubview:photoBackgroundView];
    
    addButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 62, 62)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"tianjiatu_"] forState:UIControlStateNormal];
    [photoBackgroundView addSubview:addButton];
    [addButton addTarget:self action:@selector(showAddPhotoView:) forControlEvents:UIControlEventTouchUpInside];}


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


- (void )updatePhotos:(NSInteger )index finish:(void (^)(BOOL finishedAll))finish;
{
    
    
    BOOL haveNoUpadteImage = NO;
    if (imageMutableArray.count>0) {
        NSLog(@"--------%@",imageMutableArray);
        
        NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
        
        [sendDictionary setValue:@"colourlife" forKey:@"appID"];
        [sendDictionary setValue:@"image" forKey:@"file"];
        
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak  MBProgressHUD *weakHub = hub;
        [hub setDetailsLabelText:@"正上传图片....."];
        
        [MCHttpManager upUserHeadWithIPString:BASEURL_UPDATA urlMethod:@"/picupload"andDictionary:sendDictionary andImage:imageMutableArray success:^(id responseObject) {
            [weakHub hide:YES];
            NSLog(@"------%@",responseObject);
            
            NSString *filename = [NSString stringWithFormat:@"%@",responseObject[@"filename"]];
            
            NSMutableArray * filenameArray=[NSMutableArray arrayWithArray:[filename   componentsSeparatedByString:@","]];
            
            NSMutableArray *imageUrlArray = [NSMutableArray array];
            for (int i= 0; i<filenameArray.count; i++) {
                
                NSString *imageUrl =  [NSString stringWithFormat:@"%s%@","http://114.119.7.98:30020",filenameArray[i]];
                
                [imageUrlArray addObject:imageUrl];
                
            }
            NSLog(@"%@",imageUrlArray);
            if (imageUrlArray.count>0) {
                self.image = [imageUrlArray componentsJoinedByString:@","];
                [self submit];
            }else{
                self.image = nil;
                [self submit];
                
            }
            
            
            
            
            
        } failure:^(NSError *error) {
            
        }];
        
    }else{
        
        self.image = nil;
        [self submit];
        
    }
    
}


- (void)submit
{
    if (addressField.text < 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请填写再进行提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (self.currentIndexType < 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请选择类型再进行提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([contentTextView.text length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入报修内容再进行提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    
    
    
    //    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    __weak  MBProgressHUD *weakHub = hub;
    //    [hub setDetailsLabelText:@"正在提交....."];
    
    
    NSString *imageURLString = nil;
    for (NSDictionary *dictionary in imageMutableArray)
    {
        if (dictionary == [imageMutableArray firstObject])
        {
            imageURLString = [dictionary objectForKey:@"url"];
        }
        else
        {
            imageURLString = [imageURLString stringByAppendingString:[NSString stringWithFormat:@",%@", [dictionary objectForKey:@"url"]]];
        }
    }
    
    
    
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    
    NSDictionary *dic = [MCPublicDataSingleton sharePublicDataSingleton].userDictionary;
    NSLog(@"%@",dic);
    [sendDictionary setValue:contentTextView.text forKey:@"content"];
    [sendDictionary setValue:@1 forKey:@"type"];
    [sendDictionary setValue:@0 forKey:@"identityType"];
    [sendDictionary setValue:self.addressid forKey:@"category_id"];
    [sendDictionary setValue:dic[@"uid"] forKey:@"user_id"];
    [sendDictionary setValue:dic[@"realName"] forKey:@"userrealname"];
    [sendDictionary setValue:dic[@"communityid"] forKey:@"community_id"];
    [sendDictionary setValue:addressField.text forKey:@"detailedaddress"];
    [sendDictionary setValue:dic[@"mobile"] forKey:@"customer_tel"];
    [sendDictionary setValue:self.image forKey:@"imgurls"];
    [sendDictionary setValue:@"colourlife" forKey:@"appID"];
    
    NSLog(@"%@",sendDictionary);
    [MCHttpManager PostWithIPString:BASEURL_TASK urlMethod:@"/complainRepairs" parameters:sendDictionary success:^(id responseObject)
     {
         
         NSDictionary *dicDictionary = responseObject;
         NSLog(@"---%@",dicDictionary);
         
         if ([dicDictionary[@"code"] integerValue] == 0 )
         {
             if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
             {
                 
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您的报修已提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                 [alertView show];
                 
                 [self.navigationController popViewControllerAnimated:YES];
                 return;
                 
                 
             }
             
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"提交失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alertView show];
             
             
         }
         
         
         
     } failure:^(NSError *error) {
         
         NSLog(@"****%@", error);
         
     }];
}









- (void)finish{
    
    
    [self updatePhotos:0 finish:^(BOOL finishedAll) {
        
        if (finishedAll == NO)
        {
            
        }
        else
        {
            
            [self submit];
        }
        
    }];
    
    
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
- (void)showAddPhotoView:(UIButton *)senderButton
{
    [self showChoosePhotoActionSheet];
    
}

- (void)showChooseFloorView
{
    _currenSelect = 0;
    MCPickerView *pickerView = [[MCPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [pickerView showInView:self.view animation:YES];
    [pickerView setDelegate:self];
    
}

- (void)showChooseAddressView
{
    _currenSelect = 1;
    MCPickerView *pickerView = [[MCPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [pickerView showInView:self.view animation:YES];
    [pickerView setDelegate:self];
    
}

- (void)showFloorView:(UIButton *)senderButton
{
    _currenSelect= 0;
    if(floorArray == nil)
    {
        //获取
        //        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        __weak  MBProgressHUD *weakHub = hub;
        //        [hub setDetailsLabelText:@"正在获取楼层....."];
        //
        NSDictionary *sendDict = @{
                                   
                                   @"state":@2,//类型
                                   @"type":@1,
                                   @"pagesize":@10,
                                   @"appID":@"colourlife"
                                   };
        
        [MCHttpManager GETWithIPString:BASEURL_TASK urlMethod:@"/category/select" parameters:sendDict success:^(id responseObject)
         {
             
             NSDictionary *dicDictionary = responseObject;
             NSLog(@"---%@",dicDictionary);
             
             if ([dicDictionary[@"code"] integerValue] == 0 )
             {
                 if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
                 {
                     
                     floorArray = dicDictionary[@"content"][@"data"];
                     NSLog(@"%@",floorArray);
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

- (void)showAddressView:(UIButton *)senderButton
{
    _currenSelect = 1;
    if(addressArray == nil)
    {
        NSDictionary *sendDict = @{
                                   
                                   @"appID":@"colourlife"
                                   };
        
        [MCHttpManager GETWithIPString:BASEURL_FAMILY urlMethod:@"/family/select" parameters:sendDict success:^(id responseObject)
         {
             
             NSDictionary *dicDictionary = responseObject;
             NSLog(@"---%@",dicDictionary);
             
             if ([dicDictionary[@"code"] integerValue] == 0 )
             {
                 if ([dicDictionary[@"content"] isKindOfClass:[NSDictionary class]] )
                 {
                     
                     addressArray = dicDictionary[@"content"][@"data"];
                     NSLog(@"%@",addressArray);
                     [self showChooseAddressView];
                     
                 }
                 
                 
                 
             }
             
             
             
         } failure:^(NSError *error) {
             
             NSLog(@"****%@", error);
             
         }];
    }
    else
    {
        [self showChooseAddressView];
    }
    
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
        case 0://维修类型
        {
            return floorArray.count;
        }
            break;
        case 1://地址
        {
            return addressArray.count;
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
            string = [[floorArray objectAtIndex:row] objectForKey:@"name"];
        }
            break;
        case 1://
            
        {
            NSString *str1 = [[addressArray objectAtIndex:row] objectForKey:@"Province"];
            NSString *str2 = [[addressArray objectAtIndex:row] objectForKey:@"City"];
            NSString *str3 = [[addressArray objectAtIndex:row] objectForKey:@"area"];
            NSString *str4 = [[addressArray objectAtIndex:row] objectForKey:@"name"];
            string = [NSString stringWithFormat:@"%@-%@-%@-%@",str1,str2,str3,str4];
            
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
        case 0://地址
        {
            self.currentIndexType = row;
            [typeLabel setText:[[floorArray objectAtIndex:self.currentIndexType] objectForKey:@"name"]];
            self.addressid = [[floorArray objectAtIndex:self.currentIndexType] objectForKey:@"id"];
            
        }
            break;
        case 1://类型
        {
            NSString *str1 = [[addressArray objectAtIndex:row] objectForKey:@"Province"];
            NSString *str2 = [[addressArray objectAtIndex:row] objectForKey:@"City"];
            NSString *str3 = [[addressArray objectAtIndex:row] objectForKey:@"area"];
            NSString *str4 = [[addressArray objectAtIndex:row] objectForKey:@"name"];
            NSString   *string = [NSString stringWithFormat:@"%@-%@-%@-%@",str1,str2,str3,str4];
            
            self.currentIndexAddress = row;
            addressLabel.text = [NSString stringWithFormat:@"%@",string];
            
            self.categoryid = [addressArray objectAtIndex:row][@"id"];
            
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


- (void)clickImageViewButton:(UIButton *)senderButton
{
    NSMutableArray *photoMutableArray = [NSMutableArray array];
    for (NSDictionary *dictionary in imageMutableArray)
    {
        [photoMutableArray addObject:[dictionary objectForKey:@"image"]];
    }
    NSLog(@"----%@",photoMutableArray);
    MCPhotoBrowseViewController *photoBrowseViewController = [[MCPhotoBrowseViewController alloc]initWithPhotos:photoMutableArray currentShowIndex:senderButton.tag];
    [photoBrowseViewController setShowDeleteButton:YES];
    [photoBrowseViewController setDelegate:self];
    [self.navigationController pushViewController:photoBrowseViewController animated:YES];
    
}

- (void)resetFooterImageView
{
    for (UIView *view in photoBackgroundView.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
    NSInteger oneRowCount = 4.0;
    CGRect footerViewRect = photoBackgroundView.frame;
    footerViewRect.size.height = ceil((1.0 * imageMutableArray.count + 1) / oneRowCount) * 70;
    [photoBackgroundView setFrame:footerViewRect];
    
    float place = (footerViewRect.size.width - 20 - 60 * oneRowCount) / (oneRowCount - 1);
    for (int i = 0; i < imageMutableArray.count; i++)
    {
        imageViewButton = [[UIButton alloc]initWithFrame:CGRectMake(i % oneRowCount * (60 + place) + 10, i / oneRowCount * 70 + 5, 60, 60)];
        [photoBackgroundView addSubview:imageViewButton];
        [imageViewButton setTag:i];
        [imageViewButton setBackgroundImage:[[imageMutableArray objectAtIndex:i] objectForKey:@"image"]forState:UIControlStateNormal];
        [imageViewButton addTarget:self action:@selector(clickImageViewButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CGRect addButtonRect = addButton.frame;
    addButtonRect.origin.x = imageMutableArray.count % oneRowCount * (60 + place) + 10;
    addButtonRect.origin.y = imageMutableArray.count / oneRowCount * 70 + 5;
    [addButton setFrame:addButtonRect];
    if (imageMutableArray.count >= 12)
    {
        [addButton setHidden:YES];
    }
    else
    {
        [addButton setHidden:NO];
    }
    
    //    [listTableView setTableFooterView:footerView];
    
}




#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    if (originalImage.size.width > 320 * 2)
    {
        originalImage = [MCPublicDataSingleton scaleImage:originalImage toScale: (320 * 2) / originalImage.size.width];
        
    }
    originalImage = [MCPublicDataSingleton fixOrientation:originalImage];
    NSMutableDictionary *imageDictionary = [NSMutableDictionary dictionary];
    [imageDictionary setValue:originalImage forKey:@"image"];
    [imageMutableArray addObject:imageDictionary];
    [self resetFooterImageView];
    
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
    
    imageViewButton.frame = CGRectMake(0, 0, 0, 0);
    [imageViewButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    [imageMutableArray removeObjectAtIndex:currnetIndex];
    [self resetFooterImageView];
    
    if (imageMutableArray.count == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}




@end