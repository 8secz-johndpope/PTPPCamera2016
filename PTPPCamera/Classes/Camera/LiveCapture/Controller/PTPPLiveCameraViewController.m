//
//  PTPPLiveCameraViewController.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 7/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//
#import "PTVCTransitionLeftRightManager.h"
#import "PTPPLiveStickerView.h"
#import "PTPPLiveVideoShareViewController.h"
#import "PTPPMaterialShopViewController.h"
#import "PTPPNewHomeViewController.h"
#import "ELCImagePickerHeader.h"
#import "PTPPStaticImageEditViewController.h"
#import "PTPPLiveStickerPreviewViewController.h"
#import "PTPPLiveCameraViewController.h"
#import "PTPPCameraFilterScrollView.h"
#import "PTPPLiveStickerScrollView.h"
#import "PTPPCameraSettingPopupView.h"
#import "PTPPLiveCameraTipsView.h"
#import "DetectFace.h"
#import "PTMacro.h"
#import "AssetHelper.h"
#import "PTUtilTool.h"
#import "UIView+Additions.h"
#import "NoiseFilter.h"
#import "PTPPStickerXMLParser.h"
#import "PTPPStickerAnimation.h"
#import "PTPPLocalFileManager.h"
#import "PTPPImageUtil.h"
#import "PTFilterManager.h"

#define kFilterScrollHeight 130
#define kFilterDataLength 10
#define kStickerScale 2

@interface PTPPLiveCameraViewController ()<DetectFaceDelegate,UIViewControllerTransitioningDelegate, NSXMLParserDelegate, PTPPNewHomeProtocol, ELCImagePickerControllerDelegate>
@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;
@property (nonatomic, strong) NSMutableArray *assetGroups;
@property (nonatomic, copy) NSArray *chosenImages;
@property (strong, nonatomic) DetectFace *detectFaceController;
@property (nonatomic, strong) UIView *previewView;

@property (nonatomic, strong) UIImageView *filterView;
@property (nonatomic, assign) CGRect previousFaceRect;
@property (nonatomic, assign) BOOL cameraCanUse;        //判断相机是否允许使用
@property (nonatomic, assign) BOOL assetsLibraryCanUse ;//判断相册是否允许使用
@property (nonatomic, strong) UIView *topControlView;
@property (nonatomic, strong) UIView *bottomControlView;
//Top controls
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *flashOptionButton;
@property (nonatomic, strong) UIButton *cropOptionButton;
@property (nonatomic, strong) UIButton *timerOptionButton;
@property (nonatomic, strong) UIButton *tapShootButton;
@property (nonatomic, strong) UIButton *cameraPositionButton;
@property (nonatomic, strong) PTPPCameraSettingPopupView *settingPopupView;
@property (nonatomic, assign) NSInteger shootDelay;
@property (nonatomic, assign) NSInteger delayCounter;
@property (nonatomic, strong) NSTimer *cameraTimer;
@property (nonatomic, strong) NSTimer *flashTimer;
@property (nonatomic, assign) BOOL flashBlink;
@property (nonatomic, strong) UILabel *timerLabel;
//Bottom controls
@property (nonatomic, strong) UIButton *cameraRollButton;
@property (nonatomic, strong) UIButton *liveStickerButton;
@property (nonatomic, strong) UIButton *shootButton;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIButton *jigsawButton;
@property (nonatomic, strong) UIView *cropMaskTop;
@property (nonatomic, strong) UIView *cropMaskBottom;
@property (nonatomic, strong) PTPPCameraFilterScrollView *filterScrollView;
@property (nonatomic, strong) PTPPLiveStickerScrollView *liveStickerScrollView;
@property (nonatomic, strong) NSMutableArray *filterSet;
@property (nonatomic, strong) NSMutableDictionary *cameraSettings;

@property (nonatomic, strong) PTPPLiveCameraTipsView *tipsView;
@property (nonatomic, strong) PTVCTransitionLeftRightManager *transitionManager;

@property (nonatomic, strong) PTPPLiveStickerView *liveStickerView;
@property (nonatomic, assign) NSInteger invalidDetectionTimeOut;
@property (nonatomic, strong) NSString *selectedARSticker;

@end

static NSString *PTPPCameraSettingFlash = @"PTPPCameraSettingFlash";
static NSString *PTPPCameraSettingCrop = @"PTPPCameraSettingCrop";
static NSString *PTPPCameraSettingTimer = @"PTPPCameraSettingTimer";
static NSString *PTPPCameraSettingTapShoot = @"PTPPCameraSettingTapShoot";
static NSString *PTPPCameraSettingCameraPosition = @"PTPPCameraSettingCameraPosition";

@implementation PTPPLiveCameraViewController

#pragma mark - Life Cycles

- (void)viewDidLoad {
    [super viewDidLoad];
    [self disableAdjustsScrollView];
    self.transitionManager = [[PTVCTransitionLeftRightManager alloc]init];
    [self.view addSubview:self.previewView];
    [self.view addSubview:self.filterView];
    [self.view addSubview:self.liveStickerView];
    [self.view addSubview:self.cropMaskTop];
    [self.view addSubview:self.cropMaskBottom];
    [self.view addSubview:self.topControlView];
    [self.view addSubview:self.bottomControlView];

    //Start Live camera face detection
    [self setupCameraControlPanel];
    self.cameraCanUse = [PTPPImageUtil checkCameraCanUse];
    self.assetsLibraryCanUse = [PTUtilTool checkALAssetsLibraryCanUse];

    self.liveStickerView.hidden = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.previewView addGestureRecognizer:singleFingerTap];
    BOOL hintShowed = [[NSUserDefaults standardUserDefaults] boolForKey:@"hintShowed"];
    if (!hintShowed) {
        [self showTipsView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hintShowed"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //[self loadLiveStickerWithFileName:@"demo"];
    //[self loadLiveStickerFromXMLFile:@"axfl"];
    __weak typeof(self) weakSelf = self;
    
    self.detectFaceController.finishShoot = ^(UIImage *image){
        if (weakSelf.detectFaceController.cameraPosition == UIImagePickerControllerCameraDeviceFront) {
            image = [[UIImage alloc] initWithCGImage: image.CGImage
                                               scale: 1.0
                                         orientation: UIImageOrientationUpMirrored];
        }
        if (!weakSelf.filterView.hidden){
            image = weakSelf.filterView.image;
        }
        if (weakSelf.liveStickerView.alpha == 0 || (weakSelf.liveStickerView.eyeSticker.isHidden && weakSelf.liveStickerView.mouthSticker.isHidden)) {
          
            CGFloat widthRatio = image.size.width/(Screenwidth*[UIScreen mainScreen].scale);
            CGFloat heightRatio = image.size.height/(Screenheight*[UIScreen mainScreen].scale);
            //No AR stickers on screen, go to static photo edit process.
            image = [PTPPImageUtil croppIngimageByImageName:image toRect:CGRectMake(0, self.cropMaskTop.bottom*heightRatio, Screenwidth*widthRatio, self.cropMaskBottom.top*heightRatio-self.cropMaskTop.bottom*heightRatio)];
            PTPPStaticImageEditViewController *imageEditVC = [[PTPPStaticImageEditViewController alloc] initWithBasePhoto:image];
            if (weakSelf.navigationController) {
                [weakSelf.navigationController pushViewController:imageEditVC animated:YES];
            }
        }else{
            //AR stickers on screen, go to preview video
         
            PTPPLiveStickerPreviewViewController *liveStickerVC = [[PTPPLiveStickerPreviewViewController alloc] initWithBasePhoto:image mouthSticker:weakSelf.liveStickerView.mouthSticker eyeSticker:weakSelf.liveStickerView.eyeSticker bottomSticker:weakSelf.liveStickerView.bottomSticker faceAngle:weakSelf.liveStickerView.faceAngle];
            [liveStickerVC setCropOption:[[weakSelf.cameraSettings objectForKey:PTPPCameraSettingCrop] integerValue]];
            [weakSelf.navigationController pushViewController:liveStickerVC animated:YES];
        }
        
    };
    [self.detectFaceController startDetection];
    [self preRenderFilterPreview];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    if (!self.detectFaceController.session.isRunning) {
        [self.detectFaceController startRunning];
    }
    
    [self updateTopControlOptions];
    if (self.assetsLibraryCanUse) {
        [self updateAlbumWithLatestPhoto];
        [self assetGroups];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [self.detectFaceController stopDetection];
    //    self.detectFaceController = nil;
    [self.detectFaceController stopRunning];
    //self.filterView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Touch Event

-(void)resumeFaceDetector{
    if (!self.detectFaceController.session.isRunning) {
        [self.detectFaceController startRunning];
    }
}

-(void)showTipsView{
    [self.view addSubview:self.tipsView];
    CGPoint stickerOrigin = [self.view convertPoint:self.liveStickerButton.origin fromView:self.bottomControlView];
    [self.tipsView setAttributeWithBackButtonFrame:self.backButton.frame liveStickerButtonFrame:CGRectMake(stickerOrigin.x, stickerOrigin.y, self.liveStickerButton.width, self.liveStickerButton.height)];
}

-(void)handleSingleTap{
    NSLog(@"Tap Shoot");
    BOOL tapShoot = [[self.cameraSettings objectForKey:PTPPCameraSettingTapShoot] boolValue];
    if (self.settingPopupView) {
        [self dismissSettingPopup];
        if (tapShoot) {
            return;
        }
    }
    if (self.liveStickerScrollView.finishBlock) {
        self.liveStickerScrollView.finishBlock();
        if (tapShoot) {
            return;
        }
    }
        if (tapShoot) {
        [self cameraShoot];
    }
}

-(void)toggleCameraSetting:(UIButton *)sender{
    if (self.settingPopupView && self.settingPopupView.tag == sender.tag) {
        [self dismissSettingPopup];
        return;
    }
    if (self.settingPopupView.tag == 0 || !self.settingPopupView) {
        self.settingPopupView = [[PTPPCameraSettingPopupView alloc] initWithFrame:CGRectMake(0, sender.bottom+15, sender.width-20, 0)];
        self.settingPopupView.layer.cornerRadius = 4;
        self.settingPopupView.layer.masksToBounds = YES;
        self.settingPopupView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
        self.settingPopupView.layer.borderWidth = 1;
    }
    self.settingPopupView.tag = sender.tag;
    self.settingPopupView.center = CGPointMake(sender.centerX, self.settingPopupView.centerY);
    __weak typeof(self) weakSelf = self;
    self.settingPopupView.finishBlock = ^(PTPPCameraSettingPopupView * popupView, NSInteger selectedID){
        switch (popupView.tag) {
            case PTCameraSettingFlash:
                [weakSelf.cameraSettings setObject:[NSNumber numberWithInteger:selectedID] forKey:PTPPCameraSettingFlash];
                if (selectedID == 0) {
                    [SOAutoHideMessageView showMessage:@"自动闪光" inView:weakSelf.view];
                }else if (selectedID == 1){
                    [SOAutoHideMessageView showMessage:@"闪光灯关闭" inView:weakSelf.view];
                }else if (selectedID == 2){
                    [SOAutoHideMessageView showMessage:@"闪光灯开启" inView:weakSelf.view];
                }else if (selectedID == 3){
                    [SOAutoHideMessageView showMessage:@"闪光灯常亮" inView:weakSelf.view];
                }
                break;
            case PTCameraSettingCrop:
                [weakSelf.cameraSettings setObject:[NSNumber numberWithInteger:selectedID] forKey:PTPPCameraSettingCrop];
                break;
            case PTCameraSettingTimer:
                [weakSelf.cameraSettings setObject:[NSNumber numberWithInteger:selectedID] forKey:PTPPCameraSettingTimer];
                 if (selectedID == 0){
                    [SOAutoHideMessageView showMessage:@"计时器关闭" inView:weakSelf.view];
                 }else if (selectedID == 1){
                     [SOAutoHideMessageView showMessage:@"3秒计时器" inView:weakSelf.view];
                 }else if (selectedID == 2){
                     [SOAutoHideMessageView showMessage:@"5秒计时器" inView:weakSelf.view];
                 }else if (selectedID == 3){
                     [SOAutoHideMessageView showMessage:@"10秒计时器" inView:weakSelf.view];
                 }
                break;
            default:
                break;
        }
        [weakSelf updateTopControlOptions];
        weakSelf.settingPopupView.tag = 0;
        [weakSelf dismissSettingPopup];
    };
    NSArray *buttonImages = nil;
    switch (self.settingPopupView.tag) {
        case PTCameraSettingFlash:
            buttonImages = @[[UIImage imageNamed:@"icon_capture_20_01"],[UIImage imageNamed:@"icon_capture_20_02"],[UIImage imageNamed:@"icon_capture_20_03"],[UIImage imageNamed:@"icon_capture_20_04"]];
            break;
        case PTCameraSettingCrop:
            buttonImages = @[[UIImage imageNamed:@"icon_capture_20_05"],[UIImage imageNamed:@"icon_capture_20_06"],[UIImage imageNamed:@"icon_capture_20_07"]];
            break;
        case PTCameraSettingTimer:
            buttonImages = @[[UIImage imageNamed:@"icon_capture_20_08"],[UIImage imageNamed:@"icon_capture_20_09"],[UIImage imageNamed:@"icon_capture_20_10"],[UIImage imageNamed:@"icon_capture_20_11"]];
            break;
        default:
            break;
    }
    [self.settingPopupView setAttributeWithButtonImages:buttonImages];
    [self.view addSubview:self.settingPopupView];
    self.settingPopupView.alpha = 0.0;
    self.settingPopupView.center = CGPointMake(self.settingPopupView.centerX, self.settingPopupView.centerY-10);
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.settingPopupView.alpha = 1.0;
        weakSelf.settingPopupView.center = CGPointMake(self.settingPopupView.centerX, self.settingPopupView.centerY+10);
    }];
}

-(void)dismissSettingPopup{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.settingPopupView.center = CGPointMake(weakSelf.settingPopupView.centerX, weakSelf.settingPopupView.centerY-10);
        weakSelf.settingPopupView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.settingPopupView removeFromSuperview];
        weakSelf.settingPopupView = nil;
    }];
}

-(void)toggleTapShoot{
    BOOL tapShoot = [[self.cameraSettings objectForKey:PTPPCameraSettingTapShoot] boolValue];
    tapShoot = !tapShoot;
    if (tapShoot) {
        [SOAutoHideMessageView showMessage:@"点屏拍摄开启" inView:self.view];
    }else{
        [SOAutoHideMessageView showMessage:@"点屏拍摄关闭" inView:self.view];
    }
    [self.cameraSettings setObject:[NSNumber numberWithBool:tapShoot] forKey:PTPPCameraSettingTapShoot];
    [self updateTopControlOptions];
}

-(void)toggleChangeCameraPosition{
    NSInteger cameraPosition = [[self.cameraSettings objectForKey:PTPPCameraSettingCameraPosition] integerValue];
    
    if (cameraPosition == 0) {
        //后置摄像头
        self.detectFaceController.cameraPosition =  UIImagePickerControllerCameraDeviceRear;
        [self.cameraSettings setObject:[NSNumber numberWithInteger:1] forKey:PTPPCameraSettingCameraPosition];
        [self.detectFaceController swapCameraPosition:UIImagePickerControllerCameraDeviceRear];
    }else{
        //前置摄像头
        self.detectFaceController.cameraPosition =  UIImagePickerControllerCameraDeviceFront;
        [self.cameraSettings setObject:[NSNumber numberWithInteger:0] forKey:PTPPCameraSettingCameraPosition];
        [self.detectFaceController swapCameraPosition:UIImagePickerControllerCameraDeviceFront];
    }
    
    [self updateTopControlOptions];
}

-(void)cameraShoot{
    if (self.shootDelay==0 && !self.cameraTimer) {
        [self.detectFaceController cameraShoot];
        return;
    }
    
    self.delayCounter = self.shootDelay;
    if (!self.flashTimer) {
        self.flashTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(LEDFlashBlink) userInfo:nil repeats:YES];
        self.flashBlink = YES;
        [self.flashTimer fire];
    }
    if (!self.cameraTimer) {
        [_shootButton setImage:[UIImage imageNamed:@"btn_capture_dis"] forState:UIControlStateNormal];
        [self.view addSubview:self.timerLabel];
        self.timerLabel.frame = CGRectMake(0, self.cropMaskTop.bottom, Screenwidth, Screenheight-self.cropMaskBottom.height-self.cropMaskTop.height);
        self.timerLabel.text = [NSString stringWithFormat:@"%ld",(long)self.delayCounter];
        self.cameraTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(cameraShootDelayCountdown) userInfo:nil repeats:YES];
        [self.cameraTimer fire];
        
    }else{
        NSLog(@"Timer cancelled");
        [self.cameraTimer invalidate];
        self.cameraTimer = nil;
        [self.flashTimer invalidate];
        self.flashTimer = nil;
        [self.timerLabel removeFromSuperview];
        [_shootButton setImage:[UIImage imageNamed:@"btn_capture_nor"] forState:UIControlStateNormal];
        [self updateTopControlOptions];
    }
}

-(void)cameraShootDelayCountdown{
    if (self.delayCounter == 0) {
        [self.cameraTimer invalidate];
        self.cameraTimer = nil;
        [self.flashTimer invalidate];
        self.flashTimer = nil;
        [_shootButton setImage:[UIImage imageNamed:@"btn_capture_nor"] forState:UIControlStateNormal];
        [self updateTopControlOptions];
        [self.detectFaceController cameraShoot];
        [self.timerLabel removeFromSuperview];
    }else if (self.delayCounter == 1){
        [self.detectFaceController blinkTorch:NO];
        [self.flashTimer invalidate];
        self.flashTimer = nil;
    }
    NSLog(@"Time:%ld",(long)self.delayCounter);
    self.timerLabel.text = [NSString stringWithFormat:@"%ld",(long)self.delayCounter];
    self.delayCounter--;
    self.timerLabel.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.timerLabel.alpha = 0.0;
    }];
}

-(void)LEDFlashBlink{
    [self.detectFaceController blinkTorch:self.flashBlink];
    self.flashBlink = !self.flashBlink;
}

-(void)toggleFilterOption{
    __weak typeof(self) weakSelf = self;
    self.filterScrollView.activeFilterID = self.detectFaceController.activeFilterID;
    self.filterScrollView.previousActiveFilterID = self.detectFaceController.activeFilterID;
    [self.filterScrollView setAttributeWithFilterSet:self.filterSet gridSpace:70 immediateEffectApplied:NO];
    self.filterScrollView.filterSelected = ^(NSInteger filterID, BOOL animated){
 
        weakSelf.detectFaceController.activeFilterID = filterID;
        if (filterID != 0) {
            weakSelf.filterView.hidden = NO;
        }else{
            weakSelf.filterView.hidden = YES;
        }
    };
    self.filterScrollView.finishBlock = ^(BOOL saveChange){
            weakSelf.detectFaceController.activeFilterID = weakSelf.filterScrollView.previousActiveFilterID;
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
              initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
                  weakSelf.filterScrollView.center = CGPointMake(weakSelf.filterScrollView.centerX, Screenheight+weakSelf.filterScrollView.height/2);
                  weakSelf.bottomControlView.frame = CGRectMake(0, Screenheight-kBottomControlHeight, weakSelf.bottomControlView.width, weakSelf.bottomControlView.height);
              } completion:^(BOOL finished) {
                  [weakSelf.filterScrollView removeFromSuperview];
                  weakSelf.filterScrollView = nil;
              }];
    };
    
    [self.view addSubview:self.filterScrollView];
    self.filterScrollView.frame = CGRectMake(0, Screenheight, self.filterScrollView.width, self.filterScrollView.height);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
              weakSelf.filterScrollView.frame = CGRectMake(0, Screenheight-kFilterScrollHeight, weakSelf.filterScrollView.width, weakSelf.filterScrollView.height);
              weakSelf.bottomControlView.frame = CGRectMake(0, Screenheight, weakSelf.bottomControlView.width, weakSelf.bottomControlView.height);
          } completion:^(BOOL finished) {}];
    
}

-(void)toggleLiveStickerOption{
    __weak typeof(self) weakSelf = self;
    self.liveStickerScrollView.stickerSelected = ^(NSString *stickerName, BOOL isFromBundle){
        weakSelf.liveStickerView.eyeAnimation = nil;
        weakSelf.liveStickerView.mouthAnimation = nil;
        weakSelf.liveStickerView.bottomAnimation = nil;
        weakSelf.liveStickerView.eyeSticker.animationImages = nil;
        weakSelf.liveStickerView.mouthSticker.animationImages = nil;
        weakSelf.liveStickerView.bottomSticker.animationImages = nil;

        if (stickerName != nil) {
            weakSelf.selectedARSticker = stickerName;
//            if(isFromBundle){
//                [weakSelf loadLiveStickerFromXMLFile:stickerName];
//            }else{
//#warning load from directory
//            }
            
            [SOAutoHideMessageView showMessage:@"请将正脸置于取景器内" inView:weakSelf.view];
        }
    };
    self.liveStickerScrollView.selectedStickerName = self.selectedARSticker;
    self.liveStickerScrollView.finishBlock = ^{
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
              initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
                  weakSelf.liveStickerScrollView.center = CGPointMake(weakSelf.liveStickerScrollView.centerX, Screenheight+weakSelf.liveStickerScrollView.height/2);
                  weakSelf.bottomControlView.frame = CGRectMake(0, Screenheight-kBottomControlHeight, weakSelf.bottomControlView.width, weakSelf.bottomControlView.height);
              } completion:^(BOOL finished) {
                  [weakSelf.liveStickerScrollView removeFromSuperview];
                  weakSelf.liveStickerScrollView = nil;
              }];

    };
    [self.view addSubview:self.liveStickerScrollView];
    self.liveStickerScrollView.frame = CGRectMake(0, Screenheight, self.liveStickerScrollView.width, self.liveStickerScrollView.height);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
              weakSelf.liveStickerScrollView.frame = CGRectMake(0, Screenheight-kFilterScrollHeight, weakSelf.liveStickerScrollView.width, weakSelf.liveStickerScrollView.height);
              weakSelf.bottomControlView.frame = CGRectMake(0, Screenheight, weakSelf.bottomControlView.width, weakSelf.bottomControlView.height);
          } completion:^(BOOL finished) {}];
}

-(void)toggleJigsawTemplate{
//    if (!_assetsLibraryCanUse) {
//        [self albumNotUseTapped];
//        return;
//    }
//    if (self.assetGroups.count>0) {
//        [self displayMultiPickerForGroup:[self.assetGroups objectAtIndex:0]];
//    }
    PTPPMaterialShopViewController *shopVC = [[PTPPMaterialShopViewController alloc] init];
    shopVC.activeSection = 2;
    shopVC.hideMenu = YES;
    shopVC.proceedToImageEdit = YES;
    shopVC.assetsGroup = [self.assetGroups safeObjectAtIndex:0];
    [self.navigationController pushViewController:shopVC animated:YES];
}

#pragma mark Private methods

-(void)preRenderFilterPreview{
    UIImage *inputImage = [UIImage imageNamed:@"FM_cover_photo.jpg"];
    CGSize newSize = CGSizeMake(inputImage.size.width/10, inputImage.size.height/10);
    UIGraphicsBeginImageContext(newSize);
    [inputImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    inputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    for (NSInteger i=0; i<10; i++) {
        NSDictionary *dic = [PTPPImageUtil getFilterResultFromInputImage:inputImage filterIndex:i];
        [self.filterSet addObject:dic];
    }
}




//Read Sticker files from local directory
-(BOOL)loadLiveStickerWithFileName:(NSString *)fileName{
    NSString *downloadFolder = nil;
    NSString *xmlFilePath = nil;
    if (fileName) {
        downloadFolder = [PTPPLocalFileManager getFolderPathForARStickerName:fileName];
        if (!downloadFolder){
            NSLog(@"Sticker not existed");
            return NO;
        }
        //Print list of file in the directory
        [PTPPLocalFileManager printListOfFilesAtDirectory:downloadFolder];
        
#warning xml filename will be changed in the future!!!
        xmlFilePath = [NSString stringWithFormat:@"%@/sample.xml",downloadFolder];
        
    }else{
        NSLog(@"Sticker not existed");
        return NO;
    }
    
    NSDictionary *resultDict = [PTPPStickerXMLParser dictionaryFromXMLFilePath:xmlFilePath];
    if (!resultDict) {
        NSLog(@"Sticker XML not existed");
        return NO;
    }
    [self createStickerAnimationFromDictionarySettings:resultDict downloadFolder:downloadFolder];
    return YES;
}

//Read Sticker files directly from NSBundle
-(BOOL)loadLiveStickerFromXMLFile:(NSString *)xmlFileName{
    NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:xmlFileName ofType:@"xml"];
    NSDictionary *resultDict = [PTPPStickerXMLParser dictionaryFromXMLFilePath:xmlFilePath];
    if (!resultDict) {
        NSLog(@"Sticker not existed");
        return NO;
    }
    [self createStickerAnimationFromDictionarySettings:resultDict downloadFolder:nil];
    return YES;
}

-(void)createStickerAnimationFromDictionarySettings:(NSDictionary *)resultDict downloadFolder:(NSString *)downloadFolder{
    PTPPStickerAnimation *mouthAnimation;
    PTPPStickerAnimation *eyeAnimation;
    PTPPStickerAnimation *bottomAnimation;
    for(NSString *featureKey in [[resultDict safeObjectForKey:@"animation"] allKeys]){
        if ([featureKey isEqualToString:@"mouth"]) {
            mouthAnimation = [PTPPStickerAnimation animationWithDictionarySettings:[[resultDict objectForKey:@"animation"] objectForKey:featureKey] feature:featureKey filePath:downloadFolder];
        }else if ([featureKey isEqualToString:@"eye"]){
            eyeAnimation = [PTPPStickerAnimation animationWithDictionarySettings:[[resultDict objectForKey:@"animation"] objectForKey:featureKey] feature:featureKey filePath:downloadFolder];
        }else if([featureKey isEqualToString:@"bottom"]){
            bottomAnimation = [PTPPStickerAnimation animationWithDictionarySettings:[[resultDict objectForKey:@"animation"] objectForKey:featureKey] feature:featureKey filePath:downloadFolder];
        }
    }
    [self.liveStickerView setAttributeWithMouthAnimation:mouthAnimation eyeAnimation:eyeAnimation bottomAnimation:bottomAnimation];
}

-(void)setupCameraControlPanel{
    [self.topControlView addSubview:self.backButton];
    [self.topControlView addSubview:self.flashOptionButton];
    [self.topControlView addSubview:self.cropOptionButton];
    [self.topControlView addSubview:self.timerOptionButton];
    [self.topControlView addSubview:self.tapShootButton];
    [self.topControlView addSubview:self.cameraPositionButton];
    [self.bottomControlView addSubview:self.cameraRollButton];
    [self.bottomControlView addSubview:self.liveStickerButton];
    [self.bottomControlView addSubview:self.shootButton];
    [self.bottomControlView addSubview:self.filterButton];
    [self.bottomControlView addSubview:self.jigsawButton];
    [self.cameraSettings setObject:[NSNumber numberWithInteger:0] forKey:PTPPCameraSettingFlash];
    [self.cameraSettings setObject:[NSNumber numberWithInteger:0] forKey:PTPPCameraSettingCrop];
    [self.cameraSettings setObject:[NSNumber numberWithInteger:0] forKey:PTPPCameraSettingTimer];
    [self.cameraSettings setObject:[NSNumber numberWithBool:NO] forKey:PTPPCameraSettingTapShoot];
    [self.cameraSettings setObject:[NSNumber numberWithInteger:0] forKey:PTPPCameraSettingCameraPosition];
    [self updateTopControlOptions];
}

-(void)updateTopControlOptions{
    NSInteger cameraPosition = [[self.cameraSettings objectForKey:PTPPCameraSettingCameraPosition] integerValue];
    NSInteger flashOption = [[self.cameraSettings objectForKey:PTPPCameraSettingFlash] integerValue];
    NSInteger cropOption = [[self.cameraSettings objectForKey:PTPPCameraSettingCrop] integerValue];
    NSInteger timerOption = [[self.cameraSettings objectForKey:PTPPCameraSettingTimer] integerValue];
    BOOL tapShoot = [[self.cameraSettings objectForKey:PTPPCameraSettingTapShoot] boolValue];
    
    CGFloat cropMaskTopHeight = 0.0f;
    CGFloat cropMaskBottomHeight = 0.0f;
    
    if (cameraPosition == 1) {
        //后置摄像头
        self.flashOptionButton.enabled = YES;
        self.flashOptionButton.alpha = 1.0;
    }else{
        //前置摄像头
        self.flashOptionButton.enabled = NO;
        self.flashOptionButton.alpha = 0.5;
    }

    switch (flashOption) {
        case 0:
            [self.flashOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_01"] forState:UIControlStateNormal];
            break;
        case 1:
            [self.flashOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_02"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.flashOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_03"] forState:UIControlStateNormal];
            break;
        case 3:
            [self.flashOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_04"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [self.detectFaceController turnTorchOn:flashOption];
    switch (cropOption) {
        case 0:
            [self.cropOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_05"] forState:UIControlStateNormal];
            cropMaskTopHeight = kTopControlHeight;
            cropMaskBottomHeight = kBottomControlHeight;
            break;
        case 1:
            [self.cropOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_06"] forState:UIControlStateNormal];
            cropMaskTopHeight = kTopControlHeight*2;
            cropMaskBottomHeight = Screenheight - cropMaskTopHeight-Screenwidth;
            break;
        case 2:
            [self.cropOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_07"] forState:UIControlStateNormal];
            cropMaskTopHeight = 0.0f;
            cropMaskBottomHeight = 0.0f;
            break;
        default:
            break;
    }
    switch (timerOption) {
        case 0:
            [self.timerOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_08"] forState:UIControlStateNormal];
            self.shootDelay = 0;
            break;
        case 1:
            [self.timerOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_09"] forState:UIControlStateNormal];
            self.shootDelay = 3;
            break;
        case 2:
            [self.timerOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_10"] forState:UIControlStateNormal];
            self.shootDelay = 5;
            break;
        case 3:
            [self.timerOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_11"] forState:UIControlStateNormal];
            self.shootDelay = 10;
            break;
        default:
            break;
    }
    if (tapShoot) {
        [self.tapShootButton setImage:[UIImage imageNamed:@"icon_capture_20_13"] forState:UIControlStateNormal];
    }else{
        [self.tapShootButton setImage:[UIImage imageNamed:@"icon_capture_20_12"] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
              self.cropMaskTop.frame = CGRectMake(0, 0, Screenwidth, cropMaskTopHeight);
              self.cropMaskBottom.frame = CGRectMake(0, Screenheight-cropMaskBottomHeight, Screenwidth, cropMaskBottomHeight);
          } completion:^(BOOL finished) {
              
          }];
    
}

-(void)goBack{
    //[self.navigationController popViewControllerAnimated:YES];
    [self.detectFaceController stopRunning];
    PTPPNewHomeViewController *homeVC = [[PTPPNewHomeViewController alloc] init];
    homeVC.delegate = self;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:homeVC];
    navi.transitioningDelegate = self;
    navi.modalPresentationStyle = UIModalPresentationCustom;
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:navi animated:YES completion:^{
            
        }];
    });
}


-(void) updateAlbumWithLatestPhoto {
    __block UIImage *image=nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ASSETHELPER.bReverse = YES;
        [ASSETHELPER getGroupList:^(NSArray *assetsGroup) {
            CGImageRef posterImage      = ((ALAssetsGroup*)assetsGroup[0]).posterImage;
            size_t height               = CGImageGetHeight(posterImage);
            float scale                 = height / 120;
            
            image  = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
            dispatch_async(dispatch_get_main_queue(), ^{
                /* 在主线程里面显示图片*/
                if (image != nil){
                    [self.cameraRollButton setImage:image forState:UIControlStateNormal];
                } else {
                    //NSLog(@"从相册中取最后一张图片失败. Nothing to display.");
                }
            });
        }];
    });
}

- (void)albumTapped
{
    if (!_assetsLibraryCanUse) {
        [self albumNotUseTapped];
        return;
    }
    if (self.assetGroups.count>0) {
        [self displayPickerForGroup:[self.assetGroups objectAtIndex:0]];
    }
}

- (void)displayPickerForGroup:(ALAssetsGroup *)group
{
    ELCAssetTablePicker *tablePicker = [[ELCAssetTablePicker alloc] initWithStyle:UITableViewStylePlain];
    tablePicker.singleSelection = YES;
    tablePicker.immediateReturn = YES;
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:tablePicker];
    elcPicker.maximumImagesCount = 1;
    elcPicker.imagePickerDelegate = self;
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = NO; //For single image selection, do not display and return order of selected images
    tablePicker.parent = elcPicker;
    
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}


-(void)albumNotUseTapped
{
    NSLog(@"Unable to access photo album");
}


#pragma mark DetectFaceDelegate
- (void)detectedFaceController:(DetectFace *)controller features:(NSArray *)featuresArray forVideoBox:(CGRect)clap withPreviewBox:(CGRect)previewBox processedImage:(UIImage *)processedImage
{
    
    UIImage * landscapeImage = processedImage;
    if (self.detectFaceController.cameraPosition == UIImagePickerControllerCameraDeviceFront) {
        self.filterView.image = [[UIImage alloc] initWithCGImage: landscapeImage.CGImage
                                                           scale: 1.0
                                                     orientation: UIImageOrientationUpMirrored];
    }else{
        self.filterView.image = [[UIImage alloc] initWithCGImage: landscapeImage.CGImage
                                                           scale: 1.0
                                                     orientation: landscapeImage.imageOrientation];
    }
    
    self.liveStickerView.hidden = NO;
    if (featuresArray.count == 0) {
        if (self.invalidDetectionTimeOut >= 15) {
            [UIView animateWithDuration:0.3 animations:^{
                self.liveStickerView.alpha = 0.0;
            } completion:^(BOOL finished) {}];
        }else{
            self.invalidDetectionTimeOut++;
        }
        return;
    }else{
        self.invalidDetectionTimeOut = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.liveStickerView.alpha = 1.0;
    } completion:^(BOOL finished) {}];
    
    [self.liveStickerView updateLiveStickerFrameWithFaceFeatures:featuresArray forVideoBox:clap withPreviewBox:previewBox];
}



#pragma mark - UIVieControllerTransitioningDelegate -
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source{
    self.transitionManager.transitionTo = MODAL;
    return (id)self.transitionManager;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transitionManager.transitionTo = INITIAL;
    return (id)self.transitionManager;
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
                
                UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                [imageview setContentMode:UIViewContentModeScaleAspectFit];

            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
    }
    
    self.chosenImages = images;
    if ([images safeObjectAtIndex:0]) {
        PTPPStaticImageEditViewController *imageEditVC = [[PTPPStaticImageEditViewController alloc] initWithBasePhoto:[images safeObjectAtIndex:0]];
        [self.navigationController pushViewController:imageEditVC animated:YES];
    }else{
        //[SVProgressHUD showErrorWithStatus:@"暂不支持视频编辑" duration:2.0];
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Getters/Setters

-(ALAssetsLibrary *)specialLibrary{
    if (!_specialLibrary) {
        _specialLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _specialLibrary;
}

-(NSMutableArray *)assetGroups{
    if (!_assetGroups) {
        _assetGroups = [[NSMutableArray alloc] init];
        [self.specialLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [_assetGroups addObject:group];
            }
        } failureBlock:^(NSError *error) {
            self.chosenImages = nil;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:[NSString stringWithFormat:@"相册读取错误: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            NSLog(@"A problem occured %@", [error description]);
            // an error here means that the asset groups were inaccessable.
            // Maybe the user or system preferences refused access.
        }];
    }
    return _assetGroups;
}

-(PTPPLiveStickerView *)liveStickerView{
    if (!_liveStickerView) {
        _liveStickerView = [[PTPPLiveStickerView alloc] initWithFrame:self.previewView.bounds];
    }
    return _liveStickerView;
}

-(NSMutableDictionary *)cameraSettings{
    if (!_cameraSettings) {
        _cameraSettings = [[NSMutableDictionary alloc] init];
    }
    return _cameraSettings;
}

-(NSMutableArray *)filterSet{
    if (!_filterSet) {
        _filterSet = [[NSMutableArray alloc] init];
    }
    return _filterSet;
}

-(PTPPLiveCameraTipsView *)tipsView{
    if (!_tipsView) {
        _tipsView = [[PTPPLiveCameraTipsView alloc] initWithFrame:self.view.bounds];
    }
    return _tipsView;
}

-(PTPPCameraFilterScrollView *)filterScrollView{
    if (!_filterScrollView) {
        _filterScrollView = [[PTPPCameraFilterScrollView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, kFilterScrollHeight)];
        _filterScrollView.previousActiveFilterID = 0;
    }
    return _filterScrollView;
}

-(PTPPLiveStickerScrollView *)liveStickerScrollView{
    if (!_liveStickerScrollView) {
        _liveStickerScrollView = [[PTPPLiveStickerScrollView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, kFilterScrollHeight)];
        NSArray *preinstalledSet = @[@"hz",@"cn", @"mhl", @"xm", @"fd", @"kq", @"xhx",@"hy"];
        NSMutableArray *rearrangedSet = [[NSMutableArray alloc] init];
        NSArray *fileList = [PTPPLocalFileManager getListOfFilePathAtDirectory:[PTPPLocalFileManager getRootFolderPathForARStickers]];
        for(NSString *stickerName in preinstalledSet){
            for(NSString *path in fileList){
                if ([[path lastPathComponent] isEqualToString:stickerName]) {
                    [rearrangedSet addObject:path];
                }
            }
        }
        [_liveStickerScrollView setAttributeWithLocalCacheWithPreinstalledSet:rearrangedSet];
    }
    return _liveStickerScrollView;
}

-(DetectFace *)detectFaceController{
    if (!_detectFaceController) {
        _detectFaceController = [[DetectFace alloc] init];
        _detectFaceController.delegate = self;
        _detectFaceController.filters = self.filterSet;
        _detectFaceController.previewView = self.previewView;
        NSInteger cameraPosition = [[self.cameraSettings objectForKey:PTPPCameraSettingCameraPosition] integerValue];
        if (cameraPosition == 0) {
            _detectFaceController.cameraPosition = UIImagePickerControllerCameraDeviceFront;
        }else{
            _detectFaceController.cameraPosition = UIImagePickerControllerCameraDeviceRear;
        }
        
    }
    return _detectFaceController;
}

-(UIView *)previewView{
    if (!_previewView) {
        _previewView = [[UIView alloc] initWithFrame:self.view.bounds];
        _previewView.backgroundColor = [UIColor clearColor];
    }
    return _previewView;
}


-(UIImageView *)filterView{
    if (!_filterView) {
        _filterView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    return _filterView;
}

-(UIView *)topControlView{
    if (!_topControlView) {
        _topControlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, kTopControlHeight)];
        _topControlView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _topControlView;
}

-(UIView *)bottomControlView{
    if (!_bottomControlView) {
        _bottomControlView = [[UIView alloc] initWithFrame:CGRectMake(0, Screenheight-kBottomControlHeight, Screenwidth, kBottomControlHeight)];
        _bottomControlView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomControlView;
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Screenwidth/6, kTopControlHeight)];
        [_backButton setImage:[UIImage imageNamed:@"icon_back_index"] forState:UIControlStateNormal];
        [_backButton setBackgroundColor:UIColorFromRGB(0x662425)];
        [_backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(UIButton *)flashOptionButton{
    if (!_flashOptionButton) {
        _flashOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(Screenwidth/6, 0, Screenwidth/6, kTopControlHeight)];
        [_flashOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_01"] forState:UIControlStateNormal];
        _flashOptionButton.tag = PTCameraSettingFlash;
        [_flashOptionButton addTarget:self action:@selector(toggleCameraSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashOptionButton;
}

-(UIButton *)cropOptionButton{
    if (!_cropOptionButton) {
        _cropOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(Screenwidth/6*2, 0, Screenwidth/6, kTopControlHeight)];
        [_cropOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_05"] forState:UIControlStateNormal];
        _cropOptionButton.tag = PTCameraSettingCrop;
        [_cropOptionButton addTarget:self action:@selector(toggleCameraSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cropOptionButton;
}

-(UIButton *)timerOptionButton{
    if (!_timerOptionButton) {
        _timerOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(Screenwidth/6*3, 0, Screenwidth/6, kTopControlHeight)];
        [_timerOptionButton setImage:[UIImage imageNamed:@"icon_capture_20_08"] forState:UIControlStateNormal];
        _timerOptionButton.tag = PTCameraSettingTimer;
        [_timerOptionButton addTarget:self action:@selector(toggleCameraSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timerOptionButton;
}

-(UIButton *)tapShootButton{
    if (!_tapShootButton) {
        _tapShootButton = [[UIButton alloc] initWithFrame:CGRectMake(Screenwidth/6*4, 0, Screenwidth/6, kTopControlHeight)];
        [_tapShootButton setImage:[UIImage imageNamed:@"icon_capture_20_12"] forState:UIControlStateNormal];
        [_tapShootButton addTarget:self action:@selector(toggleTapShoot) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tapShootButton;
}

-(UIButton *)cameraPositionButton{
    if (!_cameraPositionButton) {
        _cameraPositionButton = [[UIButton alloc] initWithFrame:CGRectMake(Screenwidth/6*5, 0, Screenwidth/6, kTopControlHeight)];
        [_cameraPositionButton setImage:[UIImage imageNamed:@"icon_capture_20_14"] forState:UIControlStateNormal];
        [_cameraPositionButton addTarget:self action:@selector(toggleChangeCameraPosition) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraPositionButton;
}

-(UIButton *)cameraRollButton{
    if (!_cameraRollButton) {
        _cameraRollButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (kBottomControlHeight-Screenwidth/5)/2, Screenwidth/5, Screenwidth/5)];
        _cameraRollButton.imageView.layer.cornerRadius = 4;
        _cameraRollButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _cameraRollButton.clipsToBounds = YES;
        [_cameraRollButton addTarget:self action:@selector(albumTapped) forControlEvents:UIControlEventTouchUpInside];
        _cameraRollButton.imageView.backgroundColor = [UIColor colorWithHexString:@"222222"];
    }
    return _cameraRollButton;
}

-(UIButton *)liveStickerButton{
    if (!_liveStickerButton) {
        _liveStickerButton = [[UIButton alloc] initWithFrame:CGRectMake(Screenwidth/5*1, (kBottomControlHeight-Screenwidth/5)/2, Screenwidth/5, Screenwidth/5)];
        [_liveStickerButton setImage:[UIImage imageNamed:@"icon_capture_20_15"] forState:UIControlStateNormal];
        [_liveStickerButton addTarget:self action:@selector(toggleLiveStickerOption) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liveStickerButton;
}

-(UIButton *)shootButton{
    if (!_shootButton) {
        _shootButton = [[UIButton alloc] initWithFrame:CGRectMake(Screenwidth/5*2, (kBottomControlHeight-Screenwidth/5)/2, Screenwidth/5, Screenwidth/5)];
        [_shootButton setImage:[UIImage imageNamed:@"btn_capture_nor"] forState:UIControlStateNormal];
        _shootButton.transform = CGAffineTransformMakeScale(1.1, 1.1);
        [_shootButton addTarget:self action:@selector(cameraShoot) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shootButton;
}

-(UIButton *)filterButton{
    if (!_filterButton) {
        _filterButton = [[UIButton alloc] initWithFrame:CGRectMake(Screenwidth/5*3, (kBottomControlHeight-Screenwidth/5)/2, Screenwidth/5, Screenwidth/5)];
        [_filterButton setImage:[UIImage imageNamed:@"icon_capture_20_16"] forState:UIControlStateNormal];
        [_filterButton addTarget:self action:@selector(toggleFilterOption) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}

-(UIButton *)jigsawButton{
    if (!_jigsawButton) {
        _jigsawButton = [[UIButton alloc] initWithFrame:CGRectMake(Screenwidth/5*4, (kBottomControlHeight-Screenwidth/5)/2, Screenwidth/5, Screenwidth/5)];
        [_jigsawButton setImage:[UIImage imageNamed:@"icon_capture_20_17"] forState:UIControlStateNormal];
        [_jigsawButton addTarget:self action:@selector(toggleJigsawTemplate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jigsawButton;
}

-(UIView *)cropMaskTop{
    if (!_cropMaskTop) {
        _cropMaskTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, 0)];
        _cropMaskTop.backgroundColor = [UIColor blackColor];
    }
    return _cropMaskTop;
}

-(UIView *)cropMaskBottom{
    if (!_cropMaskBottom) {
        _cropMaskBottom = [[UIView alloc] initWithFrame:CGRectMake(0, Screenheight, Screenwidth, 0)];
        _cropMaskBottom.backgroundColor = [UIColor blackColor];
    }
    return _cropMaskBottom;
}

-(UILabel *)timerLabel{
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, Screenheight)];
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.font = [UIFont systemFontOfSize:250];
        _timerLabel.textColor = [UIColor whiteColor];
        
    }
    return _timerLabel;
}

@end
