//
//  PTPPHomeItemView.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 12/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPHomeItemView.h"
#import "SOKit.h"
@interface PTPPHomeItemView ()

@end

@implementation PTPPHomeItemView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.iconView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(void)setAttributeWithImageName:(NSString *)imageName titleText:(NSString *)titleText{
    self.iconView.image = [UIImage imageNamed:imageName];
    self.titleLabel.text = titleText;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    self.titleLabel.frame = CGRectMake(0, self.iconView.bottom+10, self.titleLabel.width, self.titleLabel.height);
}

-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, self.width-40, self.width-40)];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
