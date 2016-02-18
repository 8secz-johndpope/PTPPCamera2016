//
//  PTPPLiveStickerPreviewViewController.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 20/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "SOBaseViewController.h"
#define kTopControlHeight 44
#define kBottomControlHeight 97

@interface PTPPLiveStickerPreviewViewController : SOBaseViewController
@property (nonatomic, strong) UIView *stickerView;
@property (nonatomic, strong) UIImageView *eyeSticker;
@property (nonatomic, strong) UIImageView *mouthSticker;
@property (nonatomic, strong) UIImageView *bottomSticker;
@property (nonatomic, strong) UIView *topCropMask;
@property (nonatomic, strong) UIImageView *basedPhotoView;

-(instancetype)initWithBasePhoto:(UIImage *)image mouthSticker:(UIImageView *)mouthSticker eyeSticker:(UIImageView *)eyeSticker bottomSticker:(UIImageView *)bottomSticker faceAngle:(CGFloat)faceAngle;
-(void)setCropOption:(NSInteger)cropOption;
@end
