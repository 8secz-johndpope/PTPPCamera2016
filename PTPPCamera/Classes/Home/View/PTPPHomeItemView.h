//
//  PTPPHomeItemView.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 12/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kIcon @"kIcon"
#define kTitle @"kTitle"

@interface PTPPHomeItemView : UIControl
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
-(void)setAttributeWithImageName:(NSString *)imageName titleText:(NSString *)titleText;
@end
