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
@class PTPPStaticImageEditToolBar;
@protocol PTPPStaticImageEditToolBarDelegate <NSObject>

-(void)toolBar:(PTPPStaticImageEditToolBar *)toolBar didSelectItemAtIndex:(NSInteger)index;

@end

@interface PTPPStaticImageEditToolBar : UIView

@property (nonatomic, assign) id<PTPPStaticImageEditToolBarDelegate>delegate;
-(void)setAttributeWithControlSettings:(NSArray *)controlSettings;

@end
