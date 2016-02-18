//
//  PTPPStaticImageEditViewController.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 16/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPStaticImageEditViewController.h"
#import "PTPPStaticImageEditToolBar.h"
#import "PTPPCameraFilterScrollView.h"
#import "PTFilterManager.h"
#import "PECropView.h"

#define kFilterScrollHeight 150
#define kCropScrollHeight 120

@interface PTPPStaticImageEditViewController ()<PTPPStaticImageEditToolBarDelegate>
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) PTPPStaticImageEditToolBar *toolBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIView *canvasView;
@property (nonatomic, strong) UIImageView *basePhotoView;
@property (nonatomic, strong) UIImage *basePhoto;
@property (nonatomic, strong) NSMutableArray *filterSet;
@property (nonatomic, strong) NSMutableArray *cropSet;
@property (nonatomic, strong) NSMutableArray *rotateSet;
@property (nonatomic, strong) PTPPCameraFilterScrollView *filterScrollView;
@property (nonatomic, strong) PTPPCameraFilterScrollView *cropScrollView;
@property (nonatomic, strong) PTPPCameraFilterScrollView *rotateSrollView;
@property (nonatomic, assign) NSInteger activeFilterID;
@property (nonatomic, strong) PECropView *cropView;
@property (nonatomic, assign) BOOL isRotating;
@end

static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
@implementation PTPPStaticImageEditViewController

#pragma mark - Life Cycles
-(instancetype)initWithBasePhoto:(UIImage *)basePhoto{
    self = [super init];
    if (self) {
        self.basePhoto = basePhoto;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
    [self.view addSubview:self.canvasView];
    [self.canvasView addSubview:self.basePhotoView];
    
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.toolBar];
    [self.topBar addSubview:self.backButton];
    [self.topBar addSubview:self.saveButton];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.canvasView addGestureRecognizer:singleFingerTap];
    self.basePhoto = [PTFilterManager scaleAndRotateImage:self.basePhoto];
    self.basePhotoView.image = self.basePhoto;
    [self preRenderFilterPreview];
    [self preloadCropSizeSet];
    [self preloadRotateSet];
    [self updateFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)updateFrame{
    
    self.topBar.frame = CGRectMake(0, 0, Screenwidth, HEIGHT_NAV);
    self.backButton.frame = CGRectMake(10, 0, 30, 40);
    self.saveButton.frame = CGRectMake(Screenwidth-100, 0, 100, HEIGHT_NAV);
}

-(void)viewDidAppear:(BOOL)animated{
    
}

#pragma mark - Private Methods
-(void)preRenderFilterPreview{
    UIImage *inputImage = self.basePhoto;
    CGSize newSize = CGSizeMake(inputImage.size.width/10, inputImage.size.height/10);
    UIGraphicsBeginImageContext(newSize);
    [inputImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    inputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    for (NSInteger i=0; i<10; i++) {
        NSDictionary *dic = [self getFilterResultFromInputImage:inputImage filterIndex:i];
        [self.filterSet addObject:dic];
    }
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

-(void)preloadCropSizeSet{
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"icon_capture_20_20"],PTFILTERIMAGE,[UIImage imageNamed:@"icon_capture_20_21"],PTFILTERSUBIMAGE,@"FREE",PTFILTERNAME, nil];
        [self.cropSet addObject:dic];
    }
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"icon_capture_20_22"],PTFILTERIMAGE,[UIImage imageNamed:@"icon_capture_20_23"],PTFILTERSUBIMAGE,@"9:16",PTFILTERNAME, nil];
        [self.cropSet addObject:dic];
    }
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"icon_capture_20_24"],PTFILTERIMAGE,[UIImage imageNamed:@"icon_capture_20_25"],PTFILTERSUBIMAGE,@"3:4",PTFILTERNAME, nil];
        [self.cropSet addObject:dic];
    }
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"icon_capture_20_24"],PTFILTERIMAGE,[UIImage imageNamed:@"icon_capture_20_25"],PTFILTERSUBIMAGE,@"1:1",PTFILTERNAME, nil];
        [self.cropSet addObject:dic];
    }
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"icon_capture_20_26"],PTFILTERIMAGE,[UIImage imageNamed:@"icon_capture_20_27"],PTFILTERSUBIMAGE,@"16:9",PTFILTERNAME, nil];
        [self.cropSet addObject:dic];
    }
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"icon_capture_20_28"],PTFILTERIMAGE,[UIImage imageNamed:@"icon_capture_20_29"],PTFILTERSUBIMAGE,@"4:3",PTFILTERNAME, nil];
        [self.cropSet addObject:dic];
    }
}

-(void)preloadRotateSet{
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"icon_capture_20_30"],PTFILTERIMAGE,[UIImage imageNamed:@"icon_capture_20_30"],PTFILTERSUBIMAGE,@"逆时针",PTFILTERNAME, nil];
        [self.rotateSet addObject:dic];
    }
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"icon_capture_20_31"],PTFILTERIMAGE,[UIImage imageNamed:@"icon_capture_20_31"],PTFILTERSUBIMAGE,@"顺时针",PTFILTERNAME, nil];
        [self.rotateSet addObject:dic];
    }
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"icon_capture_20_32"],PTFILTERIMAGE,[UIImage imageNamed:@"icon_capture_20_32"],PTFILTERSUBIMAGE,@"水平翻转",PTFILTERNAME, nil];
        [self.rotateSet addObject:dic];
    }
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"icon_capture_20_33"],PTFILTERIMAGE,[UIImage imageNamed:@"icon_capture_20_33"],PTFILTERSUBIMAGE,@"垂直翻转",PTFILTERNAME, nil];
        [self.rotateSet addObject:dic];
    }
}

-(void)animateRotateImage:(UIImage *)image byDegrees:(CGFloat)degrees{
    self.isRotating = YES;
    UIImageView *animateImageView = [[UIImageView alloc] initWithImage:self.basePhotoView.image];
    animateImageView.contentMode = UIViewContentModeScaleAspectFit;
    animateImageView.frame = self.basePhotoView.bounds;
    [self.basePhotoView addSubview:animateImageView];
    self.basePhotoView.image = nil;
    self.basePhoto = [self image:self.basePhoto rotatedByDegrees:degrees];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
              
              animateImageView.transform = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
              animateImageView.frame = self.basePhotoView.bounds;
          } completion:^(BOOL finished) {
              [animateImageView removeFromSuperview];
              self.basePhotoView.image = self.basePhoto;
              self.isRotating = NO;
          }];
    
}

-(void)animateFlipImage:(UIImage *)image direction:(NSInteger)direction{
    self.isRotating = YES;
    UIImageView *animateImageView = [[UIImageView alloc] initWithImage:self.basePhotoView.image];
    animateImageView.contentMode = UIViewContentModeScaleAspectFit;
    animateImageView.frame = self.basePhotoView.bounds;
    [self.basePhotoView addSubview:animateImageView];
    self.basePhotoView.image = nil;
    self.basePhoto = [self image:image flip:direction];
    CATransform3D t;
    if (direction == 0) {
        t = CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0);
    }else{
        t = CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0.0);
    }
    t.m34 = 1.0/-500;
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
              animateImageView.layer.transform = t;
          }
                     completion:^(BOOL finish){
                         [animateImageView removeFromSuperview];
                         self.basePhotoView.image = self.basePhoto;
                         self.isRotating = NO;
                     }];
}


- (UIImage *)image:(UIImage *)image rotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    CGFloat ratio = rotatedSize.height/rotatedSize.width;
    NSInteger factorOf16 = rotatedSize.width/2;
    NSInteger newWidth = factorOf16*2;
    NSInteger newHeight = newWidth*ratio;
    rotatedSize = CGSizeMake(newWidth, newHeight);
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

-(UIImage *)image:(UIImage *)image flip:(NSInteger)flipDirection{
    
    CGImageRef inImage = image.CGImage;
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             CGImageGetWidth(inImage),
                                             CGImageGetHeight(inImage),
                                             CGImageGetBitsPerComponent(inImage),
                                             CGImageGetBytesPerRow(inImage),
                                             CGImageGetColorSpace(inImage),
                                             CGImageGetBitmapInfo(inImage)
                                             );
    CGRect cropRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGImageRef TheOtherHalf = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    CGContextDrawImage(ctx, CGRectMake(0, 0, CGImageGetWidth(inImage), CGImageGetHeight(inImage)), inImage);
    
    if (flipDirection == 0) {
        // Horizontal flip
        CGAffineTransform transform = CGAffineTransformMakeTranslation(image.size.width, 0.0);
        transform = CGAffineTransformScale(transform, -1.0, 1.0);
        CGContextConcatCTM(ctx, transform);
    }else{
        // Vertical flip
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0, image.size.height);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGContextConcatCTM(ctx, transform);
    }
    
    
    CGContextDrawImage(ctx, cropRect, TheOtherHalf);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return finalImage;
}

-(void)displayToolBar:(BOOL)state basePhotoViewHeight:(CGFloat)height{
    if (state) {
        //Edit mode OFF
        self.toolBar.frame = CGRectMake(0, Screenheight-self.toolBar.height, self.toolBar.width, self.toolBar.height);
        self.topBar.frame = CGRectMake(self.topBar.left, 0, self.topBar.width, self.topBar.height);
        self.basePhotoView.frame = CGRectMake(0, 0, Screenwidth, Screenheight);
        self.cropView.frame = self.basePhotoView.frame;
    }else{
        //Edit mode ON
        self.toolBar.frame = CGRectMake(0, Screenheight, self.toolBar.width, self.toolBar.height);
        self.topBar.frame = CGRectMake(self.topBar.left, -HEIGHT_NAV, self.topBar.width, self.topBar.height);
        self.basePhotoView.frame = CGRectMake(20, 37, Screenwidth-40, Screenheight-height-37*2);
        self.cropView.frame = CGRectMake(0, 0, Screenwidth, Screenheight-height);
    }
}


#pragma mark - Touch Events
-(void)handleSingleTap{
    //    [self.filterScrollView confirm];
    //    [self.cropScrollView confirm];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAndExport{
    
}

-(void)toggleStaticStickerMenu{
    
}
-(void)toggleFilterMenu{
    __weak typeof(self) weakSelf = self;
    self.filterScrollView.activeFilterID = self.activeFilterID;
    self.filterScrollView.previousActiveFilterID = self.activeFilterID;
    [self.filterScrollView setAttributeWithFilterSet:self.filterSet gridSpace:70 immediateEffectApplied:NO];
    
    self.filterScrollView.filterSelected = ^(NSInteger filterID, BOOL animated){
        
        NSDictionary *filterResult = [weakSelf getFilterResultFromInputImage:weakSelf.basePhoto filterIndex:filterID];
        UIImage *resultImage = [filterResult safeObjectForKey:PTFILTERIMAGE];
        if (animated) {
            UIImageView *tempFilterImage = [[UIImageView alloc] initWithFrame:weakSelf.basePhotoView.frame];
            tempFilterImage.image = resultImage;
            tempFilterImage.contentMode = UIViewContentModeScaleAspectFit;
            [weakSelf.canvasView addSubview:tempFilterImage];
            tempFilterImage.alpha = 0.0;
            [UIView animateWithDuration:0.2 animations:^{
                tempFilterImage.alpha = 1.0;
            } completion:^(BOOL finished) {
                [tempFilterImage removeFromSuperview];
                weakSelf.basePhotoView.image = resultImage;
            }];
        }else{
            weakSelf.basePhotoView.image = resultImage;
        }
    };
    self.filterScrollView.finishBlock = ^(BOOL saveChange){
        weakSelf.activeFilterID = weakSelf.filterScrollView.previousActiveFilterID;
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
              initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut  animations:^(){
                  weakSelf.filterScrollView.center = CGPointMake(weakSelf.filterScrollView.centerX, Screenheight+weakSelf.filterScrollView.height/2);
                  [weakSelf displayToolBar:YES basePhotoViewHeight:weakSelf.filterScrollView.height];
              } completion:^(BOOL finished) {
                  [weakSelf.filterScrollView removeFromSuperview];
                  weakSelf.filterScrollView = nil;
              }];
    };
    
    [self.view addSubview:self.filterScrollView];
    self.filterScrollView.frame = CGRectMake(0, Screenheight, self.filterScrollView.width, self.filterScrollView.height);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut  animations:^(){
              weakSelf.filterScrollView.frame = CGRectMake(0, Screenheight-weakSelf.filterScrollView.height, weakSelf.filterScrollView.width, weakSelf.filterScrollView.height);
              [weakSelf displayToolBar:NO basePhotoViewHeight:self.filterScrollView.height];
          } completion:^(BOOL finished) {}];
    
}

-(void)toggleARStickerMenu{
    
}

-(void)toggleCropMenu{
    __weak typeof(self) weakSelf = self;
    [self.cropScrollView setAttributeWithFilterSet:self.cropSet gridSpace:70 immediateEffectApplied:NO];
    self.cropScrollView.previousActiveFilterID = 0;
    self.cropScrollView.filterSelected = ^(NSInteger filterID, BOOL animated){
        
        //Change crop ratio
        switch (filterID) {
            case 0:
                //NSLog(@"---任意尺寸---");
                weakSelf.cropView.keepingCropAspectRatio = NO;
                break;
            case 1:
                //NSLog(@"---9:16尺寸---");
                weakSelf.cropView.cropAspectRatio = 9.0f / 16.0f;
                weakSelf.cropView.keepingCropAspectRatio = YES;
                
                break;
            case 2:{
                //NSLog(@"---3:4尺寸---");
                weakSelf.cropView.cropAspectRatio = 3.0f / 4.0f;
                weakSelf.cropView.keepingCropAspectRatio = YES;
                
                break;
            }
            case 3:{
                //NSLog(@"---1:1尺寸---");
                weakSelf.cropView.cropAspectRatio = 1.0f;
                weakSelf.cropView.keepingCropAspectRatio = YES;
                break;
            }
            case 4:{
                //NSLog(@"---16:9尺寸---");
                //修改切换到 16:9 比例，裁切框出图片范围 bug
                weakSelf.cropView.cropAspectRatio = 16.0f / 9.0f;
                weakSelf.cropView.keepingCropAspectRatio = YES;
                break;
            }
            case 5:{
                //NSLog(@"---4:3尺寸---");
                //修改切换到 4:3 比例，裁切框出图片范围 bug
                weakSelf.cropView.cropAspectRatio = 4.0f / 3.0f;
                weakSelf.cropView.keepingCropAspectRatio = YES;
                break;
            }
            default:
                break;
        }
    };
    self.cropScrollView.finishBlock = ^(BOOL saveChange){
        if (saveChange) {
            weakSelf.basePhoto = weakSelf.cropView.croppedImage;
            
            NSDictionary *filterResult = [weakSelf getFilterResultFromInputImage:weakSelf.basePhoto filterIndex:weakSelf.activeFilterID];
            UIImage *resultImage = [filterResult safeObjectForKey:PTFILTERIMAGE];
            weakSelf.basePhotoView.image = resultImage;
        }
        
        [weakSelf.cropView removeFromSuperview];
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
              initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut  animations:^(){
                  weakSelf.cropScrollView.center = CGPointMake(weakSelf.filterScrollView.centerX, Screenheight+weakSelf.cropScrollView.height/2);
                  [weakSelf displayToolBar:YES basePhotoViewHeight:weakSelf.cropScrollView.height];
              } completion:^(BOOL finished) {
                  [weakSelf.cropScrollView removeFromSuperview];
                  weakSelf.cropScrollView = nil;
              }];
    };
    
    [self.view addSubview:self.cropScrollView];
    [self.canvasView addSubview:self.cropView];
    self.cropView.alpha = 0;
    self.cropView.image = self.basePhoto;
    self.cropView.keepingCropAspectRatio = NO;
    self.cropScrollView.frame = CGRectMake(0, Screenheight, self.cropScrollView.width, self.cropScrollView.height);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut  animations:^(){
              weakSelf.cropScrollView.frame = CGRectMake(0, Screenheight-weakSelf.cropScrollView.height, weakSelf.cropScrollView.width, weakSelf.cropScrollView.height);
              [weakSelf displayToolBar:NO basePhotoViewHeight:self.cropScrollView.height];
          } completion:^(BOOL finished) {
              [UIView animateWithDuration:0.35 animations:^{
                  self.cropView.alpha = 1.0;
              }];
          }];
}

-(void)toggleRotationMenu{
    __weak typeof(self) weakSelf = self;
    [self.rotateSrollView setAttributeWithFilterSet:self.rotateSet gridSpace:Screenwidth/4 immediateEffectApplied:YES];
    self.rotateSrollView.filterSelected = ^(NSInteger filterID, BOOL animated){
        //rotate or flip
        if (weakSelf.isRotating) {
            return;
        }
        switch (filterID) {
            case 0:
                [weakSelf animateRotateImage:weakSelf.basePhoto byDegrees:-90];
                break;
            case 1:
                [weakSelf animateRotateImage:weakSelf.basePhoto byDegrees:90];
                break;
            case 2:
                [weakSelf animateFlipImage:weakSelf.basePhoto direction:0];
                break;
            case 3:
                [weakSelf animateFlipImage:weakSelf.basePhoto direction:1];
                break;
            default:
                break;
        }
        
    };
    self.rotateSrollView.finishBlock = ^(BOOL saveChange){
        
        NSDictionary *filterResult = [weakSelf getFilterResultFromInputImage:weakSelf.basePhoto filterIndex:weakSelf.activeFilterID];
        UIImage *resultImage = [filterResult safeObjectForKey:PTFILTERIMAGE];
        weakSelf.basePhotoView.image = resultImage;
        
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
              initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut  animations:^(){
                  weakSelf.rotateSrollView.center = CGPointMake(weakSelf.rotateSrollView.centerX, Screenheight+weakSelf.cropScrollView.height/2);
                  [weakSelf displayToolBar:YES basePhotoViewHeight:weakSelf.rotateSrollView.height];
              } completion:^(BOOL finished) {
                  [weakSelf.rotateSrollView removeFromSuperview];
                  weakSelf.rotateSrollView = nil;
              }];
    };
    self.basePhotoView.image = self.basePhoto;
    [self.view addSubview:self.rotateSrollView];
    self.rotateSrollView.frame = CGRectMake(0, Screenheight, self.rotateSrollView.width, self.cropScrollView.height);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut  animations:^(){
              weakSelf.rotateSrollView.frame = CGRectMake(0, Screenheight-weakSelf.rotateSrollView.height, weakSelf.rotateSrollView.width, weakSelf.rotateSrollView.height);
              [weakSelf displayToolBar:NO basePhotoViewHeight:self.rotateSrollView.height];
          } completion:^(BOOL finished) {
          }];
}


#pragma mark - PTPPStaticImageEditToolBarDelegate
-(void)toolBar:(PTPPStaticImageEditToolBar *)toolBar didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"Tool Bar select: %ld",index);
    switch (index) {
        case 0:
            [self toggleStaticStickerMenu];
            break;
        case 1:
            [self toggleFilterMenu];
            break;
        case 2:
            [self toggleARStickerMenu];
            break;
        case 3:
            [self toggleCropMenu];
            break;
        case 4:
            [self toggleRotationMenu];
            break;
        default:
            break;
    }
}

#pragma mark - Getters/Setters
-(UIView *)canvasView{
    if (!_canvasView) {
        _canvasView = [[UIView alloc] initWithFrame:self.view.frame];
    }
    return _canvasView;
}

-(UIImageView *)basePhotoView{
    if (!_basePhotoView) {
        _basePhotoView = [[UIImageView alloc] initWithFrame:self.canvasView.frame];
        _basePhotoView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _basePhotoView;
}

-(UIView *)topBar{
    if (!_topBar) {
        _topBar = [[UIView alloc] init];
        _topBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _topBar;
}

-(PTPPStaticImageEditToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[PTPPStaticImageEditToolBar alloc] initWithFrame:CGRectMake(0, Screenheight-HEIGHT_NAV, Screenwidth, HEIGHT_NAV)];
        NSMutableArray *settingArray = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<5; i++) {
            NSString *name = @"";
            NSString *icon = @"";
            switch (i) {
                case 0:
                    name = @"贴纸";
                    icon = @"icon_capture_20_18";
                    break;
                case 1:
                    name = @"滤镜";
                    icon = @"icon_capture_20_16";
                    break;
                case 2:
                    name = @"";
                    icon = @"icon_capture_20_15";
                    break;
                case 3:
                    name = @"裁剪";
                    icon = @"icon_capture_20_19";
                    break;
                case 4:
                    name = @"旋转";
                    icon = @"icon_capture_20_31";
                    break;
                default:
                    break;
            }
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:icon,kEditImageControlIconKey,name,kEditImageControlNameKey, nil];
            [settingArray safeAddObject:dict];
        }
        [_toolBar setAttributeWithControlSettings:settingArray];
        _toolBar.delegate = self;
    }
    return _toolBar;
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"back_white.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        [_saveButton setTitle:@"保存/分享" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveAndExport) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

-(PTPPCameraFilterScrollView *)filterScrollView{
    if (!_filterScrollView) {
        _filterScrollView = [[PTPPCameraFilterScrollView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, kFilterScrollHeight)];
        
    }
    return _filterScrollView;
}

-(PTPPCameraFilterScrollView *)cropScrollView{
    if (!_cropScrollView) {
        _cropScrollView = [[PTPPCameraFilterScrollView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, kCropScrollHeight)];
        _cropScrollView.iconHightlightMode = YES;
        _cropScrollView.activeFilterID = 0;
    }
    return _cropScrollView;
}

-(PTPPCameraFilterScrollView *)rotateSrollView{
    if (!_rotateSrollView) {
        _rotateSrollView = [[PTPPCameraFilterScrollView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, kCropScrollHeight)];
        _rotateSrollView.iconHightlightMode = YES;
        _rotateSrollView.activeFilterID = 0;
    }
    return _rotateSrollView;
}

-(NSMutableArray *)filterSet{
    if (!_filterSet) {
        _filterSet = [[NSMutableArray alloc] init];
    }
    return _filterSet;
}

-(NSMutableArray *)cropSet{
    if (!_cropSet) {
        _cropSet = [[NSMutableArray alloc] init];
    }
    return _cropSet;
}

-(NSMutableArray *)rotateSet{
    if (!_rotateSet) {
        _rotateSet = [[NSMutableArray alloc] init];
    }
    return _rotateSet;
}

-(PECropView *)cropView{
    if (!_cropView) {
        _cropView = [[PECropView alloc] initWithFrame:self.basePhotoView.bounds];
    }
    return _cropView;
}

@end
