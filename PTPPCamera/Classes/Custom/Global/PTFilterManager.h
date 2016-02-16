//
//  PTFilterManager.h
//  PTPaiPaiCamera
//
//  Created by shenzhou on 15/4/1.
//  Copyright (c) 2015年 putao. All rights reserved.
//

/**
 *  滤镜工厂类
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PTFILTERNAME    @"ptfiltername"
#define PTFILTERIMAGE   @"ptfilterimage"

@interface PTFilterManager : NSObject

//白亮晨曦
+ (NSDictionary *)PTFilter:(UIImage *)image BLCXwithInfo:(CGFloat)brightness;
//盛夏光年
+ (NSDictionary *)PTFilter:(UIImage *)image SXGNwithInfo:(CGFloat)contrast;

//静水流深
+ (NSDictionary *)PTFilter:(UIImage *)image JSLSwithInfo:(CGFloat)contrast saturation:(CGFloat)saturation temperature:(CGFloat)temperature;

//闪亮登场
+ (NSDictionary *)PTFilter:(UIImage *)image SLDCwithInfo:(CGFloat)contrast;

//指尖流年
+ (NSDictionary *)PTFilter:(UIImage *)image ZJLNwithInfo:(CGFloat)contrast;

//陌上花开
+ (NSDictionary *)PTFilterWithMSHK:(UIImage *)image;

//白露未晞
+ (NSDictionary *)PTFilterWithBLWX:(UIImage *)image;

//温暖如玉
+ (NSDictionary *)PTFilter:(UIImage *)image WNRYwithInfo:(CGFloat)saturation;

//一米阳光
+ (NSDictionary *)PTFilter:(UIImage *)image YMYGwithInfo:(CGFloat)contrast temperature:(CGFloat)temperature;

//修正Orientation
+ (UIImage *)scaleAndRotateImage:(UIImage *)image;
@end
