//
//  PTHeaderFooterWebView.m
//  kidsPlay
//
//  Created by so on 15/9/16.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "PTHeaderFooterWebView.h"

CG_INLINE CGRect CGRectSetX(CGRect rect, CGFloat x){
    rect.origin.x = x;
    return rect;
}

CG_INLINE CGRect CGRectSetY(CGRect rect, CGFloat y){
    rect.origin.y = y;
    return rect;
}

CG_INLINE UIEdgeInsets UIEdgeInsetsSetTop(UIEdgeInsets insets, CGFloat top){
    insets.top = top;
    return insets;
}

CG_INLINE UIEdgeInsets UIEdgeInsetsSetBottom(UIEdgeInsets insets, CGFloat bottom){
    insets.bottom = bottom;
    return insets;
}

@implementation PTHeaderFooterWebView

@synthesize headerView = _headerView;
@synthesize footerView = _footerView;
@synthesize scrollDelegate = _scrollDelegate;

- (void)setHeaderView:(UIView *)view {
    if (_headerView && _headerView.superview) {
        [_headerView removeFromSuperview];
    }
    _headerView = view;
    _headerView.frame = CGRectSetY(_headerView.frame, -_headerView.frame.size.height);
    self.scrollView.contentInset = UIEdgeInsetsSetTop(self.scrollView.contentInset, _headerView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(0, -_headerView.frame.size.height);
    [self.scrollView addSubview:_headerView];
}

- (void)setFooterView:(UIView *)view {
    if (_footerView && _footerView.superview) {
        [_footerView removeFromSuperview];
    }
    _footerView = view;
    _footerView.frame = CGRectSetY(_footerView.frame, self.scrollView.contentSize.height);
    
    self.scrollView.contentInset = UIEdgeInsetsSetBottom(self.scrollView.contentInset, view.frame.size.height);
    [self.scrollView addSubview:_footerView];
}

- (void)headerViewHeightChange:(CGFloat)height animated:(BOOL)animated {
    if (animated) {
        [UIView beginAnimations:@"animateScrollView" context:nil];
        [UIView setAnimationDuration:0.3];
    }
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -height);
    self.scrollView.contentInset = UIEdgeInsetsSetTop(self.scrollView.contentInset, height);
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, -height, self.headerView.frame.size.width, height);
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.footerView.frame = CGRectSetY(_footerView.frame, self.scrollView.contentSize.height);
    
    CGFloat webViewWidth = self.frame.size.width;
    
    //缩小到小于webview宽度时
    if (scrollView.contentSize.width < webViewWidth) {
        CGSize contentSize = scrollView.contentSize;
        contentSize.width = webViewWidth;
        scrollView.contentSize = contentSize;
    }
    
    //左右露边
    if (scrollView.contentSize.width - webViewWidth < 0 && scrollView.contentOffset.x < 0) {
        self.headerView.frame = CGRectSetX(self.headerView.frame, scrollView.contentOffset.x);
        self.footerView.frame = CGRectSetX(self.footerView.frame, scrollView.contentOffset.x);
    } else if (scrollView.contentOffset.x < 0) {  //左露边
        self.headerView.frame = CGRectSetX(self.headerView.frame, 0);
        self.footerView.frame = CGRectSetX(self.footerView.frame, 0);
    } else if (scrollView.contentOffset.x > scrollView.contentSize.width - webViewWidth) {    //右露边
        self.headerView.frame = CGRectSetX(self.headerView.frame, scrollView.contentSize.width - webViewWidth);
        self.footerView.frame = CGRectSetX(self.footerView.frame, scrollView.contentSize.width - webViewWidth);
    } else {  //平常滚动/缩放
        self.headerView.frame = CGRectSetX(self.headerView.frame, scrollView.contentOffset.x);
        self.footerView.frame = CGRectSetX(self.footerView.frame, scrollView.contentOffset.x);
    }
    
    if(self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(webView:scrollViewDidScroll:)]) {
        [self.scrollDelegate webView:self scrollViewDidScroll:self.scrollView];
    }
}

@end
