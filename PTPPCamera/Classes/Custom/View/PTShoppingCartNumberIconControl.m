//
//  PTShoppingCartNumberIconControl.m
//  PTLatitude
//
//  Created by so on 15/12/24.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTShoppingCartNumberIconControl.h"

static CGFloat const PTShoppingCartNumberIconControlTextHeight      = 18.0f;
static CGFloat const PTShoppingCartNumberIconControlTextFontSize    = 10.0f;

@interface PTShoppingCartNumberIconControl ()
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UIImageView *imageView;
@end


@implementation PTShoppingCartNumberIconControl
@synthesize titleLabel = _titleLabel;
@synthesize imageView = _imageView;

+ (CGSize)contentSizeWithTitle:(NSString *)title imageSize:(CGSize)imageSize {
    if(!title || [title integerValue] == 0) {
        return (imageSize);
    }
    CGSize titleSize = [self titleSizeWithTitle:title font:[UIFont systemFontOfSize:PTShoppingCartNumberIconControlTextFontSize]];
    return (CGSizeMake(titleSize.width + imageSize.width / 2.0f, imageSize.height + titleSize.height / 2.0f));
}

+ (CGSize)titleSizeWithTitle:(NSString *)title font:(UIFont *)font {
    if(!title || [title integerValue] == 0) {
        return (CGSizeZero);
    }
    CGSize size = [title soSizeWithFont:font constrainedToWidth:9999];
    size.width = MAX(PTShoppingCartNumberIconControlTextHeight, size.width);
    size.height = MIN(PTShoppingCartNumberIconControlTextHeight, size.height);
    return (size);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        self.imageSize = CGSizeMake(20, 20);
        self.titleColor = UIColorFromRGB(0x893bca);
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect inFrame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    self.imageView.right = CGRectGetMaxX(inFrame);
    self.imageView.bottom = CGRectGetMaxY(inFrame);
    self.titleLabel.size = [[self class] titleSizeWithTitle:self.titleLabel.text font:self.titleLabel.font];
    self.titleLabel.layer.cornerRadius = self.titleLabel.height / 2.0f;
}

#pragma mark - getter
- (NSString *)title {
    return (self.titleLabel.text);
}

- (UIColor *)titleColor {
    return (self.titleLabel.textColor);
}

- (UIColor *)titleBackgroundColor {
    return (self.titleLabel.backgroundColor);
}

- (UIImage *)image {
    return (self.imageView.image);
}

- (CGSize)imageSize {
    return (self.imageView.size);
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:PTShoppingCartNumberIconControlTextFontSize];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.borderWidth = 1;
        _titleLabel.clipsToBounds = YES;
    }
    return (_titleLabel);
}

- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return (_imageView);
}
#pragma mark -

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    self.titleLabel.hidden = (!title || [title integerValue] == 0);
    [self setNeedsLayout];
}

- (void)setTitleColor:(UIColor *)titleColor {
    self.titleLabel.textColor = titleColor;
    self.titleLabel.layer.borderColor = titleColor.CGColor;
}

- (void)setTitleBackgroundColor:(UIColor *)titleBackgroundColor {
    self.titleLabel.backgroundColor = titleBackgroundColor;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)setImageSize:(CGSize)imageSize {
    self.imageView.size = imageSize;
}
#pragma mark -

@end
