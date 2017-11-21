//
//  MCTextsView.h
//  CommunityThrough
//
//  Created by 邓梦超 on 16/8/12.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCImageTextAttachment : NSTextAttachment
{
    
}
@property(copy, nonatomic) NSString *imageName;  //本地图片的名字。本类暂时不做网络图片显示。
@property(copy, nonatomic) NSString *imageShowString;//供外部使用。[开心]--->显示给用户看见，本地文件名不一定是这个名字
@property(assign, nonatomic) CGSize imageSize;

- (id)initWithImageName:(NSString *)imageName imageShowString:(NSString *)imageShowString imageSize:(CGSize )imageSize;

@end

@interface MCTextsView : UITextView
{
    
}

@property(nonatomic,copy)NSString *placeholder;
@property(nonatomic,copy)NSString *contentString;//包含图片的显示文字，赋值之后会改变text的内容。
@property(nonatomic,copy)NSDictionary *imageContentDictionary;//图片字典：键：NSString 显示给用户的表情文字如：[开心]， 值:NSString 本地图片名称如：happy.png(.png可省略)

- (id)initWithFrame:(CGRect)frame imageContentDictionary:(NSDictionary *)imageContentDictionary;


@end
