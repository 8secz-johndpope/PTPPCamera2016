//
//  PECropViewController.h
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/19.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PECropViewControllerDelegate;

@interface PECropViewController : UIViewController


/*
@property (nonatomic, weak) id<PECropViewControllerDelegate> delegate;
@property (nonatomic) UIImage *image;               //被裁切的图片

@property (nonatomic) BOOL keepingCropAspectRatio;  //保持裁切长宽比
@property (nonatomic) CGFloat cropAspectRatio;      //裁切的长宽比

@property (nonatomic) CGRect cropRect;              //裁切的矩形
@property (nonatomic) CGRect imageCropRect;         //裁切的图片矩形

@property (nonatomic) BOOL toolbarHidden;           //是否隐藏工具栏

@property (nonatomic, assign, getter = isRotationEnabled) BOOL rotationEnabled; //是否旋转

@property (nonatomic, readonly) CGAffineTransform rotationTransform; //变换

@property (nonatomic, readonly) CGRect zoomedCropRect;  //缩放裁切矩形


//取消裁切
- (void)resetCropRect;
- (void)resetCropRectAnimated:(BOOL)animated;
 
 */

@end


///////////////////////////////////////////////////////////
// Delegate 定义
///////////////////////////////////////////////////////////

@protocol PECropViewControllerDelegate <NSObject>
@optional

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage;

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect;

- (void)cropViewControllerDidCancel:(PECropViewController *)controller;

@end
