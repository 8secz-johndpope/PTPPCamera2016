//
//  UITabBar+badge.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/20.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief  tabbaritem设置红点大小、自定义宽高
 */
@interface UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
