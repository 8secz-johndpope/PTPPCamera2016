//
//  UIImage+Blur.h
//  PTPaiPaiCamera
//
//  Created by LiLiLiu on 15/4/7.
//  Copyright (c) 2015年 putao. All rights reserved.
//  http://www.cnblogs.com/ygm900/archive/2013/06/04/3117923.html
//  http://www.tuicool.com/articles/3yuyyaQ

// 为图片增加毛玻璃效果
#import <UIKit/UIKit.h>

@interface UIImage (Blur)

/*
 1.白色,参数:
 透明度 0~1,  0为白,   1为深灰色
 半径:默认30,推荐值 3   半径值越大越模糊 ,值越小越清楚
 色彩饱和度(浓度)因子:  0是黑白灰, 9是浓彩色, 1是原色  默认1.8
 “彩度”，英文是称Saturation，即饱和度。将无彩色的黑白灰定为0，最鲜艳定为9s，这样大致分成十阶段，让数值和人的感官直觉一致。
 */
- (UIImage *)imgWithLightAlpha:(CGFloat)alpha radius:(CGFloat)radius colorSaturationFactor:(CGFloat)colorSaturationFactor;
// 2.封装好,供外界调用的
- (UIImage *)imgWithBlur;

@end
