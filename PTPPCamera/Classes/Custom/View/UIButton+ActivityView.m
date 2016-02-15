//
//  UIButton+ActivityView.m
//  PTLatitude
//
//  Created by so on 15/12/24.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "UIButton+ActivityView.h"
#import <objc/runtime.h>

@implementation UIButton(ActivityView)
@dynamic loading;
@dynamic activityView;

- (BOOL)isLoading {
    id loadingValue = objc_getAssociatedObject(self, &@selector(loading));
    if(!loadingValue || ![loadingValue respondsToSelector:@selector(boolValue)]) {
        return (NO);
    }
    return ([loadingValue boolValue]);
}

- (UIActivityIndicatorView *)activityView {
    UIActivityIndicatorView *ac = objc_getAssociatedObject(self, &@selector(activityView));
    if(ac && ![ac isKindOfClass:[UIActivityIndicatorView class]]) {
        [self setActivityView:nil];
        return (nil);
    }
    return (ac);
}

- (void)setLoading:(BOOL)loading {
    objc_setAssociatedObject(self, &@selector(loading), @(loading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.enabled = !loading;
    if(!loading) {
        if([self activityView]) {
            [[self activityView] stopAnimating];
        }
        return;
    }
    if(![self activityView]) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.color = UIColorFromRGB(0x985ec9);
        activityView.hidesWhenStopped = YES;
        [self setActivityView:activityView];
    }
    [self activityView].center = CGPointMake(self.width / 2.0f, self.height / 2.0f);
    [[self activityView] startAnimating];
    [self addSubview:self.activityView];
}

- (void)setActivityView:(UIActivityIndicatorView *)activityView {
    objc_setAssociatedObject(self, &@selector(activityView), activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
