//
//  PTPPJigsawCell.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 29/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPJigsawCell.h"

@interface PTPPJigsawCell () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSArray *pointArray;
@end

@implementation PTPPJigsawCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
    }
    return self;
}

-(void)setAttributeWithImage:(UIImage *)image maskPointArray:(NSArray *)pointArray{
    self.imageView.image = image;
    self.pointArray = pointArray;
    [self updateScrollViewContentNeedsCenterImage:YES];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i=0; i<pointArray.count; i++) {
        CGPoint p = [[pointArray safeObjectAtIndex:i] CGPointValue];
        CGPoint newPoint = CGPointMake(p.x-self.left, p.y-self.top);
        if (i==0) {
            [path moveToPoint:newPoint];
        }else{
            [path addLineToPoint:newPoint];
        }
        
    }
    [path closePath];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

-(void)updateScrollViewContentNeedsCenterImage:(BOOL)centerImage{
    CGFloat newWidth = 0;
    CGFloat newHeight = 0;
    CGFloat ratioScroll = self.scrollView.width/self.scrollView.height;
    CGFloat ratioImage = self.imageView.image.size.width/self.imageView.image.size.height;
    if (ratioImage > ratioScroll) {
        newHeight = self.scrollView.height;
        CGFloat ratio = self.imageView.image.size.width/self.imageView.image.size.height;
        newWidth = newHeight * ratio;
    }else{
        newWidth =  self.scrollView.width;
        CGFloat ratio = self.imageView.image.size.height/self.imageView.image.size.width;
        newHeight = newWidth * ratio;
    }
    self.scrollView.contentSize = CGSizeMake((newWidth+1)*self.scrollView.zoomScale, (newHeight+1)*self.scrollView.zoomScale);
    NSLog(@"scroll view size: %@",NSStringFromCGSize(self.scrollView.contentSize));
    
    if (centerImage) {
      
        self.imageView.center = CGPointMake(self.scrollView.contentSize.width/2, self.scrollView.contentSize.height/2);
        self.scrollView.contentOffset = CGPointMake(self.imageView.center.x-self.scrollView.width/2, self.imageView.center.y-self.scrollView.height/2);
        
        
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
//
//}
//
//-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
//    NSLog(@"scroll view size: %@",NSStringFromCGSize(self.scrollView.contentSize));
//
//}
//
//-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    NSLog(@"scroll view size: %@",NSStringFromCGSize(self.scrollView.contentSize));
//
//    [self updateScrollViewContentNeedsCenterImage:NO];
//    
//}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end
