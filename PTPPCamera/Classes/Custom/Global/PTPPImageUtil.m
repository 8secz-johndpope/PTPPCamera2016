//
//  PTPPImageUtil.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 26/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "PTPPImageUtil.h"
#import "PTFilterManager.h"

@implementation PTPPImageUtil

+ (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], CGRectMake(rect.origin.x*[UIScreen mainScreen].scale, rect.origin.y*[UIScreen mainScreen].scale, rect.size.width*[UIScreen mainScreen].scale, rect.size.height*[UIScreen mainScreen].scale));
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:imageToCrop.scale orientation:imageToCrop.imageOrientation];
    CGImageRelease(imageRef);
    
    return cropped;
}

+ (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees-180;
}

+ (CGFloat)getDistanceFromPointA:(CGPoint)pointA pointB:(CGPoint)pointB{
    double dx = (pointB.x-pointA.x);
    double dy = (pointB.y-pointA.y);
    double dist = sqrt(dx*dx + dy*dy);
    return dist;
}

+ (NSDictionary *)getFilterResultFromInputImage:(UIImage *)inputImage filterIndex:(NSInteger)index{
    NSDictionary *dic = nil;
    switch (index) {
        case 0:
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:inputImage,PTFILTERIMAGE,@"原始",PTFILTERNAME, nil];
            break;
        case 1:
            dic = [PTFilterManager PTFilter:inputImage BLCXwithInfo:0.1];
            break;
        case 2:
            dic = [PTFilterManager PTFilter:inputImage SXGNwithInfo:2.0];
            break;
        case 3:
            dic = [PTFilterManager PTFilter:inputImage JSLSwithInfo:1.2 saturation:0.6 temperature:4500.0];
            break;
        case 4:
            dic = [PTFilterManager PTFilter:inputImage SLDCwithInfo:1.2];
            break;
        case 5:
            dic = [PTFilterManager PTFilter:inputImage ZJLNwithInfo:1.2];
            break;
        case 6:
            dic = [PTFilterManager PTFilterWithMSHK:inputImage];
            break;
        case 7:
            dic = [PTFilterManager PTFilterWithBLWX:inputImage];
            break;
        case 8:
            dic = [PTFilterManager PTFilter:inputImage WNRYwithInfo:1.2];
            break;
        case 9:
            dic = [PTFilterManager PTFilter:inputImage YMYGwithInfo:1.2 temperature:7200.0];
            break;
        default:
            break;
    }
    return dic;
}

+ (BOOL)checkCameraCanUse{
    BOOL flag = NO;
    //Capture 捕捉器,Video 视频
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusAuthorized://批准
            flag=YES;
            break;
        case AVAuthorizationStatusRestricted: //Restricted 受限制
        case AVAuthorizationStatusDenied://拒绝
            flag=NO;
            break;
        case AVAuthorizationStatusNotDetermined: //不确定
            flag=YES;
            break;
    }
    if (!flag) {
        NSLog(@"设备不支持或禁用拍照功能,请按照提示打开相机");
    }
    return flag;
}

+ (UIImage *)getThumbnailFromALAsset:(ALAsset *)asset{
    CGImageRef thumbnailRef = asset.thumbnail;
    UIImageOrientation orientation = UIImageOrientationUp;
    NSNumber *orientationValue = [asset valueForProperty:@"ALAssetPropertyOrientation"];
    if (orientationValue != nil) {
        orientation = [orientationValue intValue];
    }
    UIImage *img = [self convertUIImageFromCGImageRef:thumbnailRef orientation:orientation];
    return img;
}

+ (UIImage *)getOriginalImageFromALAsset:(ALAsset *)asset{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImageOrientation orientation = UIImageOrientationUp;
    NSNumber *orientationValue = [asset valueForProperty:@"ALAssetPropertyOrientation"];
    if (orientationValue != nil) {
        orientation = [orientationValue intValue];
    }
    UIImage *img = [self convertUIImageFromCGImageRef:imgRef orientation:orientation];
    return img;
}

+(UIImage *)convertUIImageFromCGImageRef:(CGImageRef)imageRef orientation:(UIImageOrientation)imageOrientation{
    UIImage *img = [UIImage imageWithCGImage:imageRef
                                       scale:1.0f
                                 orientation:imageOrientation];
    return img;
}

@end
