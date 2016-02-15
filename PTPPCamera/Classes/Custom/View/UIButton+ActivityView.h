//
//  UIButton+ActivityView.h
//  PTLatitude
//
//  Created by so on 15/12/24.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(ActivityView)
@property (strong, nonatomic, readonly) UIActivityIndicatorView *activityView;
@property (assign, nonatomic, getter=isLoading) BOOL loading;
@end
