//
//  PECropView.h
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/19.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface PECropView : UIView

@property (nonatomic) UIImage *image;
@property (nonatomic, readonly) UIImage *croppedImage;        //被裁切的图片
@property (nonatomic, readonly) CGRect zoomedCropRect;        //缩放裁切矩形
@property (nonatomic, readonly) CGAffineTransform rotation;
@property (nonatomic, readonly) BOOL userHasModifiedCropArea;

@property (nonatomic) BOOL keepingCropAspectRatio;
@property (nonatomic) CGFloat cropAspectRatio;

@property (nonatomic) CGRect cropRect;                        //这个参数，选择尺寸时传递过来
@property (nonatomic) CGRect imageCropRect;                   //图片裁切尺寸

@property (nonatomic) CGFloat rotationAngle;                  //变幻角度





@property (nonatomic) UIScrollView *scrollView;      //z = 1
@property (nonatomic) UIView *zoomingView;           //z = 2
@property (nonatomic) UIImageView *imageView;        //z = 3

@property (nonatomic) CGRect insetRect;
@property (nonatomic) CGRect editingRect;



@property (nonatomic, weak, readonly) UIRotationGestureRecognizer *rotationGestureRecognizer; //旋转手势

- (void)resetCropRect;
- (void)resetCropRectAnimated:(BOOL)animated;

//snap   仓促的
//- (void)setRotationAngle:(CGFloat)rotationAngle snap:(BOOL)snap;

@end





