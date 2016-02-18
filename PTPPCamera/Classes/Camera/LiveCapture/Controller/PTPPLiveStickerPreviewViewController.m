//
//  PTPPLiveStickerPreviewViewController.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 20/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPLiveStickerPreviewViewController.h"
#import "PTPPLiveVideoShareViewController.h"
#import "SOKit.h"

#import "PTImageSequenceToVideoConverter.h"
#import "SVProgressHUD.h"
#import "NSObject+Swizzle.h"

#define kFrameCount 37
@interface PTPPLiveStickerPreviewViewController ()
@property (nonatomic, strong) NSMutableArray *mergedDownAnimationFrames;
@property (nonatomic, strong) PTImageSequenceToVideoConverter *converter;
@property (nonatomic, strong) UIImage *basePhoto;


@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) UIView *bottomCropMask;

@end

@implementation PTPPLiveStickerPreviewViewController

#pragma mark - Life Cycles
-(instancetype)initWithBasePhoto:(UIImage *)image mouthSticker:(UIImageView *)mouthSticker eyeSticker:(UIImageView *)eyeSticker bottomSticker:(UIImageView *)bottomSticker faceAngle:(CGFloat)faceAngle{
    self = [super init];
    if (self) {
        self.basePhoto = image;
        self.mouthSticker.animationImages = [NSArray arrayWithArray:mouthSticker.animationImages];
        self.eyeSticker.animationImages = [NSArray arrayWithArray:eyeSticker.animationImages];
        self.bottomSticker.animationImages = [NSArray arrayWithArray:bottomSticker.animationImages];
        self.mouthSticker.frame = mouthSticker.frame;
        self.eyeSticker.frame = eyeSticker.frame;
        self.bottomSticker.frame = bottomSticker.frame;
        self.eyeSticker.transform = CGAffineTransformMakeRotation((faceAngle/180.0*M_PI));
        self.mouthSticker.transform = CGAffineTransformMakeRotation((faceAngle/180.0*M_PI));
        self.mouthSticker.animationDuration = mouthSticker.animationDuration;
        self.eyeSticker.animationDuration = eyeSticker.animationDuration;
        self.bottomSticker.animationDuration = bottomSticker.animationDuration;
        [self.mouthSticker startAnimating];
        [self.eyeSticker startAnimating];
        [self.bottomSticker startAnimating];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.basedPhotoView];
    self.basedPhotoView.image = self.basePhoto;
    [self.basedPhotoView addSubview:self.stickerView];
    [self.stickerView addSubview:self.bottomSticker];
    [self.stickerView addSubview:self.mouthSticker];
    [self.stickerView addSubview:self.eyeSticker];
    [self.view addSubview:self.topCropMask];
    [self.view addSubview:self.bottomCropMask];
    [self.view addSubview:self.topBar];
    [self.topBar addSubview:self.backButton];
    [self.topBar addSubview:self.saveButton];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.topBar.frame = CGRectMake(0, 0, Screenwidth, HEIGHT_NAV);
    self.backButton.frame = CGRectMake(10, 0, 30, 40);
    self.saveButton.frame = CGRectMake(Screenwidth-100, 0, 100, HEIGHT_NAV);
}

-(void)setCropOption:(NSInteger)cropOption{
    CGFloat cropMaskTopHeight = 0.0f;
    CGFloat cropMaskBottomHeight = 0.0f;
    switch (cropOption) {
        case 0:
            cropMaskTopHeight = kTopControlHeight;
            cropMaskBottomHeight = kBottomControlHeight;
            break;
        case 1:
            cropMaskTopHeight = kTopControlHeight*2;
            cropMaskBottomHeight = Screenheight - cropMaskTopHeight-Screenwidth;
            break;
        case 2:
            cropMaskTopHeight = 0.0f;
            cropMaskBottomHeight = 0.0f;
            break;
    }
    
    self.topCropMask.frame = CGRectMake(0, 0, Screenwidth, cropMaskTopHeight);
    self.bottomCropMask.frame = CGRectMake(0, Screenheight-cropMaskBottomHeight, Screenwidth, cropMaskBottomHeight);
    self.topCropMask.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_blur_bg_736h@3x.jpg"]];
    self.bottomCropMask.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_blur_bg_736h@3x.jpg"]];
    if (self.topCropMask.height>0){
        self.topBar.backgroundColor = [UIColor clearColor];
    }else{
        self.topBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];;
    }
}

#pragma mark - Touch Events
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAndExport{
    [self.mouthSticker stopAnimating];
    [self.eyeSticker stopAnimating];
    [self.bottomSticker stopAnimating];
    NSLog(@"Export start...");
    [SVProgressHUD showWithStatus:@"视频输出中" maskType:SVProgressHUDMaskTypeGradient];
    [self performSelector:@selector(imageSequencePreProcessing) withObject:nil afterDelay:0.1];
}

-(void)imageSequencePreProcessing{
    CGSize targetSize = CGSizeMake(self.basedPhotoView.frame.size.width, self.bottomCropMask.top-self.topCropMask.bottom);
    __weak typeof(self) weakSelf = self;
    self.converter.finishExport = ^(NSURL *videoURL){
        NSLog(@"Export Complete");
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismissWithSuccess:@"已保存到本地相册" afterDelay:1.0];
            [weakSelf.mouthSticker startAnimating];
            [weakSelf.eyeSticker startAnimating];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    };
    
    [self.converter exportVideoWithImageSequence:self exportSize:targetSize fps:12 totalFrame:kFrameCount];
}

#pragma mark - Getters/Setters

-(NSMutableArray *)mergedDownAnimationFrames{
    if (!_mergedDownAnimationFrames) {
        _mergedDownAnimationFrames = [[NSMutableArray alloc] init];
    }
    return _mergedDownAnimationFrames;
}

-(PTImageSequenceToVideoConverter *)converter{
    if (!_converter) {
        _converter = [[PTImageSequenceToVideoConverter alloc] init];
    }
    return _converter;
}

-(UIImageView *)basedPhotoView{
    if (!_basedPhotoView) {
        _basedPhotoView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    return _basedPhotoView;
}

-(UIView *)stickerView{
    if (!_stickerView) {
        _stickerView = [[UIView alloc] initWithFrame:self.view.bounds];
        _stickerView.backgroundColor = [UIColor clearColor];
    }
    return _stickerView;
}

-(UIImageView *)mouthSticker{
    if (!_mouthSticker) {
        _mouthSticker = [[UIImageView alloc] init];
        _mouthSticker.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _mouthSticker;
}

-(UIImageView *)eyeSticker{
    if (!_eyeSticker) {
        _eyeSticker = [[UIImageView alloc] init];
        _eyeSticker.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _eyeSticker;
}

-(UIImageView *)bottomSticker{
    if (!_bottomSticker) {
        _bottomSticker = [[UIImageView alloc] init];
        _bottomSticker.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bottomSticker;
}

-(UIView *)topCropMask{
    if (!_topCropMask) {
        _topCropMask = [[UIView alloc] init];
        _topCropMask.backgroundColor = [UIColor blackColor];
    }
    return _topCropMask;
}

-(UIView *)bottomCropMask{
    if (!_bottomCropMask) {
        _bottomCropMask = [[UIView alloc] init];
        _bottomCropMask.backgroundColor = [UIColor blackColor];
    }
    return _bottomCropMask;
}

-(UIView *)topBar{
    if (!_topBar) {
        _topBar = [[UIView alloc] init];
        _topBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _topBar;
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

@end
