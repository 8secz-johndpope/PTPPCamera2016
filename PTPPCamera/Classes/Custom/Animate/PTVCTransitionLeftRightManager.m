//
//  TransitionManager.m
//  TB_CustomTransitionIOS7
//
//  Created by Yari Dareglia on 10/22/13.
//  Copyright (c) 2013 Bitwaker. All rights reserved.
//

#import "PTVCTransitionLeftRightManager.h"

#import "SOKit.h"
@implementation PTVCTransitionLeftRightManager


#pragma mark - UIViewControllerAnimatedTransitioning -

//Define the transition duration
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}


//Define the transition
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    //STEP 1
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect sourceRect = [transitionContext initialFrameForViewController:fromVC];
    
    /*STEP 2:   Draw different transitions depending on the view to show
                for sake of clarity this code is divided in two different blocks
     */
    
    //STEP 2A: From the First View(INITIAL) -> to the Second View(MODAL)
    if(self.transitionTo == MODAL){
        
        //1.Settings for the fromVC ............................
        fromVC.view.frame = sourceRect;
        
        //2.Insert the toVC view...........................
        UIView *container = [transitionContext containerView];
        [container addSubview:toVC.view];
        CGPoint final_toVC_Center = toVC.view.center;
        
        toVC.view.center = CGPointMake(-sourceRect.size.width/2, sourceRect.size.height/2);
        
        //3.Perform the animation...............................
        [UIView animateWithDuration:0.6
                              delay:0.0
             usingSpringWithDamping:1
              initialSpringVelocity:8.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             fromVC.view.frame = CGRectMake(fromVC.view.left+fromVC.view.width, fromVC.view.top, fromVC.view.width, fromVC.view.height);
                             fromVC.view.alpha = 0.3f;
                             toVC.view.center = final_toVC_Center;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    
    //STEP 2B: From the Second view(MODAL) -> to the First View(INITIAL)
    else{
        
        //Settings for the fromVC ............................
        UIView *container = [transitionContext containerView];
        fromVC.view.frame = sourceRect;
        
        //Insert the toVC view view...........................
        [container insertSubview:toVC.view belowSubview:fromVC.view];

        
        //Perform the animation...............................
        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:0.92
              initialSpringVelocity:6.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             fromVC.view.center = CGPointMake(-sourceRect.size.width/2, fromVC.view.frame.size.height/2);
                             toVC.view.frame = CGRectMake(0, toVC.view.top, toVC.view.width, toVC.view.height);
                             toVC.view.alpha = 1.0;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                             [[UIApplication sharedApplication].keyWindow addSubview:toVC.view];
                         }];
    }

    
}

@end
