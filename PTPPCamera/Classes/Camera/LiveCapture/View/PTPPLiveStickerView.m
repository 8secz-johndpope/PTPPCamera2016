//
//  PTPPLiveStickerView.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 18/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPLiveStickerView.h"
#import "DetectFace.h"
#import "NoiseFilter.h"
#define kFilterDataLength 10
#define kStickerScale 2

@interface PTPPLiveStickerView ()
@property (nonatomic, strong) UIView *leftEye, *rightEye, *mouth;
@property (nonatomic, strong) UIView *foregroundView;

@property (nonatomic, strong) NoiseFilter *leftEyeFilterX, *leftEyeFilterY;
@property (nonatomic, strong) NoiseFilter *rightEyeFilterX, *rightEyeFilterY;
@property (nonatomic, strong) NoiseFilter *mouthFilterX, *mouthFilterY;
@property (nonatomic, strong) NoiseFilter *faceWidthFilter;
@end

@implementation PTPPLiveStickerView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bottomSticker];
        [self addSubview:self.foregroundView];
        [self.foregroundView addSubview:self.eyeSticker];
        [self.foregroundView addSubview:self.mouthSticker];
    }
    return self;
}

-(void)fixRotationForStaticFaceDetection{
    //self.foregroundView.transform = CGAffineTransformMakeRotation((1/180.0*M_PI));
}

//加载动态贴纸Animation基本配置
-(void)setAttributeWithMouthAnimation:(PTPPStickerAnimation *)mouthAnimation eyeAnimation:(PTPPStickerAnimation *)eyeAnimation bottomAnimation:(PTPPStickerAnimation *)bottomAnimation{
    self.mouthAnimation = mouthAnimation;
    self.eyeAnimation = eyeAnimation;
    self.bottomAnimation = bottomAnimation;
}

//实时计算动态贴纸的坐标，大小和倾斜角度
-(void)updateLiveStickerFrameWithFaceFeatures:(NSArray *)featuresArray forVideoBox:(CGRect)clap withPreviewBox:(CGRect)previewBox{
    for (CIFaceFeature *ff in featuresArray) {
        CGRect faceRect = [ff bounds];
        faceRect = [DetectFace convertFrame:faceRect previewBox:previewBox forVideoBox:clap isMirrored:YES];
        CGFloat faceWidth = faceRect.size.width;
        float newFaceWidth = [self.faceWidthFilter noiseFilterWithData:faceWidth];
        faceWidth = newFaceWidth;
        float newCenterX;
        float newCenterY;
        self.hidden = NO;
        
        //确认左眼位置
        if(ff.hasLeftEyePosition)
        {
            CGRect leftEyeFrame = CGRectMake(ff.leftEyePosition.y-faceWidth*0.15,  ff.leftEyePosition.x-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3);
            self.leftEye.frame = [DetectFace convertFrame:leftEyeFrame previewBox:previewBox forVideoBox:clap isMirrored:YES];
            [self.leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            self.leftEye.layer.cornerRadius = faceWidth*0.15;
            newCenterX = [self.leftEyeFilterX noiseFilterWithData:self.leftEye.centerX];
            newCenterY = [self.leftEyeFilterY noiseFilterWithData:self.leftEye.centerY];
            self.leftEye.center = CGPointMake(newCenterX, newCenterY);
        }
        //确认右眼位置
        if(ff.hasRightEyePosition)
        {
            CGRect rightEyeFrame = CGRectMake(ff.rightEyePosition.y-faceWidth*0.15, ff.rightEyePosition.x-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3);
            self.rightEye.frame = [DetectFace convertFrame:rightEyeFrame previewBox:previewBox forVideoBox:clap isMirrored:YES];
            [self.rightEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            self.rightEye.layer.cornerRadius = faceWidth*0.15;
            newCenterX = [self.rightEyeFilterX noiseFilterWithData:self.rightEye.centerX];
            newCenterY = [self.rightEyeFilterY noiseFilterWithData:self.rightEye.centerY];
            self.rightEye.center = CGPointMake(newCenterX, newCenterY);
        }
        
        //计算双眼的中心点，加载动画
        if (ff.hasLeftEyePosition && ff.hasRightEyePosition && self.eyeAnimation) {
            self.eyeSticker.hidden = NO;
            CGFloat stickerWidth = self.eyeAnimation.width;
            CGFloat stickerHeight = self.eyeAnimation.height;
            CGFloat stickerDistance = self.eyeAnimation.distance;
            CGPoint stickerCenter = CGPointMake(self.eyeAnimation.centerX, self.eyeAnimation.centerY);
            CGFloat frameDuration = self.eyeAnimation.duration;
            CGFloat actualDistance = [self getDistanceFromPointA:self.leftEye.center pointB:self.rightEye.center]*kStickerScale;
            CGFloat ratio = actualDistance/stickerDistance;
            if (self.eyeSticker.animationImages.count == 0) {
                self.eyeSticker.animationImages = self.eyeAnimation.imageList;
                self.eyeSticker.animationDuration = frameDuration*self.eyeAnimation.imageList.count;
                [self.eyeSticker startAnimating];
            }
            CGPoint eyeStickerCenter = CGPointMake((self.rightEye.centerX+self.leftEye.centerX)/2, (self.rightEye.centerY+self.leftEye.centerY)/2-(stickerCenter.y-stickerHeight/2)/kStickerScale);
            [UIView animateWithDuration:0.1 animations:^{
                self.eyeSticker.frame = CGRectMake(eyeStickerCenter.x-stickerWidth/2*ratio/2, eyeStickerCenter.y-stickerHeight/2*ratio/2, stickerWidth/2*ratio, stickerHeight/2*ratio);
            }];
        }else{
            
            self.eyeSticker.hidden = YES;
        }
        
        //嘴巴动画
        if (ff.hasMouthPosition && self.mouthAnimation) {
            self.mouthSticker.hidden = NO;
            CGFloat stickerWidth = self.mouthAnimation.width;
            CGFloat stickerHeight = self.mouthAnimation.height;
            CGFloat stickerDistance = self.mouthAnimation.distance;
            CGPoint stickerCenter = CGPointMake(self.mouthAnimation.centerX, self.mouthAnimation.centerY);
            CGFloat frameDuration = self.mouthAnimation.duration;
            CGFloat actualDistance = [self getDistanceFromPointA:self.leftEye.center pointB:self.rightEye.center]*kStickerScale;
            CGFloat ratio = actualDistance/stickerDistance;
            CGRect mouthFrame = CGRectMake(ff.mouthPosition.x-stickerWidth*ratio/2, ff.mouthPosition.y-stickerHeight*ratio/2, stickerWidth*ratio, stickerHeight*ratio);
            if (self.mouthSticker.animationImages.count == 0) {
                self.mouthSticker.animationImages = self.mouthAnimation.imageList;
                self.mouthSticker.animationDuration = frameDuration*self.mouthAnimation.imageList.count;
                [self.mouthSticker startAnimating];
            }
            self.mouthSticker.frame = [DetectFace convertFrame:mouthFrame previewBox:previewBox forVideoBox:clap isMirrored:YES];
            newCenterX = [self.mouthFilterX noiseFilterWithData:self.mouthSticker.centerX];
            newCenterY = [self.mouthFilterY noiseFilterWithData:self.mouthSticker.centerY];
            self.mouthSticker.center = CGPointMake(newCenterX, newCenterY-(stickerCenter.y-stickerHeight/2)/kStickerScale);
        }else{
            self.mouthSticker.hidden = YES;
        }
        
        //底部动画
        if (self.mouthAnimation || self.eyeAnimation) {
            if (self.bottomSticker.animationImages.count == 0) {
                self.bottomSticker.animationImages = self.bottomAnimation.imageList;
                self.bottomSticker.animationDuration = self.bottomAnimation.duration*self.bottomAnimation.imageList.count;
                [self.bottomSticker startAnimating];
            }
        }
        
        //倾斜角度
        self.faceAngle = [self pointPairToBearingDegrees:self.leftEye.center secondPoint:self.rightEye.center];
        [UIView animateWithDuration:0.3 animations:^{
            self.foregroundView.transform = CGAffineTransformMakeRotation((self.faceAngle/180.0*M_PI));
        }];
    }
}

- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees-180;
}

-(CGFloat)getDistanceFromPointA:(CGPoint)pointA pointB:(CGPoint)pointB{
    double dx = (pointB.x-pointA.x);
    double dy = (pointB.y-pointA.y);
    double dist = sqrt(dx*dx + dy*dy);
    return dist;
}

-(NoiseFilter *)leftEyeFilterX{
    if (!_leftEyeFilterX) {
        _leftEyeFilterX = [[NoiseFilter alloc] initWithDataLength:kFilterDataLength];
    }
    return _leftEyeFilterX;
}

-(NoiseFilter *)leftEyeFilterY{
    if (!_leftEyeFilterY) {
        _leftEyeFilterY = [[NoiseFilter alloc] initWithDataLength:kFilterDataLength];
    }
    return _leftEyeFilterY;
}

-(NoiseFilter *)rightEyeFilterX{
    if (!_rightEyeFilterX) {
        _rightEyeFilterX = [[NoiseFilter alloc] initWithDataLength:kFilterDataLength];
    }
    return _rightEyeFilterX;
}

-(NoiseFilter *)rightEyeFilterY{
    if (!_rightEyeFilterY) {
        _rightEyeFilterY = [[NoiseFilter alloc] initWithDataLength:kFilterDataLength];
    }
    return _rightEyeFilterY;
}

-(NoiseFilter *)mouthFilterX{
    if (!_mouthFilterX) {
        _mouthFilterX = [[NoiseFilter alloc] initWithDataLength:kFilterDataLength];
    }
    return _mouthFilterX;
}

-(NoiseFilter *)mouthFilterY{
    if (!_mouthFilterY) {
        _mouthFilterY = [[NoiseFilter alloc] initWithDataLength:kFilterDataLength];
    }
    return _mouthFilterY;
}

-(NoiseFilter *)faceWidthFilter{
    if (!_faceWidthFilter) {
        _faceWidthFilter = [[NoiseFilter alloc] initWithDataLength:kFilterDataLength];
    }
    return _faceWidthFilter;
}

-(UIView *)leftEye{
    if (!_leftEye) {
        _leftEye = [[UIView alloc] init];
        _leftEye.backgroundColor = [UIColor clearColor];
    }
    return _leftEye;
}

-(UIView *)rightEye{
    if (!_rightEye) {
        _rightEye = [[UIView alloc] init];
        _rightEye.backgroundColor = [UIColor clearColor];
    }
    return _rightEye;
}

-(UIView *)mouth{
    if (!_mouth) {
        _mouth = [[UIView alloc] init];
        _mouth.backgroundColor = [UIColor clearColor];
    }
    return _mouth;
}

-(UIView *)foregroundView{
    if (!_foregroundView) {
        _foregroundView = [[UIView alloc] initWithFrame:self.bounds];
        _foregroundView.backgroundColor = [UIColor clearColor];
    }
    return _foregroundView;
}

-(UIImageView *)eyeSticker{
    if (!_eyeSticker) {
        _eyeSticker = [[UIImageView alloc] init];
        _eyeSticker.contentMode = UIViewContentModeScaleAspectFit;
        [_eyeSticker startAnimating];
    }
    return _eyeSticker;
}

-(UIImageView *)mouthSticker{
    if (!_mouthSticker) {
        _mouthSticker = [[UIImageView alloc] init];
        _mouthSticker.contentMode = UIViewContentModeScaleAspectFit;
        [_mouthSticker startAnimating];
    }
    return _mouthSticker;
}

-(UIImageView *)bottomSticker{
    if (!_bottomSticker) {
        _bottomSticker = [[UIImageView alloc] initWithFrame:self.bounds];
        _bottomSticker.contentMode = UIViewContentModeScaleAspectFit;
        [_bottomSticker startAnimating];
    }
    return _bottomSticker;
}

@end
