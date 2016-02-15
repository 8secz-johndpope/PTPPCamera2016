//
//  PTCustomMenuSliderView.h
//  CustomUIWorkspace
//
//  Created by CHEN KAIDI on 26/11/15.
//  Copyright (c) 2015 CHEN KAIDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTCustomMenuSliderView;

@protocol PTCustomMenuSliderViewDelegate <NSObject>

@optional
-(void)sliderView:(PTCustomMenuSliderView *)sliderView didSelecteAtIndex:(NSInteger)index;

@end

@interface PTCustomMenuSliderView : UIView
@property (nonatomic, assign) id<PTCustomMenuSliderViewDelegate>delegate;
/*
 Setting up slider menu content.
 =====================================
 items: list of menu text (NSString)
 themeColor: hightlight color 
 idleColor: normal color
 trackerWidth: bottom tracker width
 */
-(void)setAttributeWithItems:(NSArray *)items buttonWidth:(CGFloat)buttonWidth themeColor:(UIColor *)themeColor idleColor:(UIColor *)idleColor trackerWidth:(CGFloat)trackerWidth;
-(void)scrollToIndexWithActiveSection:(NSInteger)index;
@end
