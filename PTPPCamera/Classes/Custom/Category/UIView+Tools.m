//
//  UIView+Tools.m
//  PTLatitude
//
//  Created by so on 16/1/13.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "UIView+Tools.h"

@implementation UIView (Tools)

- (void)makeCornerRadius:(CGFloat)radius borderColor:(UIColor *)bColor borderWidth:(CGFloat)bWidth {
    self.layer.borderWidth = bWidth;
    if (bColor) {
        self.layer.borderColor = bColor.CGColor;
    }
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

+ (void)getVerticalLineWithWidth:(float)width beginPointX:(float)beginPointX beginPointY:(float)beginPointY height:(float)height color:(UIColor *)color superView:(UIView *)superView {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(beginPointX, beginPointY, width, height)];
    [line setBackgroundColor:color];
    [superView addSubview:line];
}

+ (void)getHorizontalLineWithWidth:(float)width beginPointX:(float)beginPointX beginPointY:(float)beginPointY wide:(float)wide color:(UIColor *)color superView:(UIView *)superView {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(beginPointX, beginPointY, wide, width)];
    [line setBackgroundColor:color];
    [superView addSubview:line];
}

@end
