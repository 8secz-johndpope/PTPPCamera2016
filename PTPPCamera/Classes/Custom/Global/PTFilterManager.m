//
//  PTFilterManager.m
//  PTPaiPaiCamera
//
//  Created by shenzhou on 15/4/1.
//  Copyright (c) 2015年 putao. All rights reserved.
//

#import "PTFilterManager.h"
#import "GPUImage.h"

@implementation PTFilterManager

//白亮晨曦
+ (NSDictionary *)PTFilter:(UIImage *)image BLCXwithInfo:(CGFloat)brightness{

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageBrightnessFilter *lightFilter = [[GPUImageBrightnessFilter alloc] init];
    [lightFilter forceProcessingAtSize:image.size];
    [stillImageSource addTarget:lightFilter];
    [lightFilter useNextFrameForImageCapture];
    lightFilter.brightness = brightness;
    [stillImageSource processImage];
    UIImage *lightImage = [lightFilter imageFromCurrentFramebuffer];
    lightImage = [self scaleAndRotateImage:lightImage];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:lightImage forKey:PTFILTERIMAGE];
    [dic setObject:@"白亮晨曦" forKey:PTFILTERNAME];
    return dic;
}

//盛夏光年
+ (NSDictionary *)PTFilter:(UIImage *)image SXGNwithInfo:(CGFloat)contrast{

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter forceProcessingAtSize:image.size];
    [stillImageSource addTarget:contrastFilter];
    [contrastFilter useNextFrameForImageCapture];
    contrastFilter.contrast = contrast;
    [stillImageSource processImage];
    UIImage *contrastImage = [contrastFilter imageFromCurrentFramebuffer];
    contrastImage = [self scaleAndRotateImage:contrastImage];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:contrastImage forKey:PTFILTERIMAGE];
    [dic setObject:@"盛夏光年" forKey:PTFILTERNAME];
    return dic;
}

//静水流深
+ (NSDictionary *)PTFilter:(UIImage *)image JSLSwithInfo:(CGFloat)contrast saturation:(CGFloat)saturation temperature:(CGFloat)temperature{

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageSaturationFilter *saturationResamplingFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationResamplingFilter forceProcessingAtSize:image.size];
    [stillImageSource addTarget:saturationResamplingFilter];
    saturationResamplingFilter.saturation = saturation;
    [saturationResamplingFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *saturationImage = [saturationResamplingFilter imageFromCurrentFramebuffer];
    
    GPUImagePicture *fleetingImageSource = [[GPUImagePicture alloc] initWithImage:saturationImage];
    GPUImageWhiteBalanceFilter *tempResamplingFilter = [[GPUImageWhiteBalanceFilter alloc] init];
    [tempResamplingFilter forceProcessingAtSize:image.size];
    [fleetingImageSource addTarget:tempResamplingFilter];
    tempResamplingFilter.temperature = temperature;
    [tempResamplingFilter useNextFrameForImageCapture];
    [fleetingImageSource processImage];
    UIImage *fleetingTempImage = [tempResamplingFilter imageFromCurrentFramebuffer];
    
    GPUImagePicture *fleetingFinalImageSource = [[GPUImagePicture alloc] initWithImage:fleetingTempImage];
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter forceProcessingAtSize:image.size];
    [fleetingFinalImageSource addTarget:contrastFilter];
    [contrastFilter useNextFrameForImageCapture];
    contrastFilter.contrast = contrast;
    [fleetingFinalImageSource processImage];
    UIImage *fleetingImage = [contrastFilter imageFromCurrentFramebuffer];
    fleetingImage = [self scaleAndRotateImage:fleetingImage];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:fleetingImage forKey:PTFILTERIMAGE];
    [dic setObject:@"静水流深" forKey:PTFILTERNAME];
    return dic;
}

//闪亮登场
+ (NSDictionary *)PTFilter:(UIImage *)image SLDCwithInfo:(CGFloat)contrast{

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageVignetteFilter *passthroughFilter = [[GPUImageVignetteFilter alloc] init];
    [passthroughFilter forceProcessingAtSize:image.size];
    [stillImageSource addTarget:passthroughFilter];
    [passthroughFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *vignetteTempImage = [passthroughFilter imageFromCurrentFramebuffer];
    
    GPUImagePicture *vignetteImageSource = [[GPUImagePicture alloc] initWithImage:vignetteTempImage];
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter forceProcessingAtSize:image.size];
    [vignetteImageSource addTarget:contrastFilter];
    [contrastFilter useNextFrameForImageCapture];
    contrastFilter.contrast = contrast;
    [vignetteImageSource processImage];
    UIImage *vignetteImage = [contrastFilter imageFromCurrentFramebuffer];
    vignetteImage = [self scaleAndRotateImage:vignetteImage];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:vignetteImage forKey:PTFILTERIMAGE];
    [dic setObject:@"闪亮登场" forKey:PTFILTERNAME];
    return dic;
}

//指尖流年
+ (NSDictionary *)PTFilter:(UIImage *)image ZJLNwithInfo:(CGFloat)contrast{

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    [sepiaFilter forceProcessingAtSize:image.size];
    [stillImageSource addTarget:sepiaFilter];
    [sepiaFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *sepiaTempImage = [sepiaFilter imageFromCurrentFramebuffer];
    
    GPUImagePicture *sepiaImageSource = [[GPUImagePicture alloc] initWithImage:sepiaTempImage];
    //contrast
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter forceProcessingAtSize:image.size];
    [sepiaImageSource addTarget:contrastFilter];
    [contrastFilter useNextFrameForImageCapture];
    contrastFilter.contrast = contrast;
    [sepiaImageSource processImage];
    UIImage *sepiaImage = [contrastFilter imageFromCurrentFramebuffer];
    sepiaImage = [self scaleAndRotateImage:sepiaImage];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:sepiaImage forKey:PTFILTERIMAGE];
    [dic setObject:@"指尖流年" forKey:PTFILTERNAME];
    return dic;
}

//陌上花开
+ (NSDictionary *)PTFilterWithMSHK:(UIImage *)image{

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageAmatorkaFilter *documentFilter = [[GPUImageAmatorkaFilter alloc] init];
    [documentFilter forceProcessingAtSize:image.size];
    [stillImageSource addTarget:documentFilter];
    [documentFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *amatorImage = [documentFilter imageFromCurrentFramebuffer];
    amatorImage = [self scaleAndRotateImage:amatorImage];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:amatorImage forKey:PTFILTERIMAGE];
    [dic setObject:@"陌上花开" forKey:PTFILTERNAME];
    return dic;
}

//白露未晞
+ (NSDictionary *)PTFilterWithBLWX:(UIImage *)image{

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageMissEtikateFilter *missEtikateFilter = [[GPUImageMissEtikateFilter alloc] init];
    [missEtikateFilter forceProcessingAtSize:image.size];
    [stillImageSource addTarget:missEtikateFilter];
    [missEtikateFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *missImage = [missEtikateFilter imageFromCurrentFramebuffer];
    missImage = [self scaleAndRotateImage:missImage];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:missImage forKey:PTFILTERIMAGE];
    [dic setObject:@"白露未晞" forKey:PTFILTERNAME];
    return dic;
}

//温暖如玉
+ (NSDictionary *)PTFilter:(UIImage *)image WNRYwithInfo:(CGFloat)saturation{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageSaturationFilter *saturationResamplingFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationResamplingFilter forceProcessingAtSize:image.size];
    [stillImageSource addTarget:saturationResamplingFilter];
    saturationResamplingFilter.saturation = saturation;
    [saturationResamplingFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *saturation2Image = [saturationResamplingFilter imageFromCurrentFramebuffer];
    saturation2Image = [self scaleAndRotateImage:saturation2Image];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:saturation2Image forKey:PTFILTERIMAGE];
    [dic setObject:@"温暖如玉" forKey:PTFILTERNAME];
    return dic;
}

//一米阳光
+ (NSDictionary *)PTFilter:(UIImage *)image YMYGwithInfo:(CGFloat)contrast temperature:(CGFloat)temperature{

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageWhiteBalanceFilter *tempResamplingFilter = [[GPUImageWhiteBalanceFilter alloc] init];
    [tempResamplingFilter forceProcessingAtSize:image.size];
    tempResamplingFilter.temperature = temperature;
    [stillImageSource addTarget:tempResamplingFilter];
    [tempResamplingFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *bird1Image = [tempResamplingFilter imageFromCurrentFramebuffer];
    GPUImagePicture *birdImageSource = [[GPUImagePicture alloc] initWithImage:bird1Image];
    
    //contrast
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter forceProcessingAtSize:image.size];
    [birdImageSource addTarget:contrastFilter];
    [contrastFilter useNextFrameForImageCapture];
    contrastFilter.contrast = contrast;
    [birdImageSource processImage];
    UIImage *birdFinalImage = [contrastFilter imageFromCurrentFramebuffer];
    birdFinalImage = [self scaleAndRotateImage:birdFinalImage];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:birdFinalImage forKey:PTFILTERIMAGE];
    [dic setObject:@"一米阳光" forKey:PTFILTERNAME];
    return dic;
}

+ (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 2048; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
+ (UIImage *)image:(UIImage *)image rotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

@end
