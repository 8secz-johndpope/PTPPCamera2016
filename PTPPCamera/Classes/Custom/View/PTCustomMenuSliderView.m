//
//  PTCustomMenuSliderView.m
//  CustomUIWorkspace
//
//  Created by CHEN KAIDI on 26/11/15.
//  Copyright (c) 2015 CHEN KAIDI. All rights reserved.
//

#import "PTCustomMenuSliderView.h"
#define defaultTrackerWidth 50
@interface PTCustomMenuSliderView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *menuTrackerView;
@property (nonatomic, strong) NSMutableArray *menuControlArray;
@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, strong) UIColor *idleColor;
@property (nonatomic, assign) NSInteger activeSection;
@end

@implementation PTCustomMenuSliderView

#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.activeSection = 0;
        [self addSubview:self.scrollView];
    }
    return self;
}

#pragma mark - public methods

-(void)setAttributeWithItems:(NSArray *)items buttonWidth:(CGFloat)buttonWidth themeColor:(UIColor *)themeColor idleColor:(UIColor *)idleColor trackerWidth:(CGFloat)trackerWidth{
    self.themeColor = themeColor;
    self.idleColor = idleColor;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.menuControlArray removeAllObjects];
    [self.scrollView addSubview:self.menuTrackerView];
    self.scrollView.frame = self.bounds;
    for (NSInteger i=0; i<items.count; i++) {
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(i*buttonWidth, 0, buttonWidth, self.height)];
        [menuButton setTitle:[items safeObjectAtIndex:i] forState:UIControlStateNormal];
        menuButton.titleLabel.font = [UIFont systemFontOfSize:14];
        menuButton.tag = i;
        [menuButton addTarget:self action:@selector(didSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuControlArray addObject:menuButton];
        [self.scrollView addSubview:menuButton];
        [self.scrollView setContentSize:CGSizeMake(menuButton.right, self.scrollView.height)];
    }
    self.menuTrackerView.frame = CGRectMake(0, self.height-8, trackerWidth, self.menuTrackerView.height);
    self.menuTrackerView.backgroundColor = self.themeColor;
    [self updateMenuSelectionStateAnimated:NO];
}

-(void)scrollToIndexWithActiveSection:(NSInteger)index{
    if (index>=self.menuControlArray.count) {
        NSLog(@"PTCustomeMenuSliderView: index(%ld) out of boundary (Total count %ld)!",(long)index, (long)self.menuControlArray.count);
        return;
    }
    self.activeSection = index;
    [self updateMenuSelectionStateAnimated:YES];
}

#pragma mark - private methods

-(void)didSelectItem:(UIButton *)sender{
    self.activeSection = sender.tag;
    [self updateMenuSelectionStateAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:didSelecteAtIndex:)]) {
        [self.delegate sliderView:self didSelecteAtIndex:self.activeSection];
    }
}

-(void)updateMenuSelectionStateAnimated:(BOOL)animated{
    CGPoint trackerDesPoint = CGPointZero;
    CGFloat targetOffset = 0;
    for(UIButton *menuButton in self.menuControlArray){
        if (menuButton.tag == self.activeSection) {
            [menuButton setTitleColor:self.themeColor forState:UIControlStateNormal];
            trackerDesPoint = menuButton.center;
        }else{
            [menuButton setTitleColor:self.idleColor forState:UIControlStateNormal];
        }
    }
    if (trackerDesPoint.x-self.width/2 > 0 && trackerDesPoint.x+self.width/2<self.scrollView.contentSize.width) {
        targetOffset = trackerDesPoint.x-self.width/2;
    }else if(trackerDesPoint.x+self.width/2>=self.scrollView.contentSize.width){
        targetOffset = self.scrollView.contentSize.width-self.width;
    }
    [self.scrollView setContentOffset:CGPointMake(targetOffset, 0) animated:YES];
    if (animated) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2
                              delay:0.0
             usingSpringWithDamping:0.92
              initialSpringVelocity:6.0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.menuTrackerView.center = CGPointMake(trackerDesPoint.x, weakSelf.menuTrackerView.centerY);
                            } completion:^(BOOL finished) {}];
        
    }else{
        self.menuTrackerView.center = CGPointMake(trackerDesPoint.x, self.menuTrackerView.centerY);
    }
}

#pragma mark - getters/setters

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UIView *)menuTrackerView{
    if (!_menuTrackerView) {
        _menuTrackerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, defaultTrackerWidth, 2)];
        _menuTrackerView.layer.cornerRadius = 1;
        _menuTrackerView.layer.masksToBounds = YES;
    }
    return _menuTrackerView;
}

-(NSMutableArray *)menuControlArray{
    if (!_menuControlArray) {
        _menuControlArray = [[NSMutableArray alloc] init];
    }
    return _menuControlArray;
}

@end
