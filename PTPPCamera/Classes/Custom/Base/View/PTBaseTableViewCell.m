//
//  PTBaseTableViewCell.m
//  PTLatitude
//
//  Created by so on 15/11/27.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTBaseTableViewCell.h"

CGFloat const PTBaseTableViewCellBorder     = 10.0f;

@interface PTBaseTableViewCell ()
@property (strong, nonatomic, readonly) UIView *topLineView;
@property (strong, nonatomic, readonly) UIView *bottomLineView;
@end

@implementation PTBaseTableViewCell
@synthesize topLineView = _topLineView;
@synthesize bottomLineView = _bottomLineView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.contentInsets = UIEdgeInsetsZero;
        self.lineHeight = 1.0f / [UIScreen mainScreen].scale;
        [self.contentView addSubview:self.topLineView];
        [self.contentView addSubview:self.bottomLineView];
        self.showTopLine = self.showBottomLine = NO;
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.topLineView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.lineHeight);
    self.bottomLineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - self.lineHeight, CGRectGetWidth(self.bounds), self.lineHeight);
}

#pragma mark - getter
- (UIView *)topLineView {
    if(!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = UIColorFromRGB(0xe1e1e1);
    }
    return (_topLineView);
}

- (UIView *)bottomLineView {
    if(!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = UIColorFromRGB(0xe1e1e1);
    }
    return (_bottomLineView);
}

- (UIColor *)lineColor {
    return (self.bottomLineView.backgroundColor);
}

- (BOOL)isShowTopLine {
    return (![self.topLineView isHidden]);
}

- (BOOL)isShowBottomLine {
    return (![self.bottomLineView isHidden]);
}
#pragma mark -

#pragma mark - setter
- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    [self setNeedsLayout];
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    [self.contentView bringSubviewToFront:self.topLineView];
    [self.contentView bringSubviewToFront:self.bottomLineView];
    [self setNeedsLayout];
}

- (void)setLineColor:(UIColor *)lineColor {
    self.topLineView.backgroundColor = self.bottomLineView.backgroundColor = lineColor;
    [self.contentView bringSubviewToFront:self.topLineView];
    [self.contentView bringSubviewToFront:self.bottomLineView];
}

- (void)setShowTopLine:(BOOL)showTopLine {
    self.topLineView.hidden = !showTopLine;
    [self.contentView bringSubviewToFront:self.topLineView];
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    self.bottomLineView.hidden = !showBottomLine;
    [self.contentView bringSubviewToFront:self.bottomLineView];
}
#pragma mark -

@end
