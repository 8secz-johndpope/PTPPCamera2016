//
//  UIView+Hints.m
//
//  Created by Sean Li on 13-12-20.
//  Copyright (c) 2013年 HiLib. All rights reserved.
//

#import "UIView+Hints.h"

@implementation UIView (Hints)

/*
 @abstract  获取最前面的window
 */
+(UIWindow*)topWindows
{
    NSArray *windowsArray = [UIApplication sharedApplication].windows;
    if (windowsArray && [windowsArray count] > 0) {
        return [windowsArray lastObject];
    }else{
        return [UIApplication sharedApplication].keyWindow;
    }
}

@end
