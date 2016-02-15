//
//  PTPPCameraSettingPopupView.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 8/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPCameraSettingPopupView.h"
#import "UIView+Additions.h"

@interface PTPPCameraSettingPopupView ()

@end

@implementation PTPPCameraSettingPopupView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    }
    return self;
}

-(void)setAttributeWithButtonImages:(NSArray *)buttonImages{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i=0; i<buttonImages.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, i*self.width, self.width, self.width)];
        [button setImage:[buttonImages objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(didTapOption:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.frame = CGRectMake(self.left, self.top, self.width, button.bottom);
    }
}

-(void)didTapOption:(UIButton *)sender{
    if (self.finishBlock) {
        self.finishBlock(self,sender.tag);
    }
}

@end
