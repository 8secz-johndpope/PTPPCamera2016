//
//  PECropRectView.h
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/21.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.


//  封装的裁切框的视图
#import <UIKit/UIKit.h>

@protocol PECropRectViewDelegate;

@interface PECropRectView : UIView

@property (nonatomic, weak) id<PECropRectViewDelegate> delegate;
@property (nonatomic) BOOL showsGridMajor;          //裁切使用的大网格
//@property (nonatomic) BOOL showsGridMinor;          //旋转使用的小网格

@property (nonatomic) BOOL keepingAspectRatio;      //是否保持宽高比

@end


//裁切的代理方法
@protocol PECropRectViewDelegate <NSObject>

// 裁切事件
- (void)cropRectViewDidBeginEditing:(PECropRectView *)cropRectView;
//
- (void)cropRectViewEditingChanged:(PECropRectView *)cropRectView;
//
- (void)cropRectViewDidEndEditing:(PECropRectView *)cropRectView;

@end









