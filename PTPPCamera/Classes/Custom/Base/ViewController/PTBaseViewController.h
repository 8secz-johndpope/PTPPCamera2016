//
//  PTBaseViewController.h
//  kidsPlay
//
//  Created by so on 15/9/14.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "SOBaseViewController.h"
#import "PTLoadingView.h"

@interface PTBaseViewController : SOBaseViewController {
    CGRect _keyboardBenginFrame;
    CGRect _keyboardEndFrame;
    NSTimeInterval _keyboardAnimationDuration;
    
    BOOL _needRefresh;
    PTLoadingView *_loadingView;
}
@property (assign, nonatomic, getter=isNeedRefresh) BOOL needRefresh;
@property (strong, nonatomic, readonly) PTLoadingView *loadingView;    //自定义加载视图

- (UIButton *)showBackButtonItemAnimation:(BOOL)animation;
- (void)leftItemTouched:(id)sender;

//开始加载动画
- (void)startLoadAnimation;
//停止加载动画
- (void)stopLoadAnimation;

//返回手势
- (BOOL)isEnableBackGesture;
- (void)setEnableBackGesture:(BOOL)enableBackGesture;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end
