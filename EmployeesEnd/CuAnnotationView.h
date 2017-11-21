//
//  CuAnnotationView.h
//  WeiTown
//
//  Created by kakatool on 15-3-31.
//  Copyright (c) 2015年 Hairon. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class CuAnnotationView;
@protocol CuAnnotationDelegate<NSObject>
@optional
- (void)didSelectedEventWithCuAnnotationView:(CuAnnotationView *)annotationView;

@end

@interface CuAnnotationView : MAAnnotationView
@property (nonatomic, retain) UIView *calloutView;
@property (nonatomic,retain)  UIImage *portrait;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,assign) NSInteger annotationType;
@property (nonatomic,retain) id<CuAnnotationDelegate>delegate;
@property (nonatomic, assign) NSInteger pointType;
@property (nonatomic, retain) NSDictionary *info;
@property (nonatomic, assign) BOOL isArea;

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
          annotationType:(NSInteger)type;
- (void)setWidth:(NSString *)text;
@end
