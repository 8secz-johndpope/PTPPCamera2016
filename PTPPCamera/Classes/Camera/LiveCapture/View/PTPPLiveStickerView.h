//
//  PTPPLiveStickerView.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 18/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTPPStickerAnimation.h"

@interface PTPPLiveStickerView : UIView
@property (nonatomic, strong) UIImageView *eyeSticker;
@property (nonatomic, strong) UIImageView *mouthSticker;
@property (nonatomic, strong) UIImageView *bottomSticker;
@property (nonatomic, strong) PTPPStickerAnimation *mouthAnimation;
@property (nonatomic, strong) PTPPStickerAnimation *eyeAnimation;
@property (nonatomic, strong) PTPPStickerAnimation *bottomAnimation;
@property (nonatomic, assign) CGFloat faceAngle;

-(BOOL)hasStickers;
-(void)setAttributeWithMouthAnimation:(PTPPStickerAnimation *)mouthAnimation eyeAnimation:(PTPPStickerAnimation *)eyeAnimation bottomAnimation:(PTPPStickerAnimation *)bottomAnimation;
-(void)updateLiveStickerFrameWithFaceFeatures:(NSArray *)featuresArray forVideoBox:(CGRect)clap withPreviewBox:(CGRect)previewBox;
-(void)fixRotationForStaticFaceDetection;
@end
