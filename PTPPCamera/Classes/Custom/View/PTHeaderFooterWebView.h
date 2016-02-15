//
//  PTHeaderFooterWebView.h
//  kidsPlay
//
//  Created by so on 15/9/16.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTHeaderFooterWebView;
@protocol PTHeaderFooterWebViewDelegate <NSObject>
@optional
- (void)webView:(PTHeaderFooterWebView *)webView scrollViewDidScroll:(UIScrollView *)scrollView;
@end


@interface PTHeaderFooterWebView : UIWebView {
    UIView *_headerView;
    UIView *_footerView;
    __weak id <PTHeaderFooterWebViewDelegate> _scrollDelegate;
}

/**
 *  @brief  webView的顶部视图
 */
@property (nonatomic, strong) UIView *headerView;

/**
 *  @brief  webView的底部视图
 */
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, weak) id <PTHeaderFooterWebViewDelegate> scrollDelegate;

/**
 *  @brief  改变webView的顶部视图高
 */
- (void)headerViewHeightChange:(CGFloat)height animated:(BOOL)animated;

@end
