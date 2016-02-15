//
//  PTGridView.h
//  PTLatitude
//
//  Created by so on 15/11/29.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "SOBaseView.h"
#import "PTGridItem.h"

@class PTGridView;

@protocol PTGridViewDelegate <NSObject>
@optional
- (void)gridView:(PTGridView *)gridView didSelectAtIndex:(NSUInteger)index;
@end

@interface PTGridView : SOBaseView

/**
 *  @brief  元素为PTGridItem
 */
@property (strong, nonatomic) NSArray *items;

@property (weak, nonatomic) id <PTGridViewDelegate> delegate;

+ (CGFloat)gridViewHeightWithItems:(NSArray *)items width:(CGFloat)width verticalSpace:(CGFloat)verticalSpace horizontalSpace:(CGFloat)horizontalSpace;

- (void)reloadSubViews;

@end
