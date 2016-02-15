//
//  APRoundedButton.m
//  PTPaiPaiCamera
//
//  Created by LiLiLiu on 15/4/8.
//  Copyright (c) 2015年 putao. All rights reserved.
//

// 圆形按钮:自定义背景色，圆角的按钮
#import "APRoundedButton.h"

@implementation APRoundedButton

-(void)drawRect:(CGRect)rect
{
    UIRectCorner corners = UIRectCornerAllCorners;   //默认全部
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(20.0, 30.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
}


@end
