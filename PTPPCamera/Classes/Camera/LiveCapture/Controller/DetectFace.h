//  DetectFace.h
//  SantaFace
//
//  Created by Tadas Z on 11/30/12.
//  DevBridge

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef void(^FinishShoot)(UIImage *image);
@class DetectFace;
@protocol DetectFaceDelegate <NSObject>
- (void)detectedFaceController:(DetectFace *)controller features:(NSArray *)featuresArray forVideoBox:(CGRect)clap withPreviewBox:(CGRect)previewBox processedImage:(UIImage *)processedImage ;
@end

@interface DetectFace : NSObject
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, assign) UIImagePickerControllerCameraDevice cameraPosition;
@property (nonatomic, strong) NSArray *filters;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, assign) NSInteger activeFilterID;
@property (nonatomic, copy) FinishShoot finishShoot;
- (void)startDetection;
- (void)stopDetection;
-(void)cameraShoot;
-(void)startRunning;
-(void)stopRunning;
- (void) turnTorchOn:(NSInteger)mode;
-(void)blinkTorch:(BOOL)state;
-(NSString *)getFilterNameFromIndex:(NSInteger)index;
-(void)swapCameraPosition:(UIImagePickerControllerCameraDevice)cameraPosition;
+ (CGRect)convertFrame:(CGRect)originalFrame previewBox:(CGRect)previewBox forVideoBox:(CGRect)videoBox isMirrored:(BOOL)isMirrored;

@end
