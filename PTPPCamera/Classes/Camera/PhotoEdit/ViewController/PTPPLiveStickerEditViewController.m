//
//  PTPPLiveStickerEditViewController.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 18/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPLiveStickerEditViewController.h"
#import "PTPPLiveStickerScrollView.h"
#import "PTPPLiveStickerView.h"
#import "PTPPStickerXMLParser.h"

#define kFilterScrollHeight 130


@interface PTPPLiveStickerEditViewController ()
@property (nonatomic, strong) UIImageView *basePhotoView;
@property (nonatomic, strong) UIImage *basePhoto;
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) PTPPLiveStickerScrollView *liveStickerScrollView;
@property (nonatomic, strong) NSString *selectedARSticker;

@property (nonatomic, strong) PTPPLiveStickerView *liveStickerView;
@end

@implementation PTPPLiveStickerEditViewController

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
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.basePhotoView];
    self.basePhotoView.image = self.basePhoto;
    [self.basePhotoView addSubview:self.liveStickerView];
    [self.view addSubview:self.topBar];
    [self.topBar addSubview:self.backButton];
    [self.topBar addSubview:self.saveButton];
    [self toggleLiveStickerOption];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touch Events

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
            if(isFromBundle){
                [weakSelf loadLiveStickerFromXMLFile:stickerName];
            }else{
#warning load from directory
            }
            [weakSelf markFaces:weakSelf.basePhotoView];
            [SOAutoHideMessageView showMessage:@"请将正脸置于取景器内" inView:weakSelf.view];
        }
    };
    self.liveStickerScrollView.selectedStickerName = self.selectedARSticker;

    
    [self.view addSubview:self.liveStickerScrollView];
    self.liveStickerScrollView.frame = CGRectMake(0, Screenheight, self.liveStickerScrollView.width, self.liveStickerScrollView.height);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
              weakSelf.liveStickerScrollView.frame = CGRectMake(0, Screenheight-kFilterScrollHeight, weakSelf.liveStickerScrollView.width, weakSelf.liveStickerScrollView.height);
            
          } completion:^(BOOL finished) {}];
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


-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAndExport{
    
}
-(void)markFaces:(UIImageView *)facePicture
{

    // draw a CI image with the previously loaded face detection picture
    CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];

    
    // create a face detector - since speed is not an issue we'll use a high accuracy
    // detector
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    // create an array containing all the detected faces from the detector
    NSArray* features = [detector featuresInImage:image];
    
//VideoBox:{{0, 0}, {1280, 720}} PreviewBox:{{0, 0}, {414, 736}}
    NSLog(@"box %@",NSStringFromCGRect(CGRectMake(0, 0, Screenwidth, Screenheight)));
   [self.liveStickerView updateLiveStickerFrameWithFaceFeatures:features forVideoBox:CGRectMake(0, 0, 1280, 720) withPreviewBox:CGRectMake(0, 0, Screenwidth, Screenheight)];
    [self.liveStickerView fixRotationForStaticFaceDetection];
}


#pragma mark - Getters/Setters
-(UIImageView *)basePhotoView{
    if (!_basePhotoView) {
        _basePhotoView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _basePhotoView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _basePhotoView;
}

-(UIView *)topBar{
    if (!_topBar) {
        _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, HEIGHT_NAV)];
        _topBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _topBar;
}


-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 40)];
        [_backButton setImage:[UIImage imageNamed:@"back_white.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(Screenwidth-100, 0, 100, HEIGHT_NAV)];
        [_saveButton setTitle:@"保存/分享" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveAndExport) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

-(PTPPLiveStickerScrollView *)liveStickerScrollView{
    if (!_liveStickerScrollView) {
        _liveStickerScrollView = [[PTPPLiveStickerScrollView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, kFilterScrollHeight)];
        [_liveStickerScrollView setAttributeWithFilterSet:@[@"hz",@"cn", @"mhl", @"xm", @"fd", @"kq", @"xhx",@"hy"]]; //Hard coded
    }
    return _liveStickerScrollView;
}

-(PTPPLiveStickerView *)liveStickerView{
    if (!_liveStickerView) {
        _liveStickerView = [[PTPPLiveStickerView alloc] initWithFrame:self.basePhotoView.bounds];
    }
    return _liveStickerView;
}

@end
