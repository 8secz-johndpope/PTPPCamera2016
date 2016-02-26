//
//  ELCImageSelectionBottomPreview.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 26/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "ELCImagePickerHeader.h"
#import <UIKit/UIKit.h>
#import "AssetHelper.h"
#define kBottomHeight 140
typedef void(^FinishSelection)(NSArray *selectedAssets);
@interface ELCImageSelectionBottomPreview : UIView
@property (nonatomic, copy) FinishSelection finishSelection;
-(void)addPhotoAsset:(ELCAsset *)asset;
-(void)setAttributeWithMaxCount:(NSInteger)maxCount;
@end
