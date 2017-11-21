//
//  NoCell.m
//  colourlife
//
//  Created by Ender on 1/28/15.
//  Copyright (c) 2015 Hairon. All rights reserved.
//

#import "NoCell.h"
#define debugRect(rect) LOG(@"%s x:%.4f, y:%.4f, w:%.4f, h%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)

@implementation NoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
        
    }
    return self;
}

-(void)setup
{
    _noDataImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    _noDataImageView.backgroundColor=TEXTGRAY;
    _noDataImageView.contentMode=UIViewContentModeCenter;
    _noDataImageView.image=[UIImage imageNamed:@"coming"];
    [self.contentView addSubview:_noDataImageView];
    
    
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _lblTitle.font=[UIFont systemFontOfSize:15];
    _lblTitle.textAlignment=UITextAlignmentCenter;
    _lblTitle.text=@"暂无数据";
    [self.contentView addSubview:_lblTitle];
    
    self.contentView.backgroundColor=[UIColor clearColor];
}

-(void)layoutSubviews
{
//    NSLog(@"**************************** %f",self.contentView.frameSizeHeight);
    [super layoutSubviews];
    _noDataImageView.frame = CGRectMake(0, 0, self.noDataImageView.image.size.width, self.noDataImageView.image.size.height);
    
    _noDataImageView.center = self.contentView.center;
    
//    debugRect(_noDataImageView.frame);
//     _lblTitle.frame = CGRectMake(0,  self.noDataImageView.frameSizeHeight+self.noDataImageView.frameOriginY+10,self.contentView.frameSizeWidth, 50);
//    
//    debugRect(_lblTitle.frame);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
//    RELEASE_SAFELY(_lblTitle)
//    RELEASE_SAFELY(_noDataImageView);
//    [super dealloc];
}

@end
