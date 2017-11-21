//
//  NSString+COLStringSize.m
//  WeiTown
//
//  Created by Robert Xu on 17/2/28.
//  Copyright © 2017年 Hairon. All rights reserved.
//

#import "NSString+COLStringSize.h"

@implementation NSString (COLStringSize)

- (CGSize)sizeByOneLineWithFont:(UIFont *)font textLabelFrame:(CGRect)frame {
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGRect r = [self boundingRectWithSize:CGSizeMake(2000, frame.size.height) options:NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    return r.size;
}


@end
