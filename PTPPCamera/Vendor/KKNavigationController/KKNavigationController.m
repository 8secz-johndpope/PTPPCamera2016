//
//  KKNavigationController.m
//  TS
//
//  Created by Coneboy_K on 13-12-2.
//  Copyright (c) 2013年 Coneboy_K. All rights reserved.  MIT
//  WELCOME TO MY BLOG  http://www.coneboy.com
//


#import "KKNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

@interface KKNavigationController ()
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
    UIPanGestureRecognizer *_panGestureRecognizer;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL isMoving;

@end

@implementation KKNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.enableBackGesture = YES;
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paningGestureReceive:)];
        _panGestureRecognizer.delegate = self;
        [_panGestureRecognizer delaysTouchesBegan];
    }
    return self;
}

- (void)dealloc {
    self.screenShotsList = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view addGestureRecognizer:_panGestureRecognizer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view removeGestureRecognizer:_panGestureRecognizer];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIImage *img = [self capture];
    if(img) {
        [self.screenShotsList addObject:img];
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self.screenShotsList removeLastObject];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - setter
- (void)setEnableBackGesture:(BOOL)enableBackGesture {
    _panGestureRecognizer.enabled = enableBackGesture;
}
#pragma mark -

#pragma mark - Utility Methods -
- (UIImage *)capture {
    UIImage *img = nil;
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if(ctx != NULL) {
        [self.view.layer renderInContext:ctx];
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return img;
}

- (void)moveViewWithX:(float)x {
    x = x>kkBackViewWidth?kkBackViewWidth:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float alpha = 0.4 - (x/800);

    blackMask.alpha = alpha;

    CGFloat aa = ABS(startBackViewX)/kkBackViewWidth;
    CGFloat y = x*aa;

    CGFloat lastScreenShotViewHeight = kkBackViewHeight;
    
 
    [lastScreenShotView setFrame:CGRectMake(startBackViewX+y,
                                            0,
                                            kkBackViewWidth,
                                            lastScreenShotViewHeight)];

}

-(BOOL)isBlurryImg:(CGFloat)tmp {
    return YES;
}

#pragma mark - <UIGestureRecognizerDelegate>
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    NSString *clsname = [NSString stringWithUTF8String:object_getClassName(otherGestureRecognizer)];
//    if(clsname && [clsname isEqualToString:@"UIScrollViewPanGestureRecognizer"]) {
//        return (YES);
//    }
//    return (NO);
//}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer == _panGestureRecognizer) {
        CGPoint p = [gestureRecognizer locationInView:self.view];
        return (CGRectContainsPoint(CGRectMake(0, 0, 50.0f, self.view.height), p));
    }
    return (YES);
}

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer {
    
    if (self.viewControllers.count <= 1) {
        return;
    }
    
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView || 1)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
       
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        lastScreenShotView.backgroundColor = [UIColor whiteColor];
        
        startBackViewX = startX;
        [lastScreenShotView setFrame:CGRectMake(startBackViewX,
                                                lastScreenShotView.frame.origin.y,
                                                lastScreenShotView.frame.size.height,
                                                lastScreenShotView.frame.size.width)];

        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
    } else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > 50) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:kkBackViewWidth];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

@end
