//
//  PTTextView.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/28.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 自定义的带 placeholder属性的TextView
 */
@interface PTTextView : UITextView

@property(nonatomic,copy) NSString *myPlaceholder;  //文字

@property(nonatomic,strong) UIColor *myPlaceholderColor; //文字颜色

@end
