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


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.maximumZoomScale = 5.0;
        _scrollView.contentSize = _scrollView.frame.size;
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
