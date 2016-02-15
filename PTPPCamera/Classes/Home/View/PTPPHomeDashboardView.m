//
//  PTPPHomeDashboardView.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 12/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPHomeDashboardView.h"

#import "SOKit.h"
#import "NSObject+Swizzle.h"
@interface PTPPHomeItemView ()

@end

@implementation PTPPHomeDashboardView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setAttributeWithItems:(NSArray *)items{
    NSInteger index = 0;
    for(NSDictionary *itemDict in items){
        PTPPHomeItemView *itemView = [[PTPPHomeItemView alloc] initWithFrame:CGRectMake(0, 0, self.width/2, self.height/2)];
        [itemView setAttributeWithImageName:[itemDict safeObjectForKey:kIcon] titleText:[itemDict safeObjectForKey:kTitle]];
        switch (index) {
            case 0:
                itemView.frame = CGRectMake(0, 0, itemView.width, itemView.height);
                break;
            case 1:
                itemView.frame = CGRectMake(itemView.width, 0, itemView.width, itemView.height);
                break;
            case 2:
                itemView.frame = CGRectMake(0, itemView.height, itemView.width, itemView.height);
                break;
            case 3:
                itemView.frame = CGRectMake(itemView.width, itemView.height, itemView.width, itemView.height);
                break;
                
            default:
                break;
        }
        itemView.exclusiveTouch = YES;
        itemView.tag = index;
        [itemView addTarget:self action:@selector(didTapMenuItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemView];
        [self.menuItems addObject:itemView];
        index++;
    }
}

-(void)didTapMenuItem:(UIControl *)control{
    [UIView animateWithDuration:0.1 animations:^{
        control.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            control.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                control.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didTapMenuItemAtIndex:)]) {
                    [self.delegate didTapMenuItemAtIndex:control.tag];
                }
            }];
        }];
        
    }];
    
}

-(NSMutableArray *)menuItems{
    if (!_menuItems) {
        _menuItems = [[NSMutableArray alloc] init];
    }
    return _menuItems;
}

@end
