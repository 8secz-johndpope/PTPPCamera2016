//
//  WaterMarkView.h
//  PTPaiPaiCamera
//
//  Created by Eddie Dow on 12/23/14.
//  Copyright (c) 2014 putao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WaterMarkBorderView.h"



@interface WaterMarkView : UIView{
    WaterMarkBorderView *borderView;
    float _lastTransX;
    float _lastTransY;
}

@property (assign, nonatomic) UIView *contentView;

@property (nonatomic, assign) BOOL isRemoved;
@property (nonatomic, assign) BOOL isResizeTranslate;  //是否被旋转拉伸2015-05-22

//the smaller of height or width
@property (assign) float minLength;

- (void)setWMContentView:(UIView *)newcontentView;
- (void)hideTrivials;
- (void)showTrivials;
- (void)hideRemoveTrivial;
@end
