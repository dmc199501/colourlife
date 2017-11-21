//
//  NSString+COLStringSize.h
//  WeiTown
//
//  Created by Robert Xu on 17/2/28.
//  Copyright © 2017年 Hairon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (COLStringSize)
- (CGSize)sizeByOneLineWithFont:(UIFont *)font textLabelFrame:(CGRect)frame;

@end
