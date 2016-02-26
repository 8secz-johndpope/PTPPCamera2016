//
//  ELCImageSelectionBottomPreview.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 26/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetHelper.h"
#define kBottomHeight 140

@interface ELCImageSelectionBottomPreview : UIView
-(void)addPhotoAsset:(ALAsset *)asset;
-(void)setAttributeWithMaxCount:(NSInteger)maxCount;
@end
