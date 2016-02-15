//
//  PTBaseTableViewCell.h
//  PTLatitude
//
//  Created by so on 15/11/27.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const PTBaseTableViewCellBorder;

@interface PTBaseTableViewCell : UITableViewCell
@property (assign, nonatomic) UIEdgeInsets contentInsets;
@property (assign, nonatomic) CGFloat lineHeight;
@property (strong, nonatomic) UIColor *lineColor;
@property (assign, nonatomic, getter=isShowTopLine) BOOL showTopLine;
@property (assign, nonatomic, getter=isShowBottomLine) BOOL showBottomLine;
@end
