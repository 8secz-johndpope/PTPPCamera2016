//
//  UIImage+Rotation.h
//  PTPaiPaiCamera
//
//  Created by Eddie Dow on 12/23/14.
//  Copyright (c) 2014 putao. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIImage (Rotation)

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
