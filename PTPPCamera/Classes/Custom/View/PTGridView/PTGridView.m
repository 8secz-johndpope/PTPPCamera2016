//
//  PTGridView.m
//  PTLatitude
//
//  Created by so on 15/11/29.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTGridView.h"
#import "PTGridButton.h"

@interface PTGridView ()
@property (strong, nonatomic) NSMutableArray *itemViews;
@end
@implementation PTGridView

+ (CGFloat)gridViewHeightWithItems:(NSArray *)items width:(CGFloat)width verticalSpace:(CGFloat)verticalSpace horizontalSpace:(CGFloat)horizontalSpace {
    CGFloat x = 0; CGFloat y = 0; CGFloat height = 0;
    BOOL moreRow = YES;
    for(PTGridItem *item in items) {
        x += item.size.width + horizontalSpace;
        if(moreRow) {
            moreRow = NO;
            height += (item.size.height + verticalSpace);
        }
        moreRow = (x > width);
        if (moreRow) {
            x = 0;
            y += (item.size.height + verticalSpace);
        }
    }
    height -= (height > verticalSpace ? verticalSpace : 0);
    return (height);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        _delegate = nil;
        _items = nil;
        _itemViews = [[NSMutableArray alloc] init];
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadSubViews];
}

#pragma mark - setter
- (void)setItems:(NSArray *)items {
    _items = items;
    
    [self.itemViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemViews removeAllObjects];
    
    for(NSUInteger index = 0; index < _items.count; index ++) {
        PTGridItem *item = [_items safeObjectAtIndex:index];
        PTGridButton *button = [[PTGridButton alloc] init];
        button.item = item;
        [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.itemViews addObject:button];
    }
}
#pragma mark -

#pragma mark - action
- (void)reloadSubViews {
    CGRect inFrame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    CGFloat x = CGRectGetMinX(inFrame);
    CGFloat y = CGRectGetMinY(inFrame);
    for(PTGridButton *button in self.itemViews) {
        button.x = x;
        button.y = y;
        x += (button.width + self.horizontalSpace);
        if(x > CGRectGetMaxX(inFrame)) {
            x = CGRectGetMinX(inFrame);
            y += (button.height + self.verticalSpace);
        }
    }
}

- (void)buttonTouched:(PTGridButton *)button {
    button.selected =  button.item.selected = !button.item.selected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(gridView:didSelectAtIndex:)]) {
        [self.delegate gridView:self didSelectAtIndex:[self.itemViews indexOfObject:button]];
    }
}
#pragma mark -

@end
