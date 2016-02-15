//
//  PTShoppingCartNumberIconControl.h
//  PTLatitude
//
//  Created by so on 15/12/24.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "SOBaseControl.h"

@interface PTShoppingCartNumberIconControl : SOBaseControl
+ (CGSize)contentSizeWithTitle:(NSString *)title imageSize:(CGSize)imageSize;
- (NSString *)title;
- (void)setTitle:(NSString *)title;
- (UIColor *)titleColor;
- (void)setTitleColor:(UIColor *)titleColor;
- (UIColor *)titleBackgroundColor;
- (void)setTitleBackgroundColor:(UIColor *)titleBackgroundColor;
- (UIImage *)image;
- (void)setImage:(UIImage *)image;
- (CGSize)imageSize;
- (void)setImageSize:(CGSize)imageSize;
@end
