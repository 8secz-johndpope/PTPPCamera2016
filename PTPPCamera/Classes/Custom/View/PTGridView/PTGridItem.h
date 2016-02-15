//
//  PTGridItem.h
//  PTLatitude
//
//  Created by so on 15/11/29.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "SOBaseItem.h"

@interface PTGridItem : SOBaseItem
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (copy, nonatomic) NSAttributedString *text;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *selectedTextColor;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *selectedBackgroundColor;
@end
