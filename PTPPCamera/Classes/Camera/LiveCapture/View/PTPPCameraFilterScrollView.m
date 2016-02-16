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
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) NSArray *filterSet;
@property (nonatomic, strong) NSMutableArray *filterControlSet;
@end

@implementation PTPPCameraFilterScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.scrollView];
        [self addSubview:self.dismissButton];
    }
    return self;
}

-(void)setAttributeWithFilterSet:(NSArray *)filterSet{
    self.filterSet = filterSet;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.filterControlSet removeAllObjects];
    for (NSInteger i=0; i<self.filterSet.count; i++) {
        FilterControl *filterControl = [[FilterControl alloc] initWithFrame:CGRectMake(i*70, 0, 70, self.scrollView.height)];
        filterControl.tag = i;
        [filterControl addTarget:self action:@selector(didTapFilterControl:) forControlEvents:UIControlEventTouchUpInside];
        filterControl.filterPreivew = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
        filterControl.filterPreivew.image = [[self.filterSet safeObjectAtIndex:i] safeObjectForKey:PTFILTERIMAGE];
        filterControl.filterPreivew.layer.borderColor = [UIColor clearColor].CGColor;
        if (i==self.activeFilterID) {
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
        if (i==self.activeFilterID) {
            filterControl.filterLabel.textColor = [UIColor colorWithHexString:@"ff5654"];
        }else{
            filterControl.filterLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        }
        [filterControl addSubview:filterControl.filterLabel];
        [self.scrollView addSubview:filterControl];
        self.scrollView.contentSize = CGSizeMake(filterControl.right, self.scrollView.height);
        [self.filterControlSet addObject:filterControl];
    }

    self.dismissButton.frame = CGRectMake(0, self.scrollView.bottom, self.dismissButton.width, self.dismissButton.height);
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
       
        self.filterSelected(control.tag);
    }
}

-(void)dismissMe{
    if (self.finishBlock) {
        self.finishBlock();
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

-(UIButton *)dismissButton{
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        [_dismissButton setImage:[UIImage imageNamed:@"btn_spread_down"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismissMe) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}


@end

