//
//  TransitionManager.h
//  TB_CustomTransitionIOS7
//
//  Created by Yari Dareglia on 10/22/13.
//  Copyright (c) 2013 Bitwaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//Define a custom type for the transition mode
//It simply says which is the current showed view...
typedef NS_ENUM(NSUInteger, TransitionStep){
    INITIAL = 0,
    MODAL
};

@interface PTVCTransitionLeftRightManager : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) TransitionStep transitionTo;

@end
