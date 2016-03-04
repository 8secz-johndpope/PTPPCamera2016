//  DetectFace.m
//  SantaFace
//
//  Created by Tadas Z on 11/30/12.
//  DevBridge

#import "DetectFace.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <whitening/whitening.h>
#import "PTFilterManager.h"
#import "PTPPLocalFileManager.h"
#pragma mark-

@interface DetectFace () <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (strong, nonatomic) CIContext *coreImageContext;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureStillImageOutput *imageDataOutput;
@property (nonatomic) dispatch_queue_t videoDataOutputQueue;
@property (nonatomic, strong) CIDetector *faceDetector;
@property (nonatomic, strong) CIFilter *filter;
@property (nonatomic, strong) CIContext *context;
@end

@implementation DetectFace

- (void)setupAVCapture
{
    
    self.coreImageContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    self.session = [AVCaptureSession new];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // Select a video device, make an input
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //in real app you would use camera that user chose
    if([UIImagePickerController isCameraDeviceAvailable:self.cameraPosition]) {
        for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
            if (self.cameraPosition == UIImagePickerControllerCameraDeviceFront) {
                if ([d position] == AVCaptureDevicePositionFront)
                    self.device = d;
            }else{
                if ([d position] == AVCaptureDevicePositionBack)
                    self.device = d;
            }
            
        }
    }
    else
        exit(0);
    
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if(error != nil)
    {
        exit(0);
    }
    
    if ([self.session canAddInput:deviceInput])
        [self.session addInput:deviceInput];
    
    // Make a video data output
    self.videoDataOutput = [AVCaptureVideoDataOutput new];
    
    // we want BGRA, both CoreGraphics and OpenGL work well with 'BGRA'
    NSDictionary *rgbOutputSettings = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCMPixelFormat_32BGRA)};
    [self.videoDataOutput setVideoSettings:rgbOutputSettings];
    [self.videoDataOutput setAlwaysDiscardsLateVideoFrames:YES]; // discard if the data output queue is blocked (as we process the still image)
    
    self.videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    
    self.imageDataOutput = [AVCaptureStillImageOutput new];
    NSDictionary *imageOutputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
    [self.imageDataOutput setOutputSettings:imageOutputSettings];
    if ( [self.session canAddOutput:self.videoDataOutput] )
        [self.session addOutput:self.videoDataOutput];
    if ([self.session canAddOutput:self.imageDataOutput]) {
        [self.session addOutput:self.imageDataOutput];
    }
    if ( YES == [self.device lockForConfiguration:NULL] )
    {
        [self.device setActiveVideoMaxFrameDuration:CMTimeMake(10, 300)];
        [self.device setActiveVideoMinFrameDuration:CMTimeMake(10, 300)];
        [self.device unlockForConfiguration];
        
    }
    [[self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [self.previewView layer];
    [rootLayer setMasksToBounds:YES];
    [self.previewLayer setFrame:[rootLayer bounds]];
    [rootLayer insertSublayer:self.previewLayer atIndex:0];

    [self startRunning];
}

-(void)startRunning{
    [self.session startRunning];
}

-(void)stopRunning{
    [self.session stopRunning];
}

-(void)cameraShoot{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.imageDataOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    [self.imageDataOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        NSLog(@"Image %@",image);
        image = [self fixOrientationOfImage:image];
        if (self.finishShoot) {
            self.finishShoot(image);
        }
    }];
}

- (void) turnTorchOn: (NSInteger)mode{
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    AVCaptureDevice *device = (AVCaptureDevice *)[self.session.inputs.firstObject device];
    AVCaptureFlashMode flashMode = [device flashMode];
    AVCaptureTorchMode torchMode = [device torchMode];
    [device lockForConfiguration:nil];
    if (captureDeviceClass != nil) {
            [device lockForConfiguration:nil];
            switch (mode) {
                case 0:
                    flashMode = AVCaptureFlashModeAuto;
                    torchMode = AVCaptureTorchModeOff;
                    break;
                case 1:
                    flashMode = AVCaptureFlashModeOff;
                    torchMode = AVCaptureTorchModeOff;
                    break;
                case 2:
                    flashMode = AVCaptureFlashModeOn;
                    torchMode = AVCaptureTorchModeOff;
                    break;
                case 3:
                    flashMode = AVCaptureFlashModeOn;
                    torchMode = AVCaptureTorchModeOn;
                    break;
                default:
                    break;
            }
        if ([device isFlashModeSupported:flashMode]) {
            device.flashMode = flashMode;
        }
        if ([device isTorchModeSupported:torchMode]) {
            device.torchMode = torchMode;
        }
            [device unlockForConfiguration];
        }
}

-(void)blinkTorch:(BOOL)state{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    AVCaptureDevice *device = (AVCaptureDevice *)[self.session.inputs.firstObject device];
    AVCaptureFlashMode flashMode = [device flashMode];
    AVCaptureTorchMode torchMode = [device torchMode];
    [device lockForConfiguration:nil];
    if (captureDeviceClass != nil) {
        [device lockForConfiguration:nil];
        if (state) {
            flashMode = AVCaptureFlashModeOn;
            torchMode = AVCaptureTorchModeOn;
        }else{
            flashMode = AVCaptureFlashModeOff;
            torchMode = AVCaptureTorchModeOff;
        }
        if ([device isFlashModeSupported:flashMode]) {
            device.flashMode = flashMode;
        }
        if ([device isTorchModeSupported:torchMode]) {
            device.torchMode = torchMode;
        }
        [device unlockForConfiguration];
    }

}

-(void)swapCameraPosition:(UIImagePickerControllerCameraDevice)cameraPosition{
    AVCaptureDevice *device = (AVCaptureDevice *)[self.session.inputs.firstObject device];
    [device lockForConfiguration:nil];
    if([UIImagePickerController isCameraDeviceAvailable:self.cameraPosition]) {
        for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
            if (self.cameraPosition == UIImagePickerControllerCameraDeviceFront) {
                if ([d position] == AVCaptureDevicePositionFront)
                    device = d;
            }else{
                if ([d position] == AVCaptureDevicePositionBack)
                    device = d;
            }
            
        }
    }

    [device setActiveVideoMaxFrameDuration:CMTimeMake(10, 300)];
    [device setActiveVideoMinFrameDuration:CMTimeMake(10, 300)];
    [device unlockForConfiguration];
    
    [device unlockForConfiguration];
    for(AVCaptureInput *inputDevice in self.session.inputs){
        [self.session removeInput:inputDevice];
    }
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if ([self.session canAddInput:deviceInput]) {
        [self.session addInput:deviceInput];
    }
    self.device = device;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    // got an image
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *outputImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
    if (attachments)
        CFRelease(attachments);
    
    
    int exifOrientation = 6; //   6  =  0th row is on the right, and 0th column is the top.
    
    NSDictionary *imageOptions = @{CIDetectorImageOrientation : @(exifOrientation)};
    NSArray *features = [self.faceDetector featuresInImage:outputImage options:imageOptions];
    
    // get the clean aperture
    // the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
    // that represents image data valid for display.
    CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
    CGRect clap = CMVideoFormatDescriptionGetCleanAperture(fdesc, false /*originIsTopLeft == false*/);
    
    // called asynchronously as the capture output is capturing sample buffers, this method asks the face detector
    // to detect features
    
   
    
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    CGAffineTransform t;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            t = CGAffineTransformMakeRotation(-M_PI / 2.0);
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            t = CGAffineTransformMakeRotation(M_PI / 2.0);
            break;
        case UIDeviceOrientationLandscapeRight:
            t = CGAffineTransformMakeRotation(M_PI);
            break;
        default:
            t = CGAffineTransformMakeRotation(0);
            break;
    }
    outputImage = [outputImage imageByApplyingTransform:t];
    CGImageRef imageRef = [self.context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *newPtImage;

    CFDataRef m_DataRef;
    m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
    
//    NSString* tmpSrcpath =  [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
//    const char *tmpSrcPtah =  [tmpSrcpath cStringUsingEncoding:NSUTF8StringEncoding];

    PTU8* retData = new PTU8[(int)newPtImage.size.width * (int)newPtImage.size.height  *3];
    AutoWhitening(m_PixelBuf, PTSize(newPtImage.size.width, newPtImage.size.height), PT_IMG_RGBA8888, retData, PTSize(newPtImage.size.width, newPtImage.size.height), PT_IMG_BGR888, TRUE);
    delete [] retData;
    
    CFRelease(m_DataRef);
    
    
    if (self.activeFilterID>0) {
        @autoreleasepool {
            newPtImage = [UIImage imageWithCGImage:imageRef];
            NSDictionary *filterResult = [self getFilterResultFromInputImage:newPtImage filterIndex:self.activeFilterID];
            newPtImage = [filterResult safeObjectForKey:PTFILTERIMAGE];
        }
        
    }else{
        
    }
    
   
//    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^(void) {

        CGImageRelease(imageRef);
        CGSize parentFrameSize = [self.previewView frame].size;
        NSString *gravity = [self.previewLayer videoGravity];
        CGRect previewBox = [DetectFace videoPreviewBoxForGravity:gravity frameSize:parentFrameSize apertureSize:clap.size];
        if([self.delegate respondsToSelector:@selector(detectedFaceController:features:forVideoBox:withPreviewBox:processedImage:)])
            [self.delegate detectedFaceController:self features:features forVideoBox:clap withPreviewBox:previewBox processedImage:newPtImage];
       // NSLog(@"VideoBox:%@ PreviewBox:%@",NSStringFromCGRect(clap),NSStringFromCGRect(previewBox));
    });
}

-(NSDictionary *)getFilterResultFromInputImage:(UIImage *)inputImage filterIndex:(NSInteger)index{
    NSDictionary *dic = nil;
    switch (index) {
        case 0:
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:inputImage,PTFILTERIMAGE,@"原始",PTFILTERNAME, nil];
            break;
        case 1:
            dic = [PTFilterManager PTFilter:inputImage BLCXwithInfo:0.1];
            break;
        case 2:
            dic = [PTFilterManager PTFilter:inputImage SXGNwithInfo:2.0];
            break;
        case 3:
            dic = [PTFilterManager PTFilter:inputImage JSLSwithInfo:1.2 saturation:0.6 temperature:4500.0];
            break;
        case 4:
            dic = [PTFilterManager PTFilter:inputImage SLDCwithInfo:1.2];
            break;
        case 5:
            dic = [PTFilterManager PTFilter:inputImage ZJLNwithInfo:1.2];
            break;
        case 6:
            dic = [PTFilterManager PTFilterWithMSHK:inputImage];
            break;
        case 7:
            dic = [PTFilterManager PTFilterWithBLWX:inputImage];
            break;
        case 8:
            dic = [PTFilterManager PTFilter:inputImage WNRYwithInfo:1.2];
            break;
        case 9:
            dic = [PTFilterManager PTFilter:inputImage YMYGwithInfo:1.2 temperature:7200.0];
            break;
        default:
            break;
    }
    return dic;
}

-(NSString *)getFilterNameFromIndex:(NSInteger)index{
    switch (index) {
        case 0:
            return @"原始";
            break;
        case 1:
            return @"白亮晨曦";
            break;
        case 2:
            return @"盛夏光年";
            break;
        case 3:
            return @"静水流深";
            break;
        case 4:
            return @"闪亮登场";
            break;
        case 5:
            return @"指尖流年";
            break;
        case 6:
            return @"陌上花开";
            break;
        case 7:
            return @"白露未晞";
            break;
        case 8:
            return @"温暖如玉";
            break;
        case 9:
            return @"一米阳光";
            break;
        default:
            break;
    }

    return @"";
}

- (void)startDetection
{
    [self setupAVCapture];
    [[self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
    NSDictionary *detectorOptions = @{CIDetectorAccuracy : CIDetectorAccuracyLow};
    self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
}

- (void)stopDetection
{
    [self teardownAVCapture];
}

// clean up capture setup
- (void)teardownAVCapture
{
    self.videoDataOutput = nil;
    if (self.videoDataOutputQueue) {
        self.videoDataOutputQueue = nil;
    }
    
}

// find where the video box is positioned within the preview layer based on the video size and gravity
+ (CGRect)videoPreviewBoxForGravity:(NSString *)gravity frameSize:(CGSize)frameSize apertureSize:(CGSize)apertureSize
{
    CGFloat apertureRatio = apertureSize.height / apertureSize.width;
    CGFloat viewRatio = frameSize.width / frameSize.height;
    
    CGSize size = CGSizeZero;
    if ([gravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
        if (viewRatio > apertureRatio) {
            size.width = frameSize.width;
            size.height = apertureSize.width * (frameSize.width / apertureSize.height);
        } else {
            size.width = apertureSize.height * (frameSize.height / apertureSize.width);
            size.height = frameSize.height;
        }
    } else if ([gravity isEqualToString:AVLayerVideoGravityResizeAspect]) {
        if (viewRatio > apertureRatio) {
            size.width = apertureSize.height * (frameSize.height / apertureSize.width);
            size.height = frameSize.height;
        } else {
            size.width = frameSize.width;
            size.height = apertureSize.width * (frameSize.width / apertureSize.height);
        }
    } else if ([gravity isEqualToString:AVLayerVideoGravityResize]) {
        size.width = frameSize.width;
        size.height = frameSize.height;
    }
    
    CGRect videoBox;
    videoBox.size = size;
    if (size.width < frameSize.width)
        videoBox.origin.x = (frameSize.width - size.width) / 2;
    else
        videoBox.origin.x = (size.width - frameSize.width) / 2;
    
    if ( size.height < frameSize.height )
        videoBox.origin.y = (frameSize.height - size.height) / 2;
    else
        videoBox.origin.y = (size.height - frameSize.height) / 2;
    
    return videoBox;
}

+ (CGRect)convertFrame:(CGRect)originalFrame previewBox:(CGRect)previewBox forVideoBox:(CGRect)videoBox isMirrored:(BOOL)isMirrored
{
    // flip preview width and height
    CGFloat temp = originalFrame.size.width;
    originalFrame.size.width = originalFrame.size.height;
    originalFrame.size.height = temp;
    temp = originalFrame.origin.x;
    originalFrame.origin.x = originalFrame.origin.y;
    originalFrame.origin.y = temp;
    // scale coordinates so they fit in the preview box, which may be scaled
    CGFloat widthScaleBy = previewBox.size.width / videoBox.size.height;
    CGFloat heightScaleBy = previewBox.size.height / videoBox.size.width;
    originalFrame.size.width *= widthScaleBy;
    originalFrame.size.height *= heightScaleBy;
    originalFrame.origin.x *= widthScaleBy;
    originalFrame.origin.y *= heightScaleBy;
    
    if(isMirrored)
    {
        originalFrame = CGRectOffset(originalFrame, previewBox.origin.x + previewBox.size.width - originalFrame.size.width - (originalFrame.origin.x * 2), previewBox.origin.y);
    }
    else
    {
        originalFrame = CGRectOffset(originalFrame, previewBox.origin.x, previewBox.origin.y);
    }
    
    return originalFrame;
}

- (UIImage *)fixOrientationOfImage:(UIImage *)image {
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(CIContext *)context{
    if (!_context) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

@end
