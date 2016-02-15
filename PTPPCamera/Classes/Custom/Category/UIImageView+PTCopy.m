//
//  UIImageView+PTCopy.m
//  PTLatitude
//
//  Created by so on 15/12/6.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "UIImageView+PTCopy.h"

@implementation UIImageView(PTCopy)

- (UIImageView *)copyImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
    imageView.backgroundColor = self.backgroundColor;
    imageView.image = self.image;
    imageView.alpha = self.alpha;
    imageView.layer.borderColor = self.layer.borderColor;
    imageView.layer.borderWidth = self.layer.borderWidth;
    imageView.layer.cornerRadius = self.layer.cornerRadius;
    imageView.clipsToBounds = self.clipsToBounds;
    return (imageView);
}

@end
