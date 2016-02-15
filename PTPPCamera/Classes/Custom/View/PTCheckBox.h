//
//  PTCheckBox.h
//  PTLatitude
//
//  Created by so on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief  选择框，目前仅支持单行
 */
@interface PTCheckBox : UIButton

/**
 *  @brief  图片大小
 */
@property (assign, nonatomic) CGSize imageSize;

/**
 *  @brief  图片和文件的间距
 */
@property (assign, nonatomic) CGFloat imageTextGap;

/**
 *  @brief  计算大小
 *
 *  @return 返回大小
 */
+ (CGSize)checkBoxSizeWithImageSize:(CGSize)imageSize
                       imageTextGap:(CGFloat)imageTextGap
                               text:(NSString *)text
                               font:(UIFont *)font
                      contentInsets:(UIEdgeInsets)contentInsets;

- (CGSize)checkBoxSize;

@end
