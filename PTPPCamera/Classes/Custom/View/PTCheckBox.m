//
//  PTCheckBox.m
//  PTLatitude
//
//  Created by so on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTCheckBox.h"
#import "NSString+SOAdditions.h"

@interface PTCheckBox ()

@end

@implementation PTCheckBox

+ (CGSize)checkBoxSizeWithImageSize:(CGSize)imageSize
                       imageTextGap:(CGFloat)imageTextGap
                               text:(NSString *)text
                               font:(UIFont *)font
                      contentInsets:(UIEdgeInsets)contentInsets {
    CGSize textSize = [text soSizeWithFont:font constrainedToSize:CGSizeMake(9999, ceilf(MAX(font.lineHeight, imageSize.height)))];
    CGFloat width = 0;
    width += contentInsets.left;
    width += imageSize.width;
    width += imageTextGap;
    width += textSize.width;
    width += contentInsets.right;
    CGFloat height = 0;
    height += contentInsets.top;
    height += textSize.height;
    height += contentInsets.bottom;
    return (CGSizeMake(width, height));
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _imageSize = CGSizeMake(15, 15);
        _imageTextGap = 5.0f;
        [self setImage:[UIImage imageNamed:@"check_box_nor"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"check_box_sel"] forState:UIControlStateSelected];
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect inFrame = UIEdgeInsetsInsetRect(self.bounds, self.contentEdgeInsets);
    self.imageEdgeInsets = UIEdgeInsetsMake((CGRectGetHeight(inFrame) - self.imageSize.height) / 2.0f, 0, (CGRectGetHeight(inFrame) - self.imageSize.height) / 2.0f, CGRectGetWidth(inFrame) - (self.imageSize.width + self.imageTextGap));
    self.titleEdgeInsets = UIEdgeInsetsMake(0, self.imageTextGap, 0, 0);
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

#pragma mark - setter
- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self setNeedsLayout];
}

- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    [self setNeedsLayout];
}

- (void)setImageTextGap:(CGFloat)imageTextGap {
    _imageTextGap = imageTextGap;
    [self setNeedsLayout];
}
#pragma mark -

- (CGSize)checkBoxSize {
    return ([[self class] checkBoxSizeWithImageSize:self.imageSize imageTextGap:self.imageTextGap text:[self titleForState:UIControlStateNormal] font:self.titleLabel.font contentInsets:self.contentEdgeInsets]);
}

@end
