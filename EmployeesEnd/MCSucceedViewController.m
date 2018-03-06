//
//  MCSucceedViewController.m
//  EmployeesEnd
//
//  Created by 邓梦超 on 2017/12/14.
//  Copyright © 2017年 邓梦超. All rights reserved.
//

#import "MCSucceedViewController.h"
#import "MCTransferMoneyViewController.h"
#import "MCContactViewController.h"
@interface MCSucceedViewController ()

@end

@implementation MCSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_typeSting isEqualToString:@"hongbao"]) {
        self.navigationItem.title = @"发饭票成功";
    }
    if ([_typeSting isEqualToString:@"czy"]) {
        self.navigationItem.title = @"彩之云转账成功";
    }
    if ([_typeSting isEqualToString:@"bank"]) {
        self.navigationItem.title = @"提现成功";
    }
    //图片
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *succeedView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 30, 80, 80)];
    [succeedView setImage:[UIImage imageNamed:@"fpSucceed"]];
    [self.view addSubview:succeedView];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(succeedView)+10, SCREEN_WIDTH, 20)];
    textLabel.text = @"成功";
    [self.view addSubview:textLabel];
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(textLabel)+20, SCREEN_WIDTH, 1)];
    [self.view addSubview:line];
    line.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
    
    UILabel *bzLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(line)+10, 100, 20)];
    bzLabel.text = @"备注";
    [self.view addSubview:bzLabel];
    bzLabel.textColor = GRAY_COLOR_ZZ;
     bzLabel.font = [UIFont systemFontOfSize:15];
    bzLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *jeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(bzLabel)+10, 100, 20)];
    jeLabel.text = @"金额";
    jeLabel.font = [UIFont systemFontOfSize:15];
    jeLabel.textColor = GRAY_COLOR_ZZ;
    [self.view addSubview:jeLabel];
    jeLabel.textAlignment = NSTextAlignmentLeft;
    
    
    UILabel *bzLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(120, BOTTOM_Y(line)+10, SCREEN_WIDTH-130, 20)];
    bzLabel1.text = self.BZSting;
    bzLabel1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:bzLabel1];
    bzLabel1.textAlignment = NSTextAlignmentRight;
    
    UILabel *jeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(120, BOTTOM_Y(bzLabel)+10, SCREEN_WIDTH-130, 20)];
    jeLabel1.text = self.JESting;
    jeLabel1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:jeLabel1];
    jeLabel1.textAlignment = NSTextAlignmentRight;
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, BOTTOM_Y(jeLabel1)+10, SCREEN_WIDTH, 1)];
    [self.view addSubview:line2];
    line2.backgroundColor = GRAY_LIGHTS_COLOR_ZZ;
    
    
    UIButton *Button = [[UIButton alloc]initWithFrame:CGRectMake(20, BOTTOM_Y(line2)+20, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:Button];
    Button.layer.cornerRadius = 4;
    [Button setTitle:@"完成" forState:UIControlStateNormal];
    Button.layer.masksToBounds = YES;
    Button.backgroundColor = BLUK_COLOR_ZAN_MC;
    [Button addTarget:self action:@selector(goSucceed) forControlEvents:UIControlEventTouchUpInside];

    
    
    
    
    
    // Do any additional setup after loading the view.
}
-(void)goSucceed{

    NSArray *vcArray = self.navigationController.viewControllers;
    
    
    for(UIViewController *vc in vcArray)
    {
        if ([vc isKindOfClass:[MCTransferMoneyViewController class]] ||[vc isKindOfClass:[MCContactViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }


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
