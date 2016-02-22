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
#import "PTImageSequenceToVideoConverter.h"

#define kFilterScrollHeight 130


@interface PTPPLiveStickerEditViewController ()
@property (nonatomic, strong) UIView *leftEye, *rightEye, *mouth;
@property (nonatomic, strong) UIImage *basePhoto;
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) PTPPLiveStickerScrollView *liveStickerScrollView;
@property (nonatomic, strong) NSString *selectedARSticker;
@property (nonatomic, strong) NSArray *faceFeatures;
@property (nonatomic, strong) PTPPStickerAnimation *eyeAnimation;
@property (nonatomic, strong) PTPPStickerAnimation *mouthAnimation;
@property (nonatomic, strong) PTPPStickerAnimation *bottomAnimation;
@property (nonatomic, strong) PTImageSequenceToVideoConverter *converter;
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
    [self.view addSubview:self.basedPhotoView];
    [self.basedPhotoView addSubview:self.stickerView];
    [self.stickerView addSubview:self.bottomSticker];
    [self.stickerView addSubview:self.mouthSticker];
    [self.stickerView addSubview:self.eyeSticker];
    self.basedPhotoView.image = self.basePhoto;
    CGFloat imageSizeRatio = self.basePhoto.size.height/self.basePhoto.size.width;
    self.basedPhotoView.frame = CGRectMake(self.basedPhotoView.left, self.basedPhotoView.top,self.basedPhotoView.width, self.basedPhotoView.width*imageSizeRatio);
    self.stickerView.frame = self.basedPhotoView.bounds;
    CGSize newSize = self.basedPhotoView.frame.size;
    UIGraphicsBeginImageContext(newSize);
    [self.basePhoto drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    self.basedPhotoView.image = newImage;
    //[self.basePhotoView addSubview:self.liveStickerView];
    self.basedPhotoView.center = self.view.center;

    [self.view addSubview:self.topBar];
    [self.topBar addSubview:self.backButton];
    [self.topBar addSubview:self.saveButton];
    
    [self markFaces:self.basedPhotoView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touch Events

-(void)toggleLiveStickerOption{
    __weak typeof(self) weakSelf = self;
    self.liveStickerScrollView.stickerSelected = ^(NSString *stickerName, BOOL isFromBundle){
        weakSelf.eyeAnimation = nil;
        weakSelf.mouthAnimation = nil;
        weakSelf.bottomAnimation = nil;
        weakSelf.eyeSticker.animationImages = nil;
        weakSelf.mouthSticker.animationImages = nil;
        weakSelf.bottomSticker.animationImages = nil;
        if (stickerName != nil) {
            weakSelf.selectedARSticker = stickerName;
            if(isFromBundle){
                [weakSelf loadLiveStickerFromXMLFile:stickerName];
            }else{
#warning load from directory
            }
            [weakSelf updateStickerPosition];
        }
    };
    self.liveStickerScrollView.selectedStickerName = self.selectedARSticker;

    
    [self.view addSubview:self.liveStickerScrollView];
    self.liveStickerScrollView.frame = CGRectMake(0, Screenheight, self.liveStickerScrollView.width, self.liveStickerScrollView.height);
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
              weakSelf.liveStickerScrollView.frame = CGRectMake(0, Screenheight-kFilterScrollHeight+40, weakSelf.liveStickerScrollView.width, weakSelf.liveStickerScrollView.height);
            
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
//    PTPPStickerAnimation *mouthAnimation;
//    PTPPStickerAnimation *eyeAnimation;
//    PTPPStickerAnimation *bottomAnimation;
    for(NSString *featureKey in [[resultDict safeObjectForKey:@"animation"] allKeys]){
        if ([featureKey isEqualToString:@"mouth"]) {
           self.mouthAnimation = [PTPPStickerAnimation animationWithDictionarySettings:[[resultDict objectForKey:@"animation"] objectForKey:featureKey] feature:featureKey filePath:downloadFolder];
        }else if ([featureKey isEqualToString:@"eye"]){
            self.eyeAnimation = [PTPPStickerAnimation animationWithDictionarySettings:[[resultDict objectForKey:@"animation"] objectForKey:featureKey] feature:featureKey filePath:downloadFolder];
        }else if([featureKey isEqualToString:@"bottom"]){
            self.bottomAnimation = [PTPPStickerAnimation animationWithDictionarySettings:[[resultDict objectForKey:@"animation"] objectForKey:featureKey] feature:featureKey filePath:downloadFolder];
        }
    }
    //[self.liveStickerView setAttributeWithMouthAnimation:mouthAnimation eyeAnimation:eyeAnimation bottomAnimation:bottomAnimation];
}


-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAndExport{
    [self.mouthSticker stopAnimating];
    [self.eyeSticker stopAnimating];
    [self.bottomSticker stopAnimating];
    [SVProgressHUD showWithStatus:@"视频输出中" maskType:SVProgressHUDMaskTypeGradient];
    [self performSelector:@selector(imageSequencePreProcessing) withObject:nil afterDelay:0.1];
   
}

-(void)imageSequencePreProcessing{
    CGSize targetSize = CGSizeMake(self.basedPhotoView.frame.size.width, self.basedPhotoView.frame.size.height);
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

-(void)markFaces:(UIImageView *)facePicture
{
   
    // draw a CI image with the previously loaded face detection picture
    CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];
    
    
    // create a face detector - since speed is not an issue we'll use a high accuracy
    // detector
    if (!self.faceFeatures) {
        CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                  context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
        
        // create an array containing all the detected faces from the detector
        self.faceFeatures = [detector featuresInImage:image];

    }
    if (self.faceFeatures.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"检测不到人脸，请换一张试试吧" duration:2.0];
    }else{
        [self toggleLiveStickerOption];
    }

}

-(void)updateStickerPosition{
    // 眼睛相对水平的旋转角度
    float angle = 0;
    // 放大缩小比例
    float scale = 1/[UIScreen mainScreen].scale;
    int imageHeight = self.basedPhotoView.frame.size.height;

    for(CIFaceFeature* faceFeature in self.faceFeatures)
    {
        // get the width of the face
        CGFloat faceWidth = faceFeature.bounds.size.width;
        if(faceFeature.hasLeftEyePosition)
        {
            int leftEyeX = faceFeature.leftEyePosition.x;
            // leftEyePoint 0,0 is at left bottom, need change coord orientation
            int leftEyeY = imageHeight - faceFeature.leftEyePosition.y;
            // create a UIView with a size based on the width of the face
            self.rightEye = [[UIView alloc] initWithFrame:CGRectMake(leftEyeX, leftEyeY, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [self.rightEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the leftEyeView based on the face
            [self.rightEye setCenter:CGPointMake(leftEyeX, leftEyeY)];
            // round the corners
            self.rightEye.layer.cornerRadius = faceWidth*0.15;
            // add the view to the window
            //[self.stickerView addSubview:leftEyeView];
        }
        
        /************************************************************************************
         * 注意图片的坐标系原点在左上角，facedetection 找到的位置坐标系原点在坐下角
         ************************************************************************************/
        
        if(faceFeature.hasRightEyePosition)
        {
            int rightEyeX = faceFeature.rightEyePosition.x;
            int rightEyeY = imageHeight - faceFeature.rightEyePosition.y;
            // create a UIView with a size based on the width of the face
            self.leftEye = [[UIView alloc] initWithFrame:CGRectMake(rightEyeX, rightEyeY, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [self.leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the rightEyeView based on the face
            [self.leftEye setCenter:CGPointMake(rightEyeX, rightEyeY)];
            // round the corners
            self.leftEye.layer.cornerRadius = faceWidth*0.15;
            // add the new view to the window
            //[self.stickerView addSubview:leftEye];
        }
        
        // 用眼睛的位置计算旋转的角度
        if(faceFeature.leftEyePosition.x == faceFeature.rightEyePosition.x) angle = 3.14/2;
        else{
            angle = - atan((faceFeature.rightEyePosition.y - faceFeature.leftEyePosition.y)/(faceFeature.rightEyePosition.x - faceFeature.leftEyePosition.x));
        }
        // 根据眼睛来计算角度和放大倍数
        if(faceFeature.hasRightEyePosition && faceFeature.hasRightEyePosition && self.eyeAnimation)
        {
            // 眼睛中心位置 x y
            int positionX = (faceFeature.leftEyePosition.x+faceFeature.rightEyePosition.x)/2;
            int positionY = imageHeight - ((faceFeature.leftEyePosition.y+faceFeature.rightEyePosition.y)/2);
            // 两眼距离
            int eyeDistance = calDistance(faceFeature.leftEyePosition.x, faceFeature.leftEyePosition.y, faceFeature.rightEyePosition.x, faceFeature.rightEyePosition.y);
            
            
            // 计算放大后的图片显示位置和大小
            scale = (float)eyeDistance/(float)self.eyeAnimation.distance;
            
            [self getEyesImageView:self.eyeAnimation position:CGPointMake(positionX, positionY) eyesScale:scale eyesAngle:angle];
        }
        
        if(faceFeature.hasMouthPosition && self.mouthAnimation)
        {
            int mouthX = faceFeature.mouthPosition.x;
            int mouthY = imageHeight - faceFeature.mouthPosition.y;
//            UIView *mouth = [[UIView alloc] initWithFrame:CGRectMake(mouthX-50, mouthY-50, 100, 100)];
//            mouth.backgroundColor = [UIColor blueColor];
//            [self.stickerView addSubview:mouth];
            [self getMouthImageView:self.mouthAnimation position:CGPointMake(mouthX, mouthY) mouthScale:scale mouthAngle:angle];
        }
        
        if (self.bottomAnimation) {
            self.bottomSticker.frame = self.stickerView.bounds;
            self.bottomSticker.contentMode = UIViewContentModeScaleAspectFit;
            self.bottomSticker.animationImages = self.bottomAnimation.imageList;
            self.bottomSticker.animationDuration = self.bottomAnimation.duration*self.bottomAnimation.imageList.count;
            [self.bottomSticker startAnimating];

        }
    }
}

- (void) getEyesImageView:(PTPPStickerAnimation *) model position:(CGPoint) position eyesScale:(float) scale eyesAngle:(float) angle
{
    self.eyeSticker.hidden = NO;
    CGFloat stickerWidth = self.eyeAnimation.width;
    CGFloat stickerHeight = self.eyeAnimation.height;
    CGFloat stickerDistance = self.eyeAnimation.distance;
    CGPoint stickerCenter = CGPointMake(self.eyeAnimation.centerX, self.eyeAnimation.centerY);
    CGFloat frameDuration = self.eyeAnimation.duration;
    CGFloat actualDistance = [self getDistanceFromPointA:self.leftEye.center pointB:self.rightEye.center]*2;
    CGFloat ratio = actualDistance/stickerDistance;
    if (self.eyeSticker.animationImages.count == 0) {
        self.eyeSticker.animationImages = self.eyeAnimation.imageList;
        self.eyeSticker.animationDuration = frameDuration*self.eyeAnimation.imageList.count;
        [self.eyeSticker startAnimating];
    }
    CGPoint eyeStickerCenter = CGPointMake((self.rightEye.centerX+self.leftEye.centerX)/2, (self.rightEye.centerY+self.leftEye.centerY)/2-(stickerCenter.y-stickerHeight/2)/2);
    self.eyeSticker.frame = CGRectMake(eyeStickerCenter.x-stickerWidth/2*ratio/2, eyeStickerCenter.y-stickerHeight/2*ratio/2, stickerWidth/2*ratio, stickerHeight/2*ratio);
    self.eyeSticker.transform = CGAffineTransformMakeRotation(angle);
    
}

- (void) getMouthImageView:(PTPPStickerAnimation *) model position:(CGPoint) position mouthScale:(float) scale mouthAngle:(float) angle
{
    self.mouthSticker.hidden = NO;
    CGFloat stickerWidth = self.mouthAnimation.width;
    CGFloat stickerHeight = self.mouthAnimation.height;
    //CGFloat stickerDistance = self.mouthAnimation.distance;
    CGPoint stickerCenter = CGPointMake(self.mouthAnimation.centerX, self.mouthAnimation.centerY);
    CGFloat frameDuration = self.mouthAnimation.duration;
    CGFloat actualDistance = [self getDistanceFromPointA:self.leftEye.center pointB:self.rightEye.center]*2;
    CGFloat ratio = actualDistance/self.mouthAnimation.width;
    CGRect mouthFrame = CGRectMake(position.x-stickerWidth/2*ratio, position.y-stickerHeight/2*ratio, stickerWidth/2*ratio, stickerHeight/2*ratio);
    if (self.mouthSticker.animationImages.count == 0) {
        self.mouthSticker.animationImages = self.mouthAnimation.imageList;
        self.mouthSticker.animationDuration = frameDuration*self.mouthAnimation.imageList.count;
        [self.mouthSticker startAnimating];
    }
    self.mouthSticker.frame = mouthFrame;
    self.mouthSticker.center = CGPointMake(position.x, position.y-(stickerCenter.y-stickerHeight/2)/2+30);
    self.mouthSticker.transform = CGAffineTransformMakeRotation(angle);
}

static int calDistance(int fx, int fy, int tx, int ty){
    
    return sqrt((fx - tx)*(fx - tx) + (fy - ty)*(fy - ty));
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

#pragma mark - Getters/Setters

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

-(PTImageSequenceToVideoConverter *)converter{
    if (!_converter) {
        _converter = [[PTImageSequenceToVideoConverter alloc] init];
    }
    return _converter;
}

@end
