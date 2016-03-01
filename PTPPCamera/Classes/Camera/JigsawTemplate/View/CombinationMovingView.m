//
//  CombinationMovingView.m
//  PTPaiPaiCamera
//
//  Created by eddie on 1/3/15.
//  Copyright (c) 2015 putao. All rights reserved.
//

#import "CombinationMovingView.h"

@implementation CombinationMovingView

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor redColor].CGColor;
    
    UIPanGestureRecognizer *moveGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
    [moveGes setMinimumNumberOfTouches:1];
    [moveGes setMaximumNumberOfTouches:1];
    [self  addGestureRecognizer:moveGes];
}


- (void)moveImage:(UIPanGestureRecognizer *)sender
{
    CGPoint translatedPoint = [sender translationInView:self];
    
    if([sender state] == UIGestureRecognizerStateBegan) {
        _lastTransX = 0.0;
        _lastTransY = 0.0;
    }
    
    CGAffineTransform newTransform = CGAffineTransformTranslate(self.transform, translatedPoint.x - _lastTransX, translatedPoint.y - _lastTransY);
    _lastTransX = translatedPoint.x;
    _lastTransY = translatedPoint.y;
    
    self.transform = newTransform;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = frame;
        [self setup];
    }
    
    return self;
}



@end
