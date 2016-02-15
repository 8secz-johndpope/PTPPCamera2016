//
//  PTGridButton.m
//  PTLatitude
//
//  Created by so on 15/11/29.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTGridButton.h"

@implementation PTGridButton

- (void)setItem:(PTGridItem *)item {
    _item = item;
    self.size = item.size;
    self.enabled = item.enabled;
    self.selected = [item isSelected];
    [self setAttributedTitle:item.text forState:UIControlStateNormal];
    [self setTitleColor:item.textColor forState:UIControlStateNormal];
    [self setTitleColor:item.selectedTextColor forState:UIControlStateSelected];
    [self.titleLabel setFont:item.font];
    self.layer.cornerRadius = item.cornerRadius;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setBackgroundColor:[self isSelected] ? self.item.selectedBackgroundColor : self.item.backgroundColor];
}

@end
