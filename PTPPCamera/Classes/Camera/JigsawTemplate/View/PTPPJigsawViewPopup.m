//
//  PTPPJigsawViewPopup.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 1/3/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPJigsawViewPopup.h"
#define kIconSize 50
@implementation PTPPJigsawViewPopup

-(instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, kIconSize*3, kIconSize)];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
        [self setupTools];
    }
    return self;
}

-(void)setupTools{
    for (NSInteger i = 0; i<3; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*kIconSize, 0, kIconSize, kIconSize)];
        button.tag = i;
        [button addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:
                [button setImage:[UIImage imageNamed:@"icon_capture_20_35"] forState:UIControlStateNormal];
                break;
            case 1:
                [button setImage:[UIImage imageNamed:@"icon_capture_20_31"] forState:UIControlStateNormal];
                break;
            case 2:
                [button setImage:[UIImage imageNamed:@"icon_capture_20_32"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        [self addSubview:button];
    }
}

-(void)toggleButton:(UIButton *)sender{
    if (self.toolSelected) {
        self.toolSelected(sender.tag);
    }
}


@end
