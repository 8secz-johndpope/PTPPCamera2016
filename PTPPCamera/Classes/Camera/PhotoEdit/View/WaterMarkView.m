//
//  WaterMarkView.m
//  PTPaiPaiCamera
//
//  Created by Eddie Dow on 12/23/14.
//  Copyright (c) 2014 putao. All rights reserved.
//

#import "WaterMarkView.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>
#import "UIImage+Rotation.h"
#import "PTMacro.h"


#define kWaterMarkControlSize 36.0

@interface WaterMarkView(){
    CGPoint touchLocation;
    UIImageView *_resizingControl;
    UIImageView *_deleteControl;
    CGSize originSize;
}

@property (nonatomic) float deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGAffineTransform startTransform;
@property (nonatomic) CGPoint touchStart;

@end

@implementation WaterMarkView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = frame;
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    borderView = [[WaterMarkBorderView alloc] initWithFrame:CGRectMake(9, 9,
                                                                       self.bounds.size.width-18, self.bounds.size.height-18)];
    [borderView setHidden:NO];
    [self addSubview:borderView];
    _deleteControl = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                 kWaterMarkControlSize, kWaterMarkControlSize)];
    _deleteControl.backgroundColor = [UIColor clearColor];
    _deleteControl.image = [UIImage imageNamed:@"edit_button_del.png"];
    _deleteControl.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(singleTap:)];
    [_deleteControl addGestureRecognizer:singleTap];
    [self addSubview:_deleteControl];
    
    _resizingControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kWaterMarkControlSize,
                                                                   self.frame.size.height-kWaterMarkControlSize,
                                                                   kWaterMarkControlSize, kWaterMarkControlSize)];
    _resizingControl.backgroundColor = [UIColor clearColor];
    _resizingControl.userInteractionEnabled = YES;
    _resizingControl.image = [UIImage imageNamed:@"edit_button_rotation.png" ];
    UIPanGestureRecognizer* panResizeGesture = [[UIPanGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(resizeTranslate:)];
    [_resizingControl addGestureRecognizer:panResizeGesture];

    [self addSubview:_resizingControl];
    _deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x);
}


- (void)setWMContentView:(UIView *)newcontentView {
    _minLength = MIN(self.frame.size.width, self.frame.size.height);
    [_contentView removeFromSuperview];
    _contentView = newcontentView;
    _contentView.contentMode = UIViewContentModeScaleAspectFit;
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.userInteractionEnabled = TRUE;
    _contentView.frame = CGRectMake(18, 18, self.bounds.size.width-36, self.bounds.size.height-36);
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_contentView];
    
    [self bringSubviewToFront:borderView];
    [self bringSubviewToFront:_contentView];
    [self bringSubviewToFront:_resizingControl];
    [self bringSubviewToFront:_deleteControl];
    
    UITapGestureRecognizer *touchGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTrivials)];
    [_contentView  addGestureRecognizer:touchGes];
    
    originSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.alpha = 0.8f;
    _touchStart = [touch locationInView:self.superview];
    
    [self showTrivials];
}


- (void)translateUsingTouchLocation:(CGPoint)touchPoint {
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - _touchStart.x,
                                    self.center.y + touchPoint.y - _touchStart.y);
//    if(newCenter.x+self.frame.size.width/2>self.superview.frame.size.width+18){
//        newCenter = CGPointMake(self.superview.frame.size.width-self.frame.size.width/2+18,newCenter.y);
//    }
//    if(newCenter.x-self.frame.size.width/2<-18){
//        newCenter = CGPointMake(self.frame.size.width/2-18,newCenter.y);
//    }
//    if(newCenter.y+self.frame.size.height/2>self.superview.frame.size.height+18){
//        newCenter = CGPointMake(newCenter.x,self.superview.frame.size.height-self.frame.size.height/2+18);
//    }
//    if(newCenter.y-self.frame.size.height/2<-18){
//        newCenter = CGPointMake(newCenter.x,self.frame.size.height/2-18);
//    }
//    
    self.center = newCenter;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.alpha = 0.8f;
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    [self translateUsingTouchLocation:touch];
    _touchStart = touch;
    [self showTrivials];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = 1.0f;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = 1.0f;
}


- (void)setFrame:(CGRect)newFrame {
    [super setFrame:newFrame];
    _contentView.frame =  CGRectMake(18, 18, newFrame.size.width-36, newFrame.size.height-36);
    _resizingControl.frame =CGRectMake(self.bounds.size.width-kWaterMarkControlSize,
                                      self.bounds.size.height-kWaterMarkControlSize,
                                      kWaterMarkControlSize,
                                      kWaterMarkControlSize);
    _deleteControl.frame = CGRectMake(0, 0,
                                     kWaterMarkControlSize, kWaterMarkControlSize);
    borderView.frame = CGRectMake(9, 9,
                                  self.frame.size.width-18, self.frame.size.height-18);
    [borderView setNeedsDisplay];
}

- (void)hideRemoveTrivial{
    [_deleteControl removeFromSuperview];
    _resizingControl.hidden = YES;
    [borderView setHidden:YES];
}

- (void)hideTrivials
{
    _resizingControl.hidden = YES;
    _deleteControl.hidden = YES;
    [borderView setHidden:YES];
}

- (void)showTrivials
{
    _resizingControl.hidden = NO;
    _deleteControl.hidden = NO;
    [borderView setHidden:NO];
}

-(void)singleTap:(UIPanGestureRecognizer *)recognizer
{
    UIView * close = (UIView *)[recognizer view];
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut  animations:^(){
              close.superview.alpha = 0.0;
              close.superview.transform = CGAffineTransformMakeScale(0.01, 0.01);
          } completion:^(BOOL finished) {
          [close.superview removeFromSuperview];
          }];
    
    _isRemoved=true;
}

-(CGPoint) CGRectGetCenter:(CGRect)rect
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

-(CGFloat) CGPointGetDistance:(CGPoint)point1 withPoint:(CGPoint) point2
{
    //Saving Variables.
    CGFloat fx = (point2.x - point1.x);
    CGFloat fy = (point2.y - point1.y);
    
    return sqrt((fx*fx + fy*fy));
}

-(CGFloat) CGAffineTransformGetAngle:(CGAffineTransform) t
{
    return atan2(t.b, t.a);
}



//DO not move this code!!!!
-(void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    touchLocation = [recognizer locationInView:self];
    
    if ([recognizer state]== UIGestureRecognizerStateBegan)
    {
        _prevPoint = [recognizer locationInView:self];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        float wChange = 0.0, hChange = 0.0;
        
        wChange = (touchLocation.x - _prevPoint.x);
        hChange = (touchLocation.y - _prevPoint.y);
        if (ABS(wChange) > 20.0f || ABS(hChange) > 20.0f) {
            _prevPoint = [recognizer locationInView:self];
            return;
        }
        if(wChange<hChange){
            hChange = wChange*self.bounds.size.height/self.bounds.size.width;
        } else {
            wChange = hChange*self.bounds.size.width/self.bounds.size.height;
        }
        
        CGFloat preWidth = self.bounds.size.width;
        if((self.bounds.size.width + (wChange))>originSize.width/2 && (self.bounds.size.height + (hChange))>originSize.height/2){
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                     self.bounds.size.width + (wChange),
                                     self.bounds.size.height + (hChange));
            CGAffineTransform currentTransform = self.transform;
            CGFloat scale = self.bounds.size.width/preWidth;
            CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
            [self setTransform:newTransform];
        }
        
        _resizingControl.frame =CGRectMake(self.bounds.size.width-kWaterMarkControlSize,
                                           self.bounds.size.height-kWaterMarkControlSize,
                                           kWaterMarkControlSize, kWaterMarkControlSize);
        _deleteControl.frame = CGRectMake(0, 0,
                                          kWaterMarkControlSize, kWaterMarkControlSize);
        _prevPoint = [recognizer locationInView:self];
        
        /* Rotation */
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x);
        float angleDiff = _deltaAngle - ang;
        self.transform = CGAffineTransformMakeRotation(-angleDiff);
        
        borderView.frame = CGRectMake(9, 9,
                                      self.bounds.size.width-18, self.bounds.size.height-18);
        [borderView setNeedsDisplay];
        [self setNeedsDisplay];
        _isResizeTranslate = YES;
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        CGPoint newPoint = [recognizer locationInView:self];
        if (newPoint.x > _prevPoint.x) {
       
        }else{
            
        }
        _prevPoint = newPoint;
        [self setNeedsDisplay];
    }
}


@end

