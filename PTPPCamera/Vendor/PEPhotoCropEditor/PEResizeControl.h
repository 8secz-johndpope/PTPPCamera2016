//
//  PEResizeControl.h
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/19.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//  自定义裁切框的 边角

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol PEResizeControlViewDelegate;

@interface PEResizeControl : UIView

@property (nonatomic, weak) id<PEResizeControlViewDelegate> delegate;
@property (nonatomic, readonly) CGPoint translation;                     //变幻

@end



//
// 裁切框自动调整裁切框代理
//
@protocol PEResizeControlViewDelegate <NSObject>

// 尺寸调整开始时
- (void)resizeControlViewDidBeginResizing:(PEResizeControl *)resizeControlView;
// 尺寸调整进行时
- (void)resizeControlViewDidResize:(PEResizeControl *)resizeControlView;
// 尺寸调整完成时
- (void)resizeControlViewDidEndResizing:(PEResizeControl *)resizeControlView;

@end
