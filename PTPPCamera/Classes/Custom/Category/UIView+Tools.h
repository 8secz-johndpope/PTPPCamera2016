//
//  UIView+Tools.h
//  PTLatitude
//
//  Created by so on 16/1/13.
//  Copyright © 2016年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tools)

- (void)makeCornerRadius:(CGFloat)radius
             borderColor:(UIColor *)bColor
             borderWidth:(CGFloat)bWidth;

+ (void)getVerticalLineWithWidth:(float)width
                     beginPointX:(float)beginPointX
                     beginPointY:(float)beginPointY
                          height:(float)height
                           color:(UIColor *)color
                       superView:(UIView *)superView;

+ (void)getHorizontalLineWithWidth:(float)width
                       beginPointX:(float)beginPointX
                       beginPointY:(float)beginPointY
                              wide:(float)wide
                             color:(UIColor *)color
                         superView:(UIView *)superView;

@end
