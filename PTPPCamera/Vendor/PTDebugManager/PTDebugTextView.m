//
//  PTDebugTextView.m
//  PTRequestDebugManager
//
//  Created by so on 15/12/31.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTDebugTextView.h"

@implementation PTDebugTextView
@synthesize textView = _textView;
@synthesize closeButton = _closeButton;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _closeBlock = nil;
        [self addSubview:self.textView];
        [self addSubview:self.closeButton];
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = self.bounds;
    self.closeButton.center = CGPointMake(CGRectGetWidth(self.bounds) - 0.6f * CGRectGetWidth(self.closeButton.bounds), CGRectGetHeight(self.closeButton.bounds));
}

#pragma mark - getter
- (UITextView *)textView {
    if(!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.bounds];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.editable = NO;
    }
    return (_textView);
}

- (UIButton *)closeButton {
    if(!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        _closeButton.frame = CGRectMake(0, 0, 60, 30);
        [_closeButton setBackgroundColor:[UIColor clearColor]];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [_closeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_closeButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return (_closeButton);
}
#pragma mark -

#pragma mark - actions
- (void)buttonTouched:(id)sender {
    if(self.closeBlock) {
        self.closeBlock();
    }
}
#pragma mark -

@end
