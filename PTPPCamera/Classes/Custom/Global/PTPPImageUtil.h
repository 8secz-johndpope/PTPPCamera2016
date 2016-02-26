//
//  PTPPImageUtil.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 26/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetHelper.h"

static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
@interface PTPPImageUtil : NSObject
+ (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect;
+ (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint;
+ (CGFloat)getDistanceFromPointA:(CGPoint)pointA pointB:(CGPoint)pointB;
+ (NSDictionary *)getFilterResultFromInputImage:(UIImage *)inputImage filterIndex:(NSInteger)index;
+ (UIImage *)getThumbnailFromALAsset:(ALAsset *)asset;
+ (UIImage *)getOriginalImageFromALAsset:(ALAsset *)asset;
+ (UIImage *)image:(UIImage *)image rotatedByDegrees:(CGFloat)degrees;
+ (UIImage *)image:(UIImage *)image flip:(NSInteger)flipDirection;
+ (BOOL)checkCameraCanUse;
@end
