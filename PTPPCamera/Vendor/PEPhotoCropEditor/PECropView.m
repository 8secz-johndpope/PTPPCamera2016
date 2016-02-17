//
//  PECropView.m
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/19.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "PECropView.h"
#import "PECropRectView.h"
#import "UIImage+PECrop.h"
#import "UIColor+Help.h"

static const CGFloat MarginTop = 37.0f;
//static const CGFloat MarginBottom = MarginTop;
static const CGFloat MarginLeft = 20.0f;
//static const CGFloat MarginRight = MarginLeft;

@interface PECropView () <UIScrollViewDelegate, UIGestureRecognizerDelegate, PECropRectViewDelegate>



@property (nonatomic) PECropRectView *cropRectView;  //裁切框
@property (nonatomic) UIView *topOverlayView;        //顶部覆盖
@property (nonatomic) UIView *leftOverlayView;       //左侧覆盖
@property (nonatomic) UIView *rightOverlayView;      //右侧覆盖
@property (nonatomic) UIView *bottomOverlayView;     //底部覆盖



@property (nonatomic, getter = isResizing) BOOL resizing;              //是否重新调整框的尺寸
@property (nonatomic) UIInterfaceOrientation interfaceOrientation;

@end

@implementation PECropView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self setBackgroundColor:[UIColor blackColor]];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}


#pragma mark -  初始化界面
- (void)commonInit
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    
    //NSLog(@"=====ScrollView  x :%f , y :%f , width : %f , height : %f ",self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.maximumZoomScale = 20.0f;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.bouncesZoom = NO;
    self.scrollView.clipsToBounds = NO;
    [self addSubview:self.scrollView];
    
    /*
    //旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    rotationGestureRecognizer.delegate = self;
    _rotationGestureRecognizer = rotationGestureRecognizer;
    [self.scrollView addGestureRecognizer:rotationGestureRecognizer];
    */
    
    
    //创建 裁切框 对象
    self.cropRectView = [[PECropRectView alloc] init];
    self.cropRectView.delegate = self;
    [self addSubview:self.cropRectView];
    
    self.topOverlayView = [[UIView alloc] init];
    self.topOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    [self addSubview:self.topOverlayView];
    
    self.leftOverlayView = [[UIView alloc] init];
    self.leftOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    [self addSubview:self.leftOverlayView];
    
    self.rightOverlayView = [[UIView alloc] init];
    self.rightOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    [self addSubview:self.rightOverlayView];
    
    self.bottomOverlayView = [[UIView alloc] init];
    self.bottomOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    [self addSubview:self.bottomOverlayView];
}

#pragma mark -

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.userInteractionEnabled) {
        return nil;
    }
    
    UIView *hitView = [self.cropRectView hitTest:[self convertPoint:point toView:self.cropRectView] withEvent:event];
    if (hitView) {
        return hitView;
    }
    //
    CGPoint locationInImageView = [self convertPoint:point toView:self.zoomingView];
    //
    CGPoint zoomedPoint = CGPointMake(locationInImageView.x * self.scrollView.zoomScale, locationInImageView.y * self.scrollView.zoomScale);
    //
    if (CGRectContainsPoint(self.zoomingView.frame, zoomedPoint)) {
        return self.scrollView;
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.image) {
        return;
    }
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        self.editingRect = CGRectInset(self.bounds, MarginLeft, MarginTop);
    } else {
        self.editingRect = CGRectInset(self.bounds, MarginLeft, MarginLeft);
    }
    
    if (!self.imageView) {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
            self.insetRect = CGRectInset(self.bounds, MarginLeft, MarginTop);
        } else {
            self.insetRect = CGRectInset(self.bounds, MarginLeft, MarginLeft);
        }
        
        [self setupImageView];
    }
    
    if (!self.isResizing) {
        [self layoutCropRectViewWithCropRect:self.scrollView.frame];
        
        if (self.interfaceOrientation != interfaceOrientation) {
            [self zoomToCropRect:self.scrollView.frame];
        }
    }
    
    self.interfaceOrientation = interfaceOrientation;
}


//根据 指定尺寸，获取裁切框 尺寸 并调整 四个角的位置
- (void)layoutCropRectViewWithCropRect:(CGRect)cropRect
{
    self.cropRectView.frame = cropRect;
    [self layoutOverlayViewsWithCropRect:cropRect];
}

- (void)layoutOverlayViewsWithCropRect:(CGRect)cropRect
{
    self.topOverlayView.frame = CGRectMake(0.0f,
                                           0.0f,
                                           CGRectGetWidth(self.bounds),
                                           CGRectGetMinY(cropRect));
    self.leftOverlayView.frame = CGRectMake(0.0f,
                                            CGRectGetMinY(cropRect),
                                            CGRectGetMinX(cropRect),
                                            CGRectGetHeight(cropRect));
    self.rightOverlayView.frame = CGRectMake(CGRectGetMaxX(cropRect),
                                             CGRectGetMinY(cropRect),
                                             CGRectGetWidth(self.bounds) - CGRectGetMaxX(cropRect),
                                             CGRectGetHeight(cropRect));
    self.bottomOverlayView.frame = CGRectMake(0.0f,
                                              CGRectGetMaxY(cropRect),
                                              CGRectGetWidth(self.bounds),
                                              CGRectGetHeight(self.bounds) - CGRectGetMaxY(cropRect));
}

- (void)setupImageView
{
    CGRect cropRect = AVMakeRectWithAspectRatioInsideRect(self.image.size, self.insetRect);
    
    self.scrollView.frame = cropRect;
    self.scrollView.contentSize = cropRect.size;
    
    self.zoomingView = [[UIView alloc] initWithFrame:self.scrollView.bounds];
    self.zoomingView.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.zoomingView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.zoomingView.bounds];
    self.imageView.backgroundColor = [UIColor greenColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
    [self.zoomingView addSubview:self.imageView];
}

#pragma mark -

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    [self.zoomingView removeFromSuperview];
    self.zoomingView = nil;
    
    [self setNeedsLayout];
}

- (void)setKeepingCropAspectRatio:(BOOL)keepingCropAspectRatio
{
    _keepingCropAspectRatio = keepingCropAspectRatio;
    self.cropRectView.keepingAspectRatio = self.keepingCropAspectRatio;
}

- (void)setCropAspectRatio:(CGFloat)aspectRatio andCenter:(BOOL)center
{
    CGRect cropRect = self.scrollView.frame;
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    if (aspectRatio <= 1.0f) {
        width = height * aspectRatio;
        if (width > CGRectGetWidth(self.imageView.bounds)) {
            width = CGRectGetWidth(cropRect);
            height = width / aspectRatio;
        }
    } else {
        height = width / aspectRatio;
        if (height > CGRectGetHeight(self.imageView.bounds)) {
            height = CGRectGetHeight(cropRect);
            width = height * aspectRatio;
        }
    }
    cropRect.size = CGSizeMake(width, height);       //根据比例，计算出裁切框大小
    
    [self zoomToCropRect:cropRect andCenter:center];
}

- (void)setCropAspectRatio:(CGFloat)aspectRatio
{
    [self setCropAspectRatio:aspectRatio andCenter:YES];
}

- (CGFloat)cropAspectRatio
{
    CGRect cropRect = self.scrollView.frame;
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    return width / height;
}

- (void)setCropRect:(CGRect)cropRect
{
    [self zoomToCropRect:cropRect];
}

- (CGRect)cropRect
{
    return self.scrollView.frame;
}

- (void)setImageCropRect:(CGRect)imageCropRect
{
    [self resetCropRect];
    
    CGRect scrollViewFrame = self.scrollView.frame;
    CGSize imageSize = self.image.size;
    
    CGFloat scale = MIN(CGRectGetWidth(scrollViewFrame) / imageSize.width,
                        CGRectGetHeight(scrollViewFrame) / imageSize.height);
    
    CGFloat x = CGRectGetMinX(imageCropRect) * scale + CGRectGetMinX(scrollViewFrame);
    CGFloat y = CGRectGetMinY(imageCropRect) * scale + CGRectGetMinY(scrollViewFrame);
    CGFloat width = CGRectGetWidth(imageCropRect) * scale;
    CGFloat height = CGRectGetHeight(imageCropRect) * scale;
    
    CGRect rect = CGRectMake(x, y, width, height);
    CGRect intersection = CGRectIntersection(rect, scrollViewFrame);
    
    if (!CGRectIsNull(intersection)) {
        self.cropRect = intersection;
    }
}

- (void)resetCropRect
{
    [self resetCropRectAnimated:NO];
}

- (void)resetCropRectAnimated:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    self.imageView.transform = CGAffineTransformIdentity;
    
    CGSize contentSize = self.scrollView.contentSize;
    CGRect initialRect = CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height);
    [self.scrollView zoomToRect:initialRect animated:NO];
    
    self.scrollView.bounds = self.imageView.bounds;
    
    [self layoutCropRectViewWithCropRect:self.scrollView.bounds];
    
    if (animated) {
        [UIView commitAnimations];
    }
}

//所有的裁切，都必须传递两个参数 Transform  Rect
- (UIImage *)croppedImage
{
    return [self.image rotatedImageWithtransform:self.rotation croppedToRect:self.zoomedCropRect];
}

//
// 这里是关键代码
//
- (CGRect)zoomedCropRect
{
    CGRect cropRect = [self convertRect:self.scrollView.frame toView:self.zoomingView];
    CGSize size = self.image.size;
    
    CGFloat ratio = 1.0f;        //比率
    
    //根据横竖屏，判断缩放比率
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || UIInterfaceOrientationIsPortrait(orientation)) {
        ratio = CGRectGetWidth(AVMakeRectWithAspectRatioInsideRect(self.image.size, self.insetRect)) / size.width;
    } else {
        ratio = CGRectGetHeight(AVMakeRectWithAspectRatioInsideRect(self.image.size, self.insetRect)) / size.height;
    }
    
    CGRect zoomedCropRect = CGRectMake(cropRect.origin.x / ratio,
                                       cropRect.origin.y / ratio,
                                       cropRect.size.width / ratio,
                                       cropRect.size.height / ratio);
    
    return zoomedCropRect;
}

- (BOOL)userHasModifiedCropArea
{
    CGRect zoomedCropRect = CGRectIntegral(self.zoomedCropRect);
    return (!CGPointEqualToPoint(zoomedCropRect.origin, CGPointZero) ||
            !CGSizeEqualToSize(zoomedCropRect.size, self.image.size) ||
            !CGAffineTransformEqualToTransform(self.rotation, CGAffineTransformIdentity));
}

- (CGAffineTransform)rotation
{
    return self.imageView.transform;
}

- (CGFloat)rotationAngle
{
    CGAffineTransform rotation = self.imageView.transform;
    return atan2f(rotation.b, rotation.a);
}

/*
- (void)setRotationAngle:(CGFloat)rotationAngle
{
    self.imageView.transform = CGAffineTransformMakeRotation(rotationAngle);
}

- (void)setRotationAngle:(CGFloat)rotationAngle snap:(BOOL)snap
{
    if (snap)
    {
        rotationAngle = nearbyintf(rotationAngle / M_PI_2) * M_PI_2;
    }
    self.rotationAngle = rotationAngle;
}
 */

- (CGRect)cappedCropRectInImageRectWithCropRectView:(PECropRectView *)cropRectView
{
    CGRect cropRect = cropRectView.frame;
    
    CGRect rect = [self convertRect:cropRect toView:self.scrollView];
    if (CGRectGetMinX(rect) < CGRectGetMinX(self.zoomingView.frame)) {
        cropRect.origin.x = CGRectGetMinX([self.scrollView convertRect:self.zoomingView.frame toView:self]);
        CGFloat cappedWidth = CGRectGetMaxX(rect);
        cropRect.size = CGSizeMake(cappedWidth,
                                   !self.keepingCropAspectRatio ? cropRect.size.height : cropRect.size.height * (cappedWidth/cropRect.size.width));
    }
    if (CGRectGetMinY(rect) < CGRectGetMinY(self.zoomingView.frame)) {
        cropRect.origin.y = CGRectGetMinY([self.scrollView convertRect:self.zoomingView.frame toView:self]);
        CGFloat cappedHeight =  CGRectGetMaxY(rect);
        cropRect.size = CGSizeMake(!self.keepingCropAspectRatio ? cropRect.size.width : cropRect.size.width * (cappedHeight / cropRect.size.height),
                                   cappedHeight);
    }
    if (CGRectGetMaxX(rect) > CGRectGetMaxX(self.zoomingView.frame)) {
        CGFloat cappedWidth = CGRectGetMaxX([self.scrollView convertRect:self.zoomingView.frame toView:self]) - CGRectGetMinX(cropRect);
        cropRect.size = CGSizeMake(cappedWidth,
                                   !self.keepingCropAspectRatio ? cropRect.size.height : cropRect.size.height * (cappedWidth/cropRect.size.width));
    }
    if (CGRectGetMaxY(rect) > CGRectGetMaxY(self.zoomingView.frame)) {
        CGFloat cappedHeight =  CGRectGetMaxY([self.scrollView convertRect:self.zoomingView.frame toView:self]) - CGRectGetMinY(cropRect);
        cropRect.size = CGSizeMake(!self.keepingCropAspectRatio ? cropRect.size.width : cropRect.size.width * (cappedHeight / cropRect.size.height),
                                   cappedHeight);
    }
    
    return cropRect;
}

- (void)automaticZoomIfEdgeTouched:(CGRect)cropRect
{
    if (CGRectGetMinX(cropRect) < CGRectGetMinX(self.editingRect) - 5.0f ||
        CGRectGetMaxX(cropRect) > CGRectGetMaxX(self.editingRect) + 5.0f ||
        CGRectGetMinY(cropRect) < CGRectGetMinY(self.editingRect) - 5.0f ||
        CGRectGetMaxY(cropRect) > CGRectGetMaxY(self.editingRect) + 5.0f) {
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self zoomToCropRect:self.cropRectView.frame];
        } completion:NULL];
    }
}

#pragma mark -

- (void)cropRectViewDidBeginEditing:(PECropRectView *)cropRectView
{
    self.resizing = YES;    //这里默认调整 裁切框尺寸
}

- (void)cropRectViewEditingChanged:(PECropRectView *)cropRectView
{
    CGRect cropRect = [self cappedCropRectInImageRectWithCropRectView:cropRectView];
    
    [self layoutCropRectViewWithCropRect:cropRect];
    
    [self automaticZoomIfEdgeTouched:cropRect];
}

- (void)cropRectViewDidEndEditing:(PECropRectView *)cropRectView
{
    self.resizing = NO;
    [self zoomToCropRect:self.cropRectView.frame];
}


//根据按照比例，计算出的新的尺寸，计算放大后图片的尺寸
- (void)zoomToCropRect:(CGRect)toRect andCenter:(BOOL)center
{
    //如果根据比例计算出的尺寸，与图片尺寸(图片在 ScrollView 中 scrollView)一致
    if (CGRectEqualToRect(self.scrollView.frame, toRect)) {
        return;
    }
    
    CGFloat width = CGRectGetWidth(toRect);
    CGFloat height = CGRectGetHeight(toRect);
    
    CGRect  eidtingR = self.editingRect;
    
    CGFloat scale = MIN(CGRectGetWidth(self.editingRect) / width, CGRectGetHeight(self.editingRect) / height);
    
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    CGRect cropRect = CGRectMake((CGRectGetWidth(self.bounds) - scaledWidth) / 2,
                                 (CGRectGetHeight(self.bounds) - scaledHeight) / 2,
                                 scaledWidth,
                                 scaledHeight);
    
    CGRect zoomRect = [self convertRect:toRect toView:self.zoomingView];
    zoomRect.size.width = CGRectGetWidth(cropRect) / (self.scrollView.zoomScale * scale);
    zoomRect.size.height = CGRectGetHeight(cropRect) / (self.scrollView.zoomScale * scale);
    
    //根据图片尺寸，重新获取中心点
    if(center) {
        CGRect imageViewBounds = self.imageView.bounds;
        zoomRect.origin.y = (CGRectGetHeight(imageViewBounds) / 2) - (CGRectGetHeight(zoomRect) / 2);
        zoomRect.origin.x = (CGRectGetWidth(imageViewBounds) / 2) - (CGRectGetWidth(zoomRect) / 2);
    }
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollView.bounds = cropRect;
        
        //1、根据 放大图片
        //使用 scrollView 实现图片缩放  zoomRect 缩放后的图片尺寸
        [self.scrollView zoomToRect:zoomRect animated:NO];
        
        //2、
        [self layoutCropRectViewWithCropRect:cropRect];
    } completion:NULL];
}

- (void)zoomToCropRect:(CGRect)toRect
{
    [self zoomToCropRect:toRect andCenter:NO];
}

#pragma mark -
//处理旋转手势
/*
- (void)handleRotation:(UIRotationGestureRecognizer *)gestureRecognizer
{
    CGFloat rotation = gestureRecognizer.rotation;
    
    CGAffineTransform transform = CGAffineTransformRotate(self.imageView.transform, rotation);
    self.imageView.transform = transform;
    gestureRecognizer.rotation = 0.0f;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.cropRectView.showsGridMinor = YES;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
               gestureRecognizer.state == UIGestureRecognizerStateCancelled ||
               gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        self.cropRectView.showsGridMinor = NO;
    }
}
*/


#pragma mark -  UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}




- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomingView;
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint contentOffset = scrollView.contentOffset;
    *targetContentOffset = contentOffset;
}

@end
