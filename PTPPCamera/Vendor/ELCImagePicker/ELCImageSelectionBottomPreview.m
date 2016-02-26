//
//  ELCImageSelectionBottomPreview.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 26/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "ELCImageSelectionBottomPreview.h"

@interface ELCImageSelectionBottomPreview ()
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UILabel *topTitle;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *selectionCount;
@end

@implementation ELCImageSelectionBottomPreview

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    }
    return self;
}

@end
