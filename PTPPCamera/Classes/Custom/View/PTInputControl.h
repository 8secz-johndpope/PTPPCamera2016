//
//  PTInputControl.h
//  PTLatitude
//
//  Created by so on 15/11/29.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "SOBaseView.h"

/**
 *  @brief  输入控件的代理协议
 */
@class PTInputControl;
@protocol PTInputControlDelegate <NSObject>
@optional
- (BOOL)inputControl:(PTInputControl *)inputControl textFieldShouldBeginEditing:(UITextField *)textField;
- (void)inputControl:(PTInputControl *)inputControl textFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)inputControl:(PTInputControl *)inputControl textFieldShouldEndEditing:(UITextField *)textField;
- (void)inputControl:(PTInputControl *)inputControl textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)inputControl:(PTInputControl *)inputControl textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)inputControl:(PTInputControl *)inputControl textFieldShouldClear:(UITextField *)textField;
- (BOOL)inputControl:(PTInputControl *)inputControl textFieldShouldReturn:(UITextField *)textField;
- (void)inputControl:(PTInputControl *)inputControl didChangeValue:(NSInteger)value;
@end


@interface PTInputControl : SOBaseView

/**
 *  @brief  值
 */
@property (assign, nonatomic) NSInteger value;

/**
 *  @brief  最小值
 */
@property (assign, nonatomic) NSInteger minValue;

/**
 *  @brief  最大值
 */
@property (assign, nonatomic) NSInteger maxValue;

/**
 *  @brief  每步改变的大小
 */
@property (assign, nonatomic) NSInteger stepValue;

/**
 *  @brief  背景颜色
 */
@property (strong, nonatomic) UIColor *backgroundColor;

/**
 *  @brief  文本颜色
 */
@property (strong, nonatomic) UIColor *textColor;

/**
 *  @brief  代理
 */
@property (weak, nonatomic) id <PTInputControlDelegate> delegate;

@end
