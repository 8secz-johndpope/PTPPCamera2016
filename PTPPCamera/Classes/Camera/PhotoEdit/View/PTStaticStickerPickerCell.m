//
//  PTStaticStickerPickerCell.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 23/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTStaticStickerPickerCell.h"

@interface PTStaticStickerPickerCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, assign) CGFloat padding;
@end

@implementation PTStaticStickerPickerCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.icon];
    }
    return self;
}

-(void)setAttributeWithImage:(UIImage *)image framePadding:(CGFloat)padding selected:(BOOL)selected{
    self.icon.image = image;
    self.padding = padding;
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    }else{
        self.backgroundColor = [UIColor blackColor];
    }
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.icon.frame = CGRectMake(self.padding, self.padding, self.width-self.padding*2, self.height-self.padding*2);
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _icon;
}

@end
