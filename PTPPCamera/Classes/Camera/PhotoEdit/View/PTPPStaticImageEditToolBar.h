//
//  PTPPStaticImageEditToolBar.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 16/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kEditImageControlNameKey @"kEditImageControlNameKey"
#define kEditImageControlIconKey @"kEditImageControlIconKey"
@interface PTPPStaticImageEditToolBar : UIView
-(void)setAttributeWithControlSettings:(NSArray *)controlSettings;
@end
