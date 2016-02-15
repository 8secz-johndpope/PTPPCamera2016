//
//  UIScrollView+BlurCover.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/29.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView_BlurCover : UIView

@end


@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end