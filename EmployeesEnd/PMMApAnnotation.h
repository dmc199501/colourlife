//
//  PMMApAnnotation.h
//  WeiTown
//
//  Created by kakatool on 15-4-10.
//  Copyright (c) 2015年 Hairon. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface PMMApAnnotation : MAPointAnnotation
@property (nonatomic,assign)NSInteger tag;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,assign)BOOL isArea;
@end
