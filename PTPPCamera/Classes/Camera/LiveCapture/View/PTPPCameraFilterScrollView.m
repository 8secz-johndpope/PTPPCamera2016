//
//  PTPPCameraFilterScrollView.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 7/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPCameraFilterScrollView.h"
#import "UIView+Additions.h"
#import "UIColor+Help.h"
#import "NSObject+Swizzle.h"
#import "FilterControl.h"
#import "PTFilterManager.h"
@class FilterControl;
@interface PTPPCameraFilterScrollView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *buttonSplitterLeft;
@property (nonatomic, strong) UIView *buttonSplitterRight;
@property (nonatomic, strong) NSArray *filterSet;
@property (nonatomic, strong) NSMutableArray *filterControlSet;
@property (nonatomic, assign) CGFloat gridSpace;
@end

@implementation PTPPCameraFilterScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.scrollView];
        [self addSubview:self.cancelButton];
        [self addSubview:self.confirmButton];
        [self addSubview:self.buttonSplitterLeft];
        [self addSubview:self.buttonSplitterRight];
        [self addSubview:self.arrowButton];
    }
    return self;
}

-(void)setAttributeWithFilterSet:(NSArray *)filterSet gridSpace:(CGFloat)gridSpace immediateEffectApplied:(BOOL)immediateEffectApplied{
    self.filterSet = filterSet;
    self.gridSpace = gridSpace;
    if (immediateEffectApplied) {
        self.arrowButton.hidden = NO;
        self.cancelButton.hidden = YES;
        self.confirmButton.hidden = YES;
        self.buttonSplitterLeft.hidden = YES;
        self.buttonSplitterRight.hidden = YES;
    }else{
        self.arrowButton.hidden = YES;
        self.cancelButton.hidden = NO;
        self.confirmButton.hidden = NO;
        self.buttonSplitterLeft.hidden = NO;
        self.buttonSplitterRight.hidden = NO;
    }
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.filterControlSet removeAllObjects];
    for (NSInteger i=0; i<self.filterSet.count; i++) {
        FilterControl *filterControl = [[FilterControl alloc] initWithFrame:CGRectMake(i*self.gridSpace, 0, self.gridSpace, self.scrollView.height)];
        filterControl.tag = i;
        [filterControl addTarget:self action:@selector(didTapFilterControl:) forControlEvents:UIControlEventTouchUpInside];
        filterControl.filterPreivew = [[UIImageView alloc] initWithFrame:CGRectMake((self.gridSpace-50)/2, (self.scrollView.height-50)/2-10, 50, 50)];
        filterControl.filterPreivew.image = [[self.filterSet safeObjectAtIndex:i] safeObjectForKey:PTFILTERIMAGE];
        filterControl.filterPreivew.layer.borderColor = [UIColor clearColor].CGColor;
        if (i==self.previousActiveFilterID) {
            if (!self.iconHightlightMode) {
                filterControl.filterPreivew.layer.borderColor = [UIColor colorWithHexString:@"ff5654"].CGColor;
            }else{
                filterControl.filterPreivew.image = [[self.filterSet safeObjectAtIndex:i] safeObjectForKey:PTFILTERSUBIMAGE];
            }
        }else{
            if (!self.iconHightlightMode) {
                filterControl.filterPreivew.layer.borderColor = self.scrollView.backgroundColor.CGColor;
            }else{
                filterControl.filterPreivew.image = [[self.filterSet safeObjectAtIndex:i] safeObjectForKey:PTFILTERIMAGE];
            }
        }
        
        filterControl.filterPreivew.layer.borderWidth = 1;
        filterControl.filterPreivew.layer.cornerRadius = 4;
        if (self.iconHightlightMode) {
            filterControl.filterPreivew.contentMode = UIViewContentModeCenter;
        }else{
            filterControl.filterPreivew.contentMode = UIViewContentModeScaleAspectFill;
        }
        
        filterControl.filterPreivew.clipsToBounds = YES;
        [filterControl addSubview:filterControl.filterPreivew];
        filterControl.filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, filterControl.filterPreivew.bottom, filterControl.width, filterControl.height-filterControl.filterPreivew.bottom)];
        filterControl.filterLabel.font = [UIFont systemFontOfSize:12];
        filterControl.filterLabel.text = [[self.filterSet safeObjectAtIndex:i] safeObjectForKey:PTFILTERNAME];
        filterControl.filterLabel.textAlignment = NSTextAlignmentCenter;
        if (i==self.previousActiveFilterID) {
            filterControl.filterLabel.textColor = [UIColor colorWithHexString:@"ff5654"];
        }else{
            filterControl.filterLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        }
        [filterControl addSubview:filterControl.filterLabel];
        [self.scrollView addSubview:filterControl];
        self.scrollView.contentSize = CGSizeMake(filterControl.right, self.scrollView.height);
        [self.filterControlSet addObject:filterControl];
    }

}

-(void)didTapFilterControl:(UIControl *)control{
    if (self.filterSelected) {
         self.activeFilterID = control.tag;
        NSInteger index = 0;
        for(FilterControl *filterControl in self.filterControlSet){
            filterControl.filterPreivew.layer.borderColor = self.scrollView.backgroundColor.CGColor;
            filterControl.filterLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
            if (index == self.activeFilterID) {
                if (!self.iconHightlightMode) {
                    filterControl.filterPreivew.layer.borderColor = [UIColor colorWithHexString:@"ff5654"].CGColor;
                }else{
                    filterControl.filterPreivew.image = [[self.filterSet safeObjectAtIndex:index] safeObjectForKey:PTFILTERSUBIMAGE];
                }

                filterControl.filterLabel.textColor = [UIColor colorWithHexString:@"ff5654"];
            }else{
                if (!self.iconHightlightMode) {
                    filterControl.filterPreivew.layer.borderColor = self.scrollView.backgroundColor.CGColor;
                }else{
                    filterControl.filterPreivew.image = [[self.filterSet safeObjectAtIndex:index] safeObjectForKey:PTFILTERIMAGE];
                }

            }
            index ++;
        }
       
        self.filterSelected(control.tag, YES);
    }
}

-(void)cancel{
    self.filterSelected(self.previousActiveFilterID,NO);
    [self dismissMe:NO];
}

-(void)confirm{
    self.previousActiveFilterID = self.activeFilterID;
    [self dismissMe:YES];
}

-(void)dismissMe:(BOOL)saveChange{
    if (self.finishBlock) {
        self.finishBlock(saveChange);
    }
}

-(NSMutableArray *)filterControlSet{
    if (!_filterControlSet) {
        _filterControlSet = [[NSMutableArray alloc] init];
    }
    return _filterControlSet;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-40)];
        _scrollView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UIButton *)arrowButton{
    if (!_arrowButton) {
        _arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.scrollView.bottom, self.width, self.height-self.scrollView.height)];
        [_arrowButton setImage:[UIImage imageNamed:@"btn_spread_down"] forState:UIControlStateNormal];
        [_arrowButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowButton;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.scrollView.bottom, 70, self.height-self.scrollView.height)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 70, self.scrollView.bottom, 70, self.height-self.scrollView.height)];
        [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

-(UIView *)buttonSplitterLeft{
    if (!_buttonSplitterLeft) {
        _buttonSplitterLeft = [[UIView alloc] initWithFrame:CGRectMake(self.cancelButton.right, self.cancelButton.top + 10, 0.5, self.cancelButton.height-20)];
        _buttonSplitterLeft.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    return _buttonSplitterLeft;
}

-(UIView *)buttonSplitterRight{
    if (!_buttonSplitterRight) {
        _buttonSplitterRight = [[UIView alloc] initWithFrame:CGRectMake(self.confirmButton.left, self.confirmButton.top + 10, 0.5, self.confirmButton.height-20)];
        _buttonSplitterRight.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    return _buttonSplitterRight;
}

@end

