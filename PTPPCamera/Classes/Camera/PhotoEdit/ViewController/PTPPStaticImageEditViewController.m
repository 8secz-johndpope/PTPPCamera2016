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

#define kFilterScrollHeight 150

@interface PTPPStaticImageEditViewController ()<PTPPStaticImageEditToolBarDelegate>
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) PTPPStaticImageEditToolBar *toolBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIView *canvasView;
@property (nonatomic, strong) UIImageView *basePhotoView;
@property (nonatomic, strong) UIImage *basePhoto;
@property (nonatomic, strong) NSMutableArray *filterSet;
@property (nonatomic, strong) PTPPCameraFilterScrollView *filterScrollView;
@property (nonatomic, assign) NSInteger activeFilterID;

@end

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
    self.basePhotoView.image = self.basePhoto;
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.toolBar];
    [self.topBar addSubview:self.backButton];
    [self.topBar addSubview:self.saveButton];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.canvasView addGestureRecognizer:singleFingerTap];
    self.basePhoto = [PTFilterManager scaleAndRotateImage:self.basePhoto];
    [self preRenderFilterPreview];
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

-(void)viewDidAppear:(BOOL)animated{
    
}

#pragma mark 0 Private Methods
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

#pragma mark - Touch Events
-(void)handleSingleTap{
    if (self.filterScrollView.finishBlock) {
        self.filterScrollView.finishBlock();
    }
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
    [self.filterScrollView setAttributeWithFilterSet:self.filterSet];
    self.filterScrollView.activeFilterID = self.activeFilterID;
    self.filterScrollView.filterSelected = ^(NSInteger filterID){
        weakSelf.activeFilterID = filterID;
        NSDictionary *filterResult = [weakSelf getFilterResultFromInputImage:weakSelf.basePhoto filterIndex:filterID];
        UIImageView *tempFilterImage = [[UIImageView alloc] initWithFrame:weakSelf.basePhotoView.frame];
        UIImage *resultImage = [filterResult safeObjectForKey:PTFILTERIMAGE];
//        if (weakSelf.basePhoto.imageOrientation == UIImageOrientationUpMirrored) {
//            resultImage = [[UIImage alloc] initWithCGImage:resultImage.CGImage scale:1.0 orientation:UIImageOrientationUpMirrored];
//        }else if (weakSelf.basePhoto.imageOrientation == UIImageOrientationRight) {
//            resultImage = [[UIImage alloc] initWithCGImage:resultImage.CGImage scale:1.0 orientation:UIImageOrientationRight];
//            CGSize newSize = CGSizeMake(resultImage.size.height, resultImage.size.width);
//            UIGraphicsBeginImageContext(newSize);
//            [resultImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//            resultImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//        }
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
        
    };
    self.filterScrollView.finishBlock = ^{
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1
              initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
                  weakSelf.filterScrollView.center = CGPointMake(weakSelf.filterScrollView.centerX, Screenheight+weakSelf.filterScrollView.height/2);
                  [weakSelf displayToolBar:YES];
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
              [weakSelf displayToolBar:NO];
          } completion:^(BOOL finished) {}];

}

-(void)toggleARStickerMenu{

}

-(void)toggleCropMenu{

}

-(void)toggleRotationMenu{

}

-(void)displayToolBar:(BOOL)state{
    if (state) {
        self.toolBar.frame = CGRectMake(0, Screenheight-self.toolBar.height, self.toolBar.width, self.toolBar.height);
    }else{
        self.toolBar.frame = CGRectMake(0, Screenheight, self.toolBar.width, self.toolBar.height);
    }
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
        _filterScrollView.activeFilterID = 0;
    }
    return _filterScrollView;
}

-(NSMutableArray *)filterSet{
    if (!_filterSet) {
        _filterSet = [[NSMutableArray alloc] init];
    }
    return _filterSet;
}

@end
