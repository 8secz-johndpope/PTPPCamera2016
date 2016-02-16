//
//  UIImage+PECrop.m
//  PhotoCropEditor
//
//  Created by Ernesto Rivera on 2013/07/29.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "UIImage+PECrop.h"

@implementation UIImage (PECrop)



//旋转与变幻图像
- (UIImage *)rotatedImageWithtransform:(CGAffineTransform)rotation
                         croppedToRect:(CGRect)rect
{
    //旋转后的图片
    UIImage *rotatedImage = [self pe_rotatedImageWithtransform:rotation];
    
    CGFloat scale = rotatedImage.scale;
    //裁切的矩形
    CGRect cropRect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(scale, scale));
    //根据裁切矩形 ，生成 裁切图片的 尺寸
    CGImageRef croppedImage = CGImageCreateWithImageInRect(rotatedImage.CGImage, cropRect);
    
    //生成裁切后的图片
    UIImage *image = [UIImage imageWithCGImage:croppedImage scale:self.scale orientation:rotatedImage.imageOrientation];
    CGImageRelease(croppedImage);
    
    return image;
}


//预处理
- (UIImage *)pe_rotatedImageWithtransform:(CGAffineTransform)transform
{
    CGSize size = self.size;
    
    
    UIGraphicsBeginImageContextWithOptions(size,
                                           YES,                     // Opaque 不透明
                                           self.scale);             // Use image scale
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //翻译当前的图形状态变换矩阵
    CGContextTranslateCTM(context, size.width / 2, size.height / 2);
    //连接的当前图形状态变换矩阵 （CTM）用仿射变换改造
    CGContextConcatCTM(context, transform);
    CGContextTranslateCTM(context, size.width / -2, size.height / -2);
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //从当前 ImageContext 获取图像
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return rotatedImage;
}

@end
