//
//  MCTextsView.m
//  CommunityThrough
//
//  Created by 邓梦超 on 16/8/12.
//  Copyright © 2016年 邓梦超. All rights reserved.
//

#import "MCTextsView.h"

@implementation MCImageTextAttachment

- (id)initWithImageName:(NSString *)imageName imageShowString:(NSString *)imageShowString imageSize:(CGSize )imageSize;
{
    self = [super init];
    if (self)
    {
        self.imageName = imageName;
        self.imageShowString = imageShowString;
        self.imageSize = imageSize;
    }
    return self;
}

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    self.image = [UIImage imageNamed:_imageName];
}


@end


@interface MCTextsView ()
{
    UITextView *placeholderTextView;
}

@end

@implementation MCTextsView



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //        NSLog(@"%@", self);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame imageContentDictionary:(NSDictionary *)imageContentDictionary;
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.imageContentDictionary = imageContentDictionary;
    }
    return self;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setPlaceholder:_placeholder];
    
}
- (void)removeFromSuperview;
{
    [super removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview;
{
    [super willMoveToSuperview:newSuperview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if ([_placeholder length] > 0)
    {
        if (placeholderTextView == nil)
        {
            placeholderTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10)];
            [self addSubview:placeholderTextView];
            [placeholderTextView setBackgroundColor:[UIColor clearColor]];
            [placeholderTextView setUserInteractionEnabled:NO];
            [placeholderTextView setTextColor:[UIColor lightGrayColor]];
        }
        [placeholderTextView setFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
        [placeholderTextView setFont:self.font];
        [placeholderTextView setText:_placeholder];
        
    }
    else
    {
        [placeholderTextView removeFromSuperview];
        placeholderTextView = nil;
    }
    
    if ([self.textStorage length] == 0)
    {
        [placeholderTextView setHidden:NO];
    }
    else
    {
        [placeholderTextView setHidden:YES];
    }
    
}

- (void)textDidChange:(NSNotification *)notification;
{
    if ([self.textStorage length] == 0)
    {
        [placeholderTextView setHidden:NO];
    }
    else
    {
        [placeholderTextView setHidden:YES];
    }
    NSLog(@"正常显示的数%@", [self getPlainString]);
    //暂不实现，会出现字号与光标的问题
    //    [self setContentString:[self getPlainString]];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    if ([self.text length] == 0 && [self.textStorage length] == 0)
    {
        [placeholderTextView setHidden:NO];
    }
    else
    {
        [placeholderTextView setHidden:YES];
    }
}

- (NSString *)getPlainString
{
    NSMutableString *plainString = [NSMutableString stringWithString:self.textStorage.string];
    __block NSUInteger base = 0;
    
    [self.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.textStorage.length)
                                 options:0
                              usingBlock:^(id value, NSRange range, BOOL *stop) {
                                  if (value && [value isKindOfClass:[MCImageTextAttachment class]]) {
                                      [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                                 withString:((MCImageTextAttachment *) value).imageShowString];
                                      base += ((MCImageTextAttachment *) value).imageShowString.length - 1;
                                  }
                              }];
    return plainString;
}



- (void)insertImageText:(NSMutableArray *)imageMutableArray
{
    CGFloat pointSize = 12.0;
    if (self.font)
    {
        pointSize = self.font.pointSize;
    }
    
    NSInteger length = 0;
    for (NSDictionary *imageDictionary in imageMutableArray)
    {
        NSInteger location = [[imageDictionary objectForKey:@"location"] integerValue];
        [self.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:[[MCImageTextAttachment alloc] initWithImageName:[imageDictionary objectForKey:@"value"] imageShowString:[imageDictionary objectForKey:@"key"] imageSize:CGSizeMake(pointSize, pointSize)]] atIndex:location - length];
        
        NSInteger imageLength = [[imageDictionary objectForKey:@"length"] integerValue];
        length += imageLength - 1;//表情本身占一个长度
    }
    
}

- (void)setContentString:(NSString *)contentString
{
    _contentString = contentString;
    
    //取完所有的表情，然后再按位置排序，逐个插入，并且将后面的位置往前移正常。
    
    //1.取图片+位置
    NSMutableArray *imageMutableArray = [NSMutableArray array];
    for (NSString *key in self.imageContentDictionary.allKeys)
    {
        NSRange resultRange = NSMakeRange(0, 0);
        do
        {
            NSRange searchRange = NSMakeRange(resultRange.location + resultRange.length, _contentString.length - resultRange.location - resultRange.length);
            id valueObejct = [self.imageContentDictionary objectForKey:key];
            resultRange = [_contentString rangeOfString:key options:NSLiteralSearch range:searchRange];
            if (resultRange.length > 0)
            {
                [imageMutableArray addObject:@{@"key":key, @"value":valueObejct, @"location":[NSNumber numberWithInteger:resultRange.location], @"length":[NSNumber numberWithInteger:resultRange.length]}];
            }
        }
        while (resultRange.length != 0);
    }
    
    //2.排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"location" ascending:YES selector:@selector(compare:)];
    [imageMutableArray sortUsingDescriptors:@[sortDescriptor]];
    //3.去除表情
    NSString *repalceString = _contentString;
    for (id key in self.imageContentDictionary.allKeys)
    {
        repalceString = [repalceString stringByReplacingOccurrencesOfString:key withString:@""];
    }
    
    //4.将文字插入变成表情
    [self setText:repalceString];
    [self insertImageText:imageMutableArray];
    
    if ([self.text length] == 0 && [self.textStorage length] == 0)
    {
        [placeholderTextView setHidden:NO];
    }
    else
    {
        [placeholderTextView setHidden:YES];
    }
}


@end
