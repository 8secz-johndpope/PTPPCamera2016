//
//  CombinationView.m
//  PTPaiPaiCamera
//
//  Created by eddie on 1/1/15.
//  Copyright (c) 2015 putao. All rights reserved.
//

#import "CombinationImageView.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>
#import "UIImage+Rotation.h"


@interface CombinationImageView()

@end

@implementation CombinationImageView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
    }
    
    return self;
}


- (void)setup
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 2.0;
    
    CGRect frameScroll = CGRectMake(-5, -5, self.frame.size.width+10, self.frame.size.height+10);
    _contentView=[[UIScrollView alloc]initWithFrame:frameScroll];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.showsVerticalScrollIndicator = FALSE;
    _contentView.showsHorizontalScrollIndicator = FALSE;
    _contentView.delegate=self;
    _contentView.bounces = YES;
    _contentView.maximumZoomScale=3.0; //设置最大伸缩比例
    _contentView.minimumZoomScale=1; //设置最小伸缩比例
    [self addSubview:_contentView];
    
    self.imageview = [[UIImageView alloc] initWithFrame:self.frame];
//    self.imageview = [[UIImageView alloc]initWithFrame:frameScroll];
    
    _contentView.contentSize=CGSizeMake(self.frame.size.width+10, self.frame.size.height+10);
    [_contentView addSubview:self.imageview];

}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageview;
}


- (void)setImageViewData:(UIImage *)imageData
{
    _imageview.image= imageData;
    if (imageData == nil) {
        return;
    }
    
    CGRect rect  = CGRectZero;
    CGFloat scale = 1.0f;
    CGFloat w = 0.0f;
    CGFloat h = 0.0f;
    
    if(self.contentView.frame.size.width > self.contentView.frame.size.height)
    {
        
        w = self.contentView.frame.size.width;
        h = w*imageData.size.height/imageData.size.width;
        if(h < self.contentView.frame.size.height){
            h = self.contentView.frame.size.height;
            w = h*imageData.size.width/imageData.size.height;
        }
        
    }else{
        
        h = self.contentView.frame.size.height;
        w = h*imageData.size.width/imageData.size.height;
        if(w < self.contentView.frame.size.width){
            w = self.contentView.frame.size.width;
            h = w*imageData.size.height/imageData.size.width;
        }
    }
    rect.size = CGSizeMake(w, h);
    
    CGFloat scale_w = w / imageData.size.width;
    CGFloat scale_h = h / imageData.size.height;
    if (w > self.frame.size.width || h > self.frame.size.height) {
        scale_w = w / self.frame.size.width;
        scale_h = h / self.frame.size.height;
        if (scale_w > scale_h) {
            scale = 1/scale_w;
        }else{
            scale = 1/scale_h;
        }
    }
    
    if (w <= self.frame.size.width || h <= self.frame.size.height) {
        scale_w = w / self.frame.size.width;
        scale_h = h / self.frame.size.height;
        if (scale_w > scale_h) {
            scale = scale_h;
        }else{
            scale = scale_w;
        }
    }
    
    @synchronized(self){
        _imageview.frame = rect; //rect
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [self.realCellArea CGPath];
        maskLayer.fillColor = [[UIColor whiteColor] CGColor];
        maskLayer.frame = _imageview.frame;
        self.layer.mask = maskLayer;
        [_contentView setZoomScale:1.0 animated:YES];
        float wPoint = (rect.size.width-_contentView.frame.size.width)/2;
        float hPoint = (rect.size.height - _contentView.frame.size.height)/2;
        
        [_contentView setContentOffset:CGPointMake(wPoint, hPoint) animated:NO];
        [self setNeedsLayout];
    }
}


-(void) rotateImageWithRatio:(float) ratio{
    CGAffineTransform currentTransform = self.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,ratio);
    [self setTransform:newTransform];
}


@end

