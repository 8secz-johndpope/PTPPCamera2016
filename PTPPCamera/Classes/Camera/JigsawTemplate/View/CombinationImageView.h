//
//  CombinationView.h
//  PTPaiPaiCamera
//
//  拼图模块，切换两个拼图位置的视图
//
//  Created by eddie on 1/1/15.
//  Copyright (c) 2015 putao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CombinationImageView : UIView<UIScrollViewDelegate>{
    //
}

@property (nonatomic, retain) UIScrollView  *contentView;
@property(nonatomic,retain) UIImageView *imageview;
@property (nonatomic, retain) UIBezierPath *realCellArea;
- (void)setup;
- (void)setImageViewData:(UIImage *)imageData;
-(void) rotateImageWithRatio:(float) ratio;

@end
