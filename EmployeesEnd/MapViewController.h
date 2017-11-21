//
//  MapViewController.h
//  WeiTown
//
//  Created by kakatool on 15-3-23.
//  Copyright (c) 2015年 Hairon. All rights reserved.
//

#import "WTBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol MapViewControllerDelegate <NSObject>

@optional
-(void)showEmail;
-(void)showOA;

@end

@interface MapViewController : WTBaseViewController<CLLocationManagerDelegate,UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIButton *lastBtn;
@property (retain, nonatomic) IBOutlet UIImageView *retArrow;

@property (nonatomic, retain) MAMapView *mapView;
@property (retain, nonatomic) IBOutlet UIScrollView *titleScrollLable;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *titleImage;

- (IBAction)backClick:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *areaLabel; ///<物管面积/二维码开门次数 值
@property (retain, nonatomic) IBOutlet UILabel *receivable;///<应收/停车场累计收费总额 值
@property (retain, nonatomic) IBOutlet UILabel *paidIn;///<实收/海康摄像头在线情况 值
@property (retain, nonatomic) IBOutlet UILabel *ratioLabel; ///<收缴率/门禁在线情况 值
@property (retain, nonatomic) IBOutlet UILabel *satisfactionLabel; ///<满意度/格美特道闸系统在线情况 值
@property (retain, nonatomic) IBOutlet UIButton *amountBtn;///<APP安装数
@property (retain, nonatomic) IBOutlet UIButton *complaintBtn;///<业主投诉数
@property (retain, nonatomic) IBOutlet UIButton *depotBtn;///<小区数/停车场非法起杆
@property (retain, nonatomic) IBOutlet UILabel *amountLabel;///<APP安装数 值
@property (retain, nonatomic) IBOutlet UILabel *complaintLabel;///<业主投诉数 值
@property (retain, nonatomic) IBOutlet UILabel *depotLabel;///<小区数/停车场非法起杆 值
@property (retain, nonatomic) IBOutlet UILabel *labelContent;


- (IBAction)mapClick:(id)sender; //邮件
- (IBAction)feedbackClick:(id)sender; //审批

@property (retain, nonatomic) IBOutlet UILabel *label1;///<物管面积/二维码开门次数
@property (retain, nonatomic) IBOutlet UILabel *label2;///<应收/停车场累计收费总额
@property (retain, nonatomic) IBOutlet UILabel *label3;///<实收/海康摄像头在线情况
@property (retain, nonatomic) IBOutlet UILabel *label4;///<收缴率/门禁在线情况
@property (retain, nonatomic) IBOutlet UILabel *label5;///<满意度/格美特道闸系统在线情况
@property (retain, nonatomic) IBOutlet UILabel *label6;

@property (retain, nonatomic) IBOutlet UIImageView *fiveLineBg;
@property (retain, nonatomic) IBOutlet UIImageView *threeLineBg;

@property (assign, nonatomic) CGRect origFiveLineBgRect;
@property (assign, nonatomic) CGRect origThreeLineBgRect;
@property (assign, nonatomic) CGRect origLabel1Rect;
@property (assign, nonatomic) CGRect origLabel2Rect;
@property (assign, nonatomic) CGRect origLabel3Rect;
@property (assign, nonatomic) CGRect origLabel4Rect;
@property (assign, nonatomic) CGRect origLabel5Rect;
@property (assign, nonatomic) CGRect origLabel6Rect;

@property (assign, nonatomic) CGRect origLabel1ValueRect;
@property (assign, nonatomic) CGRect origLabel2ValueRect;
@property (assign, nonatomic) CGRect origLabel3ValueRect;
@property (assign, nonatomic) CGRect origLabel4ValueRect;
@property (assign, nonatomic) CGRect origLabel5ValueRect;
@property (assign, nonatomic) CGRect origLabel6NewValueRect;

@property (assign, nonatomic) CGRect origLabel6ValueRect;
@property (assign, nonatomic) CGRect origLabel7ValueRect;
@property (assign, nonatomic) CGRect origLabel8ValueRect;

@property (retain, nonatomic) IBOutlet UIImageView *sixthRowBg;
@property(assign,nonatomic) id<MapViewControllerDelegate> delegate;

@property (retain, nonatomic) UIView *kpiBg;
@property (assign, nonatomic) BOOL isClose;
@property (retain, nonatomic) IBOutlet UIView *kpiBgView;

@end
